local part1 = love.graphics.newImage('images/part.png')
AoE = {}
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
    damage = damage
  }
  setmetatable(s, AoE)

  s.partSys = love.graphics.newParticleSystem(part1, 1500)
  s.components = {}

  s.partSys:setParticleLifetime(time) -- Particles live at least 2s and at most 5s.
  -- s.partSys:setSizeVariation(0.1)

  s.partSys:setPosition(s.x,s.y)
  s.partSys:setSpeed((s.rate+s.radius/time) *.9,s.rate+s.radius/time)
  s.partSys:setRotation( 0, math.pi/2)
  -- s.partSys:setDirection(love.math.random(360))
  s.partSys:setSpread( math.pi * 2 )
  -- s.partSys:setRelativeRotation(true)


    -- if self.offset ~=  -dist/2 then
    --    self.partSys:reset()
       -- self.offset = -dist/2
    -- end

  -- s.partSys:setRadialAcceleration(1000000)
  -- self.partSys:setOffset(self.offset, 0)

  -- self.partSys:setAreaSpread("uniform", 30/2,(distanceTraveled+30)/2)

  -- s.partSys:setLinearAcceleration(1000, 10000, -1000, -1000) -- Random movement in all directions.
  s.partSys:setColors(255, 255, 255, 255, 255, 100, 100, 255, 255, 200, 100, 255, 255, 255, 0, 0) -- Fade to transparency.
  s.partSys:emit(s.endR*5)


  return s
end

function AoE:update(dt)
  self.radius = self.radius + self.rate * dt

  if self.radius >= self.endR then
    self.remove = true
  end
  -- local move = self.entity.components.move

  local players = Game.getPlayers()
  for p, otherPlayer in pairs(players) do
    if otherPlayer ~= self.entity then
      local otherMove = otherPlayer.components.move
      local xPow = math.pow(otherMove.x - self.x, 2)
      local yPow = math.pow(otherMove.y - self.y, 2)
      local dist = math.sqrt(xPow + yPow)

      if dist <= self.radius then
          otherPlayer.components.life:takeDamage(self.entity, self.damage)
      end
    end
  end
  self.partSys:update(dt)
end

function AoE:draw()
  -- love.graphics.circle("line", self.x, self.y, self.radius)
  love.graphics.draw(self.partSys)
end

return AoE