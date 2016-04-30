Zap = {}
Zap.__index = Zap

local lightning = love.graphics.newImage('images/lightnings.png')

function Zap.Fire(entity)
end

function Zap.Update(entity,dt)
  if entity.firing then
    entity.attackFrame = entity.attackFrame + 8 * dt
    if entity.attackFrame >= 4 then
      entity.attackFrame = entity.attackFrame - 4
    end

    entity.hitbox = {
      { x = 0, y = 0 },
      { x = 65, y = -65},
      { x = -65, y = -65}
    }

    for i=1,#entity.hitbox do
        local vert = entity.hitbox[i]
        local s = math.sin(entity.rotation)
        local c = math.cos(entity.rotation)
        local x = vert.x
        local y = vert.y
        vert.x = entity.x - ( x * c + y* s )
        vert.y = entity.y - (x *s + y * -c)
    end

    local players = Game.getPlayers()
    for p, otherPlayer in pairs(players) do
      if otherPlayer ~= entity then
        inShape = PointWithinShape(entity.hitbox,otherPlayer.x,otherPlayer.y)

        if inShape then
            otherPlayer.components.life:takeDamage(entity, entity.weaponDamage)
        end
      end
    end
  else
    entity.hitbox = nil
  end
end

function Zap.Draw(entity)
  if entity.firing then
    local top_left = love.graphics.newQuad(math.floor(entity.attackFrame)*100, 0, 100, 80, lightning:getDimensions())

    local lightningOffsetX = entity.x - (3 * math.sin(entity.rotation))
    local lightningOffsetY = entity.y + (3 * math.cos(entity.rotation))

    love.graphics.draw(lightning, top_left,entity.x, entity.y, entity.rotation, 1,1 , 50,70)

    if entity.hitbox then
        love.graphics.push()
        local hitbox = {}
        for i=1,#entity.hitbox do
            local vert = entity.hitbox[i]
            table.insert(hitbox,vert.x)
            table.insert(hitbox,vert.y)
        end
        love.graphics.polygon('line', hitbox)
        love.graphics.pop()
    end
  end
end

return Zap