ShockwaveComponent = {
  cannon = "right",
  gunCooldown = 0,
  weaponDamage = 100,
  fireRate = 1,
  firing = false,
  rad
}

ShockwaveComponent.__index = ShockwaveComponent

function ShockwaveComponent.new(entity)
  local i = {}
  setmetatable(i, ShockwaveComponent)
  i.entity = entity
  return i
end

function ShockwaveComponent:update(dt)
  if self.firing and self.gunCooldown <= 0 then
    self:fire()
    self.gunCooldown = 1/self.fireRate
  elseif self.gunCooldown > 0 then
    self.gunCooldown = self.gunCooldown - dt
  end
end

function ShockwaveComponent:fire()
  if self.entity.components.life.health <= 0 then
    return
  end
  local move = self.entity.components.move
  self.entity.components.score.shots = self.entity.components.score.shots + 1

  local radius = 100
  self.circleHitbox = { x = move.x, y = move.y, radius = radius }

  local players = Game.getPlayers()
  for p, otherPlayer in pairs(players) do
    if otherPlayer ~= self.entity then
      local otherMove = otherPlayer.components.move
      local xPow = math.pow(otherMove.x - move.x, 2)
      local yPow = math.pow(otherMove.y - move.y, 2)
      local dist = math.sqrt(xPow + yPow)

      if dist <= radius then
          otherPlayer.components.life:takeDamage(self.entity, self.weaponDamage)
      end
    end
  end
end

function ShockwaveComponent:draw()
  if self.circleHitbox then
    love.graphics.circle("line", self.circleHitbox.x, self.circleHitbox.y, self.circleHitbox.radius)
  end
end

return ShockwaveComponent