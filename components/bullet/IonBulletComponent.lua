IonBulletComponent = {}

IonBulletComponent.__index = IonBulletComponent

function IonBulletComponent.new(entity)
  local i = {}
  setmetatable(i, IonBulletComponent)
  i.entity = entity
  return i
end

function IonBulletComponent:OnPlayerHit(player)
  status = player.components.status
  if status then
    status:Disable(1)
  end
end

return IonBulletComponent