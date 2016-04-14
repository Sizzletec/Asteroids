Missile = {}
Missile.__index = Missile


function Missile.Fire(entity)
    if entity.cannon == "right" then
      leftCannonOffsetX = entity.x + (10 * math.sin(entity.rotation)) + (8 * math.cos(entity.rotation))
      leftCannonOffsetY = entity.y + (10 * -math.cos(entity.rotation)) + (8 * math.sin(entity.rotation))
      bullet = MissileShot.new(entity,leftCannonOffsetX,leftCannonOffsetY,200,entity.rotation, entity.weaponDamage,5)
      table.insert(entity.bullets, bullet)
    elseif entity.cannon == "left" then
      rightCannonOffsetX = entity.x + (10 * math.sin(entity.rotation)) + (-7 * math.cos(entity.rotation))
      rightCannonOffsetY = entity.y + (10 * -math.cos(entity.rotation)) + (-7 * math.sin(entity.rotation))
      bullet = MissileShot.new(entity,rightCannonOffsetX,rightCannonOffsetY,200,entity.rotation, entity.weaponDamage,5)
      table.insert(entity.bullets, bullet)
    end

    if entity.cannon == "right" then
      entity.cannon = "left"
    else
      entity.cannon = "right"
    end
end

function Missile.Update(entity,dt)
  -- body
end

function Missile.Draw(entity)
  -- body
end

return Missile