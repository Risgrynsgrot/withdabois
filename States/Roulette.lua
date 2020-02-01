local state = {}
state.name = "Roulette!"
state.r = 0
state.racc = 0.1
state.slice = (math.pi * 2) / #PlayerManager:GetPlayers()

state.OnEnter = function(self)
  
end

state.Update = function(self, dt)
  self.r = self.r + self.racc
  self.racc = self.racc - 0.0002
  self.racc = math.max(self.racc, 0)
  return false
end

state.Draw = function(self)
  love.graphics.push()
  love.graphics.translate(width*0.5, height)
  love.graphics.rotate(-math.pi * 0.5)
  love.graphics.translate(-width*0.5, -height)
  love.graphics.setColor(0.1, 0, 0.6)
  love.graphics.circle("fill", width*0.5, height, height*0.5, 3)
  love.graphics.pop()

  love.graphics.setColor(0, 0.4, 0.1)
  love.graphics.circle("fill", width/2, height/2, height * 0.4)
    love.graphics.setLineWidth(5)
  for i = 1, #PlayerManager:GetPlayers() do
    love.graphics.setColor(1, 1, 1)
    local lx = width * 0.5 + math.cos(self.r + i * self.slice) * height * 0.4
    local ly = height * 0.5 + math.sin(self.r + i * self.slice) * height * 0.4
    love.graphics.line(width * 0.5, height * 0.5, lx, ly)
    PlayerManager:GetPlayers()[i].x = width * 0.5 + math.cos(self.r + self.slice * 0.5 + i * self.slice) * height * 0.4
    PlayerManager:GetPlayers()[i].y = height * 0.5 + math.sin(self.r + self.slice * 0.5 + i * self.slice) * height * 0.4
    PlayerManager:GetPlayers()[i]:Draw()
  end
  
end

state.OnLeave = function(self)
  
end

return state