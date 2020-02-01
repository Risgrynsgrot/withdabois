local state = {}
state.vy = {}
state.g = 1
state.x = width * 1.5

state.OnEnter = function(self)
  local slice = width / #PlayerManager:GetPlayers()
  for i,p in ipairs(PlayerManager:GetPlayers()) do
    p.x = slice * i - slice / 2
    p.y = 100
    self.vy[i] = 0
  end
end

state.Update = function(self, dt)
  self.x = self.x - width * 0.1 * dt
  
  for i,p in ipairs(PlayerManager:GetPlayers()) do
    if p:GetPressed() and p.y >= height then
      self.vy[i] = -20
    end
    
    self.vy[i] = self.vy[i] + self.g
    p.y = p.y + self.vy[i]
    
    if p.y > height then
     p.y = height
     self.vy[i] = 0
    end
  end
  return false
end

state.Draw = function(self)
  love.graphics.scale(0.8, 0.8)
  love.graphics.rectangle("fill", 0, height + 32, width*2, 500)
  love.graphics.rectangle("fill", self.x, height -32, 64, 64)
  PlayerManager:Draw()

end


state.OnLeave = function()
  
end

return state