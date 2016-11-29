WallTileComponent = {}

WallTileComponent.__index = WallTileComponent

function WallTileComponent.new(entity)
  local i = {}
  setmetatable(i, WallTileComponent)
  i.entity = entity
  i.wall = false
  return i
end

function WallTileComponent:OnPlayerHit(player)
  local wall = player.components.wallCollision
  local ts = self.entity.tileset
  if wall and ts then
    self.wall = true
    local move = player.components.move
    xAngle = self.entity.x - move.x
    yAngle = self.entity.y - move.y

    if math.abs(yAngle) > math.abs(xAngle) then
      move.vy = -move.vy/2
      if yAngle > 0 then
        move.y = move.y - 1
      else
        move.y = move.y + 1
      end
    else
      move.vx = -move.vx/2
      if xAngle > 0 then
        move.x = move.x - 1
      else
        move.x = move.x + 1
      end
    end
  end
end

function WallTileComponent:getCollisonMask()
  cm = bit.bor(Collision.ship)
  return cm
end


function WallTileComponent:update(dt)
end

function WallTileComponent:draw()
  if self.wall then
    ts = self.entity.tileset.tileSize
    love.graphics.rectangle("fill", self.entity.x, self.entity.y, ts, ts)
    self.wall = false
  end
end

return WallTileComponent