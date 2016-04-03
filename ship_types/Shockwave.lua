Shockwave = {}
Shockwave.__index = Shockwave


function Shockwave.Fire(entity)
    local radius = 100
    entity.circleHitbox = { x = entity.x, y = entity.y, radius = radius }

    local players = Game.getPlayers()
    for p, otherPlayer in pairs(players) do
      if otherPlayer ~= entity then
        local xPow = math.pow(otherPlayer.x - entity.x, 2)
        local yPow = math.pow(otherPlayer.y - entity.y, 2)
        local dist = math.sqrt(xPow + yPow)

        if dist <= radius then
            otherPlayer.health = otherPlayer.health- entity.weaponDamage
        end
      end
  end
end

function Shockwave.Update(entity,dt)
  -- body
end


function Shockwave.Draw(entity)
  -- body

      if entity.circleHitbox then
        love.graphics.circle("line", entity.circleHitbox.x, entity.circleHitbox.y, entity.circleHitbox.radius)
    end
end

return Shockwave