require('object/Tile')
Layer = {}
Layer.__index = Layer

function Layer.new(map,name)
  local t = {
    tiles = {},
    name = name
  }
  setmetatable(t, Layer)
  t.components = {}
  t.map = map
  return t
end

function Layer:update(dt)
  for i,t in pairs(self.tiles) do
      if t:shouldRemove() then
        t:Remove()
        table.remove(self.tiles,i)
      else
      t:update(dt)
      end
  end
end

function Layer:draw()
  for _,t in pairs(self.tiles) do
    t:addQuad()
  end
end

return Layer