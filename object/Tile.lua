require('object/Object')

Tile = Object.new()
Tile.__index = Tile

require('components/tile/WallTileComponent')
require('components/tile/BlockingTileComponent')
require('components/tile/ShieldTileComponent')
require('components/tile/ExplodingTileComponent')

function Tile.new(id,tileset,x,y)
  local t = {
    id = tonumber(id),
    tileset = tileset,
    x = x,
    y = y,
    remove = false
  }
  setmetatable(t, Tile)
  t.components = {}
  if t.id ~= 0 and t.id < 7 then
    t.components["wall"] = WallTileComponent.new(t)
    t.components["blocking"] = BlockingTileComponent.new(t)
    -- t.components["shield"] = ShieldTileComponent.new(t,"right")

    if t.id == 3 then
      t.components["blocking"] = ExplodingTileComponent.new(t)
    end
  end
  t:buildCollisonMask()
  return t
end


function Tile:getCollisonObject()
  ts = self.tileset.tileSize
  -- love.graphics.rectangle("fill", self.entity.x-2, self.entity.y-2, ts+4, ts+4)
  return { x = self.x+ts/2, y = self.y+ts/2, r = 10 }
end

function Tile:getObjectMask()
  return Collision.tile
end

function Tile:buildCollisonMask()
  self.cm = 0 
  for _, component in pairs(self.components) do
    if component.getCollisonMask then
      self.cm = bit.bor(self.cm,component:getCollisonMask())
    end
  end
end

function Tile:getCollisonMask()
  return self.cm
end


-- obj2:OnBulletHit(obj1)
function Tile:OnPlayerHit(player)
  for _, component in pairs(self.components) do
    if component.OnPlayerHit then
      component:OnPlayerHit(player)
    end
  end
end

function Tile:OnBulletHit(bullet)
  for _, component in pairs(self.components) do
    if component.OnBulletHit then
      component:OnBulletHit(bullet)
    end
  end
end


function Tile:OnAoEHit(bullet)
  for _, component in pairs(self.components) do
    if component.OnBulletHit then
      component:OnBulletHit(bullet)
    end
  end
end



function Tile:update(dt)
  for _, component in pairs(self.components) do
    if component.update then
      component:update(dt)
    end
  end
  
end

function Tile:draw()
    for _, component in pairs(self.components) do
      if component.draw then
        component:draw()
      end
    end

    -- debug = self:getCollisonObject()
    -- love.graphics.circle("line", debug.x, debug.y, debug.r)
end

function Tile:addQuad()
  if self.tileset then
    self.tileset:addTile(self.id, self.x, self.y)
  end
end

function Tile:shouldRemove()
  return self.remove
end

function Tile:Remove()
  self.id = 0
  self.components = {}
end


return Tile