ShieldComponent = {}

ShieldComponent.__index = ShieldComponent

function ShieldComponent.new(entity)
  local i = {}
  setmetatable(i, ShieldComponent)
  i.entity = entity
  return i
end

function ShieldComponent:OnBulletHit(bullet)
  bullet.bulletLife = 0
end

return ShieldComponent