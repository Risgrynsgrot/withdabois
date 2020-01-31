local state = {}

state.Update = function(self, dt)
  
  return false
end

state.Draw = function(self)
  love.graphics.rectangle("fill", 100, 100, 100, 100)
end

return state