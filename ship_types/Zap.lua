Zap = {}
Zap.__index = Zap

local lightning = love.graphics.newImage('images/lightnings.png')

function Zap.Fire(entity)
    -- for p=1,0,-1 do
    --   local lastAngle = entity.rotation
    --   local lastX = entity.x + (10 * math.sin(lastAngle))
    --   local lastY = entity.y + (10 * -math.cos(lastAngle))

    --   for segments = love.math.random(3)+3,0,-1  do
    --       lastAngle = lastAngle + math.rad( love.math.random(100) - 50)


    --     length = love.math.random(4)+1
    --     for i=length,0,-1 do

    --       OffsetX = lastX + (5*i * math.sin(lastAngle))
    --       OffsetY = lastY + (5*i * -math.cos(lastAngle))
    --       bullet = Bullet.new(OffsetX,OffsetY,0,lastAngle, entity.weaponDamage,1)
    --       table.insert(entity.bullets, bullet)

    --       if i == 0 then
    --         lastX = OffsetX + length * 5 * math.sin(lastAngle) + 5 * math.sin(lastAngle) - math.sin(lastAngle)
    --         lastY = OffsetY + length * 5 * -math.cos(lastAngle) + 5 * -math.cos(lastAngle) + math.cos(lastAngle)
    --       end
    --     end
    --   end
    -- end
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


    -- leftCannonOffsetX = entity.x + (10 * math.sin(entity.rotation)) + (8 * math.cos(entity.rotation))
    -- leftCannonOffsetY = entity.y + (10 * -math.cos(entity.rotation)) + (8 * math.sin(entity.rotation))

    local players = Game.getPlayers()
    for p, otherPlayer in pairs(players) do
      if otherPlayer ~= entity then
        inShape = PointWithinShape(entity.hitbox,otherPlayer.x,otherPlayer.y)

        if inShape then
            otherPlayer.health = otherPlayer.health- entity.weaponDamage
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
        -- love.graphics.translate(entity.x,entity.y)   -- rotation center
        -- love.graphics.rotate(entity.rotation)         -- rotate
        -- love.graphics.translate(-entity.x,-entity.y) -- move back

        local hitbox = {}
        for i=1,#entity.hitbox do
            local vert = entity.hitbox[i]
            table.insert(hitbox,vert.x)
            table.insert(hitbox,vert.y)
        end

      --  love.graphics.polygon('line', hitbox)
        love.graphics.pop()
    end
  end
end

return Zap