WallTileComponent = {}

WallTileComponent.__index = WallTileComponent

function WallTileComponent.new(entity)
  local i = {}
  setmetatable(i, WallTileComponent)
  i.entity = entity
  i.wall = false
  return i
end

function WallTileComponent:OnPlayerHit(player,delta)
  local wall = player.components.wallCollision
  local ts = self.entity.tileset
  if wall and ts then
    self.wall = true
    local move = player.components.move
    local angle = math.atan2(delta.x,delta.y)

    move.x = move.x + delta.x
    move.y = move.y + delta.y

    if math.abs(delta.x) <  math.abs(delta.y) then
      move.vy = math.abs(move.vy)/2 * math.cos(angle)
    else
      move.vx = math.abs(move.vx)/2 * math.sin(angle)
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