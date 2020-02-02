local pm = {}

pm.players = {}
pm.allPlayers = {}
pm.alivePlayers = {}
pm.deadPlayers = {}

pm.Init = function(self)
  for i = 1,20 do
    self.allPlayers[i] = CreatePlayer(i, i * 38 - 16, 400)
    self.alivePlayers[i] = self.players[i]
  end
end

pm.JoinGame = function(self, id)
    table.insert(self.players, self.allPlayers[id])
end

pm.GetPlayers = function(self)
  return self.players
end

pm.GetAllPlayers = function(self)
    return self.allPlayers
end

pm.Update = function(self, dt)
  for k,v in ipairs(self.players) do
    v:UpdateJump(dt)
    v:UpdateEyes(dt)
  end
  for k, v in ipairs(self.allPlayers) do
      v:UpdateInput()
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
