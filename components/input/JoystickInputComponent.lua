JoystickInputComponent = {
  leftx = 0,
  lefty = 0,
  rightx = 0,
  righty = 0,
  triggerright = 0,
  triggerleft = 0
}
JoystickInputComponent.__index = JoystickInputComponent

function JoystickInputComponent.new(entity)
  local i = {}
  setmetatable(i, JoystickInputComponent)
  i.entity = entity
  return i
end

function JoystickInputComponent:gamepadpressed(joystick, button)
  self.entity.activeComponent = self
  -- if button == "rightshoulder" then
  --     self.entity.primary = true
  -- end

  -- if button == "leftshoulder" then
  --   self.entity.secondary = true 
  -- end
end

function JoystickInputComponent:gamepadreleased(joystick, button)
  -- if button == "rightshoulder" then
  --     self.entity.primary = false
  -- end

  -- if button == "leftshoulder" then
  --   self.entity.secondary = false 
  -- end
end

function JoystickInputComponent:gamepadaxis(joystick, axis, value)
  self.entity.activeComponent = self
  self[axis] = value
end


function JoystickInputComponent:update(dt)
  if math.abs(self.rightx) > 0.5 or math.abs(self.righty) > 0.5 then
    self.entity.fireAngle = math.atan2(self.rightx,-self.righty)
  end

  if math.abs(self.leftx) > 0.5 or math.abs(self.lefty) > 0.5 then
    local move = self.entity.entity.components.move
    local angle = math.atan2(self.leftx,-self.lefty)

    if angle < 0 then
      angle = angle + 2 * math.pi

    elseif angle > math.pi then
      angle = angle - 2 * math.pi
    end

    local moveAngle = angle - move.rotation

    if (moveAngle < 0 and moveAngle > -math.pi) or moveAngle > math.pi then
      self.entity.angularInput = -1
    elseif moveAngle > 0 or moveAngle < -math.pi then
      self.entity.angularInput = 1
    else
      self.entity.angularInput = 0
    end

    if math.abs(moveAngle) > math.pi and (2*math.pi - math.abs(moveAngle)) < move.rotationSpeed * dt then
      self.entity.angularInput = self.entity.angularInput * (2*math.pi - math.abs(moveAngle))/(move.rotationSpeed* dt)
    elseif math.abs(moveAngle) < move.rotationSpeed * dt then
      self.entity.angularInput = self.entity.angularInput * math.abs(moveAngle)/(move.rotationSpeed* dt)
    end

    if math.abs(moveAngle) < math.pi/8 and (math.abs(self.leftx) > 0.9 or math.abs(self.lefty) > 0.9) then
      self.entity.throttle = 1
    end
  else
    self.entity.angularInput = 0 
    self.entity.throttle = 0
  end

  self.entity.primary = self.triggerright > 0.5
  self.entity.secondary = self.triggerleft > 0.5

  -- if keyboardPlayer.player ==  player.player then
  --   if not gKeyPressed.up then
  --     player.throttle = throttle
  --   end
  -- else
  --   player.throttle = throttle
  -- end


  -- joyX = joy:getGamepadAxis("leftx")
  -- joyY = joy:getGamepadAxis("lefty")

  -- if math.abs(joyX) > 0.5 or math.abs(joyY) > 0.5 then
  --   Mover.MoveTowards(self.entity,joyX,joyY,dt)
  -- end

  -- if player.shipType == ShipType.gunship then
  --   joyCannonX = joy:getGamepadAxis("rightx")
  --   joyCannonY = joy:getGamepadAxis("righty")

  --   if math.abs(joyCannonX) > 0.5 or math.abs(joyCannonY) > 0.5 then
  --     local angle = math.atan2(joyCannonX,-joyCannonY)

  --     player.cannonRotation = angle
  --     player.firing = true
  --   end
  -- end
end

return JoystickInputComponent