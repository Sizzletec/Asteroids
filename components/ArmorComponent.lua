ArmorComponent = {}
ArmorComponent.__index = ArmorComponent

function ArmorComponent.new(entity,time)
  local i = {}
  setmetatable(i, ArmorComponent)
  i.entity = entity
  i.time = time
  return i
end

function ArmorComponent:apply(damage)
  newDamage = math.floor(damage * 0.7)
  if newDamage < 1.0 then
    newDamage = 1
  end
  return newDamage
end

function ArmorComponent:update(dt)
  self.time = self.time - dt

  if self.time < 0 then
    self = nil
  end
end

return ArmorComponent