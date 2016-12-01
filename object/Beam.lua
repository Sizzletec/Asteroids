local part1 = love.graphics.newImage('images/part.png')

part1:setFilter('nearest', 'nearest')

Beam = {}
Beam.__index = Beam

function Beam.new(player,damage)
  local s = {}
  setmetatable(s, Beam)
  s.x = x
  s.y = y
  s.player = player
  s.rotation = rotation or 0
  s.lifetime = 0
  s.damage = damage
  s.startPointX = 0
  s.startPointY = 0
  s.endPointX = 0
  s.endPointY = 0
  s.offset = 0

  s.partSys = love.graphics.newParticleSystem(part1, 1000)
  return s
end

function Beam:update(x,y,rotation,dt)
  self.rotation = rotation
  self.x = x
  self.y = y

  local collide = true
  local xBeam = self.x + 12 * math.sin(self.rotation)
  local yBeam = self.y + 12 * -math.cos(self.rotation)
    self.startPointX = xBeam
    self.startPointY = yBeam

  local beamSegmants = 1
  while collide and beamSegmants < 100 do

    OffsetX = xBeam + (beamSegmants * 3 * math.sin(self.rotation))
    OffsetY = yBeam + (beamSegmants * 3 * -math.cos(self.rotation))

    local playerHit = false
    local players = Game.getPlayers()

    for p, otherPlayer in pairs(players) do
      if otherPlayer ~= self.player and otherPlayer.components.life.alive then
        local otherMove = otherPlayer.components.move

        xPow = math.pow(xBeam - otherMove.x, 2)
        yPow = math.pow(yBeam - otherMove.y, 2)

        dist = math.sqrt(xPow + yPow)
        if dist < 10 then
          otherPlayer.components.life:takeDamage(self.player, self.damage)

          playerHit = true
        end
      end
    end

    tile = TiledMap_GetMapTile(math.floor(xBeam/16),math.floor(yBeam/16),1)
    if tile > 0  or playerHit then
      collide = false
    else
        beamSegmants = beamSegmants + 1
        -- beamBatch:add(beam1, OffsetX, OffsetY, self.rotation, 1,1 ,0,0)
        xBeam = xBeam + 3 * math.sin(self.rotation)
        yBeam = yBeam + 3 * -math.cos(self.rotation)
    end
    self.endPointX = xBeam
    self.endPointY = yBeam
  end


  xPow = math.pow(self.startPointX - self.endPointX, 2)
  yPow = math.pow(self.startPointY - self.endPointY, 2)

  dist = math.sqrt(xPow + yPow)



  -- speed = 2000

  self.partSys:setParticleLifetime(.3, .3) -- Particles live at least 2s and at most 5s.
  -- self.partSys:setEmissionRate(500)
  self.partSys:setSizeVariation(1)

  -- self.partSys:setPosition(self.startPointX,self.startPointY)
  -- self.partSys:setSpeed(speed)
  -- self.partSys:setDirection(self.rotation -math.pi/2)

  self.partSys:setEmissionRate(5*dist)
  -- self.partSys:setRelativeRotation(true)


    -- if self.offset ~=  -dist/2 then
    --    self.partSys:reset()
       self.offset = -dist/2
    -- end

  self.partSys:setOffset(self.offset, 0)

  self.partSys:setAreaSpread("uniform", dist/2,0)

  self.partSys:setLinearAcceleration(20, 200, 0, -200) -- Random movement in all directions.
  self.partSys:setColors(0, 200, 255,255, 0,200,255, 0) -- Fade to transparency.
-- Fade to transparency.
  self.partSys:update(dt)
end

function Beam:draw()
  love.graphics.draw(self.partSys,self.startPointX,self.startPointY,self.rotation-math.pi/2)

  -- love.graphics.line(self.startPointX, self.startPointY, self.endPointX,self.endPointY)
  -- beamBatch:flush()
  -- love.graphics.draw(beamBatch)
  -- beamBatch:clear()
end

return Beam