local state = {}
state.name = "Jump over it!"
state.vy = {}
state.vx = {}
state.alive = {}
state.g = 1.25
state.x = width * 4
state.wh = 128

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

local ttt = 1

state.Update = function(self, dt)
  
  local newParticle = CreateParticleStruct()
  
  newParticle.minSpeed = 1
  newParticle.maxSpeed = 100

  newParticle.color.r = 1
  newParticle.color.g = 1
  newParticle.color.b = 1
  newParticle.color.a = 1

  newParticle.shape = 5
  newParticle.startSize = 10
  newParticle.endSize = 30
  newParticle.lifetime = 0.3
  newParticle.fadeSpeed = 0.07
  
  newParticle.angle = -math.pi * 0.5
  newParticle.spread = 0
  
  ParticleManager:SpawnParticle(newParticle, 3, {x=self.x * 0.75,y=height - 200 + 48})
  
  if self.x > 0 and self.x - width * 0.8 * dt < 0 then
    for i,p in ipairs(PlayerManager:GetPlayers()) do
      if self.alive[i] then
        p:AddScore()
      end
    end
  end
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
    
    if p.x + p.wh / 2 > self.x and p.x - p.wh / 2 < self.x + self.wh and p.y >= height - self.wh + 32 then
      self.vy[i] = -30
      self.vx[i] = love.math.random(-10, 10)
      self.alive[i] = false
    end
    
  end

  return self.x < -width * 2
end

state.Draw = function(self)

  love.graphics.push()
  love.graphics.scale(0.75, 0.75)
  love.graphics.rectangle("fill", 0, height + 32, width*2, 500)
  love.graphics.rectangle("fill", self.x, height - self.wh + 32 , self.wh , self.wh )
  PlayerManager:Draw()
  love.graphics.pop()

end


state.OnLeave = function()
  for i,p in ipairs(PlayerManager:GetPlayers()) do
    p.r = 0
  end
end

return state