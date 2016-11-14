require('object/Tile')

kTileSize = 32
kMapTileTypeEmpty = 0
local floor = math.floor
local ceil = math.ceil
local max = math.max
local min = math.min
local abs = math.abs
gTileMap_LayerInvisByName = {}

local tilesetImage
local tileQuads = {}
local tilesetSprite
local tilesetBatch

function TiledMap_Load (filepath,tilesize,spritepath_removeold,spritepath_prefix)
    spritepath_removeold = spritepath_removeold or "../"
    spritepath_prefix = spritepath_prefix or ""
    kTileSize = tilesize or kTileSize or 32

    local tiletype,layers,objects = TiledMap_Parse(filepath)
    gMapLayers = layers
    gMapObjects = objects
    for first_gid,path in pairs(tiletype) do
        path = spritepath_prefix .. string.gsub(path,"^"..string.gsub(spritepath_removeold,"%.","%%."),"")
        local raw = love.image.newImageData("maps/"..path)
        local w,h = raw:getWidth(),raw:getHeight()
        local gid = first_gid
        local e = kTileSize
        local image = love.graphics.newImage(raw)
        tilesetBatch = love.graphics.newSpriteBatch(image, 120 * 90)

        for y=0,floor(h/kTileSize)-1 do
        for x=0,floor(w/kTileSize)-1 do
            tileQuads[gid] = love.graphics.newQuad(x * kTileSize, y * kTileSize, kTileSize, kTileSize,
    w, h)
            gid = gid + 1
        end
        end
    end
end

function TiledMap_Unload()
    gMapLayers = nil
    gMapObjects = nil
end


function TiledMap_GetMapW () return gMapLayers.width end
function TiledMap_GetMapH () return gMapLayers.height end

function TiledMap_GetMapWUsed ()
	local maxx = 0
	local miny = 0
	local maxy = 0
	for layerid,layer in pairs(gMapLayers) do
		if (type(layer) == "table") then for ty,row in pairs(layer) do
			if (type(row) == "table") then for tx,t in pairs(row) do 
				if (t.id and t.id ~= kMapTileTypeEmpty) then 
					miny = min(miny,ty)
					maxy = max(maxy,ty)
					maxx = max(maxx,tx)
				end
			end end
		end end
	end
	return maxx + 1,miny,maxy+1
end

function TiledMap_GetNearestTileByTypeOnLayer (x,y,z,iTileType,maxrad)
	local w = TiledMap_GetMapW()
	local h = TiledMap_GetMapW()
	local maxrad2 = max(x,w-x,y,h-y) if (maxrad) then maxrad2 = min(maxrad2,maxrad) end
	if (TiledMap_GetMapTile(x,y,z) == iTileType) then return x,y end
	for r = 1,maxrad2 do 
		for i=-r,r do 
			local xa,ya = x+i,y-r if (TiledMap_GetMapTile(xa,ya,z) == iTileType) then return xa,ya end -- top
			local xa,ya = x+i,y+r if (TiledMap_GetMapTile(xa,ya,z) == iTileType) then return xa,ya end -- bot
			local xa,ya = x-r,y+i if (TiledMap_GetMapTile(xa,ya,z) == iTileType) then return xa,ya end -- left
			local xa,ya = x+r,y+i if (TiledMap_GetMapTile(xa,ya,z) == iTileType) then return xa,ya end -- right
		end
	end
end
 
function TiledMap_GetMapTile (tx,ty,layerid)
    local row = gMapLayers[layerid][ty]

    if row and row[tx] then
        return row[tx].id
    end
    return kMapTileTypeEmpty
end
 
function TiledMap_SetMapTile (tx,ty,layerid,v)
    local row = gMapLayers[layerid][ty]
	if (not row) then row = {} gMapLayers[layerid][ty] = row end
	row[tx] = v
end

function TiledMap_ListAllOfTypeOnLayer (layerid,iTileType)
	local res = {}
	local w = TiledMap_GetMapW()
	local h = TiledMap_GetMapH()
	for x=0,w-1 do 
	for y=0,h-1 do 
		if (TiledMap_GetMapTile(x,y,layerid) == iTileType) then table.insert(res,{x=x,y=y}) end
	end
	end
	return res
end
 
function TiledMap_GetLayerZByName (layername) for z,layer in ipairs(gMapLayers) do if (layer.name == layername) then return z end end end
function TiledMap_SetLayerInvisByName (layername) gTileMap_LayerInvisByName[layername] = true end
 
function TiledMap_IsLayerVisible (z)
	local layer = gMapLayers[z]
	return layer and (not gTileMap_LayerInvisByName[layer.name or "?"])
end
 
function TiledMap_GetTilePosUnderMouse (mx,my,camx,camy)
	return	floor((mx+camx-love.graphics.getWidth()/2)/kTileSize),
			floor((my+camy-love.graphics.getHeight()/2)/kTileSize)
end
 
function TiledMap_DrawNearCam (camx,camy,fun_layercallback)
    camx,camy = floor(camx),floor(camy)
    local screen_w = love.graphics.getWidth()
    local screen_h = love.graphics.getHeight()
    scaleFactor = width/1920
    local minx,maxx = floor((camx-screen_w/2)/kTileSize),ceil((camx+screen_w/2)/kTileSize)
    local miny,maxy = floor((camy-screen_h/2)/kTileSize),ceil((camy+screen_h/2)/kTileSize)
    for z = 1,#gMapLayers do 
	if (fun_layercallback) then fun_layercallback(z,gMapLayers[z]) end
	if (TiledMap_IsLayerVisible(z)) then
    for x = minx,maxx do
    for y = miny,maxy do
        local gfx = gTileGfx[TiledMap_GetMapTile(x,y,z)]
        if (gfx) then
            local sx = x*kTileSize - camx + screen_w/2
            local sy = y*kTileSize - camy + screen_h/2
            love.graphics.draw(gfx,sx,sy)
        end
    end
    end
    end
    end
