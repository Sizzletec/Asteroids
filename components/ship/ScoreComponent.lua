local ShipsImage = love.graphics.newImage('images/ship-sprites.png')

ScoreComponent = {
  kills = 0,
  deaths = 0,
  shots = 0,
  hits = 0,
  damageGiven = 0,
  damageTaken = 0,
  wallsRunInto = 0
}
ScoreComponent.__index = ScoreComponent

function ScoreComponent.new(entity)
  local i = {}
  setmetatable(i, ScoreComponent)
  i.entity = entity
  return i
end

return ScoreComponent