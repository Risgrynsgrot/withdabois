local state = {}

local targets = {}
local isDead = {}

local gameIsFinished = false
local timeToReturn = 2

state.Update = function(self, dt)
    if gameIsFinished then
        timeToReturn = timeToReturn - dt
        if timeToReturn < 0 then return true end
    end

    for k,p in ipairs(PlayerManager:GetPlayers()) do
        if p:GetPressed() and isDead[k] == false then
            local playerTarget = PlayerManager:GetPlayers()[targets[k]]
            isDead[targets[k]] = true
            PlayerManager:EliminatePlayer(playerTarget)
        end
    end
    gameIsFinished = true
    for k, p in ipairs(PlayerManager:GetPlayers()) do
        if isDead[k] == false then
            if isDead[targets[k]] == false then
                gameIsFinished = false
            end
        end
    end
    return false
end

state.Draw = function(self)
    for k,p in ipairs(PlayerManager:GetPlayers()) do
        if isDead[k] == false then
            local playerTargetIndex = targets[k]
            if(isDead[playerTargetIndex] == false) then
                local playerTarget = PlayerManager:GetPlayers()[playerTargetIndex]
                love.graphics.line(p.x,p.y,playerTarget.x,playerTarget.y)
            end
        end
    end
    PlayerManager:Draw()
end

state.OnEnter = function()
    for k,p in ipairs(PlayerManager:GetPlayers()) do
        targets[k] = k
        isDead[k] = false
        local val = (k/#PlayerManager.alivePlayers)*2*3.14
        local playerRadius = 300
        p.x = width / 2 + math.cos(val) * playerRadius
        p.y = height / 2 + math.sin(val) * playerRadius
        p.r = 0
    end

    isShuffled = false
    while not isShuffled do
        isShuffled = true
        for i = 1, #targets do
            temp = love.math.random(#targets)
            tempValue = targets[temp]
            targets[temp] = targets[i]
            targets[i] = tempValue
        end
        for i = 1, #targets do
            if targets[i] == i then
                isShuffled = false
                break
            end
        end
    end
end

state.OnLeave = function()

end

return state
