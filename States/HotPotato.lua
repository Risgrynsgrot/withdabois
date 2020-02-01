local state = {}

local players = {}

local bombTime = 5
local bombTimer = 0
local bombBlown = false
local bombPosition = { x = width/2, y = height/2}
local bombIndex = 1
local bombRadius = 30
local bombSpeed = 10
local Explode = function()
	for k,p in ipairs(PlayerManager:GetPlayers()) do
		if bombIndex ~= k then
			p.score = p.score + 1
		else
			PlayerManager:EliminatePlayer(p)
		end
	end
end

local textScale = 0
local textRot = 0
local textTimer = 0
local textTime = 2

state.OnEnter = function()
	textScale = 0
	textRot = 0
	textTimer = 0
	bombTimer = bombTime
	bombBlown = false
  	local playerRadius = 200
	for k,p in ipairs(PlayerManager.alivePlayers) do
		local val = (k/#PlayerManager.alivePlayers)*2*3.14 
	  	p.x = width / 2 + math.cos(val) * playerRadius
	  	p.y = height / 2 + math.sin(val) * playerRadius
	  	p.r = 0
	end
end

state.Update = function(self, dt)
  	if not bombBlown then
  		for k,p in ipairs(PlayerManager.alivePlayers) do
  			if bombIndex == k then
  				if p:GetPressed() or love.keyboard.isDown('d') then
      				bombIndex = love.math.random(#PlayerManager.alivePlayers)
    			end
  			end
  		end
   		bombPosition.x = bombPosition.x + (PlayerManager.alivePlayers[bombIndex].x - bombPosition.x) * dt * bombSpeed
   		bombPosition.y = bombPosition.y + (PlayerManager.alivePlayers[bombIndex].y - bombPosition.y) * dt * bombSpeed
   		bombTimer = bombTimer - dt
   		if bombTimer < 0 then
   			bombBlown = true
   			Explode()
   		end
	else
		textTimer = textTimer + dt
		textRot = math.sin(textTimer*14) * 0.2
		textScale = textScale + (2 + math.sin(textTimer * 10) - textScale) * dt * 10
		if textTimer > textTime then
			return true
		end
	end
  	return false
end

state.Draw = function(self)
	PlayerManager:Draw()

  	if not bombBlown then
  		love.graphics.setColor(1, 1, 1, 1)
  		love.graphics.circle("fill", bombPosition.x, bombPosition.y, bombRadius, 16)
  	else
  		love.graphics.print("BOOM", 1280/2, 720/2, textRot, textScale, textScale, 0, 0, 0, 0)
  	end

end

state.OnLeave = function()

end

return state
