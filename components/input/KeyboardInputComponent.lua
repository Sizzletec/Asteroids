KeyboardInputComponent = {}
KeyboardInputComponent.__index = KeyboardInputComponent

function KeyboardInputComponent.new(entity)
  local i = {}
  setmetatable(i, KeyboardInputComponent)
  i.entity = entity
  return i
end

function KeyboardInputComponent:update(dt)
  local x, y = love.mouse.getPosition()
  local move = self.entity.entity.components.move

  if move then 
    x = x - self.entity.entity.components.move.x
    y = y - self.entity.entity.components.move.y
  end
  self.entity.fireAngle = math.atan2(x,-y)


  self.entity.primary = love.mouse.isDown(1) or love.keyboard.isDown("space")
  self.entity.secondary = love.mouse.isDown(2) or love.keyboard.isDown("lshift")

  self.entity.throttle =  love.keyboard.isDown("up","w") and 1 or 0

  if love.keyboard.isDown("left","a") then
    self.entity.angularInput = -1
  elseif love.keyboard.isDown("right","d") then
    self.entity.angularInput = 1
  else
    self.entity.angularInput = 0
  end
end

return KeyboardInputComponent