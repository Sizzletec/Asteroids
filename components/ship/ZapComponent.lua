local lightning = love.graphics.newImage('images/lightnings.png')

ZapComponent = {
  weaponDamage = 5,
  firing = false,
  attackFrame = 0,
  tick = .1
}

ZapComponent.__index = ZapComponent

function ZapComponent.new(entity)
  local i = {}
  setmetatable(i, ZapComponent)
  i.entity = entity
  i.shape = HC.polygon(0,0, 40,-60, -40,-60)
  i.shape.cx,i.shape.cy = i.shape:center()
  i.contacts = {}
  return i
end

function ZapComponent:update(dt)
  local move = self.entity.components.move

  if self.entity.components.life.health <= 0 then
    return
  end

  self.shape:setRotation(0)
  self.shape:moveTo(move.x,move.y+self.shape.cy)
  self.shape:setRotation(move.rotation,move.x,move.y)

  contacts = {}
  if self.firing then
    self.attackFrame = self.attackFrame + 8 * dt
    if self.attackFrame >= 4 then
      self.attackFrame = self.attackFrame - 4
    end
    
    for shape, delta in pairs(HC.collisions(self.shape)) do
      if shape.type == "ship" then
        if shape.entity ~= self.entity then
          if self.contacts[shape.entity] == nil then
            contacts[shape.entity] = 0
          else
            contacts[shape.entity] = self.contacts[shape.entity]
          end
        end
      end
    end
    
    for entity, v in pairs(contacts) do
      if v <= 0 then
        contacts[entity] = v + self.tick
        entity.components.life:takeDamage(self.entity, self.weaponDamage)
      end
      contacts[entity] = contacts[entity] - dt
    end
  end
  self.contacts = contacts
end

function ZapComponent:fire()
end

function ZapComponent:draw()
  if self.firing then
    local move = self.entity.components.move
    local top_left = love.graphics.newQuad(math.floor(self.attackFrame)*100, 0, 100, 80, lightning:getDimensions())

    love.graphics.draw(lightning, top_left,move.x, move.y, move.rotation, 1,1 , 50,70)
  end
  if debug then
    self.shape:draw('fill')
  end
end

return ZapComponent