MapObject = Object.new()
MapObject.__index = MapObject

function MapObject.new(id)
  local t = {
    layers = {}
    id = id
  }
  setmetatable(t, MapObject)
  t.components = {}

  return t
end

function MapObject:update(dt)
  for _, component in pairs(self.components) do
    if component.update then
      component:update(dt)
    end
  end

  if self.id == 0 then
    self.id = 1
  end
end

function MapObject:draw()
  for _, component in pairs(self.components) do
    if component.draw then
      component:draw()
    end
  end
end

return MapObject