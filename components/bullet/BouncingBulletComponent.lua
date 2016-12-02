BouncingBulletComponent = {}

BouncingBulletComponent.__index = BouncingBulletComponent

function BouncingBulletComponent.new(entity)
  local i = {}
  setmetatable(i, BouncingBulletComponent)
  i.entity = entity
  return i
end

function BouncingBulletComponent:OnWallHit(tile,delta)
  local move = self.entity.components.move
  local angle = math.atan2(delta.x,delta.y)

  xPow = math.pow(move.vx, 2)
  yPow = math.pow(move.vy, 2)
  velocity = math.sqrt(xPow + yPow)
  move.x = move.x + delta.x
  move.y = move.y + delta.y

  if math.abs(delta.x) <  math.abs(delta.y) then
    move.vy = math.abs(move.vy) * math.cos(angle)
  else
    move.vx = math.abs(move.vx) * math.sin(angle)
  end
end

function BouncingBulletComponent:OnPlayerHit(player)
  self.entity.bulletLife = 0
end

return BouncingBulletComponent