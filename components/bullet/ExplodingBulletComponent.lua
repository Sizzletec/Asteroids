ExplodingBulletComponent = {}

ExplodingBulletComponent.__index = ExplodingBulletComponent

function ExplodingBulletComponent.new(entity,damage)
  local i = {}
  setmetatable(i, ExplodingBulletComponent)
  i.entity = entity

  i.damage = damage
  return i
end

function ExplodingBulletComponent:Remove(tile,dt)
  local move = self.entity.components.move
  local sw = AoE.new(self.entity.entity, move.x,move.y,10,50,0.5,self.damage)
  table.insert(Game.getObjects(), sw)
end

return ExplodingBulletComponent