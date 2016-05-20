VortexComponent = {
  gunCooldown = 0,
  weaponDamage = 40,
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


  for b, bullet in pairs(self.entity.bullets) do

    local m = bullet.components.move

    m.rotation = m.rotation + 2 * math.pi * dt

    local powX = math.pow(m.vx, 2)
    local powY = math.pow(m.vy, 2)
    local velocity = math.sqrt(powX + powY)
    velocity = velocity + 700 * dt

    m.vx = velocity * math.sin(m.rotation)
    m.vy = velocity * -math.cos(m.rotation)

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
      table.insert(self.entity.bullets, bullet)
  end
end


return VortexComponent