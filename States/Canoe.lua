local state = {}
state.name = "Canoe!"

state.canoes = {}
state.strokeTime = 1
state.strokeForce = 2
state.canoeWidth = width*0.25
state.canoeHeight = height*0.1
state.over = false
state.overTime = 3
state.winnerIndex = 0

state.OnEnter = function(self)
  	self.canoes = {}
  	self.over = false
  	self.overTime = 3
  	self.winnerIndex = 0
  	for k, p in ipairs(PlayerManager.alivePlayers) do
  		if self.canoes[p.controllerId] == nil then
  			self.canoes[p.controllerId] = {}
  			self.canoes[p.controllerId].speed = 0
  			self.canoes[p.controllerId].force = 0
  			self.canoes[p.controllerId].pos = 0
  			self.canoes[p.controllerId].strokeTimer = 0 -- if stroke in progress
  			self.canoes[p.controllerId].isStroking = false
  			self.canoes[p.controllerId].players = {}
  		end
  		table.insert(self.canoes[p.controllerId].players, p)
  		p.hasClicked = false
  	end
  	for k, canoe in ipairs(self.canoes) do
  		for i, p in ipairs(canoe.players) do
  			p.x = canoe.pos + (i-0.5)*self.canoeWidth/#canoe.players
			p.y = (k-0.5) * height/#self.canoes
		end
	end
end

state.AddSplash = function(x, y)
  local newParticle = CreateParticleStruct()
  
  newParticle.minSpeed = 10
  newParticle.maxSpeed = 50

  newParticle.color.r = 0.2
  newParticle.color.g = 0.2
  newParticle.color.b = 1
  newParticle.color.a = 1


  newParticle.shape = 5
  newParticle.startSize = 4
  newParticle.endSize = 40
  newParticle.lifetime = 1
  
  newParticle.angle = 0
  newParticle.spread = 6.28
  newParticle.gravity.y = 0
  newParticle.fadeSpeed = 0.01
  
  ParticleManager:SpawnParticle(newParticle,10,{x=bombPosition.x,y=bombPosition.y})
end

state.Update = function(self, dt)
	if not self.over then 
	  	for k, canoe in ipairs(self.canoes) do
	  		canoe.speed = canoe.speed * 0.9
	  		canoe.speed = canoe.speed + canoe.force
	  		canoe.force = canoe.force * 0.9
	  		canoe.pos = canoe.pos + canoe.speed
	  		canoe.strokeTimer = canoe.strokeTimer - dt;
	  		if canoe.isStroking and canoe.strokeTimer < 0 then
	  			canoe.isStroking = false
	  			for i, p in ipairs(canoe.players) do
	  				p.hasClicked = false
	  			end
	  		end 
	  		for i, p in ipairs(canoe.players) do
				if not p.hasClicked and p:GetPressed() then
					-- start click
					if canoe.strokeTimer < 0 then
						if not canoe.isStroking then
	  						-- start stroke
	  						canoe.isStroking = true
	  						canoe.strokeTimer = self.strokeTime
	  						p.hasClicked = true
	  						p:Jump()
	  						if #canoe.players == 1 then
	  							canoe.force = canoe.force + self.strokeForce * self.strokeTime * #canoe.players
	  							self.AddSplash(canoe.pos + (i-0.5)*self.canoeWidth/#canoe.players, (k-0.5) * height/#self.canoes + self.canoeHeight)
	  						end
	  					end
	  				else
	  					canoe.force = canoe.force + canoe.strokeTimer * self.strokeForce / #canoe.players
	  					p.hasClicked = true
	  					p:Jump()
	  					self.AddSplash(canoe.pos + (i-0.5)*self.canoeWidth/#canoe.players, (k-0.5) * height/#self.canoes + self.canoeHeight)
	  				end
				end
				p.x = canoe.pos + (i-0.5)*self.canoeWidth/#canoe.players
				p.y = (k-0.5) * height/#self.canoes
			end
			if canoe.pos + self.canoeWidth > width then
				self.over = true;
				self.winnerIndex = k
				for i, p in ipairs(canoe.players) do
					p:AddScore()
				end
			end
	  	end
  	else
  		for k, p in ipairs(self.canoes[self.winnerIndex].players) do
  			p:Jump()
  		end
  		self.overTime = self.overTime - dt
  		if self.overTime < 0 then
  			return true
  		end
  	end 
  	return false
end

state.Draw = function(self)
	for k, canoe in ipairs(self.canoes) do
  		love.graphics.rectangle("fill", canoe.pos, (k-0.5) * height/#self.canoes, self.canoeWidth, self.canoeHeight)
  	end
  	PlayerManager:Draw()
end

state.OnLeave = function(self)
  	for k, p in ipairs(PlayerManager.alivePlayers) do
  		p.hasClicked = nil
  	end
end

return state