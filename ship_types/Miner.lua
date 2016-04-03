Miner = {}
Miner.__index = Miner

function Miner.Fire(entity)
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

function Miner.Update(entity,dt)
  -- body
end

function Miner.Draw(entity)
	-- body
end

return Miner