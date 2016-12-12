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
local active = 0
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


	active = 0

	activePlayers = {}
	for i, player in pairs(Players) do
		playerShip = player.ship
		
		if playerShip and player.select.step == SelectStep.ready then
			active = active + 1
			player.controlling = playerShip
			playerShip:setDefaults()
			playerShip:spawn()
			table.insert(players, playerShip)
			table.insert(objects, playerShip)
			table.insert(activePlayers, player)


		end
	end
	numberAlive = table.getn(players)
	gameWon = false
	winCount = 8

	width = love.graphics.getWidth()
	height = love.graphics.getHeight()

	for i, player in pairs(activePlayers) do
		player.cam = gamera.new(0,0,map.tileSize * map.width,map.tileSize * map.height)

		xOff = 0
		yOff = 0
		if i%2 == 0 then
			xOff = width/2 
		end 

		if i>2 and active > 2 then
			yOff = height/2 
		end

		if active > 2 then
			scale = 1.5
			player.cam:setWindow(xOff,yOff,width/2,height/2)
		else 
			scale = 2
			player.cam:setWindow(xOff,yOff,width/2,height)
		end
		
	end
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
	for i, player in pairs(Players) do
		if player.cam then
			player.cam:setScale(scale)

			move = player.ship.components.move
			player.cam:setPosition(move.x, move.y)
			if player.shake then
				player.shake = false
				player.cam:shake(5)
			end
		end
	end

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

	for i, player in pairs(Players) do
			if playerShip and player.select.step == SelectStep.ready then
			player.cam:draw(function(l,t,w,h)
	  			Game.drawBase(player)
			end)
		end
	end

	width = love.graphics.getWidth()
	height = love.graphics.getHeight()

	-- love.graphics.line(0,962, width,962)
	-- for i, player in pairs(players) do
	-- 	local xOffset = 1920/4 * (i-1) + 100
	-- 	love.graphics.setShader()
	-- 	player:drawLifeMarkers(xOffset+10,994)

	-- 	if player.components.life.lives > 0 then
	-- 		love.graphics.print(player.components.life.health .. " hp", xOffset+30, 1016)
	-- 	end
	-- end

	-- local joysticks = love.joystick.getJoysticks()
    -- for i, joystick in ipairs(joysticks) do
    --     love.graphics.print(joystick:getName(), 10, i * 20)
    -- end


    love.graphics.line(width/2,0, width/2,height)

    if active > 2 then
    	love.graphics.line(0,height/2, width,height/2)
    end


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

function Game.drawBase(player)
	width = love.graphics.getWidth()
	height = love.graphics.getHeight()

	scaleFactor = width/1920

	move = player.components.move
	love.graphics.scale(scaleFactor, scaleFactor)
	img:setWrap("repeat", "repeat")
	quad = love.graphics.newQuad(0,0, player.cam.w,player.cam.h, 200, 300)
	love.graphics.draw(img,quad, player.cam.x - player.cam.w/2, player.cam.y -player.cam.h/2, 0,2,2)
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