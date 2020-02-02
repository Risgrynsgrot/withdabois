local state = {}
state.name = "ZigZag!"
local walls = {}
local timer = 0
local wallTimer = 2
local wallTime = 3

local jumpForce = 300
local wallSpeed = 150
local playerSpeed = 150

local wallSide = false


local gravity = 0

local createWall = function(diff, seed)
	wall = {}
  wall.height = height/5
	wall.y = -wall.height
	wall.space = diff --  height - love.math.random(height)/diff - height * 0.3
  if wallSide then
   --	wall.x = (0.2 * width + love.math.noise(seed) * diff) -- love.math.random(wall.space*2)
       	wall.x = (0.2 * width + love.math.noise(seed) * width / 2) -- love.math.random(wall.space*2)

    wall.x2 = wall.x + diff
    wallSide = false
  else
   --	wall.x2 = (0.8 * width - love.math.noise(seed) * diff) -- love.math.random(wall.space*2)
       	wall.x2 = (0.8 * width - love.math.noise(seed) * width / 2) -- love.math.random(wall.space*2)

    wall.x = wall.x2 - diff
    wallSide = true
  end
  
  wall.Collision = function(self,p)
    if  (p.x < (self.x + p.wh) and
        p.y > (self.y - p.wh) and
        p.y < (self.y + self.height + p.wh)) or
        (p.x > (self.x2 - p.wh) and
        p.y > (self.y - p.wh) and
        p.y < (self.y + self.height + p.wh)) then
          return true
    end
    return false
  end
  
	return wall
end

state.OnEnter = function(self)
  diff = 0
  timer = 0
  walls = {}
  
  local count = #PlayerManager.alivePlayers
  
  for k,p in ipairs(PlayerManager.alivePlayers) do
    p.x =  (width - 200) * k /count
    p.y = height - 100
    p.dir = 0 
    if (p.x - width /2) > 0 then
      p.dir = -1
    else
      p.dir = 1
    end
  end
end

state.Update = function(self, dt)
	timer = timer + dt
	local diff = timer * 0.1 + 1
  diff = diff 
	wallTimer = wallTimer + dt * diff
	if wallTimer > wallTime then
		wallTimer = 0
		table.insert(walls, createWall(math.max(width / diff,50),diff))
	end

	for k,wall in ipairs(walls) do
		wall.y = wall.y + dt * diff * wallSpeed
	end

 	for k,p in ipairs(PlayerManager.alivePlayers) do
		if p:GetPressed() then
			p.dir = -p.dir
		end
		p.x = p.x + p.dir * playerSpeed * dt * math.pow(diff,1.01)
		if p.x - p.wh*2 > width  or p.x + p.wh < 0 then
			PlayerManager:EliminatePlayer(p)
		end

		for j,wall in ipairs(walls) do
      if wall:Collision(p) then
				PlayerManager:EliminatePlayer(p)
			end
		end
	end	

	if #PlayerManager.alivePlayers < 2 then
	 	for k,p in ipairs(PlayerManager.alivePlayers) do
			p:AddScore()
		end	
		return true
	end
  	return false
end

state.Draw = function(self)
	for k,wall in ipairs(walls) do
		love.graphics.setColor(1, 1, 1, 1)
		love.graphics.rectangle("fill", 0, wall.y, wall.x, wall.height)

    love.graphics.rectangle("fill", wall.x2, wall.y,  width, wall.height)
	end
 	PlayerManager:Draw()
end

state.OnLeave = function(self)
  	for k,p in ipairs(PlayerManager:GetPlayers()) do
			p.v = nil
	end	
end

return state