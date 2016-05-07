KeyboardInputComponent = {
  keysPressed = {}
}
KeyboardInputComponent.__index = KeyboardInputComponent

function KeyboardInputComponent.new(entity)
  local i = {}
  setmetatable(i, KeyboardInputComponent)
  i.entity = entity
  return i
end

function KeyboardInputComponent:keyreleased(key)
  self.keysPressed[key] = nil
  if (key == "space") then
      self.entity.components.primaryAttack.firing = false
  end

  if (key == "lshift") and self.entity.components.secondaryAttack then
    self.entity.components.secondaryAttack.firing = false
  end
end

function KeyboardInputComponent:keypressed(key, unicode)
  self.keysPressed[key] = true

  if (key == "space") then
    self.entity.components.primaryAttack.firing = true
  end

  if (key == "lshift")  and self.entity.components.secondaryAttack  then
    self.entity.components.secondaryAttack.firing = true
  end
end

function KeyboardInputComponent:update(dt)
  local move = self.entity.components.move
  local leftDown = love.mouse.isDown(1)
  local rightDown = love.mouse.isDown(2)
  if leftDown and self.entity.components.primaryAttack then
    self.entity.components.primaryAttack.firing = true
    x, y = love.mouse.getPosition()


    -- Mover.MoveToPoint(self.entity,x,y,dt)

        --    joyCannonX = joy:getGamepadAxis("rightx")
    --    joyCannonY = joy:getGamepadAxis("righty")

    --    if math.abs(joyCannonX) > 0.5 or math.abs(joyCannonY) > 0.5 then
    --      local angle = math.atan2(joyCannonX,-joyCannonY)

    --      player.cannonRotation = angle
    --      player.firing = true

    --    end
  elseif not self.keysPressed.space then
    self.entity.components.primaryAttack.firing = false
  end

  if rightDown and self.entity.components.secondaryAttack then
    self.entity.components.secondaryAttack.firing = true
  elseif not self.keysPressed.lshift then
    self.entity.components.secondaryAttack.firing = false
  end




  if move then 
    if (self.keysPressed.up or self.keysPressed.w) then
      move.throttle = 1
    end

    if (self.keysPressed.left or self.keysPressed.a) then
      move.angularInput = -1
    end

    if (self.keysPressed.right or self.keysPressed.d) then
      move.angularInput = 1
    end
  end
end

return KeyboardInputComponent