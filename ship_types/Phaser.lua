Phaser = {}
Phaser.__index = Phaser


function Phaser.Fire(entity)
    entity.x = entity.x + (80 * math.sin(entity.rotation))
    entity.y = entity.y + (80 * -math.cos(entity.rotation))

    local distanceTraveled = 80

    local tile = TiledMap_GetMapTile(math.floor(entity.x/16),math.floor(entity.y/16),1)

    while tile > 0 do

      entity.x = entity.x + (40 * math.sin(entity.rotation))
      entity.y = entity.y + (40 * -math.cos(entity.rotation))
      distanceTraveled = distanceTraveled + 40

      Mover.StageWrap(entity)

      tile = TiledMap_GetMapTile(math.floor(entity.x/16),math.floor(entity.y/16),1)
    end

    local powX = math.pow(entity.vx, 2)
    local powY = math.pow(entity.vy, 2)
    local velocity = math.sqrt(powX + powY)

    entity.vx = velocity * math.sin(entity.rotation)
    entity.vy = velocity * -math.cos(entity.rotation)

    entity.hitbox = {
      { x = -30, y = -30 },
      { x = 30, y = -30 },
      { x = 30, y = distanceTraveled+30},
      { x = -30, y = distanceTraveled+30}
    }

    for i=1,#entity.hitbox do
        local vert = entity.hitbox[i]
        local s = math.sin(entity.rotation)
        local c = math.cos(entity.rotation)
        local x = vert.x
        local y = vert.y
        vert.x = entity.x - ( x * c + y* s )
        vert.y = entity.y - (x *s + y * -c)
    end


    -- leftCannonOffsetX = entity.x + (10 * math.sin(entity.rotation)) + (8 * math.cos(entity.rotation))
    -- leftCannonOffsetY = entity.y + (10 * -math.cos(entity.rotation)) + (8 * math.sin(entity.rotation))

    local players = Game.getPlayers()
    for p, otherPlayer in pairs(players) do
      if otherPlayer ~= entity then
        inShape = PointWithinShape(entity.hitbox,otherPlayer.x,otherPlayer.y)

        if inShape then
            otherPlayer.health = otherPlayer.health- entity.weaponDamage
        end
      end
  end





end

function Phaser.Update(entity,dt)
  -- body
end


function Phaser.Draw(entity)
  -- body

      if entity.hitbox then
        love.graphics.push()
        local hitbox = {}
        for i=1,#entity.hitbox do
            local vert = entity.hitbox[i]
            table.insert(hitbox,vert.x)
            table.insert(hitbox,vert.y)
        end
        love.graphics.polygon('line', hitbox)
        love.graphics.pop()
    end
end

return Phaser