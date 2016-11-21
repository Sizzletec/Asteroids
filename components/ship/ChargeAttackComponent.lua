ChargeAttackComponent = {}

ChargeAttackComponent.__index = ChargeAttackComponent

function ChargeAttackComponent.new(entity)
  local i = {
    gunCooldown = 0,
    weaponDamage = 10,
    fireRate = 4,
    firing = false,
    chargeAmount = 0,
    charging = 0
  }
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

  local life = self.entity.components.life

  if not life.alive then
    charging = 0
  end

  local move = self.entity.components.move
  if not self.firing and self.charging then
    self.entity.components.score.shots = self.entity.components.score.shots + 1
    local numBullets = math.floor(self.chargeAmount)
    local x = move.x + (10 * math.sin(move.rotation)) 
    local y = move.y + (10 * -math.cos(move.rotation))
    bullet = Bullet.new(self.entity, x,y,400 + self.chargeAmount * 30,move.rotation, self.chargeAmount * self.weaponDamage,.5+self.chargeAmount * 0.15)
    bullet.components.yield = BouncingBulletComponent.new(bullet)
    table.insert(self.entity.bullets, bullet)
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