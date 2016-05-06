RayComponent = {
  weaponDamage = 3,
  firing = false,
}

RayComponent.__index = RayComponent

function RayComponent.new(entity)
  local i = {}
  setmetatable(i, RayComponent)
  i.entity = entity
  return i
end

function RayComponent:update(dt)
  if self.entity.components.life.health <= 0 then
    return
  end
  local move = self.entity.components.move
  if self.firing then
    self.beam = Beam.new(self.entity,move.x,move.y,0,move.rotation, self.weaponDamage,0.1)
    self.beam:update(dt)
    else
      self.beam = nil
  end
end

function RayComponent:draw()
  if self.beam then
    self.beam:draw()
  end
end


return RayComponent