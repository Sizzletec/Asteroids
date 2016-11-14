Tile = {}
Tile.__index = Tile

require('components/WallTileComponent')
require('components/BlockingTileComponent')

function Tile.new(id,tileset,x,y)
  local t = {
    id = tonumber(id),
    tileset = tileset,
    x = x,
    y = y,
  }
  setmetatable(t, Tile)
  t.components = {}
  if t.id ~= 0 then
    t.components["wall"] = WallTileComponent.new(t)
    t.components["blocking"] = BlockingTileComponent.new(t)
  end

  return t
end

function Tile:update(dt)
  for _, component in pairs(self.components) do
    if component.update then
      component:update(dt)
    end
  end
end

function Tile:draw()
  self.tileset:addTile(self.id, self.x, self.y)
  for _, component in pairs(self.components) do
    if component.draw then
      component:draw()
    end
  end
end

return Tile