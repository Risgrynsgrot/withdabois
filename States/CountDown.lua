local state = {}

local timers = {}
local stopped = {}
local time = 0
local targetTime = 5


state.OnEnter = function(self)
    time = 0
    for k,p in ipairs(PlayerManager:GetPlayers()) do
        stopped[k] = false
        timers[k] = 0
    end
end

state.Update = function(self, dt)
    for k, p in ipairs(PlayerManager:GetPlayers()) do
        if p:GetPressed() and stopped[k] == false then
            timers[k] = time
            stopped[k] = true
        end
    end
    time = time + dt
    return false
end

state.Draw = function(self)
    for k, p in ipairs(PlayerManager:GetPlayers()) do
        p.x = width / #PlayerManager:GetPlayers() * k - 1
        p.y = height * 0.75
        p:Draw()
    --love.graphics.print(timers[k], (width / #PlayerManager:GetPlayers()) * k, 300)
    end
    love.graphics.print(time, width / 2, height / 2)
end

state.OnLeave = function(self)

end

return state
