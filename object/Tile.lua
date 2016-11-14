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
    t = 0
  }
  setmetatable(t, Tile)
  t.components = {}
  if t.id ~= 0 and t.id < 7 then
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

  self.t = self.t + dt
  if self.id == 3 then
    if self.t < 1 then
      self.x = self.x + 1
    elseif self.t < 2  then
      self.x = self.x -1
    else
      self.t = 0
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