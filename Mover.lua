Mover = {}
Mover.__index = Mover

function Mover.ApplyVelocity(entity, dt)
  entity.x = entity.x + entity.vx * dt
  entity.y = entity.y + entity.vy * dt
end

function Mover.StageWrap(entity)
  if entity.y > 960 then
    entity.y = entity.y - 960
  end

  if entity.y < 0 then
    entity.y = entity.y + 960
  end

  if entity.x > 1920 then
    entity.x = entity.x - 1920
  end

  if entity.x < 0 then
    entity.x = entity.x + 1920
  end
end

return Mover