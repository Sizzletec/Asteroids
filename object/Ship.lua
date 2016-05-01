ShipsImage = love.graphics.newImage('images/ship-sprites.png')
local shoot = love.audio.newSource("sounds/shoot.wav", "static")

require('ship_types/ShipTypes')
require('helpers/Mover')
require('components/KeyboardInputComponent')
require('components/RenderComponent')
require('components/ScoreComponent')
require('components/LifeComponent')
require('components/MoveComponent')
require('components/WallCollisionComponent')

Ship = {
  shield = false,
  explodingFrame = 0,
  attackFrame = 0
}
Ship.__index = Ship

function Ship.new(player,x,y,rotation,vx,vy, type)
  local s = {}
  setmetatable(s, Ship)

  s.shipType = type or ShipType.standard
  s.fireRate = s.shipType.fireRate
  s.weaponDamage = s.shipType.weaponDamage

  s.components = {
    render = RenderComponent.new(s),
    score = ScoreComponent.new(s),
    life = LifeComponent.new(s),
    move = MoveComponent.new(s),
    wallCollision = WallCollisionComponent.new(s)
  }

  s.player = player

  if player == 1 then
    s.components["keyboard"] = KeyboardInputComponent.new(s)
  end

  s.bullets = {}
  s.beams = {}
  s.gunCooldown = 0
  return s
end

function Ship:setDefaults()
  self.fireRate = self.shipType.fireRate
  self.weaponDamage = self.shipType.weaponDamage

  playerShip.firing = false
  self.bullets = {}
  self.beams = {}
  self.gunCooldown = 0
  self.throttle = 0
  self.angularInput = 0

  self.shield = false
  self.explodingFrame = 0
  self.lives = Ship.lives
end

function Ship:update(dt)
  for _, component in pairs(self.components) do
    if component.update ~= nil then
      component:update(dt)
    end
  end

  -- when dead run exploding animation
  if not self.components.life.alive then
    self.explodingFrame = self.explodingFrame + 8 * dt
    if self.explodingFrame > 10 and self.components.life.lives > 0 then
      self:spawn()
    end
  end

  self.shipType.actionHandler.Update(self,dt)

  for i, bullet in pairs(self.bullets) do
    bullet:update(dt)
    if bullet.lifetime > bullet.bulletLife then
      table.remove(self.bullets, i)
    end
  end

  if self.firing and self.gunCooldown <= 0 then
    self:fire()
    self.gunCooldown = 1/self.shipType.fireRate
  elseif self.gunCooldown > 0 then
    self.gunCooldown = self.gunCooldown - dt
  end
end

function Ship:fire()
  if self.components.life.health <= 0 then
    return
  end

  self.components.score.shots = self.components.score.shots + 1
  shoot:play()
  self.shipType.actionHandler.Fire(self)
end

function Ship:selfDestruct()
  if self.components.life.health <= 0 then
    return
  end
  self.components.life.health = 0

  local numBullets = 100
  local angleDiff = 2 * math.pi / numBullets
  for i=numBullets/2,-numBullets/2,-1 do
    local rBullet = self.rotation + i * angleDiff
    leftCannonOffsetX = self.x + (5 * math.sin(self.rotation))
    leftCannonOffsetY = self.y + (5 * -math.cos(self.rotation))
    bullet = Bullet.new(leftCannonOffsetX,leftCannonOffsetY,2*60,rBullet, 200)
    table.insert(self.bullets, bullet)
  end
end

function Ship:drawLifeMarkers(x,y)
  for _, component in pairs(self.components) do
    if component.drawLifeMarkers ~= nil then
      component:drawLifeMarkers(x,y)
    end
  end
end

function Ship:draw()
  for _, component in pairs(self.components) do
    if component.draw ~= nil then
      component:draw()
    end
  end
end

function Ship:spawn()
  local spawnLocation = Game.GetSpawnLocation()

  for _, component in pairs(self.components) do
    if component.spawn ~= nil then
      component:spawn()
    end
  end

  local move = self.components.move
  if move then
    move.x = spawnLocation.x
    move.y = spawnLocation.y
    move.rotation = math.rad(spawnLocation.r)
    move.vx = 0
    move.vy = 0
  end

  self.explodingFrame = 0
end

return Ship