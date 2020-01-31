local pm = {}

pm.players = {}

pm.Init = function(self)
  for i = 1,20 do
    pm.players[i] = CreatePlayer(i, i * 38 - 16, 400)
  end
end

pm.GetPlayers = function(self)
  return self.players
end

pm.Draw = function(self)
  for k,v in ipairs(self.players) do
    v:Draw()
  end
end

return pm