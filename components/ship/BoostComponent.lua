BoostComponent = {}
BoostComponent.__index = BoostComponent

function BoostComponent.new(entity)
  local i = {
    gunCooldown = 0,
    fireRate = 1,
    firing = false,
    active = false,
    duration = .4,
    activeTime = 0 
  }

  setmetatable(i, BoostComponent)
  i.entity = entity
  return i
end

function BoostComponent:update(dt)
  if self.firing and self.gunCooldown <= 0 then
    self:fire()
    self.gunCooldown = 1/self.fireRate
  elseif self.gunCooldown > 0 then
    self.gunCooldown = self.gunCooldown - dt
  end

  if self.active then
    local move = self.entity.components.move

    self.activeTime = self.activeTime + dt

    move.speedModifier = 8 - 7 * (self.activeTime/self.duration)
    if self.activeTime >= self.duration then
      self.active = false
      
      move.speedModifier = 1
      move.boosting = false
    end
  end
end

function BoostComponent:fire()
  if self.entity.components.life.health <= 0 then
    return
  end
  local move = self.entity.components.move
  move.speedModifier = 8
  self.activeTime = 0
  self.active = true  
end

function BoostComponent:draw()
  if self.active then
    local move = self.entity.components.move
    move.boosting = true
    -- love.graphics.circle("line", move.x, move.y, 16)

    -- love.graphics.draw(shieldImg,move.x-16,move.y-16)
  end
  -- if self.shape then
  --   -- self.shape:draw('line')
  -- end
end

return BoostComponent