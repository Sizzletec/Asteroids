RotatingFireComponent = {
  gunCooldown = 0,
  weaponDamage = 40,
  fireRate = 2,
  firing = false,
  cannonRotation = 0
}

RotatingFireComponent.__index = RotatingFireComponent

function RotatingFireComponent.new(entity)
  local i = {}
  setmetatable(i, RotatingFireComponent)
  i.entity = entity
  return i
end

function RotatingFireComponent:update(dt)
  if self.firing and self.gunCooldown <= 0 then
    self:fire()
    self.gunCooldown = 1/self.fireRate
  elseif self.gunCooldown > 0 then
    self.gunCooldown = self.gunCooldown - dt
  end
end

function RotatingFireComponent:fire()
  if self.entity.components.life.health <= 0 then
    return
  end
  local move = self.entity.components.move
  self.entity.components.score.shots = self.entity.components.score.shots + 1

  local x = move.x - (3 * math.sin(move.rotation))
  local y = move.y + (3 * math.cos(move.rotation))
  bullet = Bullet.new(x,y,900,self.cannonRotation, self.weaponDamage)
  table.insert(self.entity.bullets, bullet)
end

return RotatingFireComponent