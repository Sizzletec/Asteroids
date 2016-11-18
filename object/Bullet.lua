local image = love.graphics.newImage('images/bullets.png')

require('components/bullet/BouncingBulletComponent')
require('components/bullet/YieldingBulletComponent')
require('components/bullet/ExplodingBulletComponent')
require('components/bullet/HomingBulletComponent')

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
    yield = YieldingBulletComponent.new(s),
    homing = HomingBulletComponent.new(s)
  }

  s.components.move.throttle = 1
  s.components.move.topSpeed = 600
  s.rotationSpeed = 3
  s.components.move.acceleration = 3000000



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

  self:DistanceCovered()

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
      self:OnPlayerHit(otherPlayer)
     end
   end
  end

  m.rotation = math.atan2(m.vx,-m.vy)
end


function Bullet:OnPlayerHit(player)
  self.entity.components.score.hits = self.entity.components.score.hits + 1
  player.components.life:takeDamage(self.entity, self.damage)

  for _, component in pairs(self.components) do
    if component.OnPlayerHit then
      component:OnPlayerHit(player)
    end
  end
end

function Bullet:OnWallHit(tile,dt)
  for _, component in pairs(self.components) do
    if component.OnWallHit then
      component:OnWallHit(tile,dt)
    end
  end
  -- local move = self.components.move
  -- local sw = AoE.new(self.entity, move.x,move.y,10,30,0.5,self.damage)
  -- table.insert(self.entity.AoE, sw)
  -- self.bulletLife = 0
end


function Bullet:Remove()
  for _, component in pairs(self.components) do
    if component.Remove then
      component:Remove(player)
    end
  end
  self.bulletLife = 0
end


function Bullet:draw()
    local m = self.components.move

    q = love.graphics.newQuad(0, 0, 12, 12, 48, 48)
    tilesetBatch:add(q,m.x, m.y, m.rotation, 1,1 , 6,6)
end


function Bullet:DistanceCovered()
    -- local move = self.components.move
    -- if move.distance >= 600 then
    --   move.distance = 0


    --   -- local bullet = Bullet.new(self.entity, move.x,move.y,600,move.rotation+math.pi/2, self.damage)
    --   -- table.insert(self.entity.bullets, bullet)


    --   -- local bullet = Bullet.new(self.entity, move.x,move.y,600,move.rotation-math.pi/2, self.damage)
    --   -- table.insert(self.entity.bullets, bullet)



    --   -- local sw = AoE.new(self.entity, move.x,move.y,10,30,0.5,self.damage)
    --   -- table.insert(self.entity.AoE, sw)
    -- end
end


function Bullet.drawBatch()
  love.graphics.draw(tilesetBatch)
  tilesetBatch:flush()
  tilesetBatch:clear()
end

return Bullet