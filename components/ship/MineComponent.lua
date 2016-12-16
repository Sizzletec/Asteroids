MineComponent = {}
MineComponent.__index = MineComponent

function MineComponent.new(entity)
  local i = {
    cannon = "right",
    gunCooldown = 0,
    weaponDamage = 20,
    fireRate = 1,
    firing = false,
    explosionDamage = 50
  }
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

  local bullet = Bullet.new(self.entity, move.x,move.y,0,move.rotation, self.weaponDamage)
  bullet.components.exploding = ExplodingBulletComponent.new(bullet,self.explosionDamage)
  table.insert(Game.getObjects(), bullet)
end


return MineComponent