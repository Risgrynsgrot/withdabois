local state = {}
state.name = "Hot potato!"
local players = {}

local playerRadius = 200
local bombTime = 5
local bombTimer = 0
local bombBlown = false
local bombPosition = { x = width/2, y = height/2}
local bombIndex = 1
local bombRadius = 30
local bombSpeed = 10
local bombHeight = 0
local bombTick = 0
local Explode = function()
	for k,p in ipairs(PlayerManager:GetPlayers()) do
		if bombIndex ~= k then
			p:AddScore()
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
	bombPosition.x = width/2
	bombPosition.y = height/2
	bombIndex = love.math.random(#PlayerManager.alivePlayers)
  	
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
  			if p:GetPressed() then
  				p:Jump()
          while bombIndex == k do
            bombIndex = love.math.random(#PlayerManager.alivePlayers)
          end 
  			end
  		end
  		local xDiff = (PlayerManager.alivePlayers[bombIndex].x - bombPosition.x) * bombSpeed
  		local yDiff = (PlayerManager.alivePlayers[bombIndex].y - bombPosition.y) * bombSpeed
   		bombPosition.x = bombPosition.x + xDiff * dt
   		bombPosition.y = bombPosition.y + yDiff * dt
   		bombTimer = bombTimer - dt
   		local x = bombPosition.x - width/2
   		local y = bombPosition.y - height/2
   		local length = math.sqrt(x * x + y * y) / playerRadius
   		bombHeight = math.sqrt(1-length*length)

   		bombTick = bombTick + dt * ((bombTime-bombTimer)*2 + 1)

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
  		local sin = math.abs(math.sin(bombTick))
  		love.graphics.setColor(1, sin*sin, sin*sin, 1)
  		if bombRed then
  			love.graphics.setColor(1, 0, 0, 1)
  		end
  		love.graphics.circle("fill", bombPosition.x, bombPosition.y + bombHeight*10, bombRadius + bombHeight*10, 16)
  	else
  		love.graphics.setColor(1, 1, 1, 1)
  		local text = "BOOM"
  		local w = font:getWidth(text)
  		local h = font:getHeight(text)
  		love.graphics.print(text, width/2, height/2, textRot, textScale, textScale, w/2, h/2, 0, 0)
  	end

end

state.OnLeave = function()

end

return state
