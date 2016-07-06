local part1 = love.graphics.newImage('images/part.png')

BoostComponent = {
  gunCooldown = 0,
  fireRate = 1,
  firing = false
}

BoostComponent.__index = BoostComponent

function BoostComponent.new(entity)
  local i = {}
  setmetatable(i, BoostComponent)
  i.entity = entity
  return i
end

function BoostComponent:update(dt)
  if self.entity.components.life.health <= 0 then
    return
  end

  local move = self.entity.components.move

  if self.firing then
    move.speedModifier = 2
  else
    move.speedModifier = 1
  end
end

return BoostComponent