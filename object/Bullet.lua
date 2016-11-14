local image = love.graphics.newImage('images/newBullet.png')

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

  local m = self.components.move

  -- if self.bounce then
  --   local hitWallY = TiledMap_GetMapTile(math.floor((m.x - m.vx * dt)/16),math.floor(m.y/16),1)
  --   local hitWallX = TiledMap_GetMapTile(math.floor(m.x/16),math.floor((m.y - m.vy * dt)/16),1)
  --   if hitWallX > 0 then
  --     m.vx = -m.vx
  --     m.x = m.x + m.vx * dt
  --   end
  --   if hitWallY > 0 then
  --     m.vy = -m.vy
  --     m.y = m.y + m.vy * dt
  --   end
  -- end


  if self.vortex then
    m.rotation = m.rotation + 2 * math.pi * dt

    local powX = math.pow(m.vx, 2)
    local powY = math.pow(m.vy, 2)
    local velocity = math.sqrt(powX + powY)
    velocity = velocity + 700 * dt

    m.vx = velocity * math.sin(m.rotation)
    m.vy = velocity * -math.cos(m.rotation)
  end


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

  m.rotation = math.atan2(m.vx,-m.vy)
  tilesetBatch:add(m.x, m.y, m.rotation, 1,1 , 6,6)
end

function Bullet.draw()
  tilesetBatch:flush()
  love.graphics.draw(tilesetBatch)
  tilesetBatch:clear()
end

return Bullet