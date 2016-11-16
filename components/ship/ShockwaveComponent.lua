ShockwaveComponent = {
  cannon = "right",
  gunCooldown = 0,
  weaponDamage = 1,
  fireRate = 1,
  firing = false,
}

ShockwaveComponent.__index = ShockwaveComponent

function ShockwaveComponent.new(entity)
  local i = {}
  setmetatable(i, ShockwaveComponent)
  i.entity = entity
  return i
end

function ShockwaveComponent:update(dt)
  if self.firing and self.gunCooldown <= 0 then
    self:fire()
    self.gunCooldown = 1/self.fireRate
  elseif self.gunCooldown > 0 then
    self.gunCooldown = self.gunCooldown - dt
  end
end

function ShockwaveComponent:fire()
  if self.entity.components.life.health <= 0 then
    return
  end
  local move = self.entity.components.move
  self.entity.components.score.shots = self.entity.components.score.shots + 1


  local sw = AoE.new(self.entity, move.x,move.y,10,200,1,self.weaponDamage)
  table.insert(self.entity.AoE, sw)
end

function ShockwaveComponent:draw()
end

return ShockwaveComponent