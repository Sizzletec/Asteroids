ExplodingBulletComponent = {}

ExplodingBulletComponent.__index = ExplodingBulletComponent

function ExplodingBulletComponent.new(entity)
  local i = {}
  setmetatable(i, ExplodingBulletComponent)
  i.entity = entity
  return i
end



function ExplodingBulletComponent:Remove(tile,dt)
  local move = self.entity.components.move
  local sw = AoE.new(self.entity.entity, move.x,move.y,10,100,0.5,self.entity.damage)
  table.insert(self.entity.entity.AoE, sw)
end

return ExplodingBulletComponent