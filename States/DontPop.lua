local state = {}
state.name = "Don't pop!"
state.scale = {}
state.maxScale = 0
state.highestValue = 0
state.highestPlayer = {}
state.popped = false
state.winTimer = 0

state.OnEnter = function(self)
  self.maxScale = 4 + love.math.random(8)
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
	  	p.scale = p.scale + ((1+self.scale[k]/6) - p.scale) * 0.1
	  	if p:GetPressed() then 
	  		self.scale[k] = self.scale[k] + 1
	  		p.scale = (1+(self.scale[k]+1)/6)
	  	end
	  	if self.scale[k] > self.maxScale then 
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
  for k, p in ipairs(PlayerManager:GetPlayers) do
  	p.scale = 1
  end
end

return state