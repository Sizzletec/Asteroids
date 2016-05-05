WallCollisionComponent = {}

WallCollisionComponent.__index = WallCollisionComponent

function WallCollisionComponent.new(entity)
  local i = {}
  setmetatable(i, WallCollisionComponent)
  i.entity = entity
  return i
end

function WallCollisionComponent:update(dt)
  local move = self.entity.components.move
  if move then
    local tileUp = TiledMap_GetMapTile(math.floor(move.x/16),math.floor((move.y+16)/16),1)
    local tileDown = TiledMap_GetMapTile(math.floor(move.x/16),math.floor((move.y-16)/16),1)

    local tileLeft = TiledMap_GetMapTile(math.floor((move.x-16)/16),math.floor(move.y/16),1)
    local tileRight = TiledMap_GetMapTile(math.floor((move.x+16)/16),math.floor(move.y/16),1)

    local wallHit = false
    if tileUp > 0 then
      move.vy = -move.vy/2
      move.y = move.y - 5
      wallHit = true
    elseif tileDown > 0 then
      move.vy = -move.vy/2
      move.y = move.y + 5
      wallHit = true
    end

    if tileLeft > 0 then
      move.vx = -move.vx/2
      move.x = move.x + 5
      wallHit = true
    elseif tileRight > 0 then
      move.vx = -move.vx/2
      move.x = move.x - 5
      wallHit = true
    end

    if self.entity.components.score and wallHit then
      self.entity.components.score.wallsRunInto = self.entity.components.score.wallsRunInto + 1
    end
  end 
end

return WallCollisionComponent