local state = { }
state.name = "Vacuum the Ball!"
state.timer = 2
local Dot = function(firstVector, secondVector)
  return  firstVector.x * secondVector.x + firstVector.y * secondVector.y
end

local ball = {

	x = width / 2,
	y = height / 2,

	vx = 0,
	vy = 0,

	radius = 64,
	angle = 0,

	color = { }
}

local winCondition = false
local winColor = {
	r,
	g,
	b
}


local playFieldRadius = 300
local givenPoint = false

local newParticle = CreateParticleStruct()


state.OnEnter = function(self)


	ball = {  

	x = width / 2,
	y = height / 2,

	vx = 0,
	vy = 0,

	radius = 64,
	angle = 0,

	color = { }

}

ball.color.r = 1
ball.color.g = 1
ball.color.b = 1

	playFieldRadius = 300
	winCondition = false
	state.timer = 2
	givenPoint = false
	for k, p in ipairs(PlayerManager.alivePlayers) do
		local val = (k/#PlayerManager:GetPlayers())*2*3.14 

	  	p.x = width / 2 + math.cos(val) * playFieldRadius
	  	p.y = height / 2 + math.sin(val) * playFieldRadius
	  	p.r = 0
	end
  
  self.winner = nil
end


state.Update = function(self, dt)

  if self.winner ~= nil then
    self.winner:Jump()
  end

	if winCondition == true then
		if 	givenPoint == false then
		    self.winner:AddScore()
		    givenPoint = true
		end
    self.timer = self.timer - dt
    if self.timer > 0 then 
      return false
    end
	end
  
  if self.timer < 0 then
    return true
  end

	for k, p in ipairs(PlayerManager.alivePlayers) do
		if p:GetPressed() then
			angle = -math.atan2 ( ball.y - p.y, p.x - ball.x) 

			p:Jump()

			ball.angle = angle

			ball.vx = ball.vx + math.cos(angle) 
			ball.vy = ball.vy + math.sin(angle) 

			ball.color = p.color

			newParticle.minSpeed = 100
  			newParticle.maxSpeed = 600
			
    		newParticle.shape = 7
    		newParticle.startSize = 14
    		newParticle.endSize = 0
    		newParticle.lifetime = 0.7
    		
    		newParticle.angle = angle
    		newParticle.spread = 0.05
			newParticle.gravity.y = 0

  			newParticle.color.r = p.color.r
  			newParticle.color.g = p.color.g
  			newParticle.color.b = p.color.b
  			newParticle.color.a = 0.6

			ParticleManager:SpawnParticle(newParticle, 8, {x=ball.x,y=ball.y})
		end

		distance = math.sqrt(math.pow(ball.x - p.x, 2) + math.pow(ball.y - p.y, 2))

		if distance <= p.wh + ball.radius then
		    winCondition = true
        self.winner = p
		    winColor.r = p.color.r
		    winColor.g = p.color.g
		    winColor.b = p.color.b

		end
	end

	playFieldDistance = math.sqrt(math.pow(ball.x - width / 2, 2) + math.pow(ball.y - height / 2, 2))

		--if the ball hits the arena limit
		if playFieldDistance >= playFieldRadius - ball.radius then

			--I - 2.0 * dot(N, I) * N.
			diff = {
				x = width / 2 - ball.x,
				y = height / 2 - ball.y
			}

			length = math.sqrt(diff.x * diff.x + diff.y * diff.y)
			diff.x = diff.x / length
			diff.y = diff.y / length

			ballVel = {
				x = ball.vx, 
				y = ball.vy
			}

			ball.vx = ball.vx - 2.0 * Dot(diff, ballVel) * diff.x
			ball.vy = ball.vy - 2.0 * Dot(diff, ballVel) * diff.y

		end

	ball.x = ball.x + ball.vx
	ball.y = ball.y + ball.vy

  return false
end

state.Draw = function(self)
	love.graphics.setColor(1, 1, 1, 1)
 	love.graphics.circle("line", width / 2, height / 2, playFieldRadius, 64)
	for k, v in pairs(PlayerManager:GetPlayers()) do
		v:Draw()
	end

	love.graphics.setColor(ball.color.r, ball.color.g, ball.color.b, 1)
	love.graphics.circle("fill", ball.x, ball.y, ball.radius, 32)


end

state.OnLeave = function(self)
  	
end

return state