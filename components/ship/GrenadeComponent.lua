GrenadeComponent = {}

GrenadeComponent.__index = GrenadeComponent

function GrenadeComponent.new(entity)
  local i = {
    gunCooldown = 0,
    weaponDamage = 50,
    fireRate = 1,
    firing = false
  }

  setmetatable(i, GrenadeComponent)
  i.entity = entity
  return i
end

function GrenadeComponent:update(dt)
  if self.firing and self.gunCooldown <= 0 then
    self:fire()
    self.gunCooldown = 1/self.fireRate
  elseif self.gunCooldown > 0 then
    self.gunCooldown = self.gunCooldown - dt
  end
end

function GrenadeComponent:fire()
  if self.entity.components.life.health <= 0 then
    return
  end

  local move = self.entity.components.move
  self.entity.components.score.shots = self.entity.components.score.shots + 1

  local x = move.x + (10 * math.sin(move.rotation)) 
  local y = move.y + (10 * -math.cos(move.rotation))
  bullet = Bullet.new(self.entity, x,y,300,move.rotation, self.weaponDamage,2,2)
  bullet.components.yield = BouncingBulletComponent.new(bullet)
  bullet.components.exploding =  ExplodingBulletComponent.new(bullet)
  table.insert(Game.getObjects(), bullet)
end


return GrenadeComponent