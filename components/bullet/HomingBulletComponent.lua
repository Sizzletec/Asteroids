HomingBulletComponent = {}

HomingBulletComponent.__index = HomingBulletComponent

function HomingBulletComponent.new(entity)
  local i = {}
  setmetatable(i, HomingBulletComponent)
  i.entity = entity
  return i
end


function HomingBulletComponent:update(dt)
  players = Game.getPlayers()
  local playerDist = 1920

  local move = self.entity.components.move
  for p, otherPlayer in pairs(players) do
    if otherPlayer ~= self.entity.entity and otherPlayer.components.life.alive then
      
      local otherMove = otherPlayer.components.move

      xPow = math.pow(move.x - otherMove.x, 2)
      yPow = math.pow(move.y - otherMove.y, 2)

      dist = math.sqrt(xPow + yPow)

      if moveToPoint then
        if playerDist > dist then
          moveToPoint = {x = otherMove.x, y = otherMove.y}
          playerDist = dist
        end
      else
        moveToPoint = {x = otherMove.x, y = otherMove.y}
        playerDist = dist
      end
    end
  end

  if moveToPoint then
    move:MoveTowards(0,0,dt)
  end
end

return HomingBulletComponent