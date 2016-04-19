Ray = {}
Ray.__index = Ray

require('weapons/Beam')

function Ray.Fire(entity)
    
end

function Ray.Update(entity,dt)
	if entity.firing then
		if not entity.beam then
			entity.beam = Beam.new(entity,entity.x,entity.y,0,entity.rotation, entity.weaponDamage,0.1)
		end
		entity.beam:update(dt)
  	else
  		entity.beam = nil
	end
end


function Ray.Draw(entity)
  if entity.beam then
  	-- entity.beam:Draw()
  end
end

return Ray