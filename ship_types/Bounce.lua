Bounce = {}
Bounce.__index = Bounce


function Bounce.Fire(entity)
    leftCannonOffsetX = entity.x + (10 * math.sin(entity.rotation)) 
    leftCannonOffsetY = entity.y + (10 * -math.cos(entity.rotation))
    bullet = Bullet.new(leftCannonOffsetX,leftCannonOffsetY,700,entity.rotation, entity.weaponDamage,2)
    bullet.bounce = true
    table.insert(entity.bullets, bullet)
end

function Bounce.Update(entity,dt)
  -- body
end


function Bounce.Draw(entity)
  -- body
end

return Bounce