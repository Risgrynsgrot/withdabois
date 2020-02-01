local state = {}

state.canoes = {}
state.strokeTime = 1
state.strokeForce = 100
state.canoeWidth = 100
state.canoeHeight = 30

state.OnEnter = function(self)
  	canoes = {}
  	for k, p in ipairs(PlayerManager.alivePlayers) do
  		if canoes[p.controllerID] == nil then
  			canoes[p.controllerID] = {}
  			canoes[p.controllerID].speed = 0
  			canoes[p.controllerID].force = 0
  			canoes[p.controllerID].pos = 0
  			canoes[p.controllerID].strokeTimer = 0 -- if stroke in progress
  			canoes[p.controllerID].isStroking = false
  			canoes[p.controllerID].players = {}
  		end
  		table.insert(canoes[p.controllerID].players, p)
  		p.hasClicked = false
  	end
end

state.Update = function(self, dt)
  	for k, canoe in ipairs(canoes) do
  		canoe.speed = canoe.speed * 0.98
  		canoe.speed = canoe.speed + canoe.force
  		canoe.force = canoe.force * 0.98
  		canoe.pos = canoe.pos + canoe.speed
  		canoe.strokeTimer = canoe.strokTimer - dt;
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
  					end
  				else
  					canoe.force = canoe.force + canoe.strokeTimer * self.strokeForce
  					p.hasClicked = true
  				end
			end
			p.x = canoe.pos + (i-0.5)*self.canoeWidth/#canoe.players
			p.y = (k-0.5) * height/#self.canoes
		end
  	end
  	return false
end

state.Draw = function(self)
	for k, canoe in ipairs(self.canoes) do
  		love.love.graphics.rectangle("fill", canoe.pos, (k-0.5) * height/#self.canoes, self.canoeWidth, self.canoeHeight)
  	end
  	PlayerManager:Draw()
end

state.OnLeave = function(self)
  	for k, p in ipairs(PlayerManager.alivePlayers) do
  		p.hasClicked = nil
  	end
end

return state