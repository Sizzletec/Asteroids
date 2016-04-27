function PointWithinShape(shape, tx, ty)
	if #shape == 0 then
		return false
	elseif #shape == 1 then
		return shape[1].x == tx and shape[1].y == ty
	elseif #shape == 2 then
		return PointWithinLine(shape, tx, ty)
	else
		return CrossingsMultiplyTest(shape, tx, ty)
	end
end

function BoundingBox(box, tx, ty)
	return	(box[2].x >= tx and box[2].y >= ty)
		and (box[1].x <= tx and box[1].y <= ty)
		or  (box[1].x >= tx and box[2].y >= ty)
		and (box[2].x <= tx and box[1].y <= ty)
end

function colinear(line, x, y, e)
	e = e or 0.1
	m = (line[2].y - line[1].y) / (line[2].x - line[1].x)
	local function f(x) return line[1].y + m*(x - line[1].x) end
	return math.abs(y - f(x)) <= e
end

function PointWithinLine(line, tx, ty, e)
	e = e or 0.66
	if BoundingBox(line, tx, ty) then
		return colinear(line, tx, ty, e)
	else
		return false
	end
end


function CrossingsMultiplyTest(pgon, tx, ty)
	local i, yflag0, yflag1, inside_flag
	local vtx0, vtx1

	local numverts = #pgon

	vtx0 = pgon[numverts]
	vtx1 = pgon[1]

	yflag0 = ( vtx0.y >= ty )
	inside_flag = false

	for i=2,numverts+1 do
		yflag1 = ( vtx1.y >= ty )

		if ( yflag0 ~= yflag1 ) then
			if ( ((vtx1.y - ty) * (vtx0.x - vtx1.x) >= (vtx1.x - tx) * (vtx0.y - vtx1.y)) == yflag1 ) then
				inside_flag =  not inside_flag
			end
		end
		yflag0  = yflag1
		vtx0    = vtx1
		vtx1    = pgon[i]
	end

	return  inside_flag
end

function GetIntersect( points )
	local g1 = points[1].x
	local h1 = points[1].y
	local g2 = points[2].x
	local h2 = points[2].y
	local i1 = points[3].x
	local j1 = points[3].y
	local i2 = points[4].x
	local j2 = points[4].y
	local xk = 0
	local yk = 0

	if checkIntersect({x=g1, y=h1}, {x=g2, y=h2}, {x=i1, y=j1}, {x=i2, y=j2}) then
		local a = h2-h1
		local b = (g2-g1)
		local v = ((h2-h1)*g1) - ((g2-g1)*h1)

		local d = i2-i1
		local c = (j2-j1)
		local w = ((j2-j1)*i1) - ((i2-i1)*j1)

		xk = (1/((a*d)-(b*c))) * ((d*v)-(b*w))
		yk = (-1/((a*d)-(b*c))) * ((a*w)-(c*v))
	else
		xk,yk = 0,0
	end
	return xk, yk
end