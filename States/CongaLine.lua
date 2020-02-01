local state = {}

state.speed = 100
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
  if  self.timer > 20 then
    
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
                
                --if collisionDot <= self.alignmentToConga and
                --cv.front == 0 and
                --v.back == 0 then
                --  v.front = ck
                --  cv.back = k
                --end
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
  
        if v:GetInput() then
          dir = dir + 1
        else
          dir = dir - 1
        end
  
        while PlayerManager.alivePlayers[currentPlayer].back ~= 0 and PlayerManager.alivePlayers[currentPlayer].back ~= k do
          currentPlayer = PlayerManager.alivePlayers[currentPlayer].back
          if PlayerManager.alivePlayers[currentPlayer]:GetInput() then
            dir = dir + 1
          else
            dir = dir - 1
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
  self.endTimer = self.endTimer + dt
  
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
          end         
        end
      end
      
      local currentPlayer = self.longestHead.id
      while PlayerManager.alivePlayers[currentPlayer].back ~= 0 do
        currentPlayer = PlayerManager.alivePlayers[currentPlayer].back
      end
      
    end
  
  if  self.endTimer > 1 then
    return true
  end
  
  end
  
  return false
end




state.Draw = function(self)
  love.graphics.setColor(1,1,1,1)
  PlayerManager:Draw()
  for k,v in ipairs(PlayerManager.alivePlayers) do
    love.graphics.print(k ..  " f: " .. v.front .. "  b: " .. v.back,v.x + 50,v.y + 50)
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

  for k,v in ipairs(PlayerManager.players) do
    v.wh = 24
    v.front = 0
    v.back = 0
    v.moved = false
    
    local radiusOffset = RandomFloat(0.5,1.5)
    
    local val = (k/20)*2*3.14 
    v.x = RandomFloat(0,width)
    v.y = RandomFloat(0,height)
    v.r = val *RandomFloat(0.5,1.5)
    
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
  end
end

return state