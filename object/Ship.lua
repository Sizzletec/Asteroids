ShipsImage = love.graphics.newImage('images/ship-sprites.png')
local shoot = love.audio.newSource("sounds/shoot.wav", "static")
-- shoot:play()

require('ship_types/ShipTypes')
require('helpers/Mover')
require('components/KeyboardInputComponent')
require('components/RenderComponent')
require('components/ScoreComponent')
require('components/LifeComponent')
require('components/MoveComponent')
require('components/WallCollisionComponent')
require('components/AlternatingFireComponent')

Ship = {
  shield = false,
  explodingFrame = 0,
}
Ship.__index = Ship

function Ship.new(player,x,y,rotation,vx,vy, type)
  local s = {}
  setmetatable(s, Ship)

  -- s.shipType = type or ShipType.standard
  s.shipType = type or ShipType.standard
  s.fireRate = s.shipType.fireRate
  s.weaponDamage = s.shipType.weaponDamage

  s.components = {
    render = RenderComponent.new(s),
    score = ScoreComponent.new(s),
    life = LifeComponent.new(s),
    move = MoveComponent.new(s),
    wallCollision = WallCollisionComponent.new(s),
    primaryAttack = AlternatingFireComponent.new(s)
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
    if self.explodingFrame > 20 and self.components.life.lives > 0 then
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
end

function Ship:selfDestruct()
  if self.components.life.health <= 0 then
    return
  end
  self.components.life.health = 0

  local numBullets = 100
  local angleDiff = 2 * math.pi / numBullets
  for i=numBullets/2,-numBullets/2,-1 do
    local rBullet = self.components.move.rotation + i * angleDiff
    leftCannonOffsetX = self.components.move.x + (5 * math.sin(self.components.move.rotation))
    leftCannonOffsetY = self.components.move.y + (5 * -math.cos(self.components.move.rotation))
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