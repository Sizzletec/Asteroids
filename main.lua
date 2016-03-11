love.filesystem.load("tiledmap.lua")()

local Ship = require('Ship')
local Bullet = require('Bullet')

gKeyPressed = {}
yAccel = 0
xAccel = 0

players = {}

gCamX,gCamY = 0,0

function love.load()
	love.window.setMode(960, 540, {fullscreen=false, resizable=false, highdpi=true})
	player1 = Ship.new(0,100,100,math.pi/2,0,0)
	player2 = Ship.new(1,1820,100,-math.pi/2,0,0)
	player3 = Ship.new(2,100,860,math.pi/2,0,0)
	player4 = Ship.new(3,1820,860,-math.pi/2,0,0)

	table.insert(players, player1)
	table.insert(players, player2)
	table.insert(players, player3)
	table.insert(players, player4)

	TiledMap_Load("arena.tmx",16)
	gCamX,gCamY = 1920/2 ,1080/2
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
		end
	end
	if (key == "e") then player1.rotation = player1.rotation + math.pi end
end

function love.gamepadpressed(joystick, button)
    if button == "a" then
    	id, instanceid = joystick:getID()
    	players[id]:fire()
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
			end
			
			

			if throttle > 0 then
				xAccel = throttle * 5 * dt * math.sin(player.rotation)
				yAccel = throttle * 5 * dt * -math.cos(player.rotation)

				player.vx = player.vx + xAccel
				player.vy = player.vy + yAccel

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
					end
				end
		   end
		end
	end
end

function love.draw()
	TiledMap_DrawNearCam(gCamX,gCamY)
	local joysticks = love.joystick.getJoysticks()

	for i, player in pairs(players) do
		if player.alive then
			player:draw()
		end

		if joysticks[i] then
			axis = joysticks[i]:getGamepadAxis("leftx")
			love.graphics.print(player.vx .." " .. player.vy, 10, i * 20)
		end
	end

	fps = love.timer.getFPS()
    love.graphics.print(fps, 50, 50)
	love.graphics.setBackgroundColor(0x30,0x30,0x30)



end