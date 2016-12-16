local part1 = love.graphics.newImage('images/part.png')

require('components/aoe/ShieldComponent')

AoE = Object.new()
AoE.__index = AoE


function AoE.new(entity,x,y,startR,endR,time,damage)
  local s = {
    entity = entity,
    x = x,
    y = y,
    radius = startR,
    rate = (endR - startR)/ time,
    endR = endR,
    remove = false,
    damage = damage,
    contacts = {}
  }
  setmetatable(s, AoE)

  s.partSys = love.graphics.newParticleSystem(part1, 1500)

  s.components = {
    -- shield = ShieldComponent.new(s)
    -- exploding = BallBulletComponent.new(s)
  }


  s.partSys:setParticleLifetime(time) -- Particles live at least 2s and at most 5s.
  s.partSys:setPosition(s.x,s.y)
  s.partSys:setSpeed((s.rate+s.radius/time) *.9,s.rate+s.radius/time)
  s.partSys:setRotation( 0, math.pi/2)
  s.partSys:setSpread( math.pi * 2 )
  s.partSys:setColors(255, 255, 255, 255, 255, 100, 100, 255, 255, 200, 100, 255, 255, 255, 0, 0) -- Fade to transparency.
 
  -- s.partSys:setParticleLifetime(time) -- Particles live at least 2s and at most 5s.
  -- s.partSys:setPosition(s.x,s.y)
  -- -- s.partSys:setSpeed(s.rate*.9,s.rate)
  -- s.partSys:setSpeed(10,10)
  -- s.partSys:setRotation( 0, 2 * math.pi)
  -- s.partSys:setSpread(math.pi * 2 )
  -- s.partSys:setOffset(100,0)
  -- s.partSys:setColors(200, 200, 255, 255, 0, 0, 255, 0) -- Fade to transparency.
 
  s.partSys:emit(s.endR*5)
  s.shape = HC.circle(x,y,s.radius)
  return s
end

function AoE:update(dt)
  for _, component in pairs(self.components) do
    if component.update then
      component:update(dt)
    end
  end
  self.radius = self.radius + self.rate * dt
  self.partSys:update(dt)

  contacts = {}

  for shape, delta in pairs(HC.collisions(self.shape)) do
    if shape.entity and not shape.entity.phase then
      if self.contacts[shape.entity] == nil then

        contacts[shape.entity] = shape.entity
        if shape.type == "ship" then
          self:OnPlayerHit(shape.entity)
        elseif shape.type == "bullet" then
          self:OnBulletHit(shape.entity)
        elseif shape.type == "tile" then
          self:OnWallHit(shape.entity,dt)
          shape.entity:OnAoEHit(self)
        end   
      else
        contacts[shape.entity] = self.contacts[shape.entity]
      end
    end
  end
  self.contacts = contacts

  
  if math.abs(self.shape._radius - self.radius) >= 1 then
    -- print(self.shape._radius, self.radius,math.abs(self.shape._radius - self.radius) )
    HC.remove(self.shape)
    self.shape = HC.circle(self.x,self.y,self.radius)
  end
end

function Object:OnPlayerHit(player)
  if player ~= self.entity or self.hurtsOwner then
      -- local otherMove = player.components.move
      -- local xPow = math.pow(otherMove.x - self.x, 2)
      -- local yPow = math.pow(otherMove.y - self.y, 2)
      -- local dist = math.sqrt(xPow + yPow)

      -- if dist <= self.radius then
          player.components.life:takeDamage(self.entity, self.damage)
      -- end
    end
end

function AoE:OnBulletHit(bullet)
  for _, component in pairs(self.components) do
    if component.OnBulletHit then
      component:OnBulletHit(bullet)
    end
  end
end

function AoE:getObjectMask()
  return Collision.aoe
end

function AoE:getCollisonMask()
  cm = bit.bor(Collision.ship,Collision.bullet,Collision.tile)
  return cm
end

function AoE:shouldRemove()
  return self.radius >= self.endR
end

function AoE:draw()
  if debug then
    self.shape:draw('fill')
  end
  -- love.graphics.circle("line", self.x, self.y, self.radius)
  love.graphics.draw(self.partSys)
end

return AoE