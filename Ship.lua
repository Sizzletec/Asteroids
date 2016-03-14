Ship = {
  image = love.graphics.newImage('ship-sprites.png'),
  ship2 = love.graphics.newImage('ship2.png'),
  ship2cannon = love.graphics.newImage('ship2cannon.png')
}
Ship.__index = Ship

shoot = love.audio.newSource("shoot.wav", "static")

function Ship.new(player,x,y,rotation,vx,vy)
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
  s.exploding = false
  s.explodingFrame = 0
  s.player = player
  s.color = 0
  s.cannonRotation = 0
  return s
end

function Ship:update(dt)
  if self.exploding then
    self.explodingFrame = self.explodingFrame + 8 * dt
  end
  if self.vx > 2 then
    self.vx = 2
  elseif self.vx < -2 then
    self.vx = -2
  end

  if self.vy > 2 then 
    self.vy = 2
  elseif self.vy < -2 then
    self.vy = -2
  end 

  self.x = self.x + self.vx
  self.y = self.y + self.vy




  if self.y > (TiledMap_GetMapH() * 16) then
    self.y = self.y - TiledMap_GetMapH() * 16
  end

  if self.y < 0 then
    self.y = self.y + TiledMap_GetMapH() * 16
  end


  if self.x > 1920 then
    self.x = self.x - 1920
  end

  if self.x < 0 then
    self.x = self.x + 1920
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
  shoot:play()
  -- self.exploding = true


  -- if self.cannon == "right" then
  --   leftCannonOffsetX = self.x + (10 * math.sin(self.rotation)) + (8 * math.cos(self.rotation))
  --   leftCannonOffsetY = self.y + (10 * -math.cos(self.rotation)) + (8 * math.sin(self.rotation))
  --   bullet = Bullet.new(leftCannonOffsetX,leftCannonOffsetY,self.rotation)
  --   table.insert(self.bullets, bullet)
  -- elseif self.cannon == "left" then
  --   rightCannonOffsetX = self.x + (10 * math.sin(self.rotation)) + (-7 * math.cos(self.rotation))
  --   rightCannonOffsetY = self.y + (10 * -math.cos(self.rotation)) + (-7 * math.sin(self.rotation))
  --   bullet = Bullet.new(rightCannonOffsetX,rightCannonOffsetY,self.rotation)
  --   table.insert(self.bullets, bullet)
  -- end

  -- if self.cannon == "right" then
  --   self.cannon = "left"
  -- else
  --   self.cannon = "right"
  -- end


  leftCannonOffsetX = self.x - (3 * math.sin(self.rotation))
  leftCannonOffsetY = self.y + (3 * math.cos(self.rotation))
  bullet = Bullet.new(leftCannonOffsetX,leftCannonOffsetY,self.cannonRotation)
  table.insert(self.bullets, bullet)

end

function Ship:draw()
  for i, bullet in pairs(self.bullets) do
    bullet:draw()
  end

  image = self.image

  if self.explodingFrame < 3 then
    xFrame = 0
    if self.engine then
      xFrame = 1
    end

    -- top_left = love.graphics.newQuad(xFrame*32, self.color*32, 32, 32, image:getDimensions())
    -- love.graphics.draw(image, top_left,self.x, self.y, self.rotation, 1,1 , 16,16)
    love.graphics.draw(self.ship2,self.x , self.y, self.rotation, 1,1 , 16,16)
    love.graphics.draw(self.ship2cannon,self.x - (3 * math.sin(self.rotation))
, self.y + (3 * math.cos(self.rotation)), self.cannonRotation, 1,1 , 10, 10)


    -- y+5 at 0
    -- x-5 at 90

  end

  if self.exploding then
    top_left = love.graphics.newQuad(math.floor(self.explodingFrame)*32, 4*32, 32, 32, image:getDimensions())
    love.graphics.draw(image, top_left,self.x, self.y, self.rotation, 1,1 , 16,16)
  end



  love.graphics.setColor(255, 255, 255)

  if self.shield then
    love.graphics.circle("line", self.x, self.y, 20)
  end
end

return Ship