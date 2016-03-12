love.filesystem.load("tiledmap.lua")()

local Ship = require('Ship')
local Bullet = require('Bullet')
local socket = require "socket"

local address, port = "localhost", 12345
local updaterate = 1/30 -- how long to wait, in seconds, before requesting an update
local t
local userInput = false

local serverRotation = 0


gKeyPressed = {}
yAccel = 0
xAccel = 0

players = {}

gCamX,gCamY = 0,0

shoot = love.audio.newSource("shoot.wav", "static")
explode = love.audio.newSource("death.wav", "static")


function love.load()
	udp = socket.udp()
	udp:settimeout(0)
	udp:setpeername(address, port)
	
	love.window.setMode(1920, 1080, {fullscreen=false, resizable=true, highdpi=true})
	scale = love.window.getPixelScale()

	-- love.window.setMode(1920/scale, 1080/scale,{fullscreen=true, resizable=false, highdpi=true})

	TiledMap_Load("arena4.tmx",16)
	player1 = Ship.new(0,100,100,math.pi/2,0,0)
	player2 = Ship.new(1,1820,100,-math.pi/2,0,0)
	player3 = Ship.new(2,100,860,math.pi/2,0,0)
	player4 = Ship.new(3,1820,860,-math.pi/2,0,0)

	table.insert(players, player1)
	table.insert(players, player2)
	table.insert(players, player3)
	table.insert(players, player4)

	for i, player in pairs(players) do
		local dg = string.format("%s %s %f %f %f %f %f", i, 'at', player.x, player.y, player.vx, player.vy, player.rotation)
		udp:send(dg)
	end
	t = 0
end

function love.keyreleased(key)
	gKeyPressed[key] = nil
end

function love.keypressed(key, unicode)
	gKeyPressed[key] = true
	if (key == "escape") then os.exit(0) end
	if (key == "space") then
		for i, player in pairs(players) do
			player:fire()
			shoot:play()
		end
	end
	if (key == "e") then player1.rotation = player1.rotation + math.pi end
end

function love.gamepadpressed(joystick, button)
    if button == "a" then
    	id, instanceid = joystick:getID()
    	players[id]:fire()
    	shoot:play()
    end
end

function love.update( dt )
	local joysticks = love.joystick.getJoysticks()
	for i, player in pairs(players) do
		local s = 0

		joy = joysticks[i]
		if joy then	
			joyX = joy:getGamepadAxis("leftx")
			throttle = joy:getGamepadAxis("triggerright")


			if math.abs(joyX) > 0.5 then
				player.rotation = player.rotation + (4 * dt * joyX)

				userInput = true

			end
			
			

			if throttle > 0 then
				xAccel = throttle * 5 * dt * math.sin(player.rotation)
				yAccel = throttle * 5 * dt * -math.cos(player.rotation)

				player.vx = player.vx + xAccel
				player.vy = player.vy + yAccel

				userInput = true

			end
		end

		if (gKeyPressed.lshift) then
			player.shield = true
		else
			player.shield = false
		end

		if (gKeyPressed.up) then
			xAccel = 1 * dt * math.sin(player.rotation)
			yAccel = 1 * dt * -math.cos(player.rotation)

			player.vx = player.vx + xAccel
			player.vy = player.vy + yAccel
			player.engine = true
		else
			player.engine = false
		end

		if (gKeyPressed.up) then
			xAccel = 1 * dt * math.sin(player.rotation)
			yAccel = 1 * dt * -math.cos(player.rotation)

			player1.vx = player1.vx + xAccel
			player1.vy = player1.vy + yAccel
		end

		if (gKeyPressed.left) then
			player.rotation = player.rotation - 4 * dt
		end

		if (gKeyPressed.right) then
			player.rotation = player.rotation + 4 * dt
		end


		player:update(dt)

		tileUp = TiledMap_GetMapTile(math.floor(player.x/16),math.floor((player.y+16)/16),1)
		tileDown = TiledMap_GetMapTile(math.floor(player.x/16),math.floor((player.y-16)/16),1)

		tileLeft = TiledMap_GetMapTile(math.floor((player.x-16)/16),math.floor(player.y/16),1)
		tileRight = TiledMap_GetMapTile(math.floor((player.x+16)/16),math.floor(player.y/16),1)

		if tileUp > 0 then
			player.vy = -player.vy/2
			player.y = player.y - 5
		elseif tileDown > 0 then
			player.vy = -player.vy/2
			player.y = player.y + 5
		end

		if tileLeft > 0 then
			player.vx = -player.vx/2
			player.x = player.x + 5
		elseif tileRight > 0 then
			player.vx = -player.vx/2
			player.x = player.x - 5
		end

		for b, bullet in pairs(player.bullets) do
			for p, otherPlayer in pairs(players) do
				if player ~= otherPlayer then
					xPow = math.pow(otherPlayer.x - bullet.x, 2)
					yPow = math.pow(otherPlayer.y - bullet.y, 2)

					dist = math.sqrt(xPow + yPow)

					if dist < 20 then
						table.remove(player.bullets, b)
						otherPlayer.exploding = true
						explode:play()
					end
				end
		   end
		end
	end

	t = t + dt -- increase t by the deltatime

	if t > updaterate then
		-- if userInput then
			for i, player in pairs(players) do
				if i == 1 then
					local dg = string.format("%s %s %f %f %f %f %f", i, 'at', player.x, player.y, player.vx, player.vy, player.rotation)
					udp:send(dg)
				end 
			end 
			-- userInput = false
		-- end

		local dg = string.format("%s %s $", 1, 'update')
		udp:send(dg)
		
		t=t-updaterate -- set t for the next round
	end

	repeat
		data, msg = udp:receive()

		if data then -- you remember, right? that all values in lua evaluate as true, save nil and false?
			ent, cmd, parms = data:match("^(%S*) (%S*) (.*)")
			if cmd == 'at' then
				local x, y, vx, vy, r = parms:match("^(%-?[%d.e]*) (%-?[%d.e]*) (%-?[%d.e]*) (%-?[%d.e]*) (%-?[%d.e]*)$")

				assert(x and y and vx and vy and r) 
				x, y, vx, vy, r = tonumber(x), tonumber(y),tonumber(vx),tonumber(vy),tonumber(r)
				-- players[ent] = {x=x, y=y}
				p = players[tonumber(ent)]
				if p then
					p.x = x
					p.y = y
					p.vx = vx
					p.vy = vy
					p.rotation = r
					if ent == 1 then
						serverRotation = r
					end
				end
				
			else
				print("unrecognised command:", cmd)
			end

		elseif msg ~= 'timeout' then 
			error("Network error: "..tostring(msg))
		end
	until not data
end

function love.draw()
	width = love.graphics.getWidth()
	height = love.graphics.getHeight()

	scaleFactor = width/1920

	love.graphics.scale(scaleFactor, scaleFactor)

	gCamX,gCamY = width/2,height/2
	TiledMap_AllAtCam(gCamX,gCamY)


	

	local joysticks = love.joystick.getJoysticks()

	for i, player in pairs(players) do
		if player.alive then
			player:draw()
		end

		if joysticks[i] then
			axis = joysticks[i]:getGamepadAxis("leftx")
			love.graphics.print(player.rotation, 10, i * 20)
		end
	end

	fps = love.timer.getFPS()
    love.graphics.print(serverRotation, 50, 50)
	love.graphics.setBackgroundColor(0x20,0x20,0x20)



end