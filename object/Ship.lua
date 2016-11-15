ShipsImage = love.graphics.newImage('images/ship-sprites.png')
part = love.graphics.newImage('images/part.png')

-- shoot:play()

require('ship_types/ShipTypes')
require('helpers/Mover')
require('components/InputComponent')
require('components/RenderComponent')
require('components/ScoreComponent')
require('components/LifeComponent')
require('components/MoveComponent')
require('components/WallCollisionComponent')
require('components/StatusComponent')
require('components/ArmorComponent')

Ship = {}
Ship.__index = Ship

function Ship.new(player,x,y,rotation,vx,vy, type)
  local s = {
    shield = false,
    explodingFrame = 0,
  }
  setmetatable(s, Ship)

  s.shipType = type or ShipType.standard

  s.player = player
  s.components = {}
  s.engineParticle = love.graphics.newParticleSystem(part, 500)

  s:setDefaults()

  return s
end

function Ship:setDefaults()
  self.bullets = {}
  self.beams = {}

  local r = self.components.render
  local color = nil

  if r then
    color = r.color
  end

  self.components = {
    render = RenderComponent.new(self),
    score = ScoreComponent.new(self),
    status = StatusComponent.new(self),
    life = LifeComponent.new(self),
    move = MoveComponent.new(self),
    wallCollision = WallCollisionComponent.new(self),
    primaryAttack = self.shipType.primaryAttack.new(self),
    secondaryAttack = self.shipType.secondaryAttack.new(self),
    input = InputComponent.new(self)
  }



  if color then
    self.components.render.color = color
  end
end

function Ship:update(dt)

  local move = self.components.move
  self.engineParticle:setParticleLifetime(0.1, 0.3) -- Particles live at least 2s and at most 5s.
  self.engineParticle:setEmissionRate(100)
  self.engineParticle:setSizeVariation(.5)
  self.engineParticle:setLinearAcceleration(1000* math.sin(move.rotation+math.pi), -1000*math.cos(move.rotation+math.pi), 1000* math.sin(move.rotation+math.pi), -1000*math.cos(move.rotation+math.pi)) -- Random movement in all directions.
  self.engineParticle:setColors(255, 0, 0,255, 255, 0,30, 0) -- Fade to transparency.

  self.engineParticle:update(dt)
  for _, component in pairs(self.components) do
    if component.update then
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

  for i, bullet in pairs(self.bullets) do
    bullet:update(dt)
    if bullet.lifetime > bullet.bulletLife then
      table.remove(self.bullets, i)
    end
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
    if component.draw then
      component:draw()
    end
  end

  for _, bullet in pairs(self.bullets) do
    if bullet then
      bullet:draw()
    end
  end
end

function Ship:spawn()
  local spawnLocation = Game.GetSpawnLocation()

  for _, component in pairs(self.components) do
    if component.spawn then
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