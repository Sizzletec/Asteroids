local image = love.graphics.newImage('images/bullet.png')

Bullet = {}
Bullet.__index = Bullet

local tilesetBatch = love.graphics.newSpriteBatch(image)

function Bullet.new(x,y,speed,rotation,damage,bulletLife)
  local s = {}
  setmetatable(s, Bullet)
  s.x = x
  s.y = y
  s.bulletLife = bulletLife or 1
  s.rotation = rotation or 0
  s.vx = speed * math.sin(s.rotation)
  s.vy = speed * -math.cos(s.rotation)
  s.lifetime = 0
  s.damage = damage
  return s
end

function Bullet:update(dt)

  self.lifetime = self.lifetime + dt
  Mover.ApplyVelocity(self, dt)

  if self.bounce then
    local hitWallY = TiledMap_GetMapTile(math.floor((self.x - self.vx * dt)/16),math.floor(self.y/16),1)
    local hitWallX = TiledMap_GetMapTile(math.floor(self.x/16),math.floor((self.y - self.vy * dt)/16),1)
    
    if hitWallX > 0 then
      self.vx = -self.vx
      self.x = self.x + self.vx * dt
    end
    if hitWallY > 0 then
      self.vy = -self.vy
      self.y = self.y + self.vy * dt
    end
  end

  Mover.StageWrap(self)
  tilesetBatch:add(self.x, self.y, self.rotation, 1,1 , 3,3)
end

function Bullet.draw()
  tilesetBatch:flush()
  love.graphics.draw(tilesetBatch)
  tilesetBatch:clear()
end

return Bullet