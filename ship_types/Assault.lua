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
    entity.shotsFired = true
end

function Assault.Update(entity,dt)
  if entity.shotsFired then
    entity.attackFrame = entity.attackFrame + 10 * dt
    if entity.attackFrame >= 5 then
      entity.attackFrame = entity.attackFrame - 5
      entity.shotsFired = false
    elseif entity.attackFrame >= 4 then
      entity.hitbox = {
        { x = -55, y = -55},
        { x = 55, y = -55},
        { x = 65, y = -65},
        { x = -65, y = -65}
      }
    elseif entity.attackFrame >= 3 then
      entity.hitbox = {
        { x = -40, y = -40},
        { x = 40, y = -40},
        { x = 55, y = -55},
        { x = -55, y = -55}
      }
    elseif entity.attackFrame >= 2 then
      entity.hitbox = {
        { x = -20, y = -20},
        { x = 20, y = -20},
        { x = 40, y = -40},
        { x = -40, y = -40}
      }
    elseif entity.attackFrame >= 1 then
      entity.hitbox = {
        { x = -10, y = -10},
        { x = 10, y = -10},
        { x = 20, y = -20},
        { x = -20, y = -20}
      }
    elseif entity.attackFrame >= 0 then
      entity.hitbox = {
        { x = 0, y = 0 },
        { x = 10, y = -10},
        { x = -10, y = -10}
      }
    end

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
            otherPlayer.health = otherPlayer.health- entity.weaponDamage
        end
      end
    end
  else
    entity.attackFrame = 0
    entity.hitbox = nil

  end
end

function Assault.Draw(entity)
  if entity.firing then
    local top_left = love.graphics.newQuad(math.floor(entity.attackFrame)*76, 0, 76, 48, shotgun:getDimensions())

    if entity.shotsFired then
      love.graphics.draw(shotgun, top_left,entity.x, entity.y, entity.rotation, 1,1 , 38,56)
    end

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

return Assault