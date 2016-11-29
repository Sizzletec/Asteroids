Collision = {
  ship    = bit.lshift(1, 0),
  aoe     = bit.lshift(1, 1),
  bullet  = bit.lshift(1, 2),
  beam    = bit.lshift(1, 3),
  tile    = bit.lshift(1, 4),
  enemy   = bit.lshift(1, 5)
}
Collision.__index = Collision


function Collision.TestCollison(object1, object2)
	c1 = object1:getCollisonObject()
	c2 = object2:getCollisonObject()

	xPow = math.pow(c1.x - c2.x, 2)
    yPow = math.pow(c1.y - c2.y, 2)
    dist = math.sqrt(xPow + yPow)

    hitDist = 0

    if c1.r then
    	hitDist = c1.r
    end

    if c2.r then
    	hitDist = hitDist + c2.r
    end

    if dist <= hitDist then
    	Collision.doCollison(object1, object2)
    	Collision.doCollison(object2, object1)
    end
end

function Collision.doCollison(obj1, obj2)
	if obj1.getObjectMask() == Collision.ship then
		obj2:OnPlayerHit(obj1)
	elseif obj1.getObjectMask() == Collision.bullet then
		obj2:OnBulletHit(obj1)
	elseif obj1.getObjectMask() == Collision.aoe then
		obj2:OnAoEHit(obj1)
	elseif obj1.getObjectMask() == Collision.beam then
		obj2:OnBeamHit(obj1)
	elseif obj1.getObjectMask() == Collision.tile then
		obj2:OnWallHit(obj1)
	end
end

return Collision