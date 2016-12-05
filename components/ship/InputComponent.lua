require('components/input/KeyboardInputComponent')
require('components/input/JoystickInputComponent')

InputComponent = {}
InputComponent.__index = InputComponent

function InputComponent.new(entity)
  local i = {
    fireAngle = 0,
    primary = false,
    secondary = false,
    throttle = 0,
    angularInput = 0,
    activeComponent = nil,
    disabled = false
  }
  setmetatable(i, InputComponent)
  i.entity = entity
  i.components = {}

  if entity.player.input == "keyboard" then
    i.components["keyboard"] = KeyboardInputComponent.new(i)
  end
  -- i.components["joystick"] = JoystickInputComponent.new(i)

  return i
end

function InputComponent:update(dt)

  if self.entity.player.input == "keyboard" then
    self.components["keyboard"]:update(dt)
  end
  -- if self.activeComponent then
  --   self.activeComponent:update(dt)
  -- end

  if self.disabled then
    self.throttle = 0
    self.angularInput = 0
    self.primary = false
    self.secondary = false
  end


  local comp = self.entity.components
  local pa = comp.primaryAttack
  local sa = comp.secondaryAttack


  if pa then
    pa.firing = self.primary
  end


  if sa then
    sa.firing = self.secondary
  end
end

return InputComponent