Charge = {}
Charge.__index = Charge


function Charge.Fire(entity)
  if entity.charging then
    if entity.chargeAmount < 10 then
      entity.chargeAmount = entity.chargeAmount + 1
    end
  else
    entity.charging = true
    entity.chargeAmount = 1
  end
end

function Charge.Update(entity,dt)
  if not entity.firing and entity.charging then
    local numBullets = math.floor(entity.chargeAmount)
    local angleDiff = math.pi/4/numBullets
    for i=numBullets/2,-numBullets/2,-1 do
      local rBullet = entity.rotation + i * angleDiff
      leftCannonOffsetX = entity.x + (5 * math.sin(entity.rotation))
      leftCannonOffsetY = entity.y + (5 * -math.cos(entity.rotation))
      bullet = Bullet.new(leftCannonOffsetX,leftCannonOffsetY,300,rBullet, entity.weaponDamage)
      table.insert(entity.bullets, bullet)
    end
    entity.charging=false
  end



	-- body
end

function Charge.Draw(entity)
  -- body

  if entity.charging then

    love.graphics.circle("line", entity.x + (15 * math.sin(entity.rotation)), entity.y - (15 * math.cos(entity.rotation)), entity.chargeAmount, 30)
  end
end

return Charge