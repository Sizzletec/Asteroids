local shieldImg = love.graphics.newImage('images/shield.png')


ShieldingComponent = {}
ShieldingComponent.__index = ShieldingComponent

function ShieldingComponent.new(entity)
  local i = {
    gunCooldown = 0,
    fireRate = .1,
    firing = false,
    active = false,
    duration = 2,
    activeTime = 0 
  }

  setmetatable(i, ShieldingComponent)
  i.entity = entity

  i.entity.shield = i 
  return i
end

function ShieldingComponent:update(dt)
  if self.firing and self.gunCooldown <= 0 then
    self:fire()
    self.gunCooldown = 1/self.fireRate
  elseif self.gunCooldown > 0 then
    self.gunCooldown = self.gunCooldown - dt
  end

  if self.active then
    self.activeTime = self.activeTime + dt
    if self.activeTime >= self.duration then
      self.active = false
    end
  end
end

function ShieldingComponent:fire()
  if self.entity.components.life.health <= 0 then
    return
  end
  self.activeTime = 0
  self.active = true  
end


function ShieldingComponent:takeDamage(fromPlayer, damage)


end 

function ShieldingComponent:draw()
  if self.active then
    local move = self.entity.components.move
    -- love.graphics.circle("line", move.x, move.y, 16)

    love.graphics.draw(shieldImg,move.x-16,move.y-16)
  end
  -- if self.shape then
  --   -- self.shape:draw('line')
  -- end
end

return ShieldingComponent