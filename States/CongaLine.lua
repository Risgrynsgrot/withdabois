local state = {}

state.speed = 10
state.turningSpeed = 1

state.Update = function(self, dt)
  for k,v in ipairs(PlayerManager.alivePlayers) do
    v.x = v.x + math.cos(v.r) * dt * self.speed
    v.y = v.y + math.sin(v.r) * dt * self.speed
  end
  
  return false
end

state.Draw = function(self)
  PlayerManager:Draw()
end


state.OnEnter = function(self)
  	local playerRadius = 200
  for k,v in ipairs(PlayerManager.players) do
    v.front = 0
    v.back = 0
    
    local val = (k/20)*2*3.14 
    v.x = width / 2 + math.cos(val) * playerRadius
    v.y = height / 2 + math.sin(val) * playerRadius
    v.r = val
    
  end
end

state.OnLeave = function(self)
  
end

return state