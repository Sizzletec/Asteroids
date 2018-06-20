local shoot = love.audio.newSource("sounds/Laser_Shoot50.wav", "static")

AlternatingFireComponent = {}

AlternatingFireComponent.__index = AlternatingFireComponent

function AlternatingFireComponent.new(entity)
  local i = {
    cannon = "right",
    weaponDamage = 10,
    fireRate = 12,
    firing = false,
    heat = 180,
    cooldown = false
  }
  setmetatable(i, AlternatingFireComponent)
  i.entity = entity
  return i
end

function AlternatingFireComponent:update(dt)
  if self.cooldown then
    coroutine.resume(self.co, dt)
  elseif self.firing then
    self:fire()
  else
    self.heat = 0
  end
end

function angledOffset(rotation, offsetX, offsetY)

end

function AlternatingFireComponent:fire()
  if self.entity.components.life.health <= 0 then
    return
  end

  local move = self.entity.components.move
  self.entity.components.score.shots = self.entity.components.score.shots + 1

  local x,y = 0,0

  if self.cannon == "right" then
    x,y = move:angledOffset(10, 8)
  elseif self.cannon == "left" then
    x,y = move:angledOffset(10, -7)
  end

  local random = love.math.random(-50,50)

  local heatOffset = self.heat/100 * random/50.0 * math.pi/8

  local bullet = Bullet.new(self.entity, x,y,600,move.rotation + heatOffset , self.weaponDamage)

  table.insert(Game.getObjects(), bullet)

  shoot:rewind()
  shoot:play()


  if self.cannon == "right" then
    self.cannon = "left"
  else
    self.cannon = "right"
  end

  self.heat = self.heat + 10
  if self.heat > 100 then
    self.heat = 100
  end

  self.cooldown = true

  self.co = coroutine.create(function (dt)
    time = 0
    while time < 1/self.fireRate do
      time = time + dt
      coroutine.yield()
    end
    self.cooldown = false
  end)
end

return AlternatingFireComponent