Ship = {
  image = love.graphics.newImage('ship-sprites.png'),
  ship2 = love.graphics.newImage('ship2.png'),
  ship3 = love.graphics.newImage('ship3.png'),
  ship3engine = love.graphics.newImage('ship3engine.png'),
  ship2cannon = love.graphics.newImage('ship2cannon.png'),
  bullets = {},
  acceleration = 0,
  shield = false,
  alive = true,
  exploding = false,
  explodingFrame = 0,
}
Ship.__index = Ship

ShipType = {
  standard = {
    topSpeed = 4,
    acceleration = 4,
    rotationSpeed = 4,
    fireRate = 10,
    health = 150,
    weaponDamage = 30
  },
  gunship = {
    topSpeed = 2,
    acceleration = 3,
    rotationSpeed = 4,
    cannonRotation = 0,
    fireRate = 3,
    health = 200,
    weaponDamage = 50
  },
  assalt = {
    topSpeed = 5,
    acceleration = 5,
    rotationSpeed = 4,
    fireRate = 1,
    health = 100,
    weaponDamage = 20
  }
}

shoot = love.audio.newSource("shoot.wav", "static")

function Ship.new(player,x,y,rotation,vx,vy, type)
  local s = {}
  setmetatable(s, Ship)

  s.shipType = type or ShipType.standard
  s.x = x
  s.y = y
  s.vx = vx or 0
  s.vy = vy or 0
  s.rotation = rotation or 0

  s.topSpeed = s.shipType.topSpeed
  s.acceleration = s.shipType.acceleration
  s.rotationSpeed = s.shipType.rotationSpeed
  s.fireRate = s.shipType.fireRate
  s.health = s.shipType.health
  s.weaponDamage = s.shipType.weaponDamage

  s.player = player
  s.color = 0
  return s
end

function Ship:update(dt)
  if self.exploding then
    self.explodingFrame = self.explodingFrame + 8 * dt
  end

  if self.vx > self.topSpeed then
    self.vx = self.topSpeed
  elseif self.vx < -self.topSpeed  then
    self.vx = -self.topSpeed
  end

  if self.vy > self.topSpeed then
    self.vy = self.topSpeed
  elseif self.vy < -self.topSpeed then
    self.vy = -self.topSpeed
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


  if self.shipType == ShipType.standard then
    if self.cannon == "right" then
      leftCannonOffsetX = self.x + (10 * math.sin(self.rotation)) + (8 * math.cos(self.rotation))
      leftCannonOffsetY = self.y + (10 * -math.cos(self.rotation)) + (8 * math.sin(self.rotation))
      bullet = Bullet.new(leftCannonOffsetX,leftCannonOffsetY,10,self.rotation)
      table.insert(self.bullets, bullet)
    elseif self.cannon == "left" then
      rightCannonOffsetX = self.x + (10 * math.sin(self.rotation)) + (-7 * math.cos(self.rotation))
      rightCannonOffsetY = self.y + (10 * -math.cos(self.rotation)) + (-7 * math.sin(self.rotation))
      bullet = Bullet.new(rightCannonOffsetX,rightCannonOffsetY,10,self.rotation)
      table.insert(self.bullets, bullet)
    end

    if self.cannon == "right" then
      self.cannon = "left"
    else
      self.cannon = "right"
    end
  elseif self.shipType == ShipType.gunship then
    leftCannonOffsetX = self.x - (3 * math.sin(self.rotation))
    leftCannonOffsetY = self.y + (3 * math.cos(self.rotation))
    bullet = Bullet.new(leftCannonOffsetX,leftCannonOffsetY,10,self.cannonRotation)
    bullet.image = love.graphics.newImage('bullet-red.png')
    table.insert(self.bullets, bullet)
  elseif self.shipType == ShipType.assalt then
      local numBullets = 7
      local angleDiff = math.pi/4/numBullets
      for i=numBullets/2,-numBullets/2,-1 do
        local rBullet = self.rotation + i * angleDiff
        leftCannonOffsetX = self.x + (5 * math.sin(self.rotation))
        leftCannonOffsetY = self.y + (5 * -math.cos(self.rotation)) 
        bullet = Bullet.new(leftCannonOffsetX,leftCannonOffsetY,5,rBullet)
        bullet.image = love.graphics.newImage('bullet-blue.png')
        table.insert(self.bullets, bullet)
      end

  end
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

    if self.shipType == ShipType.standard then
      xFrame = 0
      if self.engine then
        xFrame = 1
      end
      top_left = love.graphics.newQuad(xFrame*32, self.color*32, 32, 32, image:getDimensions())
      love.graphics.draw(image, top_left,self.x, self.y, self.rotation, 1,1 , 16,16)

    elseif self.shipType == ShipType.gunship then
      love.graphics.draw(self.ship2,self.x , self.y, self.rotation, 1,1 , 16,16)
      love.graphics.draw(self.ship2cannon,self.x - (3 * math.sin(self.rotation)), self.y + (3 * math.cos(self.rotation)), self.cannonRotation, 1,1 , 10, 10)
    elseif self.shipType == ShipType.assalt then
      if self.engine then
        love.graphics.draw(self.ship3engine,self.x , self.y, self.rotation, 1,1 , 16,16)
      else
        love.graphics.draw(self.ship3,self.x , self.y, self.rotation, 1,1 , 16,16)
      end
    end
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