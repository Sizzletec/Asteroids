ExplodingTileComponent = {}

ExplodingTileComponent.__index = ExplodingTileComponent

function ExplodingTileComponent.new(entity)
  local i = {}
  setmetatable(i, ExplodingTileComponent)
  i.entity = entity
  i.wall = false
  return i
end

function ExplodingTileComponent:getCollisonMask()
  cm = bit.bor(Collision.bullet,Collision.aoe)
  return cm
end

function ExplodingTileComponent:OnBulletHit(bullet)
  self:explodeTile(bullet)
end

function ExplodingTileComponent:OnAoEHit(aoe)
  self:explodeTile(aoe)
end

function ExplodingTileComponent:explodeTile(object)
  local ts = self.entity.tileset
  if ts and not self.entity.remove then
    cx = self.entity.x + ts.tileSize/2
    cy = self.entity.y + ts.tileSize/2

    local sw = AoE.new(object.entity,cx,cy,10,60,1,10000)
    table.insert(Game.getObjects(), sw)
    self.entity.remove = true
  end
end

function ExplodingTileComponent:draw()
  if self.entity.remove then
    ts = self.entity.tileset.tileSize
    love.graphics.rectangle("fill", self.entity.x-2, self.entity.y-2, ts+4, ts+4)    
  end
end

return ExplodingTileComponent