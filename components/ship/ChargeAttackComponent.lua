local chargeImg = love.graphics.newImage('images/charge.png')

ChargeAttackComponent = {}

ChargeAttackComponent.__index = ChargeAttackComponent

function ChargeAttackComponent.new(entity)
  local i = {
    gunCooldown = 0,
    weaponDamage = 15,
    fireRate = 4,
    firing = false,
    chargeAmount = 0,
    charging = 0,
    timeOnFrame = 0,
    burstOffset = 0.1
  }
  setmetatable(i, ChargeAttackComponent)
  i.entity = entity

  i.burst = 0
  i.burstCooldown = 0

  return i
end

function ChargeAttackComponent:update(dt)
  self.timeOnFrame = self.timeOnFrame + dt

  if self.firing and self.gunCooldown <= 0 then
    self:charge(dt)
    self.gunCooldown = 1/self.fireRate
  elseif self.gunCooldown > 0 then
    self.gunCooldown = self.gunCooldown - dt
  end

  local life = self.entity.components.life

  if not life.alive then
    charging = 0
  end

  self.burstCooldown = self.burstCooldown  - dt

  if self.burst > 0  and self.burstCooldown <= 0 then
    self.burst = self.burst -1
    self:fire()
  end

  local move = self.entity.components.move
  if not self.firing and self.charging then
    self.burst = math.floor(self.chargeAmount)/2.9 - 1
    self:fire()
    -- self.entity.components.score.shots = self.entity.components.score.shots + 1
    -- local numBullets = math.floor(self.chargeAmount)
    -- local x = move.x + (10 * math.sin(move.rotation)) 
    -- local y = move.y + (10 * -math.cos(move.rotation))
    -- bullet = Bullet.new(self.entity, x,y,400 + self.chargeAmount * 30,move.rotation, self.chargeAmount * self.weaponDamage,.5+self.chargeAmount * 0.15)
    -- bullet.components.yield = BouncingBulletComponent.new(bullet)
    -- table.insert(Game.getObjects(), bullet)
    self.charging=false
  end
end


function ChargeAttackComponent:charge(dt)
  if self.entity.components.life.health <= 0 then
    return
  end

  if self.charging then
    if self.chargeAmount < 12 then
      self.chargeAmount = self.chargeAmount + 1
      self.timeOnFrame = 0
    end
  else
    self.charging = true
    self.chargeAmount = 1
  end
end


function ChargeAttackComponent:fire(dt)
  if self.entity.components.life.health <= 0 then
    return
  end

  self.burstCooldown = self.burstOffset

  local move = self.entity.components.move
  self.entity.components.score.shots = self.entity.components.score.shots + 1

  local x = move.x + (10 * math.sin(move.rotation)) 
  local y = move.y + (10 * -math.cos(move.rotation))
  bullet = Bullet.new(self.entity, x,y,500,move.rotation, self.weaponDamage,2,2)
  bullet.components.yield = BouncingBulletComponent.new(bullet)
  table.insert(Game.getObjects(), bullet)
end

function ChargeAttackComponent:draw()
  local move = self.entity.components.move
  if self.charging then
    -- love.graphics.circle("line", move.x + (15 * math.sin(move.rotation)), move.y - (15 * math.cos(move.rotation)), self.chargeAmount, 30)
    frame = self.chargeAmount -1

    if frame > 0 and self.timeOnFrame >= 0.05 then
      if self.timeOnFrame >= 0.1 then
      self.timeOnFrame = self.timeOnFrame - .1
      end

      frame = frame -1 
    end

    quad = love.graphics.newQuad(24*frame, 0, 24, 24, 288, 24)
    love.graphics.draw(chargeImg, quad, move.x-12 + (15 * math.sin(move.rotation)), move.y-12 - (15 * math.cos(move.rotation)))

  end
end


return ChargeAttackComponent