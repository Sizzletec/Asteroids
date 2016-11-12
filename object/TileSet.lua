TileSet = {}
TileSet.__index = TileSet

function TileSet.new(filename,tileSize)
  local m = {}
  setmetatable(m, TileSet)
  local raw = love.image.newImageData(filename)
  m.image = love.graphics.newImage(raw)

  local w,h = raw:getWidth(),raw:getHeight()

  m.tileQuads = {}
  for y=0,math.floor(h/kTileSize)-1 do
    for x=0,math.floor(w/kTileSize)-1 do
      quad = love.graphics.newQuad(x * tileSize, y * tileSize, tileSize, tileSize, w, h)
      table.insert(m.tileQuads,quad)
    end
  end


  return m
end


function TileSet:GetProperties(id)
end

function TileSet:GetImage(id)
  return self.tileQuads[id]
end



return TileSet