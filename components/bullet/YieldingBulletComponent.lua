YieldingBulletComponent = {}

YieldingBulletComponent.__index = YieldingBulletComponent

function YieldingBulletComponent.new(entity)
  local i = {}
  setmetatable(i, YieldingBulletComponent)
  i.entity = entity
  return i
end

function YieldingBulletComponent:OnWallHit(tile,dt)
  self.entity:Remove()
end

function YieldingBulletComponent:OnPlayerHit(player)
  self.entity:Remove()
end
return YieldingBulletComponent