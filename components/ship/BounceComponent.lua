BounceComponent = {}

BounceComponent.__index = BounceComponent

function BounceComponent.new(entity)
  local i = {
    gunCooldown = 0,
    weaponDamage = 15,
    fireRate = .8,
    firing = false,
    burstOffset = 0.1
  }

  setmetatable(i, BounceComponent)
  i.entity = entity

  i.burst = 0
  i.burstCooldown = 0
  return i
end

function BounceComponent:update(dt)
  if self.firing and self.gunCooldown <= 0 then
    self:fire()
    self.burst = 2
    self.burstCooldown = self.burstOffset
    self.gunCooldown = 1/self.fireRate
  elseif self.gunCooldown > 0 then
    self.gunCooldown = self.gunCooldown - dt
  end

  self.burstCooldown = self.burstCooldown  - dt

  if self.burst > 0  and self.burstCooldown <= 0 then
    self.burst = self.burst -1
    self.burstCooldown = self.burstOffset
    self:fire()
  end
end

function BounceComponent:fire()
  if self.entity.components.life.health <= 0 then
    return
  end

  local move = self.entity.components.move
  self.entity.components.score.shots = self.entity.components.score.shots + 1

  local x = move.x + (10 * math.sin(move.rotation)) 
  local y = move.y + (10 * -math.cos(move.rotation))
  bullet = Bullet.new(self.entity, x,y,500,move.rotation, self.weaponDamage,2,2)
  bullet.components.yield = BouncingBulletComponent.new(bullet)
  table.insert(Game.getObjects(), bullet)
end


return BounceComponent