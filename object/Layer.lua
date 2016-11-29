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
  for _,row in pairs(self.tiles) do
    for _,t in pairs(row) do
      t:update(dt)
    end
  end
end

function Layer:draw()
  for _,row in pairs(self.tiles) do
    for _,t in pairs(row) do
      t:addQuad()
    end
  end
end

return Layer