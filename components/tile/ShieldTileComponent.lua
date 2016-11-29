ShieldTileComponent = {}

ShieldTileComponent.__index = ShieldTileComponent

function ShieldTileComponent.new(entity,direction)
  local i = {}
  setmetatable(i, ShieldTileComponent)
  i.entity = entity
  i.direction = direction
  return i
end

function ShieldTileComponent:getCollisonMask()
  cm = bit.bor(Collision.bullet)
  return cm
end

function ShieldTileComponent:update(dt)
  -- players = Game.getPlayers()
  -- for _, player in pairs(players) do
  --   for _, bullet in pairs(player.bullets) do

  --     local ts = self.entity.tileset
  --     if ts then
  --       cx = self.entity.x + ts.tileSize/2
  --       cy = self.entity.y + ts.tileSize/2

  --       local move = bullet.components.move
  --       local powX = math.pow(cx - move.x, 2)
  --       local powY = math.pow(cy - move.y, 2)
  --       local dist = math.sqrt(powX + powY)

  --       if dist < 30 and self.id ~= 0 then
  --           c1 = 0
  --           c2 = move.vx
  --           if self.direction == "right" then
  --             c1 = move.vx
  --             c2 = 0
  --           elseif self.direction == "up" then
  --             c1 = 0
  --             c2 = move.vy
  --           elseif self.direction == "down" then
  --             c1 = move.vy
  --             c2 = 0
  --           end

  --           if c1 < c2 then
  --             if bullet.bounce then
  --               xAngle = self.entity.x - move.x
  --               yAngle = self.entity.y - move.y
  --               if math.abs(yAngle) < math.abs(xAngle) then
  --                 move.vx = -move.vx
  --                 move.x = move.x + move.vx * dt
  --               else
  --                 move.vy = -move.vy
  --                 move.y = move.y + move.vy * dt
  --               end
  --             else
  --               bullet:Remove()
  --             end
  --         end
  --       end
  --     end
  --   end
  -- end
end

function ShieldTileComponent:draw()
end

return ShieldTileComponent