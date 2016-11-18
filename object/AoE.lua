AoE = {}
AoE.__index = AoE


function AoE.new(entity,x,y,startR,endR,time,damage)
  local s = {
    entity = entity,
    x = x,
    y = y,
    radius = startR,
    rate = (endR - startR)/ time,
    endR = endR,
    remove = false,
    damage = damage
  }
  setmetatable(s, AoE)

  s.components = {}
  return s
end

function AoE:update(dt)
  self.radius = self.radius + self.rate * dt

  if self.radius >= self.endR then
    self.remove = true
  end
  -- local move = self.entity.components.move

  local players = Game.getPlayers()
  for p, otherPlayer in pairs(players) do
    if otherPlayer ~= self.entity then
      local otherMove = otherPlayer.components.move
      local xPow = math.pow(otherMove.x - self.x, 2)
      local yPow = math.pow(otherMove.y - self.y, 2)
      local dist = math.sqrt(xPow + yPow)

      if dist <= self.radius then
          otherPlayer.components.life:takeDamage(self.entity, self.damage)
      end
    end
  end
end

function AoE:draw()
  love.graphics.circle("line", self.x, self.y, self.radius)
end

return AoE