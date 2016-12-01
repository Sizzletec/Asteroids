Game = {}
Game.__index = Game

love.filesystem.load("maps/tiledmap.lua")()

require('object/object')
require('object/Map')
require('object/Ship')
require('object/Bullet')
require('object/AoE')
require('object/MissileShot')

HC = require("HC")

local myShader = love.graphics.newShader( "shaders/lighting.glsl" )
local players = {}
local objects = {}

gCamX,gCamY = 0,0

local numberAlive = 0
local gameWon = false
local winCount = 10

local map

local canvases = {}
local split = false
debug  = false
fps = true


function Game.load()
	players = {}
	objects = {}
	local level = "maps/arena" .. tostring(love.math.random(4)) .. ".tmx"
	map = nil
	map = Map.new(level)
	TiledMap_Load(level,16)

	spawn = TiledMap_GetSpawnLocations()


	for i, player in pairs(selections) do
		playerShip = player.ship
		if playerShip then
			playerShip:setDefaults()
			playerShip:spawn()
			table.insert(players, playerShip)
			table.insert(objects, playerShip)
		end
	end
	numberAlive = table.getn(players)
	gameWon = false
	winCount = 8

	canvases = {
	love.graphics.newCanvas(love.graphics.getWidth()/2,love.graphics.getHeight()/2),
	love.graphics.newCanvas(love.graphics.getWidth()/2,love.graphics.getHeight()/2),
	love.graphics.newCanvas(love.graphics.getWidth()/2,love.graphics.getHeight()/2),
	love.graphics.newCanvas(love.graphics.getWidth()/2,love.graphics.getHeight()/2)
}
end

function Game.getPlayers()
	return players
end

function Game.getObjects()
	return objects
end

function Game.GetSpawnLocation()
	local newSpawn = {x = 100, y = 100, r = 0}

	playerCount = table.getn(players)

	anyoneAlive = false
	for p, player in pairs(players) do
		if player.components.life.alive then
			anyoneAlive =true
		end
	end

	if playerCount == 0 or not anyoneAlive then
		newSpawn = {x = spawn[1].x, y = spawn[1].y, r = spawn[1].r}
	else
		local bestDistance = 0

		for l, location in pairs(spawn) do
			local compDist
			for p, player in pairs(players) do
				if player.components.life.alive then
					xPow = math.pow(player.components.move.x - location.x, 2)
					yPow = math.pow(player.components.move.y - location.y, 2)

					local dist = math.sqrt(xPow + yPow)
					if not compDist then
						compDist = dist
					elseif dist < compDist then
						compDist = dist
					end
				end
			end

			if compDist >= bestDistance then
				bestDistance = compDist
				newSpawn = {x = location.x, y = location.y, r = location.r}
			end
		end
	end
	return newSpawn
end

function Game.keyreleased(key)
	for _, player in pairs(players) do
		local keyboard = player.components.input.components.keyboard
		if keyboard ~= nil then
			keyboard:keyreleased(key)
		end
	end
end

function Game.keypressed(key, unicode)
	if (key == "escape") then setState(State.shipSelect) end
	for _, player in pairs(players) do
		local keyboard = player.components.input.components.keyboard
		if keyboard ~= nil then
			keyboard:keypressed(key, unicode)
		end
	end
end

function Game.gamepadpressed(joystick, button)
	local id, instanceid = joystick:getID()
	local player = Game.getPlayer(id)
	if player then
		local joystick = player.components.input.components.joystick
		if joystick ~= nil then
			joystick:gamepadpressed(joystick, button)
		end
	end
end

function Game.gamepadreleased(joystick, button)
	local id, instanceid = joystick:getID()
	local player = Game.getPlayer(id)
	if player then
		local joystick = player.components.input.components.joystick
		if joystick ~= nil then
			joystick:gamepadreleased(joystick, button)
		end
	end
end

function Game.gamepadaxis(joystick, axis, value)
	local id, instanceid = joystick:getID()
	local player = Game.getPlayer(id)
	if player then
		local joystick = player.components.input.components.joystick
		if joystick ~= nil then
			joystick:gamepadaxis(joystick, axis, value)
		end
	end
