local state = {}
state.vy = {}
state.g = 1

state.OnEnter = function(self)
  for i,p in ipairs(PlayerManager:GetPlayers()) do
    p.x = i * 38 - 16
    p.y = 100
    self.vy[i] = 0
  end
end

state.Update = function(self, dt)
  for i,p in ipairs(PlayerManager:GetPlayers()) do
    if p:GetPressed() and p.y >= height - 128 then
      self.vy[i] = -64
    end
    
    self.vy[i] = self.vy[i] + self.g
    p.y = p.y + self.vy[i]
    
    if p.y > height - 128 then
     p.y = height - 128
     self.vy[i] = 0
    end
  end
  return false
end

state.Draw = function(self)
  PlayerManager:Draw()
end


state.OnLeave = function()
  
end

return state