MineComponent = {
  cannon = "right",
  gunCooldown = 0,
  weaponDamage = 10,
  fireRate = 1,
  firing = false
}

MineComponent.__index = MineComponent

function MineComponent.new(entity)
  local i = {}
  setmetatable(i, MineComponent)
  i.entity = entity
  return i
end

function MineComponent:update(dt)
  if self.firing and self.gunCooldown <= 0 then
    self:fire()
    self.gunCooldown = 1/self.fireRate
  elseif self.gunCooldown > 0 then
    self.gunCooldown = self.gunCooldown - dt
  end
end

function MineComponent:fire()
  if self.entity.components.life.health <= 0 then
    return
  end
  local move = self.entity.components.move
  self.entity.components.score.shots = self.entity.components.score.shots + 1

  local numBullets = 100
  local angleDiff = math.pi*2/numBullets
  for i=numBullets/2,-numBullets/2,-1 do
    local rBullet = move.rotation + i * angleDiff
    local x = move.x + (5 * math.sin(move.rotation))
    local y = move.y + (5 * -math.cos(move.rotation))
    bullet = Bullet.new(self.entity,x,y,10,rBullet, self.weaponDamage)
    table.insert(self.entity.bullets, bullet)
  end
end


return MineComponent