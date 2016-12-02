SapperBulletComponent = {}

SapperBulletComponent.__index = SapperBulletComponent

function SapperBulletComponent.new(entity)
  local i = {}
  setmetatable(i, SapperBulletComponent)
  i.entity = entity
  return i
end

function SapperBulletComponent:OnPlayerHit(player)
  status = player.components.status
  if status then
    status:ApplyDot(self.entity.entity,1,5)
  end
end

return SapperBulletComponent