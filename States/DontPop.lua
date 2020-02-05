local state = {}
state.name = "Don't pop!"
state.scale = {}
state.maxScale = 0
state.highestValue = 0
state.highestPlayer = {}
state.popped = false
state.winTimer = 0

state.Pop = function(x, y, r, g, b)
  local newParticle = CreateParticleStruct()
  
  newParticle.minSpeed = 10
  newParticle.maxSpeed = 90

  newParticle.color.r = r
  newParticle.color.g = g
  newParticle.color.b = b
  newParticle.color.a = 1


  newParticle.shape = 5
  newParticle.startSize = 1
  newParticle.endSize = 40
  newParticle.lifetime = 1
  
  newParticle.angle = 0
  newParticle.spread = 6.28
  newParticle.gravity.y = 0
  newParticle.fadeSpeed = 0.05
  
  ParticleManager:SpawnParticle(newParticle,8,{x=x,y=y})
end

state.OnEnter = function(self)
  self.scale = {}
  self.maxScale = 2 + love.math.random(5)
  self.highestValue = 0
  self.highestPlayer = {}
  self.popped = false
  self.winTimer = 0
  local vertical = 0
  for k, p in ipairs(PlayerManager.alivePlayers) do
  	p.x = (k-0.5) * (width*0.8)/#PlayerManager.alivePlayers + width*0.1
  	if vertical == 0 then vertical = 1 else vertical = 0 end 
  	p.y = height/2 + (vertical - 0.5) * 0.3 * height
  	self.scale[k] = 0
  end
end

state.Update = function(self, dt)
  if not self.popped then
	for k, p in ipairs(PlayerManager.alivePlayers) do
	  	self.scale[k] = self.scale[k] - 0.07
	  	if self.scale[k] < 0 then
	  		self.scale[k] = 0
	  	end
	  	p.scale = p.scale + ((1+self.scale[k]/4) - p.scale) * 0.1
	  	if p:GetPressed() then 
	  		self.scale[k] = self.scale[k] + 1
	  		p.scale = (1+(self.scale[k]+1)/4)
	  	end
	  	if self.scale[k] > self.maxScale then 
        self.Pop(p.x, p.y, p.color.r, p.color.g, p.color.b)
	  		PlayerManager:EliminatePlayer(p)
	  		table.remove(self.scale, k)
	  		self.popped = true
	  		for i, o in ipairs(PlayerManager.alivePlayers) do
	  			if self.scale[i] >= self.highestValue then
	  				self.highestValue = self.scale[i]
	  				self.highestPlayer = o
	  				print("set")
				  end  				
	  		end
	  		self.highestPlayer:AddScore()
	  	end
	end
  else
  	self.highestPlayer:Jump()
  	self.winTimer = self.winTimer + dt
  	if self.winTimer > 3 then
  		return true
  	end
  end

  return false
end

state.Draw = function(self)
  PlayerManager:Draw()
end

state.OnLeave = function(self)
  for k, p in ipairs(PlayerManager:GetPlayers()) do
  	p.scale = 1
  end
end

return state