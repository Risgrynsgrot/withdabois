local state = {}

local walls = {}
local diff = 0
local timer = 0

local jumpForce = 10
local gravity = 1

local createWall = function(diff)
	wall = {}
	wall.x = 0
	wall.space = love.math.random(diff)
	wall.y = love.math.random(diff)
	return wall
end

state.OnEnter = function(self)
  	diff = 0
  	timer = 0
  	for k,p in ipairs(PlayerManager.alivePlayers) do
  		p.x = width/2
  		p.y = height/2
		p.v = 0
	end
end

state.Update = function(self, dt)
	timer = timer + dt
 	for k,p in ipairs(PlayerManager.alivePlayers) do
		p.v = p.v + gravity * dt
		if p:GetPressed() then
			p.v = p.v - jumpForce
		end
		p.y = p.y + p.v
	end
  return false
end

state.Draw = function(self)
	for k,p in ipairs(walls) do
		love.love.graphics.setColor(1, 1, 1, 1)
		local x = wall.x - timer + width
		love.graphics.rectangle("fill", x, wall.y, 10, 10)
	end
 	PlayerManager:Draw()
end

state.OnLeave = function(self)
  
end

return state