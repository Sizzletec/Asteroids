ShipsImage = love.graphics.newImage('images/ship-sprites.png')
local shoot = love.audio.newSource("sounds/shoot.wav", "static")

require('ship_types/ShipTypes')
require('helpers/Mover')
require('components/KeyboardInputComponent')
require('components/RenderComponent')
require('components/ScoreComponent')
require('components/LifeComponent')

Ship = {
  acceleration = 0,
  shield = false,
  explodingFrame = 0,
  attackFrame = 0
}
Ship.__index = Ship

function Ship.new(player,x,y,rotation,vx,vy, type)
  local s = {}
  setmetatable(s, Ship)

  s.shipType = type or ShipType.standard
  s.x = x
  s.y = y
  s.vx = vx or 0
  s.vy = vy or 0
  s.rotation = rotation or 0

  s.topSpeed = s.shipType.topSpeed
  s.acceleration = s.shipType.acceleration
  s.rotationSpeed = s.shipType.rotationSpeed
  s.fireRate = s.shipType.fireRate
  s.weaponDamage = s.shipType.weaponDamage

  s.components = {
    render = RenderComponent.new(s),
    score = ScoreComponent.new(s),
    life = LifeComponent.new(s)
  }

  s.player = player

  if player == 1 then
    s.components["keyboard"] = KeyboardInputComponent.new(s)
  end

  s.color = 0

  s.bullets = {}
  s.beams = {}
  s.gunCooldown = 0
  s.throttle = 0
  s.angularInput = 0
  return s
end

function Ship:setDefaults()
  self.x = 0
  self.y = 0
  self.vx = 0
  self.vy = 0
  self.rotation = 0

  self.topSpeed = self.shipType.topSpeed
  self.acceleration = self.shipType.acceleration
  self.rotationSpeed = self.shipType.rotationSpeed
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
      self:respawn()
    end
  end


  Mover.ApplyAcceleration(self, dt)
  Mover.ApplyVelocity(self, dt)


  -- check wall collisions
  tileUp = TiledMap_GetMapTile(math.floor(self.x/16),math.floor((self.y+16)/16),1)
  tileDown = TiledMap_GetMapTile(math.floor(self.x/16),math.floor((self.y-16)/16),1)

  tileLeft = TiledMap_GetMapTile(math.floor((self.x-16)/16),math.floor(self.y/16),1)
  tileRight = TiledMap_GetMapTile(math.floor((self.x+16)/16),math.floor(self.y/16),1)

  if tileUp > 0 then
    self.vy = -self.vy/2
    self.y = self.y - 5
    self.components.score.wallsRunInto = self.components.score.wallsRunInto + 1
  elseif tileDown > 0 then
    self.vy = -self.vy/2
    self.y = self.y + 5
    self.components.score.wallsRunInto = self.components.score.wallsRunInto + 1
  end

  if tileLeft > 0 then
    self.vx = -self.vx/2
    self.x = self.x + 5
    self.components.score.wallsRunInto = self.components.score.wallsRunInto + 1
  elseif tileRight > 0 then
    self.vx = -self.vx/2
    self.x = self.x - 5
    self.components.score.wallsRunInto = self.components.score.wallsRunInto + 1
  end


  Mover.ApplyRotation(self,dt)
  Mover.StageWrap(self)

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

function Ship:respawn()
  local spawnLocation = Game.GetSpawnLocation()

  for _, component in pairs(self.components) do
    if component.respawn ~= nil then
      component:respawn()
    end
  end

  self.x = spawnLocation.x
  self.y = spawnLocation.y
  self.rotation = math.rad(spawnLocation.r)
  self.vx = 0
  self.vy = 0

  self.explodingFrame = 0
end

return Ship