BlockingTileComponent = {}

BlockingTileComponent.__index = BlockingTileComponent

function BlockingTileComponent.new(entity)
  local i = {}
  setmetatable(i, BlockingTileComponent)
  i.entity = entity
  i.wall = false
  return i
end

function BlockingTileComponent:OnBulletHit(bullet,delta)
  bullet:OnWallHit(self.entity,delta)
end

function BlockingTileComponent:OnBeamHit(beam)
  return true
end

function BlockingTileComponent:draw()
  if self.wall then
    ts = self.entity.tileset.tileSize
    love.graphics.rectangle("fill", self.entity.x-2, self.entity.y-2, ts+4, ts+4)
    self.wall = false
  end
end

return BlockingTileComponent