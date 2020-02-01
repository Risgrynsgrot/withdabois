local state = {}

state.speed = 200
state.turningSpeed = 1
state.alignmentToConga = 0.5

state.Collision = function(self, firstPlayer, firstForwardVector, secondPlayer)
  local diff = {}
    diff.x = firstPlayer.x + firstForwardVector.x - secondPlayer.x
    diff.y = firstPlayer.y + firstForwardVector.x - secondPlayer.y
  
  local diffLength = math.sqrt(diff.x * diff.x + diff.y * diff.y)
  
  return (firstPlayer.wh + secondPlayer.wh) > diffLength
end

local Dot = function(firstVector, secondVector)
  return  firstVector.x * secondVector.x + firstVector.y * secondVector.y
end

local Length = function(aVector)
  return math.sqrt(aVector.x*aVector.x + aVector.y * aVector.y)
end

local GetNoramlized = function(vector)
  local returnVector = {}
  
  local vectorLength = math.sqrt(vector.x * vector.x + vector.y * vector.y)

  returnVector.x = vector.x / vectorLength
  returnVector.y = vector.y / vectorLength
  
  
  return  returnVector
end


state.Update = function(self, dt)
  self.timer = self.timer + dt
  if  self.timer < 20 then
    
    for k,v in ipairs(PlayerManager.alivePlayers) do
      v.moved = false
      if v.front == 0 then
        local collided = false
        
        local forward = {}
        forward.x =math.cos(v.r) * dt * self.speed
        forward.y =math.sin(v.r) * dt * self.speed
        
        for ck,cv in ipairs(PlayerManager.alivePlayers) do
          if ck ~= k and v.front ~= ck and v.back ~= ck then
            if not collided then
              collided = self:Collision(v,forward,cv)
              if collided then
                local cdiff = {}
                cdiff.x = cv.x - v.x
                cdiff.y = cv.y - v.y
                
                cdiff = GetNoramlized(cdiff)
                
                local collisionDot = Dot(forward,cdiff)
                
                if collisionDot >= self.alignmentToConga and
                  v.front == 0 and
                  cv.back == 0 then
                  v.front = ck
                  cv.back = k
                end
                
                local cforward = {}
                cforward.x = math.cos(cv.r) * dt * self.speed
                cforward.y = math.sin(cv.r) * dt * self.speed
                
                collisionDot = Dot(cforward,cdiff)
                
               
              end
              
            end
          end
        end
        if not collided then
          v.moved = true
          v.x = v.x + forward.x
          v.y = v.y + forward.y
        end
        
        v.y = math.max(math.min(v.y,height),0)
        v.x = math.max(math.min(v.x,width),0)
        
        local dir = 0
        
        local currentPlayer = k
  
        v.turning = 0
  
        if v:GetInput() then
          dir = dir + 1
          v.turning = 1
        else
          dir = dir - 1
          v.turning = -1
        end
        
        local backVector = {
          x = 0,
          y = 0
        }
        
        while PlayerManager.alivePlayers[currentPlayer].back ~= 0 and PlayerManager.alivePlayers[currentPlayer].back ~= k do
          currentPlayer = PlayerManager.alivePlayers[currentPlayer].back
          PlayerManager.alivePlayers[currentPlayer].turning = 0
          if PlayerManager.alivePlayers[currentPlayer]:GetInput() then
            dir = dir + 1
            PlayerManager.alivePlayers[currentPlayer].turning = 1
          else
            dir = dir - 1
            PlayerManager.alivePlayers[currentPlayer].turning = -1
          end
        end
        
        if dir >0 then
          v.r = math.fmod(v.r + self.turningSpeed * dt, 6.28)
        else
          v.r = math.fmod(v.r - self.turningSpeed * dt, 6.28)
        end
      end
    end
    
    for k,v in ipairs(PlayerManager.alivePlayers) do
      if v.front ~= 0 and v.back == 0 then
        --print("hello")
        local currentPlayer = k
        while PlayerManager.alivePlayers[currentPlayer].front ~= 0 and PlayerManager.alivePlayers[currentPlayer].front ~= k do
          currentPlayer = PlayerManager.alivePlayers[currentPlayer].front
        end
      
      
        while PlayerManager.alivePlayers[currentPlayer].back ~= 0 do
          currentPlayer = PlayerManager.alivePlayers[currentPlayer].back
        
          local frontPlayer = PlayerManager.alivePlayers[PlayerManager.alivePlayers[currentPlayer].front]
        
          local diff = {}
          diff.x = frontPlayer.x - PlayerManager.alivePlayers[currentPlayer].x
          diff.y = frontPlayer.y - PlayerManager.alivePlayers[currentPlayer].y
        
        
          diff = GetNoramlized(diff)
        
          PlayerManager.alivePlayers[currentPlayer].x = frontPlayer.x - diff.x * frontPlayer.wh * 2
          PlayerManager.alivePlayers[currentPlayer].y = frontPlayer.y - diff.y * frontPlayer.wh * 2
          PlayerManager.alivePlayers[currentPlayer].r = math.atan2(diff.y,diff.x)

        end
      end
      
    end
  
