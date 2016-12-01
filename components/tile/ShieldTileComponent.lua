ShieldTileComponent = {}

ShieldTileComponent.__index = ShieldTileComponent

function ShieldTileComponent.new(entity,direction)
  local i = {}
  setmetatable(i, ShieldTileComponent)
  i.entity = entity
  i.direction = direction
  return i
end

function ShieldTileComponent:getCollisonMask()
  cm = bit.bor(Collision.bullet)
  return cm
end

function ShieldTileComponent:OnBulletHit(bullet)
  local move = bullet.components.move
  local c1 = 0
  local c2 = move.vx
  if self.direction == "right" then
    c1 = move.vx
    c2 = 0
  elseif self.direction == "up" then
    c1 = 0
    c2 = move.vy
  elseif self.direction == "down" then
    c1 = move.vy
    c2 = 0
  end

  if c1 < c2 then
    bullet:OnWallHit(self.entity)
  end
end

function ShieldTileComponent:update(dt)
end

function ShieldTileComponent:draw()
end

return ShieldTileComponent