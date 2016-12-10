Game = {}
Game.__index = Game

love.filesystem.load("maps/tiledmap.lua")()

require('object/object')
require('object/Map')
require('object/Ship')
require('object/Bullet')
require('object/AoE')
require('object/MissileShot')


img = love.graphics.newImage('images/background.png')


HC = require("HC")
local gamera =  require("gamera/gamera")

local myShader = love.graphics.newShader( "shaders/lighting.glsl" )
local players = {}
local objects = {}


local scale = 2
gCamX,gCamY = 0,0

local numberAlive = 0
local gameWon = false
local winCount = 10

local map

local canvases = {}
local split = false
debug  = false
fps = true

local cam1
local cam2


function Game.load()
	players = {}
	objects = {}
	local level = "maps/arena" .. tostring(love.math.random(5)) .. ".tmx"
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

	cam1 = gamera.new(0,0,map.tileSize * map.width,map.tileSize * map.height)
	cam1:setWindow(0,0,map.tileSize * map.width/2,map.tileSize * map.height)

	cam2 = gamera.new(0,0,map.tileSize * map.width,map.tileSize * map.height)
	cam2:setWindow(map.tileSize * map.width/2,0,map.tileSize * map.width/2,map.tileSize * map.height)
	
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
	cam1:setScale(scale)
	cam2:setScale(scale)

	map:update(dt)
	Game.updateObjects(dt)
	move = players[1].components.move
	-- cam:setAngle(move.rotation)

	-- camGoalX = move.x + 100 * math.sin(move.rotation)
	-- camGoalY = move.y - 100 * math.cos(move.rotation)

	-- rate = 4
	-- nextPos = {x = move.x,y = move.y}
	-- if cam.x < camGoalX then
	-- 	nextPos.x = cam.x + rate
	-- elseif cam.x > camGoalX then
	-- 	nextPos.x = cam.x - rate
	-- end

	-- if cam.y < camGoalY then
	-- 	nextPos.y = cam.y + rate
	-- elseif cam.y > camGoalY then
	-- 	nextPos.y = cam.y - rate
	-- end


	-- if math.abs(cam.x - camGoalX)< rate  or math.abs(cam.x - camGoalX)>500 then
	-- 	nextPos.x = camGoalX
	-- end

	-- if math.abs(cam.y - camGoalY)< rate or math.abs(cam.y - camGoalY)>500 then
	-- 	nextPos.y = camGoalY
	-- end

	-- cam:setPosition(nextPos.x, nextPos.y)
	move2 = players[2].components.move
	cam1:setPosition(move.x, move.y)
	cam2:setPosition(move2.x, move2.y)
	if Game.shake1 then
		Game.shake1 = false
		cam1:shake(5)
	end

	if Game.shake2 then
		Game.shake2 = false
		cam2:shake(5)
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
	cam1:draw(function(l,t,w,h)
  		Game.drawBase(cam1,1)
	end)

	cam2:draw(function(l,t,w,h)
  		Game.drawBase(cam2,1)
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

	-- local joysticks = love.joystick.getJoysticks()
    -- for i, joystick in ipairs(joysticks) do
    --     love.graphics.print(joystick:getName(), 10, i * 20)
    -- end

    love.graphics.line(width/2,0, width/2,962)

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

function Game.drawBase(cam,player)
	width = love.graphics.getWidth()
	height = love.graphics.getHeight()

	scaleFactor = width/1920

	move = players[player].components.move
	love.graphics.scale(scaleFactor, scaleFactor)
	img:setWrap("repeat", "repeat")
	quad = love.graphics.newQuad(0,0, cam.w,cam.h, 200, 300)
	love.graphics.draw(img,quad, cam.x - cam.w/2, cam.y -cam.h/2)
	map:drawBackground()
	love.graphics.setNewFont(40)
	for i, obj in pairs(objects) do
		obj:draw()
	end
	Bullet.drawBatch()
	MissileShot.draw()
	map:drawForeground()
	love.graphics.setBackgroundColor(0x20,0x20,0x20)


end

return Game