AlternatingMissileComponent = {
  cannon = "right",
  gunCooldown = 0,
  weaponDamage = 0,
  fireRate = 0,
  firing = false
}

AlternatingMissileComponent.__index = AlternatingMissileComponent

function AlternatingMissileComponent.new(entity)
  local i = {}
  setmetatable(i, AlternatingMissileComponent)
  i.entity = entity
  i.fireRate = entity.shipType.fireRate
  i.weaponDamage = entity.shipType.weaponDamage
  return i
end

function AlternatingMissileComponent:update(dt)
  if self.firing and self.gunCooldown <= 0 then
    self:fire()
    self.gunCooldown = 1/self.fireRate
  elseif self.gunCooldown > 0 then
    self.gunCooldown = self.gunCooldown - dt
  end
end

function AlternatingMissileComponent:fire()
  if self.entity.components.life.health <= 0 then
    return
  end
  local move = self.entity.components.move
  self.entity.components.score.shots = self.entity.components.score.shots + 1

  local x,y = 0,0
  if self.cannon == "right" then
    x = move.x + (10 * math.sin(move.rotation)) + (8 * math.cos(move.rotation))
    y = move.y + (10 * -math.cos(move.rotation)) + (8 * math.sin(move.rotation))

  elseif self.cannon == "left" then
    x = move.x + (10 * math.sin(move.rotation)) + (-7 * math.cos(move.rotation))
    y = move.y + (10 * -math.cos(move.rotation)) + (-7 * math.sin(move.rotation))
  end

  bullet = MissileShot.new(self.entity,x,y,200,move.rotation, self.weaponDamage,5)
  table.insert(self.entity.bullets, bullet)

  if self.cannon == "right" then
    self.cannon = "left"
  else
    self.cannon = "right"
  end
end


return AlternatingMissileComponent