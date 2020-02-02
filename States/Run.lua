local state = {}
state.name = "Run!"
state.vy = {}

state.OnEnter = function(self)
  local slice = width / #PlayerManager:GetPlayers()
  for i,p in ipairs(PlayerManager:GetPlayers()) do
    p.x = slice * i - slice / 2
    p.y = 0
    p.vy = 0
    p.r = 0
  end
  self.t = 2
  
  self.minY = 999999
end

state.Update = function(self, dt)
  self.minY = 999999
  
  for i,p in ipairs(PlayerManager.alivePlayers) do
    if p:GetPressed() then
      p.vy = p.vy- 0.2
      p:Jump()
    end
    
    p.y = p.y + p.vy
    
    self.minY = math.min(self.minY, p.y)
  end
  
  for i,p in ipairs(PlayerManager.alivePlayers) do
    if p.y > self.minY + height * 0.9 then
        PlayerManager:EliminatePlayer(p)
    end
  end
  
  if #PlayerManager.alivePlayers == 1 then
    if self.t == 2 then
      for i,p in ipairs(PlayerManager.alivePlayers) do
        p:AddScore()
      end
    end
    self.t = self.t - dt
  end
  
  return self.t < 0
end

state.Draw = function(self)
  love.graphics.push()
  local camY = math.min(self.minY - 64, -height * 0.9)
  love.graphics.translate(0, -camY)
  local ly = camY
  for i = 0, height + 129, 128 do
    local y = math.floor((ly + i)/ 128) * 128
    love.graphics.line(0, y, width, y)    
  end
  PlayerManager:Draw()
  love.graphics.pop()
end

state.OnLeave = function(self)
  for i,p in ipairs(PlayerManager.alivePlayers) do
   p.vy = nil
  end
end

return state