Tile = {}
Tile.__index = Tile

function Tile.new(id,tileset,x,y)
  local t = {
    id = tonumber(id),
    tileset = tileset,
    x = x,
    y = y
  }
  setmetatable(t, Tile)
  t.components = {}

  return t
end

function Tile:update(dt)
  for _, component in pairs(self.components) do
    if component.update then
      component:update(dt)
    end
  end

  players = Game.getPlayers()
  for _, player in pairs(players) do
    local wall = player.components.wallCollision
    local ts = self.tileset
    if wall and ts then
      cx = self.x + ts.tileSize/2
      cy = self.y + ts.tileSize/2

      local move = player.components.move


      local powX = math.pow(move.x-cx, 2)
      local powY = math.pow(move.y-cy, 2)
      local dist = math.sqrt(powX + powY)

      if dist < 1 then
        print("WALL")
      end
    end
  end
end

function Tile:draw()
  self.tileset:addTile(self.id, self.x, self.y)
  for _, component in pairs(self.components) do
    if component.draw then
      component:draw(dt)
    end
  end
end

return Tile