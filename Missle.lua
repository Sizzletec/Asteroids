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
  Mover.ApplyVelocity(self, dt)
  Mover.StageWrap(self)
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