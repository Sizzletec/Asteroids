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
    if not self.beam  then
      self.beam = Beam.new(self.entity, self.weaponDamage)
    end
    self.beam:update(move.x,move.y,move.rotation,dt)
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