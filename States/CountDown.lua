local state = {}

local timers = {}
local stopped = {}
local score = {}
local time = 0
local targetTime = 10
local alpha = 0
local alphaTime = targetTime / 2
local ended = false
local endTimer = 5


state.OnEnter = function(self)
    for k, p in ipairs(PlayerManager:GetPlayers()) do
        p.x = width / #PlayerManager:GetPlayers() * k - (p.wh)
        p.y = height * 0.75
    end
    ended = false
    time = targetTime
    for k,p in ipairs(PlayerManager:GetPlayers()) do
        stopped[k] = false
        timers[k] = 0
    end
end

function End()

    for k, p in ipairs(PlayerManager:GetPlayers()) do
        p.x = width / #PlayerManager:GetPlayers() * (k - 1)
        p.y = height / 2 + timers[k] * 100
    end
    ended = true
end
state.Update = function(self, dt)

    if ended then
        endTimer = endTimer - dt
    end
    if endTimer < 0 then
        return true
    end
    if time > 0 then
        alpha = math.max(1 - (alphaTime / time), 0)
    end

    if time < -targetTime / 2  and not ended then
        for k, p in ipairs(PlayerManager:GetPlayers()) do
            stopped[k] = true
        end
        End()
    end

    for k, p in ipairs(PlayerManager:GetPlayers()) do
        if p:GetPressed() and stopped[k] == false then
            timers[k] = time
            stopped[k] = true
        end
    end
    if not ended then
        time = time - dt
    end
    return false
end

state.Draw = function(self)
    if ended then
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.line(0, height / 2, width, height / 2)
    end
    for k, p in ipairs(PlayerManager:GetPlayers()) do
        p:Draw()
    end
    love.graphics.setColor(1, 1, 1, alpha)
    love.graphics.print(time, width / 2, height / 2)
end

state.OnLeave = function(self)

end

return state
