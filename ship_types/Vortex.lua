Vortex = {}
Vortex.__index = Vortex


function Vortex.Fire(entity)
    leftCannonOffsetX = entity.x 
    leftCannonOffsetY = entity.y

    for i=1,8 do
        bullet = Bullet.new(leftCannonOffsetX,leftCannonOffsetY,0,entity.rotation + math.pi/4 * i, entity.weaponDamage)
        table.insert(entity.bullets, bullet)
    end
end

function Vortex.Update(entity,dt)
  for b, bullet in pairs(entity.bullets) do

    bullet.rotation = bullet.rotation + 2 * math.pi * dt

    local powX = math.pow(bullet.vx, 2)
    local powY = math.pow(bullet.vy, 2)
    local velocity = math.sqrt(powX + powY)
    velocity = velocity + 700 * dt

    bullet.vx = velocity * math.sin(bullet.rotation)
    bullet.vy = velocity * -math.cos(bullet.rotation)

  end
  -- body
end


function Vortex.Draw(entity)
  -- body
end

return Vortex