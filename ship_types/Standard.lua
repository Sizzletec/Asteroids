Standard = {}
Standard.__index = Standard


function Standard.Fire(entity)
  
	if entity.cannon == "right" then
      leftCannonOffsetX = entity.components.move.x + (10 * math.sin(entity.components.move.rotation)) + (8 * math.cos(entity.components.move.rotation))
      leftCannonOffsetY = entity.components.move.y + (10 * -math.cos(entity.components.move.rotation)) + (8 * math.sin(entity.components.move.rotation))
      bullet = Bullet.new(leftCannonOffsetX,leftCannonOffsetY,600,entity.components.move.rotation, entity.weaponDamage)
      table.insert(entity.bullets, bullet)
    elseif entity.cannon == "left" then
      rightCannonOffsetX = entity.components.move.x + (10 * math.sin(entity.components.move.rotation)) + (-7 * math.cos(entity.components.move.rotation))
      rightCannonOffsetY = entity.components.move.y + (10 * -math.cos(entity.components.move.rotation)) + (-7 * math.sin(entity.components.move.rotation))
      bullet = Bullet.new(rightCannonOffsetX,rightCannonOffsetY,600,entity.components.move.rotation, entity.weaponDamage)
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