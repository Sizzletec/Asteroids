BouncingBulletComponent = {}

BouncingBulletComponent.__index = BouncingBulletComponent

function BouncingBulletComponent.new(entity)
  local i = {}
  setmetatable(i, BouncingBulletComponent)
  i.entity = entity
  return i
end


function HomingBulletComponent(dt)
    self.lifetime = self.lifetime + dt
  Mover.ApplyAcceleration(self, dt)
  Mover.ApplyVelocity(self, dt)

  players = Game.getPlayers()
  local playerDist = 1920

  for p, otherPlayer in pairs(players) do
    if otherPlayer ~= self.player and otherPlayer.components.life.alive then
      local otherMove = otherPlayer.components.move

      xPow = math.pow(self.x - otherMove.x, 2)
      yPow = math.pow(self.y - otherMove.y, 2)

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

            -- if dist < 20 then
            --   player.health = player.health - self.damage

            --   if player.health < 0 then
            --     player.health = 0
            --   end
            --   table.remove(self.player.bullets, b)
            -- end
    end
  end

  if moveToPoint then
    Mover.MoveTowards(self,moveToPoint.x-self.x,moveToPoint.y-self.y,dt)
  end

  Mover.ApplyRotation(self,dt)

  self.vx = self.topSpeed * math.sin(self.rotation)
  self.vy = self.topSpeed * -math.cos(self.rotation)


  Mover.StageWrap(self)
  tilesetBatch:add(self.x, self.y, self.rotation, 1,1 , 3,3)
end


return BouncingBulletComponent