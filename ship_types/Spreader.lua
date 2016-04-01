Spreader = {}
Spreader.__index = Spreader

function Spreader.Fire(entity)
  local numBullets = 4
  local angleDiff = math.pi/8/numBullets
  for i=numBullets/2,-numBullets/2,-1 do
    local rBullet = entity.rotation + i * angleDiff
    leftCannonOffsetX = entity.x + (5 * math.sin(entity.rotation))
    leftCannonOffsetY = entity.y + (5 * -math.cos(entity.rotation))
    bullet = Bullet.new(leftCannonOffsetX,leftCannonOffsetY,600,rBullet, entity.weaponDamage)
    table.insert(entity.bullets, bullet)
  end
end

function Spreader.Update(entity,dt)
	-- body
end

function Spreader.Draw(entity)
  -- body
end

return Spreader