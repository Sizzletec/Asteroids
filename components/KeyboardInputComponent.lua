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
      self.entity.firing = false
  end
end

function KeyboardInputComponent:keypressed(key, unicode)
  self.keysPressed[key] = true

  if (key == "space") then
    self.entity.firing = true
  end

  if (key == "y") then
    self.entity:selfDestruct()
  end
end

function KeyboardInputComponent:update(dt)
  if (self.keysPressed.lshift) then
    self.entity.shield = true
  else
    self.entity.shield = false
  end
  local leftDown = love.mouse.isDown(1)
  if leftDown then
    scaleFactor = width/1920

    x, y = love.mouse.getPosition()
    Mover.MoveToPoint(self.entity,x,y,dt)
  end
  if (self.keysPressed.up) then
    self.entity.throttle = 1
  end

  if (self.keysPressed.left) then
    self.entity.angularInput = -1
  end

  if (self.keysPressed.right) then
    self.entity.angularInput = 1
  end
end

return KeyboardInputComponent