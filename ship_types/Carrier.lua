Carrier = {}
Carrier.__index = Carrier


function Carrier.Fire(entity)
    local numBullets = 100
    local angleDiff = math.pi*2/numBullets
    for i=numBullets/2,-numBullets/2,-1 do
      local rBullet = entity.rotation + i * angleDiff
      leftCannonOffsetX = entity.x + (5 * math.sin(entity.rotation))
      leftCannonOffsetY = entity.y + (5 * -math.cos(entity.rotation))
      bullet = Bullet.new(leftCannonOffsetX,leftCannonOffsetY,10,rBullet, entity.weaponDamage)
      table.insert(entity.bullets, bullet)
    end
end

function Carrier.Update(entity,dt)
  -- body
end

function Carrier.Draw(entity)
	-- body
end

return Carrier