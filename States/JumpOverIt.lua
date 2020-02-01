local state = {}
state.vy = {}
state.vx = {}
state.alive = {}
state.g = 1
state.x = width * 4

state.OnEnter = function(self)
  local slice = width / #PlayerManager:GetPlayers() * 0.75
  for i,p in ipairs(PlayerManager:GetPlayers()) do
    p.x = slice * i - slice / 2
    p.y = 100
    self.vx[i] = 0
    self.vy[i] = 0
    self.alive[i] = true
    p.r = 0
  end
  self.x = width * 4
end

state.Update = function(self, dt)
  self.x = self.x - width * 0.8 * dt
  
  for i,p in ipairs(PlayerManager:GetPlayers()) do
    if p:GetPressed() and p.y >= height then
      self.vy[i] = -20
    end
    
    self.vy[i] = self.vy[i] + self.g
    p.x = p.x + self.vx[i]
    p.y = p.y + self.vy[i]
    
    if p.y > height and self.alive[i] then
     p.y = height
     self.vy[i] = 0
    end
    
    if self.alive[i] == false then
      local sign = self.vx[i] > 0 and 1 or self.vx[i] < 0 and -1 or 0
      p.r = p.r + 0.10 * sign
    end
    
    if p.x + p.wh / 2 > self.x and p.x - p.wh / 2 < self.x + 64 and p.y >= height - 32 then
      self.vy[i] = -30
      self.vx[i] = love.math.random(-10, 10)
      self.alive[i] = false
    end
    
  end

  return self.x < -100
end

state.Draw = function(self)
  love.graphics.scale(0.75, 0.75)
  love.graphics.rectangle("fill", 0, height + 32, width*2, 500)
  love.graphics.rectangle("fill", self.x, height -32, 64, 64)
  PlayerManager:Draw()

end


state.OnLeave = function()
  
end

return state