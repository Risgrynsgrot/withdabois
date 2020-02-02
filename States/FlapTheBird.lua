local state = {}
state.name = "Flap the bird!"
local walls = {}
local timer = 0
local wallTimer = 0
local wallTime = 2

local jumpForce = 300
local wallSpeed = 150
local gravity = 500
local hasFinished = false
local finishTimer = 0

local createWall = function(diff)
	wall = {}
	wall.x = width
	wall.space = height - height * diff * 0.2--  height - love.math.random(height)/diff - height * 0.3
	wall.y = (0.2 + love.math.noise(diff * 10)) * height * 0.2 -- love.math.random(wall.space*2)
	wall.width = 50
	return wall
end

state.OnEnter = function(self)
	hasFinished = false
	finishTimer = 0
  	diff = 0
  	timer = 0
  	walls = {}
  	for k,p in ipairs(PlayerManager.alivePlayers) do
  		p.x = width/3 - p.id * 20
  		p.y = height/2
		p.v = 0
	end
end

state.Update = function(self, dt)
	if not hasFinished then
		timer = timer + dt
		local diff = timer * 0.1 + 1
		wallTimer = wallTimer + dt * diff
		if wallTimer > wallTime then
			wallTimer = 0
			table.insert(walls, createWall(diff))
		end

		for k,wall in ipairs(walls) do
			wall.x = wall.x - dt * diff * wallSpeed
		end

	 	for k,p in ipairs(PlayerManager.alivePlayers) do
			p.v = p.v + gravity * dt
			if p:GetPressed() then
				p.v = -jumpForce
			end
			p.y = p.y + p.v * dt
			if p.y - p.wh*2 > height or p.y + p.wh < 0 then
				PlayerManager:EliminatePlayer(p)
			end

			for j,wall in ipairs(walls) do
				if p.x + p.wh / 2 > wall.x and p.x - p.wh / 2 < wall.x + wall.width and 
					(p.y + p.wh / 2 > 0 and p.y - p.wh / 2 < wall.y or 
					 p.y + p.wh / 2 > wall.y + wall.space and p.y - p.wh / 2 < height - wall.y + wall.space) then
					PlayerManager:EliminatePlayer(p)
				end
			end
		end	

		if #PlayerManager.alivePlayers < 2 then
		 	for k,p in ipairs(PlayerManager.alivePlayers) do
				p:AddScore()
			end	
			hasFinished = true
		end
	else
		finishTimer = finishTimer + dt
		for k,p in ipairs(PlayerManager.alivePlayers) do
			p:Jump()
		end	
		if finishTimer > 2 then
			return true
		end
	end
  	return false
end

state.Draw = function(self)
	for k,wall in ipairs(walls) do
		love.graphics.setColor(1, 1, 1, 1)
		love.graphics.rectangle("fill", wall.x, 0, wall.width, wall.y)

		local y2 = wall.y + wall.space
		love.graphics.rectangle("fill", wall.x, y2, wall.width, height-y2)
	end
 	PlayerManager:Draw()
end

state.OnLeave = function(self)
  	for k,p in ipairs(PlayerManager:GetPlayers()) do
			p.v = nil
	end	
end

return state