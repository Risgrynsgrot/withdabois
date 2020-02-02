local state = {}
state.name = "Roulette!"
state.r = 0
state.racc = 0.1
state.slice = (math.pi * 2) / #PlayerManager:GetPlayers()
state.deadId = 0
state.vx = 0
state.vy = 0

state.OnEnter = function(self)
  self.p = nil
  self.r = love.math.random() * math.pi * 2
  self.racc = 0.1
  self.slice = (math.pi * 2) / #PlayerManager:GetPlayers()
  self.deadId = 0
  self.vy = -10
  self.vx = love.math.random(-20, 20)
  self.t = 3
end

state.Update = function(self, dt)
  local i = math.floor(math.fmod(self.r + self.slice * 0.5, math.pi * 2) / self.slice) + 1
  self.p = PlayerManager:GetPlayers()[i]
  
  if self.racc > 0 then
    self.r = self.r + self.racc
    self.racc = self.racc - 0.0002
    self.racc = math.max(self.racc, 0)
  else
    self.deadId = i
    self.vy = self.vy + 1
    self.t = self.t - dt
  end
  return self.t <= 0
end

state.Draw = function(self)
  love.graphics.push()
  love.graphics.translate(width*0.5, height)
  love.graphics.rotate(-math.pi * 0.5)
  love.graphics.translate(-width*0.5, -height)
  love.graphics.setColor(0.1, 0, 0.6)
  love.graphics.circle("fill", width*0.5, height, height*0.5, 3)
  love.graphics.pop()
  
  love.graphics.push()
  love.graphics.rotate(math.pi)
  love.graphics.scale(1, 0.5)
  love.graphics.translate(-width, -height)
  love.graphics.setColor(0.1, 0, 0.6)
  love.graphics.circle("fill", 0, 0, width * 0.25, 3)
  love.graphics.pop()

  love.graphics.setColor(0, 0.4, 0.1)
  love.graphics.circle("fill", width/2, height/2, height * 0.4)
  love.graphics.setLineWidth(5)

  for i = 1,#PlayerManager:GetPlayers()  do
    love.graphics.setColor(1, 1, 1)
    local angle = self.r + ((i) * self.slice)
    local r = height * 0.4
    local px = width / 2 + math.cos(angle) * r
    local py = height / 2 + math.sin(angle) * r
    local lx = width / 2 + math.cos(angle - self.slice * 0.5) * r
    local ly = height / 2 + math.sin(angle - self.slice * 0.5) * r
    love.graphics.line(width / 2, height / 2, lx, ly)
    if (#PlayerManager:GetPlayers() + 1 - i) ~= self.deadId then
      PlayerManager:GetPlayers()[#PlayerManager:GetPlayers()+1 - i].x = px
      PlayerManager:GetPlayers()[#PlayerManager:GetPlayers()+1 - i].y = py
    else
      PlayerManager:GetPlayers()[#PlayerManager:GetPlayers()+1 - i].x = PlayerManager:GetPlayers()[#PlayerManager:GetPlayers()+1 - i].x + state.vx
      PlayerManager:GetPlayers()[#PlayerManager:GetPlayers()+1 - i].y = PlayerManager:GetPlayers()[#PlayerManager:GetPlayers()+1 - i].y + state.vy
    end
    
    PlayerManager:GetPlayers()[#PlayerManager:GetPlayers()+1 - i]:Draw()
    if self.deadId  > 0 then
      if love.math.random(4) == 3 then 
        PlayerManager:GetPlayers()[#PlayerManager:GetPlayers()+1 - i]:Jump()
      end
    end
  end
  
end

state.OnLeave = function(self)
  
end

return state