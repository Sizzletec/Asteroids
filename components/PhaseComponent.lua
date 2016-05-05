PhaseComponent = {
  cannon = "right",
  gunCooldown = 0,
  weaponDamage = 100,
  fireRate = 1,
  firing = false
}

PhaseComponent.__index = PhaseComponent

function PhaseComponent.new(entity)
  local i = {}
  setmetatable(i, PhaseComponent)
  i.entity = entity
  return i
end

function PhaseComponent:update(dt)
  if self.firing and self.gunCooldown <= 0 then
    self:fire()
    self.gunCooldown = 1/self.fireRate
  elseif self.gunCooldown > 0 then
    self.gunCooldown = self.gunCooldown - dt
  end
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
  end
end

return PhaseComponent