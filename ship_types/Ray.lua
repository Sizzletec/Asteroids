Ray = {}
Ray.__index = Ray


function Ray.Fire(entity)
    beam = Beam.new(entity,entity.x,entity.y,0,entity.rotation, entity.weaponDamage,0.1)
    table.insert(entity.beams, beam)
end

function Ray.Update(entity,dt)
  for i, beam in pairs(entity.beams) do
    beam:update(dt)
    if beam.lifetime > beam.bulletLife then
      table.remove(entity.beams, i)
    end
  end
end


function Ray.Draw(entity)
  -- body
end

return Ray