local state = {}
state.name = "Run!"
state.vy = {}
state.minY = 999999

state.OnEnter = function(self)
  local slice = width / #PlayerManager:GetPlayers()
  for i,p in ipairs(PlayerManager:GetPlayers()) do
    p.x = slice * i - slice / 2
    p.y = 0
    self.vy[i] = 0
    p.r = 0
  end
  
  self.minY = 999999
end

state.Update = function(self, dt)
  self.minY = 999999
  
  for i,p in ipairs(PlayerManager.alivePlayers) do
    if p:GetPressed() then
      self.vy[i] = self.vy[i] - 0.1
    end
    
    p.y = p.y + self.vy[i]
    
    self.minY = math.min(self.minY, p.y)
      
  end
  
  for i,p in ipairs(PlayerManager.alivePlayers) do
    if p.y > self.minY + height * 0.9 then
        PlayerManager:EliminatePlayer(p)
    end
  end
  
  print(#PlayerManager.alivePlayers)
  return #PlayerManager.alivePlayers == 1
end

state.Draw = function(self)
  local camY = math.min(self.minY - 64, -height * 0.9)
  love.graphics.translate(0, -camY)
  local ly = camY
  for i = 0, height, 64 do
    local y = math.floor((ly + i)/ 64) * 64
    love.graphics.line(0, y, width, y)    
  end
  PlayerManager:Draw()
    
end

state.OnLeave = function(self)
end

return state