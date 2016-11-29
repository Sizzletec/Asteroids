VortexComponent = {
  gunCooldown = 0,
  weaponDamage = 20,
  fireRate = 1,
  firing = false
}

VortexComponent.__index = VortexComponent

function VortexComponent.new(entity)
  local i = {}
  setmetatable(i, VortexComponent)
  i.entity = entity
  return i
end

function VortexComponent:update(dt)
  if self.firing and self.gunCooldown <= 0 then
    self:fire()
    self.gunCooldown = 1/self.fireRate
  elseif self.gunCooldown > 0 then
    self.gunCooldown = self.gunCooldown - dt
  end
end

function VortexComponent:fire()
  if self.entity.components.life.health <= 0 then
    return
  end
  local move = self.entity.components.move
  self.entity.components.score.shots = self.entity.components.score.shots + 1

  for i=1,8 do
      bullet = Bullet.new(self.entity, move.x,move.y,200,move.rotation + math.pi/4 * i, self.weaponDamage)
      bullet.vortex = true
      table.insert(Game.getObjects(), bullet)
  end
end


return VortexComponent