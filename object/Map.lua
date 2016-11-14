require('object/TileSet')
require('object/Layer')
require('object/Tile')
local floor = math.floor
local ceil = math.ceil
local max = math.max
local min = math.min
local abs = math.abs

Map = {
  tileSets = {},
  layers = {},
  width = 0,
  height = 0,
  tileSize = 0
}
Map.__index = Map

function Map.new(filename)
  local m = {}
  setmetatable(m, Map)

  print(filename)

  local xml = LoadXML(love.filesystem.read(filename))[2]
  m.tileSize = xml.xarg.tilewidth
  m:LoadTileset(xml)
  m:LoadLayers(xml)


  print(m.layers[1].tiles[0][0].id)
  print(m.layers[1].tiles[20][0].id)

  id = m.layers[1].tiles[20][0].id


  return m
end



function Map:LoadTileset(xml)
  for k, sub in ipairs(xml) do
    if (sub.label == "tileset") then
      imagePath = "maps/".. sub[1].xarg.source

      firstGid = sub.xarg.firstgid

      tileCount = sub.xarg.tilecount

      tileset = TileSet.new(imagePath,firstGid,tileCount,self.tileSize)

      self.tileSets[tonumber(sub.xarg.firstgid)] = tileset
      print(self.tileSets[1])
    end
  end
end

function Map:LoadLayers(xml)
  for k, sub in ipairs(xml) do
    if (sub.label == "layer") then --  and sub.xarg.name == layer_name
      self.width = max(self.width,tonumber(sub.xarg.width) or 0)
      self.height = max(self.height,tonumber(sub.xarg.height) or 0)

      layer = Layer.new(self)
      table.insert(self.layers,layer)

      layer.name = sub.xarg.name
      width = tonumber(sub.xarg.width)
      i = 0
      j = 0
      for l, child in ipairs(sub[1]) do
        if (j == 0) then
          layer.tiles[i] = {}
        end
        tileset = self.tileSets[1]
        layer.tiles[i][j] = Tile.new(tonumber(child.xarg.gid), tileset,j*self.tileSize,i*self.tileSize)
        j = j + 1
        if j >= width then
          j = 0
          i = i + 1
        end
      end
    end
  end
end


function Map:update(dt)
  for _,layer in pairs(self.layers) do
    layer:update()
  end
end

function Map:draw()
  for _,layer in pairs(self.layers) do
    for _,ts in pairs(self.tileSets) do
      ts.batch:clear()
    end
    layer:draw()
    for _,ts in pairs(self.tileSets) do
      love.graphics.draw(ts.batch)
      ts.batch:flush()
    end
  end
end

return Map