end

function Game.getPlayer(id)
	for i, player in pairs(players) do
		if player.player == id then
			return player
		end
	end
end

function Game.checkWin()
	for i, player in pairs(players) do
		if player.components.life.lives == 0 then
			if not player.place then
				player.place = numberAlive
				numberAlive = numberAlive - 1
			end
		end
	end
	if numberAlive == 1 then
		for i, player in pairs(players) do
			if player.components.life.lives > 0 then
				player.place = numberAlive
			end
			selections[player.player].ship = player
		end
		gameWon = true
	end
end

function Game.update(dt)
	map:update(dt)
	Game.updateObjects(dt)

	if gameWon then
		winCount = winCount - 3 * dt
		dt = dt / winCount

		if winCount <= 1 then
			setState(State.score)
		end
	end
	Game.checkWin()
end

function Game.updateObjects(dt)
	for i, obj in pairs(objects) do

		if obj:shouldRemove() then
			obj:Remove()
			table.remove(objects,i)
		else
			obj:update(dt)
		end
	end
end

function Game.draw()
	width = love.graphics.getWidth()
	height = love.graphics.getHeight()

	if split then
		for index,can in ipairs(canvases) do
			move = players[index].components.move

			transX = -move.x + width/4
			transY = -move.y + height/4

			xMax = false
			xMin = false

			yMax = false
			yMin = false

		if transX < -map.width* 16 + can:getWidth() then
    elseif transX > 0 then
      transX = 0
      xMin = true
    end
			transX = -map.width* 16 + can:getWidth()
			xMax = true

  		if transY < -map.height* 16 + can:getHeight() then
  			transY = -map.height* 16 + can:getHeight()
  			yMax = true
			elseif transY > 0 then
				transY = 0
				yMin = true
			end

			love.graphics.translate(transX , transY)
			love.graphics.setCanvas(can)
			love.graphics.clear()

			Game.drawBase()

			transX = move.x - width/4
			transY = move.y - height/4

			if xMin then
				transX = 0
			elseif xMax then
				transX = map.width* 16 - can:getWidth()
			end

			if yMin then
				transY = 0
			elseif yMax then
				transY = map.height* 16 - can:getHeight()
			end

			love.graphics.translate(transX, transY)
			love.graphics.setCanvas()
			x = 0
			y = 0
			if index%2 == 0 then
				x = width/2
			end
			if index > 2 then
				y = height/2
			end
			love.graphics.draw(can,x,y)

			player = players[index]
			player:drawLifeMarkers(x+4,y+20)

			if player.components.life.lives > 0 then
				love.graphics.print(player.components.life.health .. " hp", x+26, y+42)
			end
		end
		love.graphics.line(0,height/2, width,height/2)
		love.graphics.line(width/2,0, width/2,height)
	else
		Game.drawBase()
		for i, player in pairs(players) do
			local xOffset = 1920/4 * (i-1) + 100
			love.graphics.setShader()
			player:drawLifeMarkers(xOffset+10,994)

			if player.components.life.lives > 0 then
				love.graphics.print(player.components.life.health .. " hp", xOffset+30, 1016)
			end
		end
	end
end

function Game.drawBase()
	width = love.graphics.getWidth()
	height = love.graphics.getHeight()

	scaleFactor = width/1920

	love.graphics.scale(scaleFactor, scaleFactor)
	-- love.graphics.setColor(255, 255, 255, alpha)
	map:drawBackground()
	-- love.graphics.setColor(255, 255, 255, 255)
	love.graphics.setNewFont(40)
	for i, obj in pairs(objects) do
		obj:draw()
	end
	Bullet.drawBatch()
	MissileShot.draw()
	-- Beam.draw()

	map:drawForeground()
	love.graphics.setBackgroundColor(0x20,0x20,0x20)

	if fps then
		fps = love.timer.getFPS()
		love.graphics.print(fps, 0, 100)
	end
	if debug then

		local count = 0 
		for _, v in pairs(HC.hash():shapes()) do 
			count = count +1 
		end
		love.graphics.print(count, 40, 200)
	end
end

return Game