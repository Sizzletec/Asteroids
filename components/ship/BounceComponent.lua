BounceComponent = {}

BounceComponent.__index = BounceComponent

function BounceComponent.new(entity)
  local i = {
    gunCooldown = 0,
    weaponDamage = 20,
    fireRate = 5,
    firing = false
  }

  setmetatable(i, BounceComponent)
  i.entity = entity
  return i
end

function BounceComponent:update(dt)
  if self.firing and self.gunCooldown <= 0 then
    self:fire()
    self.gunCooldown = 1/self.fireRate
  elseif self.gunCooldown > 0 then
    self.gunCooldown = self.gunCooldown - dt
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
  bullet = Bullet.new(self.entity, x,y,700,move.rotation, self.weaponDamage,2,2)
  bullet.components.yield = BouncingBulletComponent.new(bullet)
  table.insert(Game.getObjects(), bullet)
end


return BounceComponent