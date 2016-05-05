local lightning = love.graphics.newImage('images/lightnings.png')

ZapComponent = {
  weaponDamage = 3,
  firing = false,
  attackFrame = 0
}

ZapComponent.__index = ZapComponent

function ZapComponent.new(entity)
  local i = {}
  setmetatable(i, ZapComponent)
  i.entity = entity
  return i
end

function ZapComponent:update(dt)
  -- if self.firing and self.gunCooldown <= 0 then
  --   self:fire()
  --   self.gunCooldown = 1/self.fireRate
  -- elseif self.gunCooldown > 0 then
  --   self.gunCooldown = self.gunCooldown - dt
  -- end

  local move = self.entity.components.move


  if self.entity.components.life.health <= 0 then
    return
  end

  if self.firing then
    self.attackFrame = self.attackFrame + 8 * dt
    if self.attackFrame >= 4 then
      self.attackFrame = self.attackFrame - 4
    end

    self.hitbox = {
      { x = 0, y = 0 },
      { x = 65, y = -65},
      { x = -65, y = -65}
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
  else
    self.hitbox = nil
  end
end

function ZapComponent:fire()
end

function ZapComponent:draw()
  if self.firing then
    local move = self.entity.components.move
    local top_left = love.graphics.newQuad(math.floor(self.attackFrame)*100, 0, 100, 80, lightning:getDimensions())

    love.graphics.draw(lightning, top_left,move.x, move.y, move.rotation, 1,1 , 50,70)

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
end

return ZapComponent