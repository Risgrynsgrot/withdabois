local state = {}


state.Update = function(self, dt)
  for k,p in ipairs(PlayerManager:GetPlayers()) do
    if p:GetInput() then
      p.y = p.y + 5
    end
    if p.y > 550 then
      p.y = 550
    end
    
    
    
  end
  return false
end

state.Draw = function(self)
  PlayerManager:Draw()
end

state.OnEnter = function()
  
end

state.OnLeave = function()
  
end

return state