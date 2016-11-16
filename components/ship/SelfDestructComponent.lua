SelfDestructComponent = {
  cannon = "right",
  gunCooldown = 0,
  weaponDamage = 200,
  fireRate = 1,
  firing = false
}

SelfDestructComponent.__index = SelfDestructComponent

function SelfDestructComponent.new(entity)
  local i = {}
  setmetatable(i, SelfDestructComponent)
  i.entity = entity
  return i
end

function SelfDestructComponent:update(dt)
  if self.firing and self.gunCooldown <= 0 then
    self:fire()
    self.gunCooldown = 1/self.fireRate
  elseif self.gunCooldown > 0 then
    self.gunCooldown = self.gunCooldown - dt
  end
end

function SelfDestructComponent:fire()
  if self.entity.components.life.health <= 0 then
    return
  end
  local move = self.entity.components.move
  self.entity.components.life.health = 0

  local sw = AoE.new(self.entity, move.x,move.y,10,500,4,self.weaponDamage)
  table.insert(self.entity.AoE, sw)
end


return SelfDestructComponent