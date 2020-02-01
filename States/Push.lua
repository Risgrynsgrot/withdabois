local state = { }


local playFieldRadius = 316
local playerSpawnRadius = 256

local friction = 1.2
local growthRate = 40.0

local baseSpeed = 1000.0

local GetAllPlayersAffected = function(player)
	playersAffected = { }

	for k, p in ipairs(PlayerManager.alivePlayers) do
		if p == player then
		    goto continue
		end
 
		distance = math.sqrt(math.pow(p.x - player.x, 2) + math.pow(p.y - player.y, 2))

		if distance <= player.shockWaveCharge + p.wh then
		    p.vx = ((p.x - player.x) / distance) * (baseSpeed / (distance / (player.shockWaveCharge / 100.0)))
		    p.vy = ((p.y - player.y) / distance) * (baseSpeed / (distance / (player.shockWaveCharge / 100.0)))
		end

		::continue::
	end
end

state.OnEnter = function(self)
  
  	angle = 0
	for k, p in ipairs(PlayerManager.players) do

		dis = love.math.random(p.wh, playFieldRadius - p.wh)

		angle = angle + 3.141592653589793238462643383279 * 2 / #PlayerManager.players

	  	p.x = width / 2 + math.cos(angle) * dis
	  	p.y = height / 2 + math.sin(angle) * dis
	  	p.r = love.math.random(0, 3.141592653589793238462643383279 * 2)

	  	p.shockWaveCharge = 0;

	  	p.vx = 0
	  	p.vy = 0
	end
end

state.Update = function(self, dt)
  
	if #PlayerManager.alivePlayers <= 1 then
	    return true
	end

	for k, p in ipairs(PlayerManager.alivePlayers) do

		p.x = p.x + p.vx
		p.y = p.y + p.vy

		p.vx = p.vx / friction
		p.vy = p.vy / friction

		arenaDistance = math.sqrt(math.pow(p.x - width / 2, 2) + math.pow(p.y - height / 2, 2))
		if arenaDistance >= playFieldRadius then
		    p.wh = p.wh - dt * 20
		    if p.wh <= 0 then
		        PlayerManager:EliminatePlayer(p)
		    end
		    goto continue
		end


		if p:GetDown() then
			p.shockWaveCharge = p.shockWaveCharge + dt * growthRate
		end

		if p:GetReleased() then
			
			GetAllPlayersAffected(p)
			p.shockWaveCharge = 0

		end

		::continue::
	end
  return false
end

state.Draw = function(self)

	love.graphics.setColor(0.4, 0.4, 0.4, 1.0)
    love.graphics.circle("fill", width / 2, height / 2, playFieldRadius, 69)
   
    for k, p in ipairs(PlayerManager.alivePlayers) do
    	p:Draw()
	end

    for k, p in ipairs(PlayerManager.alivePlayers) do
	    	if p.shockWaveCharge ~= 0 then
    		love.graphics.setColor(1.0, 1.0, 1.0, 0.6)
    		love.graphics.circle("fill", p.x, p.y, p.shockWaveCharge, 16)

    		love.graphics.setColor(0.0, 0.0, 0.0, 1.0)
    		love.graphics.circle("line", p.x, p.y, p.shockWaveCharge, 16)
    	end	
    end
end

state.OnLeave = function(self)
  	for k, p in ipairs(PlayerManager.players) do
  		p.wh = 32
	end
	
end

return state