local state = {}

local targets = {}


state.Update = function(self, dt)

    return false
end

state.Draw = function(self)

end

state.OnEnter = function()
    for k,p in ipairs(PlayerManager:GetPlayers()) do
        local val = (k/20)*2*3.14
        p.x = 1280 / 2 + math.cos(val) * playerRadius
        p.y = 720 / 2 + math.sin(val) * playerRadius
        p.r = 0
    end
end

state.OnLeave = function()

end

return state
