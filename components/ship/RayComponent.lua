

RayComponent = {
  weaponDamage = 50,
  firing = false,
  heat = 0,
  cooldown = false,
  range = 1000
}

RayComponent.__index = RayComponent

function RayComponent.new(entity)
  local i = {}
  setmetatable(i, RayComponent)
  i.entity = entity
  i.hitShapes = {}
  i.length = i.range
  return i
end

function RayComponent:update(dt)
  local life = self.entity.components.life
  if self.entity.components.life.health <= 0 and not life.alive  then
    return
  end

  

  if not life.alive then
    self.beam = nil
  end

  length = self.range +50

  local move = self.entity.components.move
  if self.firing and not self.cooldown then
    self.heat = self.heat + 80 * dt

    if self.heat >= 100 then
      self.cooldown = true
    end

    collisons = HC:hash():intersectionsWithSegment(move.x,move.y,move.x + length*math.sin(move.rotation), move.y+ length*-math.cos(move.rotation))

    self.length = self.range
    self.hitShapes = {}
    for _,col in pairs(collisons) do
      shape = col[1]
      t = col[2]
      px = col[3]
      py = col[4]

      if shape.entity ~= self.entity then
        data = {shape = shape, x = px , y = py}
        if t <=  self.range then 
          
          -- self.length = t

          if shape.type == "ship" then
            if not shape.entity.phase then
              shape.entity.components.life:takeDamage(self.entity, self.weaponDamage * dt) 
              self.length = t
              table.insert( self.hitShapes, data)
              break
            end
          elseif shape.type == "tile" then
            beam = {entity = self.entity}
            if shape.entity:OnBeamHit(beam) then
              self.length = t
              table.insert( self.hitShapes, data)
              break
            end
          end
        end
        -- shape.entity.components.life:takeDamage(self.entity, self.weaponDamage)   
      end  
    end

    -- -- if not self.beam  then
    --   self.beam = Beam.new(self.entity, self.weaponDamage)
    -- end
    -- self.beam:update(move.x,move.y,move.rotation,dt)
    -- else
    --   self.beam = nil
  end

  -- self.heat = 0
  if self.cooldown or not self.firing then
    self.heat = self.heat - 1

    if self.heat <= 0 then
      self.heat = 0
      self.cooldown = false
    end
  end
end 

function RayComponent:draw()

  -- for _,data in pairs(self.hitShapes) do
  --   love.graphics.setColor(0, 255, 0)
  --   data.shape:draw('fill')
  --   love.graphics.setColor(255, 0, 0)

  --   love.graphics.circle("fill", data.x, data.y, 10)
  -- end
  love.graphics.setColor(0, 200, 255)
  if self.firing and not self.cooldown then
    -- self.beam:draw()
    local move = self.entity.components.move
    love.graphics.line(move.x,move.y,move.x + self.length*math.sin(move.rotation), move.y+ self.length*-math.cos(move.rotation))
  end
  love.graphics.setColor(255, 255, 255)


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