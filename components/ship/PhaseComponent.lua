local part1 = love.graphics.newImage('images/part.png')

PhaseComponent = {}

PhaseComponent.__index = PhaseComponent

function PhaseComponent.new(entity)
  local i = {
    cannon = "right",
    gunCooldown = 0,
    weaponDamage = 20,
    fireRate = 1,
    firing = false
  }

  setmetatable(i, PhaseComponent)
  i.entity = entity
  i.shape = nil
  return i
end

function PhaseComponent:update(dt)
  if self.firing and self.gunCooldown <= 0 then
    self:fire()
    self.gunCooldown = 1/self.fireRate
  elseif self.gunCooldown > 0 then
    self.gunCooldown = self.gunCooldown - dt
  end
end

function PhaseComponent:fire()
  if self.entity.components.life.health <= 0 then
    return
  end
  local move = self.entity.components.move
  self.entity.components.score.shots = self.entity.components.score.shots + 1

  move.x = move.x + (80 * math.sin(move.rotation))
  move.y = move.y + (80 * -math.cos(move.rotation))

  local distanceTraveled = 80

      move:StageWrap()
    move:updateShape()


  tile = false 

  for shape, delta in pairs(HC.collisions(self.entity.shape)) do
    if shape.type == "tile" then
      if shape.entity.components.wall then
        tile = true
        break
      end
    end 
  end 

  while tile do
    move.x = move.x + (20 * math.sin(move.rotation))
    move.y = move.y + (20 * -math.cos(move.rotation))
    distanceTraveled = distanceTraveled + 20

    move:StageWrap()
    move:updateShape()

    tile = false
    for shape, delta in pairs(HC.collisions(self.entity.shape)) do
      if shape.type == "tile" then
        if shape.entity.components.wall then
          tile = true
          break
        end
      end 
    end 
  end

  local powX = math.pow(move.vx, 2)
  local powY = math.pow(move.vy, 2)
  local velocity = math.sqrt(powX + powY)

  move.vx = velocity * math.sin(move.rotation)
  move.vy = velocity * -math.cos(move.rotation)

  self.shape = HC.polygon(-30,-30, 30,-30, 30, distanceTraveled+30, -30, distanceTraveled+30)
  self.shape:setRotation(0)
  local cx,cy = self.shape:center()
  self.shape:moveTo(move.x,move.y+cy)
  self.shape:setRotation(move.rotation,move.x,move.y)


  for shape, delta in pairs(HC.collisions(self.shape)) do
    if shape.type == "ship" then
      if shape.entity ~= self.entity then
        shape.entity.components.life:takeDamage(self.entity, self.weaponDamage)
      end
    end
  end

  
end

function PhaseComponent:draw()
  if self.shape then
    self.shape:draw('line')
  end
end

return PhaseComponent