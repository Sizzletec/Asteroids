Ship = {
  image = love.graphics.newImage('ship.png'),
  imageEngine = love.graphics.newImage('ship-engine.png')
}
Ship.__index = Ship

function Ship.new(x,y,rotation,vx,vy)
  local s = {}
  setmetatable(s, Ship)
  s.x = x
  s.y = y
  s.vx = vx or 0
  s.vy = vy or 0
  s.bullets = {}
  s.rotation = rotation or 0
  s.cannon = "left"
  s.engine = false
  s.shield = false
  s.alive = true
  return s
end

function Ship:update(dt)
  if self.vx > 4 then 
    self.vx = 4
  elseif self.vx < -4 then
    self.vx = -4
  end

  if self.vy > 4 then 
    self.vy = 4
  elseif self.vy < -4 then
    self.vy = -4
  end 

	self.x = self.x + self.vx
	self.y = self.y + self.vy




  if self.y > love.graphics.getHeight() then
    self.y = self.y - love.graphics.getHeight()
  end

  if self.y < 0 then
    self.y = self.y + love.graphics.getHeight()
  end


  if self.x > love.graphics.getWidth() then
    self.x = self.x - love.graphics.getWidth()
  end

  if self.x < 0 then
    self.x = self.x + love.graphics.getWidth()
  end

  for i, bullet in pairs(self.bullets) do
    bullet:update(dt)
    hitWall = TiledMap_GetMapTile(math.floor(bullet.x/16),math.floor(bullet.y/16),1)
    if bullet.lifetime > 1  or hitWall > 0 then
      table.remove(self.bullets, i)
    end
  end
end

function Ship:fire()
  if self.cannon == "right" then
    leftCannonOffsetX = self.x + (10 * math.sin(self.rotation)) + (8 * math.cos(self.rotation))
    leftCannonOffsetY = self.y + (10 * -math.cos(self.rotation)) + (8 * math.sin(self.rotation))
    bullet = Bullet.new(leftCannonOffsetX,leftCannonOffsetY,self.rotation)
    table.insert(self.bullets, bullet)
  elseif self.cannon == "left" then
    rightCannonOffsetX = self.x + (10 * math.sin(self.rotation)) + (-7 * math.cos(self.rotation))
    rightCannonOffsetY = self.y + (10 * -math.cos(self.rotation)) + (-7 * math.sin(self.rotation))
    bullet = Bullet.new(rightCannonOffsetX,rightCannonOffsetY,self.rotation)
    table.insert(self.bullets, bullet)
  end

  if self.cannon == "right" then
    self.cannon = "left"
  else
    self.cannon = "right"
  end
end

function Ship:draw()
  for i, bullet in pairs(self.bullets) do
    bullet:draw()
  end

  image = self.image

  if self.engine then
    image = self.imageEngine
  end

	love.graphics.draw(image, self.x, self.y, self.rotation, 1,1 , 16,16)

  love.graphics.setColor(255, 255, 255)

  if self.shield then
    love.graphics.circle("line", self.x, self.y, 20)
  end
end

return Ship