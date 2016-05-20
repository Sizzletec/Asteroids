

RayComponent = {
  weaponDamage = 3,
  firing = false,
  heat = 0,
  cooldown = false
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
  if self.firing and not self.cooldown then
    self.heat = self.heat + 1

    if self.heat == 100 then
      self.cooldown = true
    end
    if not self.beam  then
      self.beam = Beam.new(self.entity, self.weaponDamage)
    end
    self.beam:update(move.x,move.y,move.rotation,dt)
    else
      self.beam = nil
  end

  if self.cooldown or not self.firing then
    self.heat = self.heat - 1

    if self.heat <= 0 then
      self.heat = 0
      self.cooldown = false
    end
  end
end 

function RayComponent:draw()
  if self.beam then
    self.beam:draw()
  end

  if self.heat > 0 then
    local move = self.entity.components.move

    if self.cooldown then
      love.graphics.setNewFont(10)
      love.graphics.print("OVERHEAT!", move.x -36, move.y - 30)
      love.graphics.setColor(200, 200, 200)
      love.graphics.setNewFont(40)
    else
      love.graphics.setColor(0, 255, 0)
    end
    love.graphics.rectangle("fill", move.x + 30, move.y - 30, 5, 30)

    love.graphics.setColor(255, 0, 0)
    love.graphics.rectangle("fill", move.x + 30, move.y - 30, 5, 30*self.heat/100)
    love.graphics.setColor(255, 255, 255)
  end
end


return RayComponent