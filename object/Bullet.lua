local image = love.graphics.newImage('images/bullets.png')

require('components/bullet/BouncingBulletComponent')
require('components/bullet/YieldingBulletComponent')
require('components/bullet/ExplodingBulletComponent')
require('components/bullet/HomingBulletComponent')
require('components/bullet/IonBulletComponent')
require('components/bullet/SapperBulletComponent')

Bullet = Object.new()
Bullet.__index = Bullet

local tilesetBatch = love.graphics.newSpriteBatch(image)

function Bullet.new(entity,x,y,speed,rotation,damage,bulletLife)
  local s = {}
  setmetatable(s, Object)
  setmetatable(s, Bullet)
  s.bulletLife = bulletLife or 1
  s.lifetime = 0
  s.damage = damage
  s.entity = entity

  s.components = {
    move = MoveComponent.new(s),
    yield = YieldingBulletComponent.new(s),
    -- exploding = BallBulletComponent.new(s)
  }

  local m = s.components.move
  m.x = x
  m.y = y
  m.rotation = rotation or 0
  m.vx = speed * math.sin(m.rotation)
  m.vy = speed * -math.cos(m.rotation)
  m.topSpeed = speed

  s.shape = HC.circle(m.x,m.y,5)
  s.shape.type = "bullet"
  s.shape.entity = s

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

  if self.vortex then
    m.rotation = m.rotation + 2 * math.pi * dt

    local powX = math.pow(m.vx, 2)
    local powY = math.pow(m.vy, 2)
    local velocity = math.sqrt(powX + powY)
    velocity = velocity + 700 * dt

    m.vx = velocity * math.sin(m.rotation)
    m.vy = velocity * -math.cos(m.rotation)
  end

  m.rotation = math.atan2(m.vx,-m.vy)

  for shape, delta in pairs(HC.collisions(self.shape)) do
    if shape.type == "ship" then
      self:OnPlayerHit(shape.entity)
    elseif shape.type == "tile" then
      shape.entity:OnBulletHit(self,delta)
    end
  end
end


function Bullet:OnPlayerHit(player)
  if self.entity ~= player and player.components.life.alive and not player.phase then
    self.entity.components.score.hits = self.entity.components.score.hits + 1
    player.components.life:takeDamage(self.entity, self.damage)

    for _, component in pairs(self.components) do
      if component.OnPlayerHit then
        component:OnPlayerHit(player)
      end
    end
  end
end

function Bullet:OnWallHit(tile,delta)
  for _, component in pairs(self.components) do
    if component.OnWallHit then
      component:OnWallHit(tile,delta)
    end
  end
end

function Bullet:shouldRemove()
  return self.lifetime > self.bulletLife 
end

function Bullet:Remove()
  for _, component in pairs(self.components) do
    if component.Remove then
      component:Remove(player)
    end
  end
  HC.remove(self.shape)
end

function Bullet:draw()
    local m = self.components.move
    c = self.entity.player.select.color

    c = c + 2 

    if c > 3 then
      c = c - 4
    end

    q = love.graphics.newQuad(12*c, 0, 12, 12, 48, 12)
    tilesetBatch:add(q,m.x, m.y, m.rotation, 1,1 , 6,6)

    if debug then
      self.shape:draw('fill')
    end
end

function Bullet.drawBatch()
  love.graphics.draw(tilesetBatch)
  tilesetBatch:flush()
  tilesetBatch:clear()
end

return Bullet