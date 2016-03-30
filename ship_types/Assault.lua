Assault = {}
Assault.__index = Assault

local shotgun = love.graphics.newImage('images/ShotGun.png')

function Assault.Fire(entity)
    -- local numBullets = 7
    -- local angleDiff = math.pi/4/numBullets
    -- for i=numBullets/2,-numBullets/2,-1 do
    --   local rBullet = entity.rotation + i * angleDiff
    --   leftCannonOffsetX = entity.x + (5 * math.sin(entity.rotation))
    --   leftCannonOffsetY = entity.y + (5 * -math.cos(entity.rotation))
    --   bullet = Bullet.new(leftCannonOffsetX,leftCannonOffsetY,300,rBullet, entity.weaponDamage)
    --   table.insert(entity.bullets, bullet)
    -- end
end

function Assault.Update(entity,dt)
  if entity.firing then
    entity.attackFrame = entity.attackFrame + 10 * dt
    if entity.attackFrame >= 5 then
      entity.attackFrame = entity.attackFrame - 5
    end
  else
      entity.attackFrame = 0
  end
end

function Assault.Draw(entity)
  if entity.firing then
    local top_left = love.graphics.newQuad(math.floor(entity.attackFrame)*76, 0, 76, 48, shotgun:getDimensions())

    local lightningOffsetX = entity.x - (3 * math.sin(entity.rotation))
    local lightningOffsetY = entity.y + (3 * math.cos(entity.rotation))

    love.graphics.draw(shotgun, top_left,entity.x, entity.y, entity.rotation, 1,1 , 38,56)

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

return Assault