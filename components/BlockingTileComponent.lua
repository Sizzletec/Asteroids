BlockingTileComponent = {}

BlockingTileComponent.__index = BlockingTileComponent

function BlockingTileComponent.new(entity)
  local i = {}
  setmetatable(i, BlockingTileComponent)
  i.entity = entity
  i.wall = false
  return i
end

function BlockingTileComponent:update(dt)
  players = Game.getPlayers()
  for _, player in pairs(players) do
    for _, bullet in pairs(player.bullets) do

      local ts = self.entity.tileset
      if ts then
        cx = self.entity.x + ts.tileSize/2
        cy = self.entity.y + ts.tileSize/2

        local move = bullet.components.move



        local powX = math.pow(cx - move.x, 2)
        local powY = math.pow(cy - move.y, 2)
        local dist = math.sqrt(powX + powY)

        if dist < 30 and self.id ~= 0 then
          self.wall = true


            if bullet.bounce then
              xAngle = self.entity.x - move.x
              yAngle = self.entity.y - move.y
              if math.abs(yAngle) < math.abs(xAngle) then
                move.vx = -move.vx
                move.x = move.x + move.vx * dt
              else
                move.vy = -move.vy
                move.y = move.y + move.vy * dt
              end
            else
              bullet.bulletLife = 0
            end
        end
      end
    end
  end
end

function BlockingTileComponent:draw()
  if self.wall then
    ts = self.entity.tileset.tileSize
    love.graphics.rectangle("fill", self.entity.x-2, self.entity.y-2, ts+4, ts+4)
    self.wall = false
    self.entity.id = 0
    self.entity.components = {}
  end
end

return BlockingTileComponent