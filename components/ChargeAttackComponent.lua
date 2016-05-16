ChargeAttackComponent = {
  gunCooldown = 0,
  weaponDamage = 20,
  fireRate = 4,
  firing = false,
  chargeAmount = 0,
  charging = 0
}

ChargeAttackComponent.__index = ChargeAttackComponent

function ChargeAttackComponent.new(entity)
  local i = {}
  setmetatable(i, ChargeAttackComponent)
  i.entity = entity
  return i
end

function ChargeAttackComponent:update(dt)
  if self.firing and self.gunCooldown <= 0 then
    self:fire()
    self.gunCooldown = 1/self.fireRate
  elseif self.gunCooldown > 0 then
    self.gunCooldown = self.gunCooldown - dt
  end

  local move = self.entity.components.move
  if not self.firing and self.charging then
    self.entity.components.score.shots = self.entity.components.score.shots + 1
    local numBullets = math.floor(self.chargeAmount)
    local angleDiff = math.pi/4/numBullets
    for i=numBullets/2,-numBullets/2,-1 do
      local rBullet = move.rotation + i * angleDiff
      local x = move.x + (5 * math.sin(move.rotation))
      local y = move.y + (5 * -math.cos(move.rotation))
      bullet = Bullet.new(self.entity,x,y,300,rBullet, self.weaponDamage)
      table.insert(self.entity.bullets, bullet)
    end
    self.charging=false
  end
end

function ChargeAttackComponent:fire()
  if self.entity.components.life.health <= 0 then
    return
  end

  if self.charging then
    if self.chargeAmount < 10 then
      self.chargeAmount = self.chargeAmount + 1
    end
  else
    self.charging = true
    self.chargeAmount = 1
  end
end

function ChargeAttackComponent:draw()
  local move = self.entity.components.move
  if self.charging then
    love.graphics.circle("line", move.x + (15 * math.sin(move.rotation)), move.y - (15 * math.cos(move.rotation)), self.chargeAmount, 30)
  end
end


return ChargeAttackComponent