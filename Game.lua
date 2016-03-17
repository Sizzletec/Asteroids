Game = {}
Game.__index = Game



love.filesystem.load("tiledmap.lua")()

local Ship = require('Ship')
local Bullet = require('Bullet')
local socket = require "socket"

local address, port = "sizzletec.com", 12345
local updaterate = 1/60 -- how long to wait, in seconds, before requesting an update
local t
local userInput = false
local serverRotation = 0

gKeyPressed = {}
yAccel = 0
xAccel = 0

players = {}

gCamX,gCamY = 0,0

local localPlayer
angle = 0


function Game.load()
	udp = socket.udp()
	udp:settimeout(0)
	udp:setpeername(address, port)

	-- love.window.setMode(1920/scale, 1080/scale,{fullscreen=true, resizable=false, highdpi=true})

	math.randomseed(os.time())
	local level = "arena" .. tostring(math.random(4)) .. ".tmx"

	TiledMap_Load(level,16)

	player2 = Ship.new(1,1820,100,-math.pi/2,0,0,ShipType.gunship)
	player3 = Ship.new(2,100,860,math.pi/2,0,0,ShipType.assalt)
	-- player4 = Ship.new(3,1820,860,-math.pi/2,0,0)

	-- table.insert(players, player1)
	table.insert(players, player2)
	table.insert(players, player3)
	-- table.insert(players, player4)


	entity = tostring(math.random(99999))

	localPlayer = Ship.new(entity,200,200,math.pi/2,0,0,ShipType.standard)
	table.insert(players, localPlayer)



	-- local dg = string.format("%s %s %f %f %f %f %f", localPlayer.player, 'at', localPlayer.x, localPlayer.y, localPlayer.vx, localPlayer.vy, localPlayer.rotation)
	-- udp:send(dg)

	t = 0
end

function Game.keyreleased(key)
	gKeyPressed[key] = nil
	if (key == "space") then
		localPlayer.firing = false
	end
end


function Game.keypressed(key, unicode)
	gKeyPressed[key] = true
	if (key == "escape") then love.event.quit() end
	if (key == "space") then
		localPlayer.firing = true
	end
	if (key == "e") then localPlayer.rotation = localPlayer.rotation + math.pi end
end

function Game.gamepadpressed(joystick, button)
    if button == "a" then
    	id, instanceid = joystick:getID()
    	localPlayer:fire()
    	localPlayer.firing = true
    end
end

function Game.gamepadreleased(joystick, button)
    if button == "a" then
    	id, instanceid = joystick:getID()
    	localPlayer.firing = false
    end
end

