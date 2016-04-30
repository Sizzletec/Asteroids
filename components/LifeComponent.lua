LifeComponent = {
  lives = 2,
  health = 100,
  alive = true
}

LifeComponent.__index = LifeComponent

function LifeComponent.new(entity, health)
  local i = {}
  setmetatable(i, LifeComponent)
  i.entity = entity
  i.health = entity.shipType.health
  return i
end

function LifeComponent:respawn()
  self.health = self.entity.shipType.health
  self.alive = true 
end

function LifeComponent:takeDamage(fromPlayer, damage)

  if self.entity.components.score then 
    if damage >= self.health then
      self.entity.components.score.damageTaken = self.entity.components.score.damageTaken + self.entity.components.life.health
    else
      self.entity.components.score.damageTaken = self.entity.components.score.damageTaken + damage
    end
  end

  if fromPlayer.components.score then
    if damage >= self.health then
      if self.health ~= 0 then
        fromPlayer.components.score.kills = fromPlayer.components.score.kills + 1
      end
      fromPlayer.components.score.damageGiven = fromPlayer.components.score.damageGiven + self.entity.components.life.health
    else
      fromPlayer.components.score.damageGiven = fromPlayer.components.score.damageGiven + damage
    end
  end

  self.health = self.health - damage

  if self.entity.components.score then
    self.entity.components.score.damageTaken = self.entity.components.score.damageTaken + self.entity.components.life.health
  end
end

function LifeComponent:update(dt)
  if self.health <= 0 then
    self.health = 0
    if self.alive then
      self.entity.components.score.deaths = self.entity.components.score.deaths + 1
      self.lives = self.lives - 1
      self.alive = false
    end
  end
end

return LifeComponent