local beamImage = love.graphics.newImage('images/beam.png')

Beam = {}
Beam.__index = Beam

local w = beamImage:getWidth()
local h = beamImage:getHeight()

beamBatch = love.graphics.newSpriteBatch(beamImage)
local beam1 = love.graphics.newQuad(0, 0, 6, 4,w,h)
local beam2 = love.graphics.newQuad(6, 0, 6, 4,w,h)

function Beam.new(x,y,speed,rotation,damage,bulletLife)
  local s = {}
  setmetatable(s, Beam)
  s.x = x
  s.y = y
  s.bulletLife = bulletLife or 1
  s.rotation = rotation or 0
  s.vx = speed * math.sin(s.rotation)
  s.vy = speed * -math.cos(s.rotation)
  s.lifetime = 0
  s.damage = damage
  s.startPointX = 0
  s.startPointY = 0
  s.endPointX = 0
  s.endPointY = 0
  return s
end

function Beam:update(dt)
  self.lifetime = self.lifetime + dt

  local collide = true
  local xBeam = self.x + 12 * math.sin(self.rotation)
  local yBeam = self.y + 12 * -math.cos(self.rotation)
    self.startPointX = xBeam
    self.startPointY = yBeam


  -- beamBatch:add(beam1,xBeam, yBeam, self.rotation, 1,1 , 0,0)

  local beamSegmants = 1
  while collide and beamSegmants < 100 do

    OffsetX = xBeam + (beamSegmants * 3 * math.sin(self.rotation))
    OffsetY = yBeam + (beamSegmants * 3 * -math.cos(self.rotation))


    tile = TiledMap_GetMapTile(math.floor(xBeam/16),math.floor(yBeam/16),1)
    if tile > 0 then
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



  -- -- self.x = self.x + self.vx
  -- -- self.y = self.y + self.vy

  -- if self.y > (TiledMap_GetMapH() * 16) then
  --   self.y = self.y - TiledMap_GetMapH() * 16
  -- end

  -- if self.y < 0 then
  --   self.y = self.y + TiledMap_GetMapH() * 16
  -- end


  -- if self.x > 1920 then
  --   self.x = self.x - 1920
  -- end

  -- if self.x < 0 then
  --   self.x = self.x + 1920
  -- end


  -- tilesetBatch:add(self.x, self.y, self.rotation, 1,1 , 3,3)
end

function Beam:draw()
  love.graphics.line(self.startPointX, self.startPointY, self.endPointX,self.endPointY)
  -- beamBatch:flush()
  -- love.graphics.draw(beamBatch)
  -- beamBatch:clear()
end

return Beam