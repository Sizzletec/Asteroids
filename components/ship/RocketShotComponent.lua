RocketShotComponent = {
  cannon = "right",
  gunCooldown = 0,
  weaponDamage = 1,
  fireRate = 1,
  firing = false
}

RocketShotComponent.__index = RocketShotComponent

function RocketShotComponent.new(entity)
  local i = {}
  setmetatable(i, RocketShotComponent)
  i.entity = entity
  return i
end

function RocketShotComponent:update(dt)
  if self.firing and self.gunCooldown <= 0 then
    self:fire()
    self.gunCooldown = 1/self.fireRate
  elseif self.gunCooldown > 0 then
    self.gunCooldown = self.gunCooldown - dt
  end
end

function RocketShotComponent:fire()
  if self.entity.components.life.health <= 0 then
    return
  end
  local move = self.entity.components.move
  self.entity.components.score.shots = self.entity.components.score.shots + 1

  local numBullets = 3
  local angleDiff = math.pi/8/numBullets
  for i=numBullets/3,-numBullets/3,-1 do
    local rBullet = move.rotation + i * angleDiff
    leftCannonOffsetX = move.x + (5 * math.sin(move.rotation))
    leftCannonOffsetY = move.y + (5 * -math.cos(move.rotation))
    bullet = Bullet.new(self.entity,leftCannonOffsetX,leftCannonOffsetY,600,rBullet, self.weaponDamage)
    bullet.components.exploding = ExplodingBulletComponent.new(bullet)
    table.insert(self.entity.bullets, bullet)
  end
end


return RocketShotComponent