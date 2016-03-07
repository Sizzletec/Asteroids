Ship = {}
Ship.__index = Ship

function Ship.new(x,y,vx,vy)
  vx = vx  or 0
  vy = vy  or 0
  local s = {}
  setmetatable(s, Ship)
  s.x = x
  s.y = y
  s.vx = vx
  s.vy = vy
  return s
end

function Ship:update()
	self.x = self.x + self.vx
	self.y = self.y + self.vy
end

function Ship:draw()
	love.graphics.print('ship', self.x, self.y)
end

return Ship