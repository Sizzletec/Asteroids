local image = love.graphics.newImage('images/missleShot.png')

Missle = {}
Missle.__index = Missle

local tilesetBatch = love.graphics.newSpriteBatch(image)

function Missle.new(x,y,speed,rotation,damage,bulletLife)
  local s = {}
  setmetatable(s, Missle)
  s.x = x
  s.y = y
  s.bulletLife = bulletLife or 1
  s.rotation = rotation or 0
  s.vx = speed * math.sin(s.rotation)
  s.vy = speed * -math.cos(s.rotation)
  s.lifetime = 0
  s.damage = damage
  return s
end

function Missle:update(dt)
  self.lifetime = self.lifetime + dt
  self.x = self.x + self.vx
  self.y = self.y + self.vy

  if self.y > 960 then
    self.y = self.y - 960
  end

  if self.y < 0 then
    self.y = self.y + 960
  end


  if self.x > 1920 then
    self.x = self.x - 1920
  end

  if self.x < 0 then
    self.x = self.x + 1920
  end

  tilesetBatch:add(self.x, self.y, self.rotation, 1,1 , 3,3)
end


function Missle:flyTowardsPoint(x,y)
  angle = math.atan2(x - self.x, -(y - self.y))

  if angle < 0 then
    angle= angle + 2 * math.pi

  elseif angle > math.pi then
    angle = angle - 2 * math.pi
  end

  moveAngle = angle - self.rotation

  if moveAngle > math.pi or moveAngle < 0 then
    self.angularInput = -1
  elseif moveAngle > 0 then
    self.angularInput = 1
  else
    self.angularInput = 0
  end

  self.throttle = 1
end


function Missle.draw()
  tilesetBatch:flush()
  love.graphics.draw(tilesetBatch)
  tilesetBatch:clear()
end

return Missle