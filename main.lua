local Ship = require('Ship')
local Bullet = require('Bullet')

gKeyPressed = {}
yAccel = 0
xAccel = 0

function love.load()
	player = Ship.new(100,200,math.pi/2,0,0)
end

function love.keyreleased(key)
	gKeyPressed[key] = nil
end

function love.keypressed(key, unicode)
	gKeyPressed[key] = true
	if (key == "escape") then os.exit(0) end
	if (key == "space") then player:fire() end
end

function love.update( dt )
	local s = 0

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

		player.vx = player.vx + xAccel
		player.vy = player.vy + yAccel
	end

	if (gKeyPressed.left) then
		player.rotation = player.rotation - 4 * dt
		-- player.rotation = player.rotation - math.pi/2
	end

	if (gKeyPressed.right) then
		player.rotation = player.rotation + 4 * dt
		-- player.rotation = player.rotation + math.pi/2
	end
	player:update(dt)
	-- ship2:update()
end
function love.draw()
	player:draw()

	-- love.graphics.draw(bullet, player.x + 20 * -math.cos(player.rotation), player.y - 7 * math.sin(player.rotation), player.rotation, 1,1 , 3,3)

	-- love.graphics.draw(bullet, player.x + 30 * -math.cos(player.rotation), player.y + 8 * math.sin(player.rotation), player.rotation, 1,1 , 3,3)
	-- love.graphics.draw(bullet, player.x + 40 * -math.cos(player.rotation), player.y - 7 * math.sin(player.rotation), player.rotation, 1,1 , 3,3)
	-- ship2:draw()
    love.graphics.print(xAccel.." "..yAccel, 50, 50)
	love.graphics.setBackgroundColor(0x30,0x30,0x30)
end