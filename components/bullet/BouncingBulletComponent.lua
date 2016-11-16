BouncingBulletComponent = {}

BouncingBulletComponent.__index = BouncingBulletComponent

function BouncingBulletComponent.new(entity)
  local i = {}
  setmetatable(i, BouncingBulletComponent)
  i.entity = entity
  return i
end

function BouncingBulletComponent:OnWallHit(tile,dt)
  -- local move = self.entity.components.move
  -- local sw = AoE.new(self.entity, move.x,move.y,10,30,0.5,self.damage)
  -- table.insert(self.entity.entity.AoE, sw)
  -- self.bulletLife = 0



  local move = self.entity.components.move


    xAngle = tile.x - move.x
    yAngle = tile.y - move.y
    if math.abs(yAngle) < math.abs(xAngle) then
      move.vx = -move.vx
      move.x = move.x + move.vx * dt
    else
      move.vy = -move.vy
      move.y = move.y + move.vy * dt
    end
end

return BouncingBulletComponent