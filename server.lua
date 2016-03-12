local socket = require "socket"
local udp = socket.udp()

udp:settimeout(0)
udp:setsockname('*', 12345)

local world = {} -- the empty world-state
local data, msg_or_ip, port_or_nil
local entity, cmd, parms

local running = true

print "Beginning server loop."
while running do
	data, msg_or_ip, port_or_nil = udp:receivefrom()
	if data then
		-- more of these funky match paterns!
		entity, cmd, parms = data:match("^(%S*) (%S*) (.*)")
		if cmd == 'move' then
			local x, y, vx, vy, r = parms:match("^(%-?[%d.e]*) (%-?[%d.e]*) (%-?[%d.e]*) (%-?[%d.e]*) (%-?[%d.e]*)$")
			assert(x and y and vx and vy and r) -- validation is better, but asserts will serve.
			-- don't forget, even if you matched a "number", the result is still a string!
			-- thankfully conversion is easy in lua.
			x, y, vx, vy, r = tonumber(x), tonumber(vx),tonumber(vy),tonumber(r)
			local ent = world[entity] or {x=0, y=0, vx=0, vy=0, r=0}
			world[entity] = {x=ent.x+x, y=ent.y+y, vx=ent.vx+vx, vy=ent.vy+vy, r=ent.r+r}
		elseif cmd == 'at' then
			local x, y, vx, vy, r = parms:match("^(%-?[%d.e]*) (%-?[%d.e]*) (%-?[%d.e]*) (%-?[%d.e]*) (%-?[%d.e]*)$")
			assert(x and y and vx and vy and r)  -- validation is better, but asserts will serve.
			x, y, vx, vy, r = tonumber(x), tonumber(y),tonumber(vx),tonumber(vy),tonumber(r)
			world[entity] = {x=x, y=y, vx=vx, vy=vy, r=r}
		elseif cmd == 'update' then
			for k, v in pairs(world) do
				udp:sendto(string.format("%s %s %f %f %f %f %f", k, 'at', v.x, v.y, v.vx, v.vy, v.r), msg_or_ip,  port_or_nil)
			end
		elseif cmd == 'quit' then
			running = false;
		else
			print("unrecognised command:", cmd)
		end
	elseif msg_or_ip ~= 'timeout' then
		error("Unknown network error: "..tostring(msg))
	end
	socket.sleep(0.0001)
end

print "Thank you."