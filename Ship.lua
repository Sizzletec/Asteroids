local image = love.graphics.newImage('ship-sprites.png')
local ship2cannon = love.graphics.newImage('ship2cannon.png')

Ship = {
  acceleration = 0,
  shield = false,
  alive = true,
  exploding = false,
  explodingFrame = 0,
  lives = 3,
  wrap = true,


  -- for score

  kills = 0,
  deaths = 0,
  shots = 0,
  hits = 0,
  damageGiven = 0,
  damageTaken = 0,
  wallsRunInto = 0


}
Ship.__index = Ship

ShipType = {
  standard = {
    name = "Standard",
    topSpeed = 4,
    acceleration = 6,
    rotationSpeed = 4,
    fireRate = 15,
    health = 150,
    weaponDamage = 10
  },
  gunship = {
    name = "Gunship",
    topSpeed = 2,
    acceleration = 3,
    rotationSpeed = 4,
    cannonRotation = 0,
    fireRate = 1.5,
    health = 130,
    weaponDamage = 40
  },
  assalt = {
    name = "Assault",
    topSpeed = 5,
    acceleration = 4,
    rotationSpeed = 4,
    fireRate = 1,
    health = 170,
    weaponDamage = 10
  },
  ray = {
    name = "Rayman",
    topSpeed = 2,
    acceleration = 4,
    rotationSpeed = 1,
    fireRate = 6,
    health = 150,
    weaponDamage = 1.5
  },
  zap = {
    name = "Zapper",
    topSpeed = 3,
    acceleration = 3,
    rotationSpeed = 4,
    fireRate = 10,
    health = 160,
    weaponDamage = 1.5
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
  s.bullets = {}
  s.gunCooldown = 0
  s.throttle = 0
  s.angularInput = 0
  return s
end

function Ship:setDefaults()
  self.x = 0
  self.y = 0
  self.vx = 0
  self.vy = 0
  self.rotation = 0

  self.topSpeed = self.shipType.topSpeed
  self.acceleration = self.shipType.acceleration
  self.rotationSpeed = self.shipType.rotationSpeed
  self.fireRate = self.shipType.fireRate
  self.health = self.shipType.health
  self.weaponDamage = self.shipType.weaponDamage

  playerShip.firing = false
  self.bullets = {}
  self.gunCooldown = 0
  self.throttle = 0
  self.angularInput = 0

  self.shield = false
  self.alive = true
  self.exploding = false
  self.explodingFrame = 0
  self.lives = Ship.lives

  self.kills = 0
  self.deaths = 0
  self.shots = 0
  self.hits = 0
  self.damageGiven = 0
  self.damageTaken = 0
  self.wallsRunInto = 0

end

function Ship:update(dt)

  if self.health <= 0 and not self.exploding then
    self.health = 0
    self.deaths = self.deaths + 1
    self.lives = self.lives - 1
    self.exploding = true
  end


  if self.exploding then
    self.explodingFrame = self.explodingFrame + 8 * dt

    if self.explodingFrame > 10 and self.lives > 0 then
      self:respawn()
    end
  end


  if self.throttle > 0 then
    xAccel = self.throttle * self.acceleration * dt * math.sin(self.rotation)
    yAccel = self.throttle * self.acceleration * dt * -math.cos(self.rotation)

    self.vx = self.vx + xAccel
    self.vy = self.vy + yAccel

    self.engine = true
    self.throttle = 0
  else
    self.engine = false
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


  self.rotation = self.rotation + (4 * dt * self.angularInput)
  self.angularInput = 0

  if self.rotation < 0 then
    self.rotation = self.rotation + 2 * math.pi

  elseif self.rotation > math.pi*2 then
    self.rotation = self.rotation - 2 * math.pi
  end

  if self.wrap then
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
  end

  for i, bullet in pairs(self.bullets) do
    bullet:update(dt)
    if bullet.lifetime > bullet.bulletLife then
      table.remove(self.bullets, i)
    end
  end

  if self.firing and self.gunCooldown <= 0 then
    self:fire()
    self.gunCooldown = 1/self.shipType.fireRate
  elseif self.gunCooldown > 0 then
    self.gunCooldown = self.gunCooldown - dt
  end
end

function Ship:fire()
  if self.health <= 0 then
    return
  end

  self.shots = self.shots + 1

  shoot:play()


  if self.shipType == ShipType.standard then
    if self.cannon == "right" then
      leftCannonOffsetX = self.x + (10 * math.sin(self.rotation)) + (8 * math.cos(self.rotation))
      leftCannonOffsetY = self.y + (10 * -math.cos(self.rotation)) + (8 * math.sin(self.rotation))
      bullet = Bullet.new(leftCannonOffsetX,leftCannonOffsetY,10,self.rotation, self.weaponDamage)
      table.insert(self.bullets, bullet)
    elseif self.cannon == "left" then
      rightCannonOffsetX = self.x + (10 * math.sin(self.rotation)) + (-7 * math.cos(self.rotation))
      rightCannonOffsetY = self.y + (10 * -math.cos(self.rotation)) + (-7 * math.sin(self.rotation))
      bullet = Bullet.new(rightCannonOffsetX,rightCannonOffsetY,10,self.rotation, self.weaponDamage)
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
    bullet = Bullet.new(leftCannonOffsetX,leftCannonOffsetY,15,self.cannonRotation, self.weaponDamage)
    bullet.image = love.graphics.newImage('bullet-red.png')
    table.insert(self.bullets, bullet)
    self.firing = false
  elseif self.shipType == ShipType.assalt then
      local numBullets = 7
      local angleDiff = math.pi/4/numBullets
      for i=numBullets/2,-numBullets/2,-1 do
        local rBullet = self.rotation + i * angleDiff
        leftCannonOffsetX = self.x + (5 * math.sin(self.rotation))
        leftCannonOffsetY = self.y + (5 * -math.cos(self.rotation)) 
        bullet = Bullet.new(leftCannonOffsetX,leftCannonOffsetY,5,rBullet, self.weaponDamage)
        bullet.image = love.graphics.newImage('bullet-blue.png')
        table.insert(self.bullets, bullet)
      end
  elseif self.shipType == ShipType.ray then

    for i=150,0,-1 do

      OffsetX = self.x + (10*math.sin(self.rotation) +  5*i * math.sin(self.rotation))
      OffsetY = self.y + (10*-math.cos(self.rotation) + 5*i * -math.cos(self.rotation)) 
      bullet = Bullet.new(OffsetX,OffsetY,0,self.rotation, self.weaponDamage,0.1)
      table.insert(self.bullets, bullet)
    end
  elseif self.shipType == ShipType.zap then
    for p=1,0,-1 do
    local lastAngle = self.rotation
    local lastX = self.x
    local lastY = self.y
    for segments = love.math.random(3)+3,0,-1  do
        lastAngle = lastAngle + math.rad( love.math.random(40) - 20) 


      length = love.math.random(2)+2
      for i=length,0,-1 do

        OffsetX = lastX + (5*i * math.sin(lastAngle))
        OffsetY = lastY + (5*i * -math.cos(lastAngle)) 
        bullet = Bullet.new(OffsetX,OffsetY,0,lastAngle, self.weaponDamage,0.1)
        table.insert(self.bullets, bullet)

        if i == 1 then
          lastX = OffsetX + 3 * 5 * math.sin(lastAngle)
          lastY = OffsetY + 3 * 5 * -math.cos(lastAngle)
        end
      end
    end
  end
  end
end

function Ship:selfDestruct()
  if self.health <= 0 then
    return
  end
  self.health = 0

  local numBullets = 100
  local angleDiff = 2 * math.pi / numBullets
  for i=numBullets/2,-numBullets/2,-1 do
    local rBullet = self.rotation + i * angleDiff
    leftCannonOffsetX = self.x + (5 * math.sin(self.rotation))
    leftCannonOffsetY = self.y + (5 * -math.cos(self.rotation)) 
    bullet = Bullet.new(leftCannonOffsetX,leftCannonOffsetY,2,rBullet, 200)
    bullet.image = love.graphics.newImage('bullet-blue.png')
    table.insert(self.bullets, bullet)
  end
end


function Ship:drawLifeMarkers(x,y)
    for live=self.lives,1,-1 do


        local xFrame = 0
        if self.engine then
          xFrame = 1
        end

        if self.shipType == ShipType.gunship then
          xFrame = xFrame + 2
        elseif self.shipType == ShipType.assalt then
          xFrame = xFrame + 4
        elseif self.shipType == ShipType.ray then
          xFrame = xFrame + 6
        end


        local top_left = love.graphics.newQuad(xFrame*32, self.color*32, 32, 32, image:getDimensions())
        love.graphics.draw(image, top_left,x + 36 * live, y, 0, 1,1 , 16,16)

        if self.shipType == ShipType.gunship then
          love.graphics.draw(ship2cannon,x + 36 * live - (3 * math.sin(0)), y + (3 * math.cos(0)), 0, 1,1 , 10, 10)
        end

    end
end

function Ship:draw()
  -- for i, bullet in pairs(self.bullets) do
    -- Bullet.draw()
  -- end

  if self.explodingFrame < 3 then
    local xFrame = 0
    if self.engine then
      xFrame = 1
    end

    if self.shipType == ShipType.gunship then
      xFrame = xFrame + 2
    elseif self.shipType == ShipType.assalt then
      xFrame = xFrame + 4
    elseif self.shipType == ShipType.ray then
      xFrame = xFrame + 6
    end


    local top_left = love.graphics.newQuad(xFrame*32, self.color*32, 32, 32, image:getDimensions())
    love.graphics.draw(image, top_left,self.x, self.y, self.rotation, 1,1 , 16,16)

    if self.shipType == ShipType.gunship then
      love.graphics.draw(ship2cannon,self.x - (3 * math.sin(self.rotation)), self.y + (3 * math.cos(self.rotation)), self.cannonRotation, 1,1 , 10, 10)
    end
  end

  if self.exploding then
    local top_left = love.graphics.newQuad(math.floor(self.explodingFrame)*32, 4*32, 32, 32, image:getDimensions())
    love.graphics.draw(image, top_left,self.x, self.y, self.rotation, 1,1 , 16,16)
  end


  love.graphics.setColor(255, 255, 255)

  if self.shield then
    love.graphics.circle("line", self.x, self.y, 20)
  end
end

function Ship:flyTowardsPoint(x,y)
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


function Ship:respawn()

  local spawnLocation = Game.GetSpawnLocation()

  self.x = spawnLocation.x
  self.y = spawnLocation.y
  self.rotation = math.rad(spawnLocation.r)
  self.vx = 0
  self.vy = 0
  self.health = self.shipType.health
  self.exploding = false
  self.explodingFrame = 0
end

return Ship