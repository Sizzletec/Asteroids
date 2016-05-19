local image = love.graphics.newImage('images/bullet.png')

Bullet = {}
Bullet.__index = Bullet

local tilesetBatch = love.graphics.newSpriteBatch(image)

function Bullet.new(entity,x,y,speed,rotation,damage,bulletLife)
  local s = {}
  setmetatable(s, Bullet)
  s.bulletLife = bulletLife or 1
  s.lifetime = 0
  s.damage = damage
  s.entity = entity

  s.components = {
    move = MoveComponent.new(s),
  }

  local m = s.components.move

  m.x = x
  m.y = y
  m.rotation = rotation or 0
  m.vx = speed * math.sin(m.rotation)
  m.vy = speed * -math.cos(m.rotation)
  m.topSpeed = speed


  return s
end

function Bullet:update(dt)
  for _, component in pairs(self.components) do
    if component.update then
      component:update(dt)
    end
  end

  self.lifetime = self.lifetime + dt

  -- if self.bounce then
  --   local hitWallY = TiledMap_GetMapTile(math.floor((self.x - self.vx * dt)/16),math.floor(self.y/16),1)
  --   local hitWallX = TiledMap_GetMapTile(math.floor(self.x/16),math.floor((self.y - self.vy * dt)/16),1)
  --   if hitWallX > 0 then
  --     self.vx = -self.vx
  --     self.x = self.x + self.vx * dt
  --   end
  --   if hitWallY > 0 then
  --     self.vy = -self.vy
  --     self.y = self.y + self.vy * dt
  --   end
  -- end

  local m = self.components.move
  local hitWall = TiledMap_GetMapTile(math.floor(m.x/16),math.floor(m.y/16),1)

  if hitWall > 0 and not self.bounce then
    self.bulletLife = 0
  else

  for _, otherPlayer in pairs(Game.getPlayers()) do
     if self.entity ~= otherPlayer and otherPlayer.components.life.alive then
       xPow = math.pow(otherPlayer.components.move.x - m.x, 2)
       yPow = math.pow(otherPlayer.components.move.y - m.y, 2)

       dist = math.sqrt(xPow + yPow)

       if dist < 20 then
         self.entity.components.score.hits = self.entity.components.score.hits + 1
         otherPlayer.components.life:takeDamage(self.entity, self.damage)
         self.bulletLife = 0
       end
     end
    end
 end

 tilesetBatch:add(m.x, m.y, m.rotation, 1,1 , 3,3)
end

function Bullet.draw()
  tilesetBatch:flush()
  love.graphics.draw(tilesetBatch)
  tilesetBatch:clear()
end

return Bullet