ShieldComponent = {}

ShieldComponent.__index = ShieldComponent

function ShieldComponent.new(entity)
  local i = {}
  setmetatable(i, ShieldComponent)
  i.entity = entity
  return i
end

function ShieldComponent:update(dt)
  players = Game.getPlayers()
  for _, player in pairs(players) do
    for i, bullet in pairs(player.bullets) do
    cx = self.entity.x 
    cy = self.entity.y

    local move = bullet.components.move

    local powX = math.pow(cx - move.x, 2)
    local powY = math.pow(cy - move.y, 2)
    local dist = math.sqrt(powX + powY)

    if dist < self.entity.radius then
      self.wall = true

      bullet:OnWallHit(self.entity,dt)
      if bullet.lifetime > bullet.bulletLife then
        bullet:Remove()
        table.remove(player.bullets, i)
      end
    end
    end
  end
end
return ShieldComponent