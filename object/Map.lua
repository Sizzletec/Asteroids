require('object/TileSet')
require('object/Layer')
require('object/Tile')
local floor = math.floor
local ceil = math.ceil
local max = math.max
local min = math.min
local abs = math.abs

Map = {}
Map.__index = Map

function Map.new(filename)
  local m = {
    tileSets = {},
    layers = {},
    width = 0,
    height = 0,
    tileSize = 0
  }
  setmetatable(m, Map)

  local xml = LoadXML(love.filesystem.read(filename))[2]
  m.tileSize = xml.xarg.tilewidth
  m:LoadTileset(xml)
  m:LoadLayers(xml)


  -- print(m.layers[1].tiles[0][0].id)
  -- print(m.layers[1].tiles[20][0].id)

  -- id = m.layers[1].tiles[20][0].id


  return m
end



function Map:LoadTileset(xml)
  for k, sub in ipairs(xml) do
    if (sub.label == "tileset") then
      imagePath = "maps/".. sub[1].xarg.source

      firstGid = tonumber(sub.xarg.firstgid)

      tileCount = tonumber(sub.xarg.tilecount)

      tileset = TileSet.new(imagePath,firstGid,tileCount,self.tileSize)

      self.tileSets[tonumber(sub.xarg.firstgid)] = tileset
    end
  end
end

function Map:GetTileset(id)
  if id == 0 then
    return nil
  end
  for _,ts in pairs(self.tileSets) do
    if id >= ts.firstGid and id <= ts.lastGid then
      return ts
    end
  end
end

function Map:LoadLayers(xml)
  for k, sub in ipairs(xml) do
    if (sub.label == "layer") then --  and sub.xarg.name == layer_name
      self.width = max(self.width,tonumber(sub.xarg.width) or 0)
      self.height = max(self.height,tonumber(sub.xarg.height) or 0)

      layer = Layer.new(self,sub.xarg.name)
      table.insert(self.layers,layer)

      layer.name = sub.xarg.name
      width = tonumber(sub.xarg.width)
      i = 0
      j = 0
      for l, child in ipairs(sub[1]) do
        id = tonumber(child.xarg.gid)
        ts = self:GetTileset(id)
        if id > 0 then
          tile = Tile.new(id, ts,j*self.tileSize,i*self.tileSize)
          table.insert(layer.tiles,tile)
          -- table.insert(Game.getObjects(),tile)
        end
       
        j = j + 1
        if j >= width then
          j = 0
          i = i + 1
        end
      end
    end
  end
  print(#self.layers)
end

function Map:update(dt)
  for _,layer in pairs(self.layers) do
    layer:update(dt)
  end
end

function Map:drawBackground()
  for _,layer in pairs(self.layers) do
    if layer.name == "background" then
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
end

function Map:drawForeground()
  for _,layer in pairs(self.layers) do
    if layer.name == "foreground" then
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
end

return Map