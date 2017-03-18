local shoot = love.audio.newSource("sounds/shoot.wav", "static")

RotatingFireComponent = {
  gunCooldown = 0,
  weaponDamage = 30,
  fireRate = 2,
  firing = false,
  fireAngle = 0
}

RotatingFireComponent.__index = RotatingFireComponent

function RotatingFireComponent.new(entity)
  local i = {}
  setmetatable(i, RotatingFireComponent)
  i.entity = entity
  return i
end

function RotatingFireComponent:update(dt)
  if self.firing and self.gunCooldown <= 0 then
    self:fire()
    self.gunCooldown = 1/self.fireRate
  elseif self.gunCooldown > 0 then
    self.gunCooldown = self.gunCooldown - dt
  end

    input = self.entity.components.input
  if input then
    self.fireAngle = input.fireAngle
  end
end

function RotatingFireComponent:fire()
  if self.entity.components.life.health <= 0 then
    return
  end
  shoot:play()
  local move = self.entity.components.move
  self.entity.components.score.shots = self.entity.components.score.shots + 1

  input = self.entity.components.input
  if input then
    self.fireAngle = input.fireAngle
  end

  local x = move.x - (3 * math.sin(move.rotation))
  local y = move.y + (3 * math.cos(move.rotation))
  bullet = Bullet.new(self.entity,x,y,900,self.fireAngle, self.weaponDamage)
  table.insert(Game.getObjects(), bullet)
end

function RotatingFireComponent:draw()
  local move = self.entity.components.move
  local angle = self.fireAngle
  local cannonQuad = love.graphics.newQuad(0, 160, 20, 20, ShipsImage:getDimensions())
  if self.entity.components.life.health > 0 then
    love.graphics.draw(ShipsImage,cannonQuad,move.x - (3 * math.sin(move.rotation)), move.y + (3 * math.cos(move.rotation)), angle, 1,1 , 10, 10)
  end
end


return RotatingFireComponent