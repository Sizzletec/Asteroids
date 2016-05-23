local shoot = love.audio.newSource("sounds/Laser_Shoot50.wav", "static")

AlternatingFireComponent = {
  cannon = "right",
  weaponDamage = 10,
  fireRate = 12,
  firing = false,
  gunCooldown = 0,
  heat = 0,
  cooldown = false
}

AlternatingFireComponent.__index = AlternatingFireComponent

function AlternatingFireComponent.new(entity)
  local i = {}
  setmetatable(i, AlternatingFireComponent)
  i.entity = entity
  return i
end

function AlternatingFireComponent:update(dt)
  if self.firing and self.gunCooldown <= 0 then
    self:fire()
    self.gunCooldown = 1/self.fireRate
  elseif self.gunCooldown > 0 then
    self.heat = self.heat - 1
    self.gunCooldown = self.gunCooldown - dt
  end

  if not self.firing then
    self.heat = 0
  end
end

function AlternatingFireComponent:fire()
  if self.entity.components.life.health <= 0 then
    return
  end
  local move = self.entity.components.move
  self.entity.components.score.shots = self.entity.components.score.shots + 1

  
  local x,y = 0,0
  if self.cannon == "right" then
    x = move.x + (10 * math.sin(move.rotation)) + (8 * math.cos(move.rotation))
    y = move.y + (10 * -math.cos(move.rotation)) + (8 * math.sin(move.rotation))
  elseif self.cannon == "left" then
    x = move.x + (10 * math.sin(move.rotation)) + (-7 * math.cos(move.rotation))
    y = move.y + (10 * -math.cos(move.rotation)) + (-7 * math.sin(move.rotation))
  end




  local random = love.math.random(200) - 100

  local heatOffset = self.heat/100 * math.pi/20 * random/100

  local bullet = Bullet.new(self.entity, x,y,600,move.rotation + heatOffset , self.weaponDamage)
  table.insert(self.entity.bullets, bullet)

  shoot:rewind()
  shoot:play()

  if self.cannon == "right" then
    self.cannon = "left"
  else
    self.cannon = "right"
  end

  self.heat = self.heat + 0.1
end


return AlternatingFireComponent