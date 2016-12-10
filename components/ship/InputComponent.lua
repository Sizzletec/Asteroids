InputComponent = {}
InputComponent.__index = InputComponent

function InputComponent.new(entity)
  local i = {
    fireAngle = 0,
    primary = false,
    secondary = false,
    tertiary = false,
    throttle = 0,
    angularInput = 0,
    activeComponent = nil,
    disabled = false
  }
  setmetatable(i, InputComponent)
  i.entity = entity
  i.components = {}

  return i
end

function InputComponent:update(dt)

  if self.entity.player.controlling == self.entity then
    if self.entity.player.input == "keyboard" then
      self:getKeyboard()
    elseif self.entity.player.input == "joystick" then 
      self:getJoystick(dt)
    end
  end 

  if self.disabled then
    self.throttle = 0
    self.angularInput = 0
    self.primary = false
    self.secondary = false
    self.tertiary = false
  end


  local comp = self.entity.components
  local pa = comp.primaryAttack
  local sa = comp.secondaryAttack
  local ta = comp.tertiaryAttack

  if pa then
    pa.firing = self.primary
  end


  if sa then
    sa.firing = self.secondary
  end

  if ta then
    ta.firing = self.tertiary
  end
end


function InputComponent:getKeyboard()
  local x, y = love.mouse.getPosition()
  local move = self.entity.components.move

  if move then 
    x = x - self.entity.components.move.x
    y = y - self.entity.components.move.y
  end

  self.fireAngle = math.atan2(x,-y)

  self.primary = love.mouse.isDown(1) or love.keyboard.isDown("space")
  self.secondary = love.mouse.isDown(2) or love.keyboard.isDown("lshift")
  self.tertiary = love.keyboard.isDown("z")

  self.throttle =  love.keyboard.isDown("up","w") and 1 or 0

  if love.keyboard.isDown("left","a") then
    self.angularInput = -1
  elseif love.keyboard.isDown("right","d") then
    self.angularInput = 1
  else
    self.angularInput = 0
  end
end

function InputComponent:getJoystick(dt)

  joy = self.entity.player.joystick

  if joy then

    rightx = joy:getGamepadAxis("rightx")
    righty = joy:getGamepadAxis("righty")

    lefty = joy:getGamepadAxis("lefty")
    leftx = joy:getGamepadAxis("leftx")

    triggerleft = joy:getGamepadAxis("triggerleft")
    triggerright = joy:getGamepadAxis("triggerright")


    if math.abs(rightx) > 0.5 or math.abs(righty) > 0.5 then
      self.fireAngle = math.atan2(rightx,-righty)
    end

    if math.abs(leftx) > 0.5 or math.abs(lefty) > 0.5 then
      local move = self.entity.components.move
      local angle = math.atan2(leftx,-lefty)

      if angle < 0 then
        angle = angle + 2 * math.pi
      elseif angle > math.pi then
        angle = angle - 2 * math.pi
      end

      local moveAngle = angle - move.rotation

      if (moveAngle < 0 and moveAngle > -math.pi) or moveAngle > math.pi then
        self.angularInput = -1
      elseif moveAngle > 0 or moveAngle < -math.pi then
        self.angularInput = 1
      else
        self.angularInput = 0
      end

      if math.abs(moveAngle) > math.pi and (2*math.pi - math.abs(moveAngle)) < move.rotationSpeed * dt then
        self.angularInput = self.angularInput * (2*math.pi - math.abs(moveAngle))/(move.rotationSpeed* dt)
      elseif math.abs(moveAngle) < move.rotationSpeed * dt then
        self.angularInput = self.angularInput * math.abs(moveAngle)/(move.rotationSpeed* dt)
      end



      if math.abs(moveAngle) < math.pi/8 then

        gas = math.sqrt(leftx*leftx + lefty*lefty)
        if gas > 0.99 then
          self.throttle = 1
        end
      end
    else
      self.angularInput = 0 
      self.throttle = 0
    end

    self.primary = triggerright > 0.5
    self.secondary = triggerleft > 0.5
    self.tertiary = joy:isGamepadDown("rightshoulder")
  end
end

return InputComponent