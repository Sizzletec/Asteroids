Gunship = {}
Gunship.__index = Gunship

function Gunship.Fire(entity)
    leftCannonOffsetX = entity.x - (3 * math.sin(entity.rotation))
    leftCannonOffsetY = entity.y + (3 * math.cos(entity.rotation))
    bullet = Bullet.new(leftCannonOffsetX,leftCannonOffsetY,900,entity.cannonRotation, entity.weaponDamage)
    table.insert(entity.bullets, bullet)
    entity.firing = false
end

function Gunship.Update(entity,dt)
end

function Gunship.Draw(entity)
    local cannonQuad = love.graphics.newQuad(0, 160, 20, 20, ShipsImage:getDimensions())
    love.graphics.draw(ShipsImage,cannonQuad,entity.x - (3 * math.sin(entity.rotation)), entity.y + (3 * math.cos(entity.rotation)), entity.cannonRotation, 1,1 , 10, 10)
end

return Gunship