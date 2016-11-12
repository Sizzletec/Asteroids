Layer = {
  tiles = {}
}
Layer.__index = Layer

function Layer.new()
  local t = {}
  setmetatable(t, Layer)
  t.components = {}

  return t
end

function Layer:update(dt)
  for _, component in pairs(self.components) do
    if component.update then
      component:update(dt)
    end
  end

  if self.id == 0 then
    self.id = 1
  end
end

function Layer:draw()
  for _, component in pairs(self.components) do
    if component.draw then
      component:draw()
    end
  end
end

return Layer