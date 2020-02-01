local pm = {}

pm.players = {}
pm.alivePlayers = {}
pm.deadPlayers = {}

pm.Init = function(self)
  for i = 1,20 do
    pm.players[i] = CreatePlayer(i, i * 38 - 16, 400)
    pm.alivePlayers[i] = pm.players[i]
  end
end

pm.GetPlayers = function(self)
  return self.players
end

pm.Update = function(self, dt)
  for k,v in ipairs(self.players) do
    v:UpdateInput()
    v:UpdateJump(dt)
    v:UpdateEyes(dt)
  end
end

pm.Draw = function(self)
  for k,v in ipairs(self.players) do
    v:Draw()
  end
end

pm.ResetRound = function(self)
  self.deadPlayers = {}
  self.alivePlayers = {}
  for k,v in ipairs(self.players) do
    self.alivePlayers[k] = v
  end
end

pm.EliminatePlayer = function(self,player)
  if player ~= nil then
    
    for k,v in ipairs(self.alivePlayers) do
      if  v == player then
        table.insert(self.deadPlayers,self.alivePlayers[k])
        table.remove(self.alivePlayers,k)
      end
    end
    
  end
end

return pm
