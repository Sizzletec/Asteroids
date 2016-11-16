local hit = love.audio.newSource("sounds/hit.wav", "static")
local explode = love.audio.newSource("sounds/death.wav", "static")

LifeComponent = {}

LifeComponent.__index = LifeComponent

function LifeComponent.new(entity)
  local i = {
    lives = 2,
    health = 100,
    alive = true
  }
  setmetatable(i, LifeComponent)
  i.entity = entity
  i.health = entity.shipType.health
  return i
end

function LifeComponent:spawn()
  self.health = self.entity.shipType.health
  self.alive = true
end

function LifeComponent:takeDamage(fromPlayer, damage)
  hit:stop()
  hit:play()
  local score = self.entity.components.score
  local armor = self.entity.components.armor

  if armor then
    damage = armor:apply(damage)
  end

  if score then 
    if damage >= self.health then
      score.damageTaken = score.damageTaken + self.health
    else
      score.damageTaken = score.damageTaken + damage
    end
  end

  local otherScore = fromPlayer.components.score
  if otherScore then
    if damage >= self.health then
      if self.health ~= 0 then
        otherScore.kills = otherScore.kills + 1
      end
      otherScore.damageGiven = otherScore.damageGiven + self.health
    else
      otherScore.damageGiven = otherScore.damageGiven + damage
    end
  end

  self.health = self.health - damage
end

function LifeComponent:update(dt)
  if self.health <= 0 then
    self.health = 0
    if self.alive then
      explode:play()
      self.entity.components.score.deaths = self.entity.components.score.deaths + 1
      self.lives = self.lives - 1
      self.alive = false
      self.entity.components.status:Clear()
    end
  end
end

return LifeComponent