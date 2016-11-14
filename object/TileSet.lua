TileSet = {}
TileSet.__index = TileSet

function TileSet.new(filename,firstGid,tileCount,tileSize)
  local m = {}
  setmetatable(m, TileSet)

  m.tileSize = tileSize
  m.firstGid = firstGid
  m.lastGid = firstGid + tileCount - 1
  local raw = love.image.newImageData(filename)
  local image = love.graphics.newImage(raw)

  m.batch = love.graphics.newSpriteBatch(image, 120 * 90)

  local w,h = raw:getWidth(),raw:getHeight()

  m.tileQuads = {}
  for y=0,math.floor(h/tileSize)-1 do
    for x=0,math.floor(w/tileSize)-1 do
      quad = love.graphics.newQuad(x * tileSize, y * tileSize, tileSize, tileSize, w, h)
      table.insert(m.tileQuads,quad)
    end
  end


  return m
end

function TileSet:addTile(id,x,y)
  quad = self.tileQuads[id]
  if quad ~= nil then
    local screen_w = love.graphics.getWidth()
    local screen_h = love.graphics.getHeight()

    local sx = x
    local sy = y
    self.batch:add(quad, sx, sy)
  end
end



return TileSet