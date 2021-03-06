local ShipsImage = love.graphics.newImage('images/ship-sprites.png')

RenderComponent = {
  color = 0
}
RenderComponent.__index = RenderComponent

function RenderComponent.new(entity)
  local i = {}
  setmetatable(i, RenderComponent)
  i.entity = entity
  return i
end

function RenderComponent:drawLifeMarkers(x,y)
  for live=self.entity.components.life.lives,1,-1 do
      local xFrame = 0
      if self.entity.engine then
        xFrame = 1
      end

      xFrame = xFrame + self.entity.shipType.frameOffset
      local top_left = love.graphics.newQuad(xFrame*32, self.color*32, 32, 32, ShipsImage:getDimensions())
      love.graphics.draw(ShipsImage, top_left,x + 36 * live, y, 0, 1,1 , 16,16)


      if self.entity.shipType == ShipType.gunship then
        local cannonQuad = love.graphics.newQuad(0, 160, 20, 20, ShipsImage:getDimensions())
        love.graphics.draw(ShipsImage,cannonQuad,x + 36 * live - (3 * math.sin(0)), y + (3 * math.cos(0)), 0, 1,1 , 10, 10)
      end
  end
end

function RenderComponent:draw()
  local x,y,r = 0,0,0
  local move = self.entity.components.move
  if move then
    x = move.x
    y = move.y
    r = move.rotation
  end
  
  if self.entity.phase then
    love.graphics.setColor(255, 255, 255,100)
  end


  if self.entity.explodingFrame < 3 then
    local xFrame = 0
    if self.entity.engine then
      xFrame = 1
    end
    xFrame = xFrame + self.entity.shipType.frameOffset

    local top_left = love.graphics.newQuad(xFrame*32, self.color*32, 32, 32, ShipsImage:getDimensions())
    love.graphics.draw(ShipsImage, top_left,x, y, r, 1,1 , 16,16)
  end

  local life = self.entity.components.life

  if life and not life.alive then
    local top_left = love.graphics.newQuad(math.floor(self.entity.explodingFrame)*32, 4*32, 32, 32, ShipsImage:getDimensions())
    love.graphics.draw(ShipsImage, top_left,x, y, r, 1,1 , 16,16)
  else

    -- if self.entity.shipType == ShipType.gunship and life.alive then

      
    --   local angle = self.entity.components.input.fireAngle
    --   local cannonQuad = love.graphics.newQuad(0, 160, 20, 20, ShipsImage:getDimensions())
    --   love.graphics.draw(ShipsImage,cannonQuad,move.x - (3 * math.sin(move.rotation)), move.y + (3 * math.cos(move.rotation)), angle, 1,1 , 10, 10)
    -- end

    love.graphics.setColor(255, 255, 255)


    local maxTicks = math.ceil(self.entity.shipType.health/10)
    local currentTicks = math.ceil(life.health/10)
    local angleDiff = math.pi/maxTicks

    -- print(angleDiff)

    love.graphics.setLineWidth(2)
    love.graphics.setColor(200, 0, 0,160)
    for i=1,maxTicks,1 do
      -- love.graphics.setLineWidth(20)
      if currentTicks < i then
          love.graphics.setColor(100, 100, 100,50)
      end


      -- 2/17 for 150 2/14 for 130 2/19 for 170 2/18  2/36 for 300

      love.graphics.arc("line", "open", x, y, 30,angleDiff*(i-1)+math.pi/14 -math.pi ,angleDiff*i- math.pi/36 -math.pi)
    end


  end
  love.graphics.setLineWidth(1)
  love.graphics.setColor(255, 255, 255)





  dis = self.entity.components.status:GetDisabled()
  if dis and dis > 0 then
    -- love.graphics.print(dis, x, y)

    -- local move = self.entity.components.move
    -- love.graphics.circle("line", move.x, move.y, 16)

    love.graphics.draw(disableImg,x,y)
  end

  for b, beam in pairs(self.entity.beams) do
    beam:draw()
  end
  -- love.graphics.draw(self.entity.engineParticle, x - (13 * math.sin(move.rotation)), y + (13 * math.cos(move.rotation)))
end

return RenderComponent