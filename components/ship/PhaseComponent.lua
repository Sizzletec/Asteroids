local part1 = love.graphics.newImage('images/part.png')

PhaseComponent = {}

PhaseComponent.__index = PhaseComponent

function PhaseComponent.new(entity)
  local i = {
    cannon = "right",
    gunCooldown = 0,
    weaponDamage = 20,
    fireRate = 1,
    firing = false
  }

  setmetatable(i, PhaseComponent)
  i.entity = entity
  i.partSys = love.graphics.newParticleSystem(part1, 1000)
  return i
end

function PhaseComponent:update(dt)
  if self.firing and self.gunCooldown <= 0 then
    self:fire()
    self.gunCooldown = 1/self.fireRate
  elseif self.gunCooldown > 0 then
    self.gunCooldown = self.gunCooldown - dt
  end


-- Fade to transparency.
  self.partSys:update(dt)
end

function PhaseComponent:fire()
  if self.entity.components.life.health <= 0 then
    return
  end
  local move = self.entity.components.move
  self.entity.components.score.shots = self.entity.components.score.shots + 1

    move.x = move.x + (80 * math.sin(move.rotation))
    move.y = move.y + (80 * -math.cos(move.rotation))

    local distanceTraveled = 80

    local tile = TiledMap_GetMapTile(math.floor(move.x/16),math.floor(move.y/16),1)

    while tile > 0 do

      move.x = move.x + (40 * math.sin(move.rotation))
      move.y = move.y + (40 * -math.cos(move.rotation))
      distanceTraveled = distanceTraveled + 40

      move:StageWrap()

      tile = TiledMap_GetMapTile(math.floor(move.x/16),math.floor(move.y/16),1)
    end

    local powX = math.pow(move.vx, 2)
    local powY = math.pow(move.vy, 2)
    local velocity = math.sqrt(powX + powY)

    move.vx = velocity * math.sin(move.rotation)
    move.vy = velocity * -math.cos(move.rotation)







    self.hitbox = {
      { x = -30, y = -30 },
      { x = 30, y = -30 },
      { x = 30, y = distanceTraveled+30},
      { x = -30, y = distanceTraveled+30}
    }

    for i=1,#self.hitbox do
        local vert = self.hitbox[i]
        local s = math.sin(move.rotation)
        local c = math.cos(move.rotation)
        local x = vert.x
        local y = vert.y
        vert.x = move.x - ( x * c + y* s )
        vert.y = move.y - (x *s + y * -c)
    end

    local players = Game.getPlayers()
    for p, otherPlayer in pairs(players) do
      if otherPlayer ~= self.entity then
        local otherMove = otherPlayer.components.move
        inShape = PointWithinShape(self.hitbox,otherMove.x,otherMove.y)

        if inShape then
            otherPlayer.components.life:takeDamage(self.entity, self.weaponDamage)
        end
      end
  end


  self.partSys:setParticleLifetime(.2, .3) -- Particles live at least 2s and at most 5s.
  -- self.partSys:setEmissionRate(500)
  self.partSys:setSizeVariation(1)

  -- self.partSys:setPosition(self.startPointX,self.startPointY)
  -- self.partSys:setSpeed(speed)
  self.partSys:setDirection(move.rotation -math.pi/2)

  -- self.partSys:setEmissionRate(500)
  -- self.partSys:setRelativeRotation(true)


    -- if self.offset ~=  -dist/2 then
    --    self.partSys:reset()
       -- self.offset = -dist/2
    -- end

  -- self.partSys:setOffset(self.offset, 0)

  self.partSys:setAreaSpread("uniform", 30/2,(distanceTraveled+30)/2)

  self.partSys:setLinearAcceleration(1000, 0, -1000, 2000) -- Random movement in all directions.
  self.partSys:setColors(255, 0, 255,255, 255,0,255, 0) -- Fade to transparency.

  self.partSys:emit(1000)
end

function PhaseComponent:draw()
  local move = self.entity.components.move
  if self.hitbox then
    love.graphics.push()
    local hitbox = {}
    for i=1,#self.hitbox do
        local vert = self.hitbox[i]
        table.insert(hitbox,vert.x)
        table.insert(hitbox,vert.y)
    end
    love.graphics.polygon('line', hitbox)
    love.graphics.pop()


    local xMid = (self.hitbox[1].x + self.hitbox[2].x)/2
    local yMid = (self.hitbox[3].y + self.hitbox[4].y)/2
    local offset = (self.hitbox[1].y - self.hitbox[3].y + 30)/2
    local offsetX = xMid + offset * math.sin(move.rotation)
    local offsetY = yMid + offset * math.cos(move.rotation)

    love.graphics.draw(self.partSys,offsetX,offsetY,move.rotation)
  end


end

return PhaseComponent