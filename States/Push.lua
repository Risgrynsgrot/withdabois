local state = { }
state.name = "Push!"

local playFieldRadius = 316
local playerSpawnRadius = 256

local friction = 1.2
local growthRate = 40.0

local baseSpeed = 1000.0

local newParticle = CreateParticleStruct()

local winTimer = 2.0

function lerp(a,b,t) return (1-t)*a + t*b end

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
	winTimer = 2
	
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
  
 	growthRate = 40.0 * (20 / #PlayerManager.alivePlayers)

	if #PlayerManager.alivePlayers <= 1 then

		if winTimer == 2 then
			for k, p in ipairs(PlayerManager.alivePlayers) do
				p:AddScore()
			end
		end

		winTimer = winTimer - dt

		if winTimer <= 0 then
	    	return true
		end
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
			p.wh = lerp(p.wh, 20, 0.2)
			p.x = p.x + love.math.random(-1, 1)
			p.y = p.y + love.math.random(-1, 1)

		end

		if p:GetReleased() then

			newParticle.minSpeed = p.shockWaveCharge * 2.0
  			newParticle.maxSpeed = p.shockWaveCharge * 3.0
			
    		newParticle.shape = 7
    		newParticle.startSize = 10
    		newParticle.endSize = 0
    		newParticle.lifetime = 2
    		
    		newParticle.angle = 0
    		newParticle.spread = 6.28
			newParticle.gravity.y = 0

  			newParticle.color.r = p.color.r
  			newParticle.color.g = p.color.g
  			newParticle.color.b = p.color.b
  			newParticle.color.a = 0.6

			ParticleManager:SpawnParticle(newParticle, p.shockWaveCharge * 0.8, {x=p.x,y=p.y})

			GetAllPlayersAffected(p)
			p.shockWaveCharge = 0
		end

			p.wh = lerp(p.wh, 32, 0.15)


		::continue::
	end
  return false
end

state.Draw = function(self)

	love.graphics.setColor(0.4, 0.4, 0.4, 1.0)
    love.graphics.circle("fill", width / 2, height / 2, playFieldRadius, 69)
   
    for k, p in ipairs(PlayerManager.alivePlayers) do
	    	if p.shockWaveCharge ~= 0 then

    		love.graphics.setColor(1.0, 1.0, 1.0, 0.4)
    		love.graphics.circle("fill", p.x, p.y, p.shockWaveCharge, 32)

    		love.graphics.setColor(0.0, 0.0, 0.0, 1.0)
    		love.graphics.circle("line", p.x, p.y, p.shockWaveCharge, 32)

    	end	
    end

    for k, p in ipairs(PlayerManager.alivePlayers) do
    	p:Draw()
	end
end

state.OnLeave = function(self)
  	for k, p in ipairs(PlayerManager.players) do
  		p.wh = 32
	end
	
end

return state