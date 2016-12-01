SpreadShotComponent = {
  cannon = "right",
  gunCooldown = 0,
  weaponDamage = 5,
  fireRate = 4,
  firing = false
}

SpreadShotComponent.__index = SpreadShotComponent

function SpreadShotComponent.new(entity)
  local i = {}
  setmetatable(i, SpreadShotComponent)
  i.entity = entity
  return i
end

function SpreadShotComponent:update(dt)
  if self.firing and self.gunCooldown <= 0 then
    self:fire()
    self.gunCooldown = 1/self.fireRate
  elseif self.gunCooldown > 0 then
    self.gunCooldown = self.gunCooldown - dt
  end
end

function SpreadShotComponent:fire()
  if self.entity.components.life.health <= 0 then
    return
  end
  local move = self.entity.components.move
  self.entity.components.score.shots = self.entity.components.score.shots + 1

  local numBullets = 4
  local angleDiff = math.pi/8/numBullets
  for i=numBullets/2,-numBullets/2,-1 do
    local rBullet = move.rotation + i * angleDiff
    leftCannonOffsetX = move.x + (5 * math.sin(move.rotation))
    leftCannonOffsetY = move.y + (5 * -math.cos(move.rotation))
    bullet = Bullet.new(self.entity,leftCannonOffsetX,leftCannonOffsetY,600,rBullet, self.weaponDamage)
    table.insert(Game.getObjects(), bullet)
  end
end


return SpreadShotComponent