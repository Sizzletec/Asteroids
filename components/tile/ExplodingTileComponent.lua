ExplodingTileComponent = {}

ExplodingTileComponent.__index = ExplodingTileComponent

function ExplodingTileComponent.new(entity)
  local i = {}
  setmetatable(i, ExplodingTileComponent)
  i.entity = entity
  i.wall = false
  return i
end

function ExplodingTileComponent:getCollisonMask()
  cm = bit.bor(Collision.bullet,Collision.aoe)
  return cm
end


function ExplodingTileComponent:OnBulletHit(bullet)
  local ts = self.entity.tileset
  if ts then
      cx = self.entity.x + ts.tileSize/2
      cy = self.entity.y + ts.tileSize/2
      self.wall = true
      -- bullet:OnWallHit(self.entity,dt)
      local sw = AoE.new(bullet.entity,cx,cy,10,40,1,10000)
      table.insert(Game.getObjects(), sw)

      -- if bullet.lifetime > bullet.bulletLife then
        -- bullet:Remove()
        -- table.remove(player.bullets, i)
      -- end
  end
end


function ExplodingTileComponent:draw()
  if self.wall then
    ts = self.entity.tileset.tileSize
    love.graphics.rectangle("fill", self.entity.x-2, self.entity.y-2, ts+4, ts+4)
    self.wall = false
    self.entity.id = 0
    self.entity.components = {}
  end
end

return ExplodingTileComponent