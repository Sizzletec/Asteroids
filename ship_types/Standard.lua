Standard = {}
Standard.__index = Standard


function Standard.Fire(entity)
	if entity.cannon == "right" then
      leftCannonOffsetX = entity.x + (10 * math.sin(entity.rotation)) + (8 * math.cos(entity.rotation))
      leftCannonOffsetY = entity.y + (10 * -math.cos(entity.rotation)) + (8 * math.sin(entity.rotation))
      bullet = Bullet.new(leftCannonOffsetX,leftCannonOffsetY,600,entity.rotation, entity.weaponDamage)
      table.insert(entity.bullets, bullet)
    elseif entity.cannon == "left" then
      rightCannonOffsetX = entity.x + (10 * math.sin(entity.rotation)) + (-7 * math.cos(entity.rotation))
      rightCannonOffsetY = entity.y + (10 * -math.cos(entity.rotation)) + (-7 * math.sin(entity.rotation))
      bullet = Bullet.new(rightCannonOffsetX,rightCannonOffsetY,600,entity.rotation, entity.weaponDamage)
      table.insert(entity.bullets, bullet)
    end

    if entity.cannon == "right" then
      entity.cannon = "left"
    else
      entity.cannon = "right"
    end
end

function Standard.Update(entity,dt)
  -- body
end


function Standard.Draw(entity)
  -- body
end

return Standard