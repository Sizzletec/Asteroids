local ShipsImage = love.graphics.newImage('images/ship-sprites.png')

RenderComponent = {}
RenderComponent.__index = RenderComponent

function RenderComponent.new(entity)
  local i = {}
  setmetatable(i, RenderComponent)
  i.entity = entity
  return i
end

function RenderComponent:drawLifeMarkers(x,y)
  for live=self.entity.lives,1,-1 do
      local xFrame = 0
      if self.entity.engine then
        xFrame = 1
      end

      xFrame = xFrame + self.entity.shipType.frameOffset
      local top_left = love.graphics.newQuad(xFrame*32, self.entity.color*32, 32, 32, ShipsImage:getDimensions())
      love.graphics.draw(ShipsImage, top_left,x + 36 * live, y, 0, 1,1 , 16,16)

      if self.entity.shipType == ShipType.gunship then
        local cannonQuad = love.graphics.newQuad(0, 160, 20, 20, ShipsImage:getDimensions())
        love.graphics.draw(ShipsImage,cannonQuad,x + 36 * live - (3 * math.sin(0)), y + (3 * math.cos(0)), 0, 1,1 , 10, 10)
      end
  end
end

function RenderComponent:draw(dt)
  if self.entity.explodingFrame < 3 then
    local xFrame = 0
    if self.entity.engine then
      xFrame = 1
    end
    xFrame = xFrame + self.entity.shipType.frameOffset

    local top_left = love.graphics.newQuad(xFrame*32, self.entity.color*32, 32, 32, ShipsImage:getDimensions())
    love.graphics.draw(ShipsImage, top_left,self.entity.x, self.entity.y, self.entity.rotation, 1,1 , 16,16)

    self.entity.shipType.actionHandler.Draw(self.entity)
  end

  if self.entity.exploding then
    local top_left = love.graphics.newQuad(math.floor(self.entity.explodingFrame)*32, 4*32, 32, 32, ShipsImage:getDimensions())
    love.graphics.draw(ShipsImage, top_left,self.entity.x, self.entity.y, self.entity.rotation, 1,1 , 16,16)
  end

  love.graphics.setColor(255, 255, 255)

  if self.entity.shield then
    love.graphics.circle("line", self.entity.x, self.entity.y, 20)
  end

  for b, beam in pairs(self.entity.beams) do
    beam:draw()
  end
end

return RenderComponent