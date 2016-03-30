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
  end
end

function Zap.Draw(entity)
  if entity.firing then
    local top_left = love.graphics.newQuad(math.floor(entity.attackFrame)*100, 0, 100, 80, lightning:getDimensions())

    local lightningOffsetX = entity.x - (3 * math.sin(entity.rotation))
    local lightningOffsetY = entity.y + (3 * math.cos(entity.rotation))

    love.graphics.draw(lightning, top_left,entity.x, entity.y, entity.rotation, 1,1 , 50,70)

    -- local vertices = {
    --   entity.x, entity.y-10,
    --   entity.x - 50, entity.y - 50,
    --   entity.x + 50, entity.y - 50
    -- }

    -- if entity.attackFrame >= 3 then
    --   vertices = {
    --     entity.x, entity.y-10,
    --     entity.x - 100, entity.y - 100,
    --     entity.x + 100, entity.y - 100
    --   }

    -- end

    -- love.graphics.push()
    -- love.graphics.translate(entity.x,entity.y)   -- rotation center
    -- love.graphics.rotate(entity.rotation)         -- rotate
    -- love.graphics.translate(-entity.x,-entity.y) -- move back
    -- love.graphics.polygon('line', vertices)
    -- love.graphics.pop()
  end
end

return Zap