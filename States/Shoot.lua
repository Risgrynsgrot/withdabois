local state = {}

local targets = {}


state.Update = function(self, dt)
    for k,p in ipairs(PlayerManager:GetPlayers()) do
        if p:GetPressed() and p.isAlive == true then
            local playerTarget = PlayerManager:GetPlayers()[targets[k]]
            PlayerManager:EliminatePlayer(playerTarget)
        end
    end
    return false
end

state.Draw = function(self)
    for k,p in ipairs(PlayerManager:GetPlayers()) do
        --if p.isAlive then
            local playerTarget = PlayerManager:GetPlayers()[targets[k]]
            --if(playerTarget.isAlive) then
                love.graphics.line(p.x,p.y,playerTarget.x,playerTarget.y)
            --end
        --end
    end
    PlayerManager:Draw()
end

state.OnEnter = function()
    for k,p in ipairs(PlayerManager:GetPlayers()) do
        targets[k] = k
        local val = (k/#PlayerManager.alivePlayers)*2*3.14
        local playerRadius = 200
        p.x = width / 2 + math.cos(val) * playerRadius
        p.y = height / 2 + math.sin(val) * playerRadius
        p.r = 0
    end

    isShuffled = false
    while not isShuffled do
        for i = 1, #targets do
            temp = love.math.random(#targets)
            tempValue = targets[temp]
            targets[temp] = targets[i]
            targets[i] = tempValue
        end
        for i = 1, #targets do
            if targets[i] == i then
                break
            end
        end
        isShuffled = true
    end
end

state.OnLeave = function()

end

return state
