Player = {}
Player.__index = Player

function Player.new()
  local p = {}
  p.components = {}
  return p
end

function Player:update(dt)
  for _, component in pairs(self.components) do
    if component.update then
      component:update(dt)
    end
  end
end


function Player:draw()
  for _, component in pairs(self.components) do
    if component.update then
      component:update(dt)
    end
  end
end

return Player