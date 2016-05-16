ShipsImage = love.graphics.newImage('images/ship-sprites.png')
local shoot = love.audio.newSource("sounds/shoot.wav", "static")
-- shoot:play()

require('ship_types/ShipTypes')
require('helpers/Mover')
require('components/InputComponent')
require('components/RenderComponent')
require('components/ScoreComponent')
require('components/LifeComponent')
require('components/MoveComponent')
require('components/WallCollisionComponent')

Ship = {
  shield = false,
  explodingFrame = 0,
}
Ship.__index = Ship

function Ship.new(player,x,y,rotation,vx,vy, type)
  local s = {}
  setmetatable(s, Ship)

  s.shipType = type or ShipType.standard

  s.player = player
  s.components = {}
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