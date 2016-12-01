local shoot = love.audio.newSource("sounds/death2.wav", "static")

ShotgunComponent = {
  gunCooldown = 0,
  weaponDamage = 10,
  fireRate = 1,
  firing = false
}

ShotgunComponent.__index = ShotgunComponent

function ShotgunComponent.new(entity)
  local i = {}
  setmetatable(i, ShotgunComponent)
  i.entity = entity
  return i
end

function ShotgunComponent:update(dt)
  if self.firing and self.gunCooldown <= 0 then
    self:fire()
    self.gunCooldown = 1/self.fireRate
  elseif self.gunCooldown > 0 then
    self.gunCooldown = self.gunCooldown - dt
  end
end

function ShotgunComponent:fire()
  if self.entity.components.life.health <= 0 then
    return
  end
  shoot:play()
  local move = self.entity.components.move
  self.entity.components.score.shots = self.entity.components.score.shots + 1


  local numBullets = 7
  local angleDiff = math.pi/4/numBullets
  for i=numBullets/2,-numBullets/2,-1 do
    local rBullet = move.rotation + i * angleDiff
    x = move.x + (5 * math.sin(move.rotation))
    y = move.y + (5 * -math.cos(move.rotation))
    bullet = Bullet.new(self.entity,x,y,300,rBullet, self.weaponDamage)
    table.insert(Game.getObjects(), bullet)
  end
end


return ShotgunComponent