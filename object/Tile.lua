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

  if tileset then 
    ts = tileset.tileSize
    t.shape = HC.rectangle(x,y,ts,ts)
    t.shape.type = "tile"
    t.shape.entity = t
  end

  return t
end

function Tile:OnPlayerHit(player,delta)
  for _, component in pairs(self.components) do
    if component.OnPlayerHit then
      component:OnPlayerHit(player,delta)
    end
  end
end

function Tile:OnBulletHit(bullet,delta)
  for _, component in pairs(self.components) do
    if component.OnBulletHit then
      component:OnBulletHit(bullet,delta)
    end
  end
end

function Tile:OnAoEHit(bullet)
  for _, component in pairs(self.components) do
    if component.OnAoEHit then
      component:OnAoEHit(bullet)
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
end

function Tile:addQuad()
  if self.tileset then
    self.tileset:addTile(self.id, self.x, self.y)
  end

  for _, component in pairs(self.components) do
    if component.draw then
      component:draw()
    end
  end

  if debug then
    self.shape:draw('fill')
  end
end

function Tile:shouldRemove()
  return self.remove
end

function Tile:Remove()
  HC.remove(self.shape)
  self.id = 0
  self.components = {}
end

return Tile