ShotgunComponent = {
  gunCooldown = 0,
  weaponDamage = 0,
  fireRate = 0,
  firing = false
}

ShotgunComponent.__index = ShotgunComponent

function ShotgunComponent.new(entity)
  local i = {}
  setmetatable(i, ShotgunComponent)
  i.entity = entity
  i.fireRate = entity.shipType.fireRate
  i.weaponDamage = entity.shipType.weaponDamage
  return i
end

function ShotgunComponent:update(dt)
  if self.firing and self.gunCooldown <= 0 then
    self:fire()
    self.gunCooldown = 1/self.fireRate
  elseif self.gunCooldown > 0 then
    self.gunCooldown = self.gunCooldown - dt
  end
end

function ShotgunComponent:fire()
  if self.entity.components.life.health <= 0 then
    return
  end
  local move = self.entity.components.move
  self.entity.components.score.shots = self.entity.components.score.shots + 1


  local numBullets = 7
  local angleDiff = math.pi/4/numBullets
  for i=numBullets/2,-numBullets/2,-1 do
    local rBullet = move.rotation + i * angleDiff
    x = move.x + (5 * math.sin(move.rotation))
    y = move.y + (5 * -math.cos(move.rotation))
    bullet = Bullet.new(x,y,300,rBullet, self.weaponDamage)
    table.insert(self.entity.bullets, bullet)
  end
end


return ShotgunComponent