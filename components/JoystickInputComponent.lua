JoystickInputComponent = {}
JoystickInputComponent.__index = InputComponent

function JoystickInputComponent.new(entity)
  local i = {}
  setmetatable(i, JoystickInputComponent)
  i.entity = entity
  return i
end

function JoystickInputComponent:gamepadpressed(joystick, button)
  if button == "a" then
    self.entity.firing = true
  end

  if button == "y" then
    self.entity:selfDestruct()
  end
end

function JoystickInputComponent:gamepadreleased(joystick, button)
  if button == "a" then
    self.entity.firing = false
  end
end

function JoystickInputComponent:gamepadaxis(joystick, axis, value)
end


function JoystickInputComponent:update(dt)

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