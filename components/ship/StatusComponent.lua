StatusComponent = {}
StatusComponent.__index = StatusComponent

function StatusComponent.new(entity)
  local i = {
    statusList = {}
  }
  setmetatable(i, StatusComponent)
  i.entity = entity
  i.time = 0
  return i
end

function StatusComponent:ApplyDot(entity,damage,time)
  self.statusList["DoT"] = {
    entity = entity,
    damage = damage,
    time = time
  }
end


function StatusComponent:Disable(time)
  self.statusList["disable"] = {
    time = time
  }
end

function StatusComponent:GetDisabled()
  d = self.statusList.disable
  if d then
    return d.time
  end
end

function StatusComponent:Armored(time)
  self.statusList["armored"] = {
    time = time
  }
end


function StatusComponent:Clear()
  self.statusList = {}
end

function StatusComponent:update(dt)
  self.time = self.time + dt
    self.time = 0
    for key,status in pairs(self.statusList) do
      if status.time > 0 then
        status.time = status.time -dt
        if key == "DoT" then
            self.entity.components.life:takeDamage(status.entity,status.damage)
        elseif key == "disable" then
          self.entity.components.input.disabled = true
        end
      else
        if key == "disable" then
          self.entity.components.input.disabled = false
          status.time = 0
        end
      end
    end
end

return StatusComponent