function Game.update(dt)
	local joysticks = love.joystick.getJoysticks()
	joy = joysticks[1]
	if joy then
		joyX = joy:getGamepadAxis("leftx")
		joyCannonX = joy:getGamepadAxis("rightx")
		joyCannonY = joy:getGamepadAxis("righty")
		throttle = joy:getGamepadAxis("triggerright")


		if math.abs(joyX) > 0.5 then
			localPlayer.rotation = localPlayer.rotation + (4 * dt * joyX)
		end

		if math.abs(joyCannonX) > 0.5 or math.abs(joyCannonY) > 0.5 then
			angle = math.atan2(joyCannonX,-joyCannonY)

			localPlayer.cannonRotation = angle
			localPlayer:fire()
		end

		if throttle > 0 then
			xAccel = throttle * 5 * dt * math.sin(localPlayer.rotation)
			yAccel = throttle * 5 * dt * -math.cos(localPlayer.rotation)

			localPlayer.vx = localPlayer.vx + xAccel
			localPlayer.vy = localPlayer.vy + yAccel

			localPlayer.engine = true
		else
			localPlayer.engine = false
		end
	end

	if (gKeyPressed.lshift) then
		localPlayer.shield = true
	else
		localPlayer.shield = false
	end

	if (gKeyPressed.up) then
		xAccel = 5 * dt * math.sin(localPlayer.rotation)
		yAccel = 5 * dt * -math.cos(localPlayer.rotation)

		localPlayer.vx = localPlayer.vx + xAccel
		localPlayer.vy = localPlayer.vy + yAccel
		localPlayer.engine = true
	else
		localPlayer.engine = false
	end

	if (gKeyPressed.left) then
		localPlayer.rotation = localPlayer.rotation - 4 * dt
	end

	if (gKeyPressed.right) then
		localPlayer.rotation = localPlayer.rotation + 4 * dt
	end


	for i, player in pairs(players) do
		local s = 0
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
		    hitWall = TiledMap_GetMapTile(math.floor(bullet.x/16),math.floor(bullet.y/16),1)
		    if hitWall > 0 then
		      table.remove(player.bullets, b)
		    else
				for p, otherPlayer in pairs(players) do
					if player ~= otherPlayer then
						xPow = math.pow(otherPlayer.x - bullet.x, 2)
						yPow = math.pow(otherPlayer.y - bullet.y, 2)

						dist = math.sqrt(xPow + yPow)

						if dist < 20 then
							table.remove(player.bullets, b)
							otherPlayer.exploding = true
							-- explode:play()
						end
					end
			   end
			end
		end
	end

	-- t = t + dt -- increase t by the deltatime

	-- if t > updaterate then
	-- 	local dg = string.format("%s %s %f %f %f %f %f", localPlayer.player, 'at', localPlayer.x, localPlayer.y, localPlayer.vx, localPlayer.vy, localPlayer.rotation)
	-- 	udp:send(dg)

	-- 	local dg = string.format("%s %s $", localPlayer.player, 'update')
	-- 	udp:send(dg)

	-- 	t=t-updaterate -- set t for the next round
	-- end

	-- repeat
	-- 	data, msg = udp:receive()

	-- 	if data then -- you remember, right? that all values in lua evaluate as true, save nil and false?
	-- 		ent, cmd, parms = data:match("^(%S*) (%S*) (.*)")
	-- 		if cmd == 'at' then
	-- 			local x, y, vx, vy, r = parms:match("^(%-?[%d.e]*) (%-?[%d.e]*) (%-?[%d.e]*) (%-?[%d.e]*) (%-?[%d.e]*)$")

	-- 			assert(x and y and vx and vy and r)
	-- 			x, y, vx, vy, r = tonumber(x), tonumber(y),tonumber(vx),tonumber(vy),tonumber(r)

	-- 			notFound = true
	-- 			for i, player in pairs(players) do
	-- 				if localPlayer.player == ent then
	-- 					notFound = false
	-- 					break
	-- 				elseif player.player == ent then
	-- 					notFound = false

	-- 					player.x = x
	-- 					player.y = y
	-- 					player.vx = vx
	-- 					player.vy = vy
	-- 					player.rotation = r
	-- 				end
	-- 			end

	-- 			if notFound then
	-- 				newplayer = Ship.new(ent,x,y,vx,vy,r)
	-- 				newplayer.color = 1
	-- 				table.insert(players, newplayer)
	-- 			end
	-- 		else
	-- 			print("unrecognised command:", cmd)

	-- 		end

	-- 	elseif msg ~= 'timeout' then
	-- 		error("Network error: "..tostring(msg))
	-- 	end
	-- until not data
end

function Game.draw()
	width = love.graphics.getWidth()
	height = love.graphics.getHeight()

	scaleFactor = width/1920

	love.graphics.scale(scaleFactor, scaleFactor)

	gCamX,gCamY = width/2,height/2
	TiledMap_AllAtCam(gCamX,gCamY)


	-- local joysticks = love.joystick.getJoysticks()

	for i, player in pairs(players) do
		if player.alive then
			player:draw()
		end
	end

	-- 	-- if joysticks[i] then
	-- 	-- 	axis = joysticks[i]:getGamepadAxis("leftx")
	-- 	-- 	love.graphics.print(player.rotation, 10, i * 20)
	-- 	-- end
	-- end

	for i, player in pairs(players) do

		bullets = table.getn(player.bullets)
		love.graphics.print(bullets, 50, 100*i+30)
	end



	fps = love.timer.getFPS()
    love.graphics.print(fps, 50, 50)
	love.graphics.setBackgroundColor(0x20,0x20,0x20)
end

function love.quit()
	-- local dg = string.format("%s %s $", localPlayer.player, 'delete')
	-- udp:send(dg)
end

return Game