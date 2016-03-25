local image = love.graphics.newImage('images/ship-sprites.png')
local lightning = love.graphics.newImage('images/lightnings.png')
local ship2cannon = love.graphics.newImage('images/ship2cannon.png')
require('ShipTypes')
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
  wallsRunInto = 0,

  lightningFrame = 0 

}
Ship.__index = Ship

shoot = love.audio.newSource("sounds/shoot.wav", "static")

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
  s.beams = {}
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
  self.beams = {}
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
  self.lightningFrame = self.lightningFrame + 8 * dt
  if self.lightningFrame >= 4 then
    self.lightningFrame = self.lightningFrame - 4
  end

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

  for i, beam in pairs(self.beams) do
    beam:update(dt)
    if beam.lifetime > beam.bulletLife then
      table.remove(self.beams, i)
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
    bullet.image = love.graphics.newImage('images/bullet-red.png')
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
      bullet.image = love.graphics.newImage('images/bullet-blue.png')
      table.insert(self.bullets, bullet)
    end
  elseif self.shipType == ShipType.ray then

    beam = Beam.new(self.x,self.y,0,self.rotation, self.weaponDamage,0.05)
    table.insert(self.beams, beam)

    -- for i=150,0,-1 do

    --   OffsetX = self.x + (10*math.sin(self.rotation) +  5*i * math.sin(self.rotation))
    --   OffsetY = self.y + (10*-math.cos(self.rotation) + 5*i * -math.cos(self.rotation)) 
    --   bullet = Bullet.new(OffsetX,OffsetY,0,self.rotation, self.weaponDamage,0.1)
    --   table.insert(self.bullets, bullet)
    -- end
  elseif self.shipType == ShipType.zap then
    for p=1,0,-1 do
      local lastAngle = self.rotation
      local lastX = self.x + (10 * math.sin(lastAngle))
      local lastY = self.y + (10 * -math.cos(lastAngle))

      for segments = love.math.random(3)+3,0,-1  do
          lastAngle = lastAngle + math.rad( love.math.random(100) - 50) 


        length = love.math.random(4)+1
        for i=length,0,-1 do

          OffsetX = lastX + (5*i * math.sin(lastAngle))
          OffsetY = lastY + (5*i * -math.cos(lastAngle)) 
          bullet = Bullet.new(OffsetX,OffsetY,0,lastAngle, self.weaponDamage,1)
          table.insert(self.bullets, bullet)

          if i == 0 then
            lastX = OffsetX + length * 5 * math.sin(lastAngle) + 5 * math.sin(lastAngle) - math.sin(lastAngle)
            lastY = OffsetY + length * 5 * -math.cos(lastAngle) + 5 * -math.cos(lastAngle) + math.cos(lastAngle)
          end
        end
      end
    end
  elseif self.shipType == ShipType.charge then
    local numBullets = 7
    local angleDiff = math.pi/4/numBullets
    for i=numBullets/2,-numBullets/2,-1 do
      local rBullet = self.rotation + i * angleDiff
      leftCannonOffsetX = self.x + (5 * math.sin(self.rotation))
      leftCannonOffsetY = self.y + (5 * -math.cos(self.rotation)) 
      bullet = Bullet.new(leftCannonOffsetX,leftCannonOffsetY,5,rBullet, self.weaponDamage)
      bullet.image = love.graphics.newImage('images/bullet-blue.png')
      table.insert(self.bullets, bullet)
    end
  elseif self.shipType == ShipType.missle then
    if self.cannon == "right" then
      leftCannonOffsetX = self.x + (10 * math.sin(self.rotation)) + (8 * math.cos(self.rotation))
      leftCannonOffsetY = self.y + (10 * -math.cos(self.rotation)) + (8 * math.sin(self.rotation))
      bullet = Missle.new(leftCannonOffsetX,leftCannonOffsetY,5,self.rotation, self.weaponDamage,5)
      table.insert(self.bullets, bullet)
    elseif self.cannon == "left" then
      rightCannonOffsetX = self.x + (10 * math.sin(self.rotation)) + (-7 * math.cos(self.rotation))
      rightCannonOffsetY = self.y + (10 * -math.cos(self.rotation)) + (-7 * math.sin(self.rotation))
      bullet = Missle.new(rightCannonOffsetX,rightCannonOffsetY,5,self.rotation, self.weaponDamage,5)
      table.insert(self.bullets, bullet)
    end

    if self.cannon == "right" then
      self.cannon = "left"
    else
      self.cannon = "right"
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
    bullet.image = love.graphics.newImage('images/bullet-blue.png')
    table.insert(self.bullets, bullet)
  end
end


function Ship:drawLifeMarkers(x,y)
    for live=self.lives,1,-1 do


        local xFrame = 0
        if self.engine then
          xFrame = 1
        end

        xFrame = xFrame + self.shipType.frameOffset

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
  
    if self.shipType == ShipType.zap and self.firing then
      local top_left = love.graphics.newQuad(math.floor(self.lightningFrame)*100, 0, 100, 80, lightning:getDimensions())

      local lightningOffsetX = self.x - (3 * math.sin(self.rotation))
      local lightningOffsetY = self.y + (3 * math.cos(self.rotation))

      love.graphics.draw(lightning, top_left,self.x, self.y, self.rotation, 1,1 , 50,70)

      local vertices = {self.x, self.y-10, self.x - 50, self.y - 50, self.x + 50, self.y - 50}
 
      love.graphics.push()
      love.graphics.translate(self.x,self.y)   -- rotation center
      love.graphics.rotate(self.rotation)         -- rotate
      love.graphics.translate(-self.x,-self.y) -- move back
      love.graphics.polygon('line', vertices)
      love.graphics.pop()
    end



    xFrame = xFrame + self.shipType.frameOffset

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

  for b, beam in pairs(self.beams) do
    beam:draw()
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