end

function TiledMap_AllAtCam (camx,camy,fun_layercallback)
    tilesetBatch:clear()
    camx,camy = floor(camx),floor(camy)
    local screen_w = love.graphics.getWidth()
    local screen_h = love.graphics.getHeight()
    scaleFactor = width/1920
    local minx,maxx = floor((camx-screen_w/2)/kTileSize),gMapLayers.width
    local miny,maxy = floor((camy-screen_h/2)/kTileSize),gMapLayers.height
    for z = 1,#gMapLayers do 
      if (fun_layercallback) then fun_layercallback(z,gMapLayers[z]) end
          if (TiledMap_IsLayerVisible(z)) then
            for x = minx,maxx do
                for y = miny,maxy do
                    local gfx = tileQuads[TiledMap_GetMapTile(x,y,z)]
                    if (gfx) then
                        local sx = x*kTileSize - camx + screen_w/2
                        local sy = y*kTileSize - camy + screen_h/2

                        tilesetBatch:add(gfx, sx, sy)
                    end
                end
            end
            tilesetBatch:flush()
            love.graphics.setColor(255, 255, 255)
            -- love.graphics.draw(tilesetBatch)
            -- tilesetBatch:flush()
        end
    end
end

function LoadXML(s)
  local function LoadXML_parseargs(s)
    local arg = {}
    string.gsub(s, "(%w+)=([\"'])(.-)%2", function (w, _, a)
    arg[w] = a
    end)
    return arg
  end
  local stack = {}
  local top = {}
  table.insert(stack, top)
  local ni,c,label,xarg, empty
  local i, j = 1, 1
  while true do
    ni,j,c,label,xarg, empty = string.find(s, "<(%/?)([%w:]+)(.-)(%/?)>", i)
    if not ni then break end
    local text = string.sub(s, i, ni-1)
    if not string.find(text, "^%s*$") then
      table.insert(top, text)
    end
    if empty == "/" then  -- empty element tag
      table.insert(top, {label=label, xarg=LoadXML_parseargs(xarg), empty=1})
    elseif c == "" then   -- start tag
      top = {label=label, xarg=LoadXML_parseargs(xarg)}
      table.insert(stack, top)   -- new level
    else  -- end tag
      local toclose = table.remove(stack)  -- remove top
      top = stack[#stack]
      if #stack < 1 then
        error("nothing to close with "..label)
      end
      if toclose.label ~= label then
        error("trying to close "..toclose.label.." with "..label)
      end
      table.insert(top, toclose)
    end
    i = j+1
  end
  local text = string.sub(s, i)
  if not string.find(text, "^%s*$") then
    table.insert(stack[#stack], text)
  end
  if #stack > 1 then
    error("unclosed "..stack[stack.n].label)
  end
  return stack[1]
end

local function getTilesets(node)
    local tiles = {}
    for k, sub in ipairs(node) do
        if (sub.label == "tileset") then
            tiles[tonumber(sub.xarg.firstgid)] = sub[1].xarg.source
        end
    end
    return tiles
end

local function getLayers(node)
    local layers = {}
	layers.width = 0
	layers.height = 0
    for k, sub in ipairs(node) do
        if (sub.label == "layer") then --  and sub.xarg.name == layer_name
			layers.width  = max(layers.width ,tonumber(sub.xarg.width ) or 0)
			layers.height = max(layers.height,tonumber(sub.xarg.height) or 0)
            local layer = {}
            table.insert(layers,layer)
			layer.name = sub.xarg.name
            width = tonumber(sub.xarg.width)
            i = 0
            j = 0
            for l, child in ipairs(sub[1]) do
                if (j == 0) then
                    layer[i] = {}
                end
                layer[i][j] = Tile.new(tonumber(child.xarg.gid))
                j = j + 1
                if j >= width then
                    j = 0
                    i = i + 1
                end
            end
        end
    end
    return layers
end

local function getObjects(node)
    local layers = {}
    for k, sub in ipairs(node) do
        if (sub.label == "objectgroup") then
            local layer = {}
            layer.name = sub.xarg.name
            layer.objects = {}
            for l, child in ipairs(sub) do
                objectX = tonumber(child.xarg.x)
                objectY = tonumber(child.xarg.y)
                objectR = tonumber(child.xarg.rotation)
                objectId = tonumber(child.xarg.id)
                layer.objects[objectId] = { x = objectX, y = objectY,r = objectR}
            end
            table.insert(layers,layer)
        end
    end
    return layers
end

function TiledMap_GetSpawnLocations()
    for i, layer in pairs(gMapObjects) do
        if layer.name == "spawn" then
            return layer.objects
        end
    end
end

function TiledMap_Parse(filename)
    local xml = LoadXML(love.filesystem.read(filename))
    local tiles = getTilesets(xml[2])
    local layers = getLayers(xml[2])
    local objectLayers = getObjects(xml[2])
    return tiles, layers, objectLayers
end