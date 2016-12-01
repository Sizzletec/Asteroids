YieldingBulletComponent = {}

YieldingBulletComponent.__index = YieldingBulletComponent

function YieldingBulletComponent.new(entity)
  local i = {}
  setmetatable(i, YieldingBulletComponent)
  i.entity = entity
  return i
end

function YieldingBulletComponent:OnWallHit(tile,dt)
  self.entity.bulletLife = 0
end

function YieldingBulletComponent:OnPlayerHit(player)
  self.entity.bulletLife = 0
end

return YieldingBulletComponent