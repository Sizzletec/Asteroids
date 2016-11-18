Tile = {}
Tile.__index = Tile

require('components/tile/WallTileComponent')
require('components/tile/BlockingTileComponent')
require('components/tile/ShieldTileComponent')
require('components/tile/ExplodingTileComponent')

function Tile.new(id,tileset,x,y)
  local t = {
    id = tonumber(id),
    tileset = tileset,
    x = x,
    y = y
  }
  setmetatable(t, Tile)
  t.components = {}
  if t.id ~= 0 and t.id < 7 then
    t.components["wall"] = WallTileComponent.new(t)
    t.components["blocking"] = BlockingTileComponent.new(t)
    -- t.components["shield"] = ShieldTileComponent.new(t,"right")

    if t.id == 3 then
      t.components["blocking"] = ExplodingTileComponent.new(t)
    end
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
  if self.tileset then
    self.tileset:addTile(self.id, self.x, self.y)
    for _, component in pairs(self.components) do
      if component.draw then
        component:draw()
      end
    end
  end
end

return Tile