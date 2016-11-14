KeyboardInputComponent = {}
KeyboardInputComponent.__index = KeyboardInputComponent

function KeyboardInputComponent.new(entity)
  local i = {
    keysPressed = {}
  }
  setmetatable(i, KeyboardInputComponent)
  i.entity = entity
  return i
end

function KeyboardInputComponent:keyreleased(key)
  self.keysPressed[key] = nil
end

function KeyboardInputComponent:keypressed(key, unicode)
  self.entity.activeComponent = self
  self.keysPressed[key] = true
end

function KeyboardInputComponent:update(dt)
  local x, y = love.mouse.getPosition()
  local move = self.entity.entity.components.move

  if move then 
    x = x - self.entity.entity.components.move.x
    y = y - self.entity.entity.components.move.y
  end
  self.entity.fireAngle = math.atan2(x,-y)


  self.entity.primary = love.mouse.isDown(1) or self.keysPressed.space
  self.entity.secondary = love.mouse.isDown(2) or self.keysPressed.lshift

  self.entity.throttle =  (self.keysPressed.up or self.keysPressed.w) and 1 or 0

  if (self.keysPressed.left or self.keysPressed.a) then
    self.entity.angularInput = -1
  elseif (self.keysPressed.right or self.keysPressed.d) then
    self.entity.angularInput = 1
  else
    self.entity.angularInput = 0
  end
end

return KeyboardInputComponent