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

  local numBullets = 100
  local angleDiff = 2 * math.pi / numBullets
  for i=numBullets/2,-numBullets/2,-1 do
    local rBullet = move.rotation + i * angleDiff
    local x = move.x + (5 * math.sin(move.rotation))
    local y = move.y + (5 * -math.cos(move.rotation))
    bullet = Bullet.new(self.entity,x,y,2*60,rBullet, self.weaponDamage)
    table.insert(self.entity.bullets, bullet)
  end
end


return SelfDestructComponent