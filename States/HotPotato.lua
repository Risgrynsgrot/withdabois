local state = {}

local players = {}

 -- Place players in circle
 -- Create bomb
 -- Bomb ticking
 -- If bomb time over, explode
 -- Kill current player, aka give all other players score
 -- Create smoke particles!
 -- Wait a moment before returning

local bombTimer = 5
local bombPosition = { x = 0, y = 0}
local bombIndex = 1
local bombBlown = false
local bombRadius = 30
local bombSpeed = 100
local Explode = function()
	for k,p in ipairs(PlayerManager:GetPlayers()) do
		if bombIndex ~= k then
			-- Increase score
		end
	end
end

-- Do this in init
local playerRadius = 200
for k,p in ipairs(PlayerManager:GetPlayers()) do
	local val = (k/20)*2*3.14 
  	p.x = 1280 / 2 + math.cos(val) * playerRadius
  	p.y = 720 / 2 + math.sin(val) * playerRadius
  	p.r = 0
end

state.Update = function(self, dt)
  	if bombBlown == false then
  		for k,p in ipairs(PlayerManager:GetPlayers()) do
  			if bombIndex == k then
  				if p:GetInput() or love.keyboard.isDown('d') then
      				bombIndex = love.math.random(20)
    			end
  			end
  		end
   		bombPosition.x = bombPosition.x + (PlayerManager:GetPlayers()[bombIndex].x - bombPosition.x) * dt * bombSpeed
   		bombPosition.y = bombPosition.y + (PlayerManager:GetPlayers()[bombIndex].y - bombPosition.y) * dt * bombSpeed
   		bombTimer = bombTimer - dt
   		if bombTimer < 0 then
   			bombBlown = true
   			Explode()
   		end
	end
  	return false
end

state.Draw = function(self)
  	for k,p in ipairs(PlayerManager:GetPlayers()) do
    	p:Draw()
  	end

  	if bombBlown == false then
  		love.graphics.circle("fill", bombPosition.x, bombPosition.y, bombRadius, 16)
  	end
end

return state