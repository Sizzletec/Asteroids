ShieldDropComponent = {
  cannon = "right",
  gunCooldown = 0,
  weaponDamage = 1,
  fireRate = 1,
  firing = false,
}

ShieldDropComponent.__index = ShieldDropComponent

function ShieldDropComponent.new(entity)
  local i = {}
  setmetatable(i, ShieldDropComponent)
  i.entity = entity
  return i
end

function ShieldDropComponent:update(dt)
  if self.firing and self.gunCooldown <= 0 then
    self:fire()
    self.gunCooldown = 1/self.fireRate
  elseif self.gunCooldown > 0 then
    self.gunCooldown = self.gunCooldown - dt
  end
end

function ShieldDropComponent:fire()
  if self.entity.components.life.health <= 0 then
    return
  end
  local move = self.entity.components.move
  self.entity.components.score.shots = self.entity.components.score.shots + 1


  local sw = AoE.new(self.entity, move.x,move.y,99,100,10,0)
  table.insert(self.entity.AoE, sw)
end

function ShieldDropComponent:draw()
end

return ShieldDropComponent