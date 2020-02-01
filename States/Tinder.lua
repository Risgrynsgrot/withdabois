local state = {}
state.name = "Tinder!"
local unpairedPlayers = { }
local pairedPlayers = { }

local playerState = {
	dirSelect = 1,
	walking = 2,
	matched = 3
}

local winCondition = false
local winTimer = 20

local timer = 2

local tablefind = function(tab,el)
	for index, value in pairs(tab) do
	     if value == el then
	         return index
	     end
	 end
end

local DrawPlayerWithArrow = function(self, x, y)

		oldX = self.x
		oldY = self.y

		self.x = x 
		self.y = y

		self:Draw()

		self.x = oldX
		self.y = oldY
end

local CheckCollision = function(self)

	for k, p in pairs(unpairedPlayers) do

		if p == self then
		    goto continue
		end

		distance = math.sqrt(math.pow(self.x - p.x, 2) + math.pow(self.y - p.y, 2))

		if distance <= (p.wh + p.wh) then
		    return p
		end

		::continue::
	end

	return nil
end

state.OnEnter = function(self)

	x = 0
	y = 0
  	for k, p in ipairs(PlayerManager.alivePlayers) do
  		x = x + (width  - p.wh * 2) / #PlayerManager:GetPlayers()
  		y = (y + height / 3) % height
	  	p.x = x
	  	p.y = y + p.wh * 4
	  	p.r = love.math.random(0, 3.141592653589793238462643383279 * 2)

	  	p.state = playerState.dirSelect
	  	table.insert(unpairedPlayers, p)
	end
end

state.Update = function(self, dt)
  
	if winCondition == true then
		timer = timer - dt
		if timer <= 0 then
		    return true
		end
		return false	   
	end

  	for k, p in pairs(PlayerManager:GetPlayers()) do
  		
  		if p.state == playerState.dirSelect then
  		    p.r = p.r + dt * 4

  		    if p:GetPressed() then
  		        p.state = playerState.walking
  		        goto continue
  		    end
  		end

  		if p.state == playerState.walking then

  			if p:GetPressed() then
  		        p.state = playerState.dirSelect
  		        goto continue
  		    end

  		    p.x = p.x + math.cos(p.r) * 4
  		    p.y = p.y + math.sin(p.r) * 4

  		    p.x = p.x % width
  		    p.y = p.y % height


  		    other = CheckCollision(p)
  		    if other ~= nil then
  		        p.state = playerState.matched
  		        other.state = playerState.matched

  		        table.remove(unpairedPlayers, tablefind(unpairedPlayers, other))
  		        table.remove(unpairedPlayers, tablefind(unpairedPlayers, p))

  		        table.insert(pairedPlayers, other)
				table.insert(pairedPlayers, p)

				goto continue
  		    end
  		end

  		if p.state == playerState.matched then
  		    
  		end

  		  ::continue::
  	end

	winTimer = winTimer - dt
  	winCondition = (winTimer <= 0)

  return false
end

state.Draw = function(self)
	love.graphics.setColor(1,1,1,1)
  	love.graphics.print(string.sub(winTimer, 0, 3),10,10)

	for i = 1, #pairedPlayers, 2 do

		p = pairedPlayers[i]
		p2 = pairedPlayers[i + 1]

		px = (p.x + p2.x) * 0.5 
		py = (p.y + p2.y) * 0.5

    	love.graphics.push()
			love.graphics.setColor(1, 0, 1, 1)
	
				love.graphics.circle("fill", px, py, p.wh, 4)
				angle = -3.14159265358 / 4
	
				radius = p.wh * 0.5* math.sqrt(2)
	    	  	love.graphics.circle("fill", px + math.cos(angle) * radius, py + math.sin(angle)* radius, radius, 20)
	
				angle = 3.14159265358 / 4 + 3.14159265358
	    	  	love.graphics.circle("fill", px + math.cos(angle) * radius, py + math.sin(angle)* radius, radius, 20)
		love.graphics.pop()
	end

  	for k, p in pairs(unpairedPlayers) do
		for x= -1, 1 do
			for y= -1, 1 do
				if x ~= y then
					DrawPlayerWithArrow(p, p.x + width * x, p.y + height * y)				
				end
			end
		end

		DrawPlayerWithArrow(p, p.x, p.y)
	end

	if winCondition == true then
		love.graphics.setColor(1, 1, 1, 1)
  		local text = "Time's up!"
  		local w = font:getWidth(text)
  		local h = font:getHeight(text)
  		love.graphics.print(text, width/2, height/2, 0, 1, 1, w/2, h/2, 0, 0)
  	end

end

state.OnLeave = function(self)
    	for k, p in pairs(PlayerManager:GetPlayers()) do
    		p.state = nil
    		p.r = 0
	end
end

return state