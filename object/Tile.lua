Tile = {}
Tile.__index = Tile

function Tile.new(id)
  local t = {
    id = id
  }
  setmetatable(t, Tile)
  t.components = {}

  return t
end

function Tile:update(dt)
  for _, component in pairs(self.components) do
    if component.update then
      component:update(dt)
    end
  end

  if self.id == 0 then
    self.id = 1
  end
end

function Tile:draw()
  for _, component in pairs(self.components) do
    if component.draw then
      component:draw()
    end
  end
end

return Tile