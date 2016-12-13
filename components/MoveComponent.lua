MoveComponent = {}
MoveComponent.__index = MoveComponent

function MoveComponent.new(entity)
  local i = {
    x = 0,
    y = 0,
    vx = 0,
    vy = 0,
    rotation = 0,
    throttle = 0,
    acceleration = 0,
    topSpeed = 0,
    rotationSpeed = 0,
    angularInput = 0,
    speedModifier = 1,
    distance = 0
  }

  setmetatable(i, MoveComponent)
  i.entity = entity

  if entity.shipType then
    i.topSpeed = entity.shipType.topSpeed
    i.acceleration = entity.shipType.acceleration
    i.rotationSpeed = entity.shipType.rotationSpeed
  end
  return i
end

function MoveComponent:update(dt)


  local input = self.entity.components.input

  if input then
    self.angularInput = input.angularInput
    self.throttle = input.throttle
  end

  if not self.entity.phase then
    self:ApplyAcceleration(dt)
    self:ApplyVelocity(dt)
    self:ApplyRotation(dt)
  end
  self:StageWrap()
  self:updateShape()
end

function MoveComponent:updateShape(dt)
  self.entity.shape:moveTo(self.x,self.y)
end


function MoveComponent:ApplyAcceleration(dt)
  if self.throttle > 0 then
    local xAccel = self.throttle * self.acceleration * dt * math.sin(self.rotation) * self.speedModifier
    local yAccel = self.throttle * self.acceleration * dt * -math.cos(self.rotation) * self.speedModifier

    self.vx = self.vx + xAccel
    self.vy = self.vy + yAccel

    self.entity.engine = true
    self.throttle = 0
  else
    self.entity.engine = false
  end
end

function MoveComponent:ApplyVelocity(dt)

  if self.topSpeed then
    ts = self.topSpeed * self.speedModifier
    if self.vx > ts then
      self.vx = ts
    elseif self.vx < -ts  then
      self.vx = -ts
    end

    if self.vy > ts then
      self.vy = ts
    elseif self.vy < -ts then
      self.vy = -ts
    end
  end

  self.x = self.x + self.vx * dt
  self.y = self.y + self.vy * dt

  self.distance = self.distance + math.abs(self.vx * dt) + math.abs(self.vy * dt)
end

function MoveComponent:ApplyRotation(dt)
  self.rotation = self.rotation + self.rotationSpeed * self.angularInput * dt
  self.angularInput = 0

  if self.rotation < 0 then
    self.rotation = self.rotation + 2 * math.pi

  elseif self.rotation > math.pi*2 then
    self.rotation = self.rotation - 2 * math.pi
  end
end

function MoveComponent:StageWrap()
  if self.y > 960 then
    self.y = self.y - 960
  end

  if self.y < 0 then
    self.y = self.y + 960
  end

  if self.x > 1920 then
    self.x = self.x - 1920
  end

  if self.x < 0 then
    self.x = self.x + 1920
  end
end


function MoveComponent:MoveTowards(x,y,dt)
  local angle = math.atan2(x,-y)

  if angle < 0 then
    angle = angle + 2 * math.pi

  elseif angle > math.pi then
    angle = angle - 2 * math.pi
  end

  moveAngle = angle - self.rotation


  if (moveAngle < 0 and moveAngle > -math.pi) or moveAngle > math.pi then
    self.angularInput = -1
  elseif moveAngle > 0 or moveAngle < -math.pi then
      self.angularInput = 1
  else
      self.angularInput = 0
  end

  if math.abs(moveAngle) > math.pi and (2*math.pi - math.abs(moveAngle)) < self.rotationSpeed * dt then
    self.angularInput = self.angularInput * (2*math.pi - math.abs(moveAngle))/(self.rotationSpeed* dt)
  elseif math.abs(moveAngle) < self.rotationSpeed * dt then
    self.angularInput = self.angularInput * math.abs(moveAngle)/(self.rotationSpeed* dt)
  end
  if math.abs(moveAngle) < math.pi/8 then
    local xPow = math.pow(x, 2)
    local yPow = math.pow(y, 2)
    local dist = math.sqrt(xPow + yPow)
      if dist > 1 then
        dist = 1
      end
      self.throttle = dist
  end
end


return MoveComponent