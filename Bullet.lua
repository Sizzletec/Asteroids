image = love.graphics.newImage('bullet.png')

Bullet = {}
Bullet.__index = Bullet

local tilesetBatch = love.graphics.newSpriteBatch(image)

function Bullet.new(x,y,speed,rotation,damage)
  local s = {}
  setmetatable(s, Bullet)
  s.x = x
  s.y = y
  s.rotation = rotation or 0
  s.vx = speed * math.sin(s.rotation)
  s.vy = speed * -math.cos(s.rotation)
  s.lifetime = 0
  s.damage = damage
  return s
end

function Bullet:update(dt)
  self.lifetime = self.lifetime + dt
  self.x = self.x + self.vx
  self.y = self.y + self.vy

  if self.y > (TiledMap_GetMapH() * 16) then
    self.y = self.y - TiledMap_GetMapH() * 16
  end

  if self.y < 0 then
    self.y = self.y + TiledMap_GetMapH() * 16
  end


  if self.x > 1920 then
    self.x = self.x - 1920
  end

  if self.x < 0 then
    self.x = self.x + 1920
  end

  tilesetBatch:add(self.x, self.y, self.rotation, 1,1 , 3,3)
end

function Bullet.draw()
  -- tilesetBatch:clear()

  tilesetBatch:flush()
  -- if self.lifetime < 1 then
    -- love.graphics.draw(self.image, self.x, self.y, self.rotation, 1,1 , 3,3)
  -- end
  love.graphics.draw(tilesetBatch)
  tilesetBatch:clear()
end

return Bullet