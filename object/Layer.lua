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
  for _,t in pairs(self.tiles) do
    t:update(dt)
  end
end

function Layer:draw()
  for _,t in pairs(self.tiles) do
    t:addQuad()
  end
end

return Layer