else
  
    if self.longestHead.id == 0 then
      for k,v in ipairs(PlayerManager.alivePlayers) do
        if v.back == 0 then
          
          local congaLength = 1
          local currentPlayer = k
          
          while PlayerManager.alivePlayers[currentPlayer].back ~= 0 do
            congaLength = congaLength + 1
            currentPlayer = PlayerManager.alivePlayers[currentPlayer].back
          end
          
          if self.longestHead.length < congaLength then
            self.longestHead.id = k
            self.longestHead.length = congaLength
          end         
        end
      end
      
      local currentPlayer = self.longestHead.id
      PlayerManager.alivePlayers[currentPlayer]:Jump()
      while PlayerManager.alivePlayers[currentPlayer].back ~= 0 do
        currentPlayer = PlayerManager.alivePlayers[currentPlayer].back
        PlayerManager.alivePlayers[currentPlayer]:Jump()
      end
      
    end
  
  
  if  self.endTimer > 1 then
    return true
  end

  
  self.endTimer = self.endTimer + dt

  
  end
  
  return false
end




state.Draw = function(self)
  love.graphics.setColor(1,1,1,1)
  love.graphics.print(self.timer,0,0)
  
  for k,v in ipairs(PlayerManager.alivePlayers) do
    v:Draw()
    
    local forward = {
      x = math.cos(v.r),
      y = math.sin(v.r)
    }
    
    
    local forwardNormal = {
      x = -forward.y,
      y = forward.x
    }
    
    if v.turning == 1 then
      forwardNormal.x = forwardNormal.x + forward.x * math.sin(self.timer) * 0.5
      forwardNormal.y = forwardNormal.y + forward.y * math.sin(self.timer) * 0.5
    elseif v.turning == -1 then
      forwardNormal.x = -forwardNormal.x + forward.x * math.sin(self.timer) * 0.5
      forwardNormal.y = -forwardNormal.y + forward.y * math.sin(self.timer) * 0.5
    else
      forwardNormal.x = 0
      forwardNormal.y = 0
    end
    
    love.graphics.circle("fill", v.x + forwardNormal.x * v.wh , v.y + forwardNormal.y * v.wh,v.wh/4)
  
  end
end

function RandomFloat(min, max, precision)
	local range = max - min
	local offset = range * math.random()
	local unrounded = min + offset

	if not precision then
		return unrounded
	end

	local powerOfTen = 10 ^ precision
	return math.floor(unrounded * powerOfTen + 0.5) / powerOfTen
end

state.OnEnter = function(self)
  	local playerRadius = 200

  local x = 0
	local y = 0

  for k,v in ipairs(PlayerManager.players) do
    v.wh = 24
    v.front = 0
    v.back = 0
    v.moved = false
    v.turning = 0
    
    x = x + (width  - v.wh * 2) / #PlayerManager.alivePlayers
  	y = (y + height / 3) % height
	  v.x = x
	  v.y = y + v.wh * 4
	  v.r = love.math.random(0, 3.141592653589793238462643383279 * 2)

    
  end
  
  state.timer = 0
  self.endTimer = 0
  self.longestHead = {
    id = 0,
    length = 0
  }
end

state.OnLeave = function(self)
  for k,v in ipairs(PlayerManager.players) do
    v.wh = 32
    v.front = nil
    v.back = nil
    v.moved = nil
    v.turning = nil
  end
end

return state