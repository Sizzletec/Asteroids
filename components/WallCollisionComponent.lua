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
    if self.entity.components.score and wallHit then
      self.entity.components.score.wallsRunInto = self.entity.components.score.wallsRunInto + 1
    end
  end
end

return WallCollisionComponent