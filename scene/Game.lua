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
local gamera =  require("gamera/gamera")

local myShader = love.graphics.newShader( "shaders/lighting.glsl" )
local players = {}
local objects = {}


local scale = 1
gCamX,gCamY = 0,0

local numberAlive = 0
local gameWon = false
local winCount = 10

local map

local canvases = {}
local split = false
debug  = false
fps = true

local cam


function Game.load()
	players = {}
	objects = {}
	local level = "maps/arena" .. tostring(love.math.random(4)) .. ".tmx"
	map = nil
	map = Map.new(level)
	TiledMap_Load(level,16)

	spawn = TiledMap_GetSpawnLocations()


	for i, player in pairs(Players) do
		playerShip = player.ship
		
		if playerShip and player.select.step == SelectStep.ready then
			player.controlling = playerShip
			playerShip:setDefaults()
			playerShip:spawn()
			table.insert(players, playerShip)
			table.insert(objects, playerShip)
		end
	end
	numberAlive = table.getn(players)
	gameWon = false
	winCount = 8

	cam = gamera.new(0,0,map.tileSize * map.width,map.tileSize * map.height)
	cam:setWindow(0,0,map.tileSize * map.width,map.tileSize * map.height)
	
end

function Game.resize(w, h)
	print("resize",w,h)
  	
end

function Game.getPlayers()
	return players
end

function Game.getObjects()
	return objects
end

function Game.keypressed(key, unicode)
	if (key == "escape") then setState(ShipSelect)  end
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
		end
		gameWon = true
	end
end

function Game.update(dt)
	-- if scale < 4 then
	-- 	scale = scale + 0.1 * dt
	-- end 
	cam:setScale(2)
	map:update(dt)
	Game.updateObjects(dt)
	move = players[1].components.move
	-- cam:setAngle(move.rotation)

	cam:setPosition(move.x, move.y)
	if Game.shake then
		 Game.shake = false
		cam:shake(5)
	end
	-- cam:setAngle(move.rotation)

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
	cam:draw(function(l,t,w,h)
  		Game.drawBase()
	end)
	width = love.graphics.getWidth()
	height = love.graphics.getHeight()

	love.graphics.line(0,962, width,962)
	for i, player in pairs(players) do
		local xOffset = 1920/4 * (i-1) + 100
		love.graphics.setShader()
		player:drawLifeMarkers(xOffset+10,994)

		if player.components.life.lives > 0 then
			love.graphics.print(player.components.life.health .. " hp", xOffset+30, 1016)
		end
	end

	local joysticks = love.joystick.getJoysticks()
    for i, joystick in ipairs(joysticks) do
        love.graphics.print(joystick:getName(), 10, i * 20)
    end
end

function Game.drawBase()
	width = love.graphics.getWidth()
	height = love.graphics.getHeight()

	scaleFactor = width/1920

	love.graphics.scale(scaleFactor, scaleFactor)
	map:drawBackground()
	love.graphics.setNewFont(40)
	for i, obj in pairs(objects) do
		obj:draw()
	end
	Bullet.drawBatch()
	MissileShot.draw()
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