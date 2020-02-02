local state = {}
state.name = "Shoot!"
local targets = {}
local isDead = {}

local gameIsFinished = false
local timeToReturn = 2
local scoreGiven = false

state.AddSmoke = function(x, y)
    local newParticle = CreateParticleStruct()

    newParticle.minSpeed = 10
    newParticle.maxSpeed = 90

    newParticle.color.r = 0.7
    newParticle.color.g = 0.7
    newParticle.color.b = 0.7
    newParticle.color.a = 1


    newParticle.shape = 5
    newParticle.startSize = 400
    newParticle.endSize = 2000
    newParticle.lifetime = 5

    newParticle.angle = 0
    newParticle.spread = 6.28
    newParticle.gravity.y = -1
    newParticle.fadeSpeed = 0.06

    ParticleManager:SpawnParticle(newParticle,10,{x=x,y=y})
end

state.Update = function(self, dt)

    if not scoreGiven and gameIsFinished then
        for k, p in ipairs(PlayerManager.alivePlayers) do
            p:AddScore()
        end
        scoreGiven = true
    end

    if gameIsFinished then
        timeToReturn = timeToReturn - dt
        if timeToReturn < 0 then return true end
    end

    for k,p in ipairs(PlayerManager:GetPlayers()) do
        if p:GetPressed() and isDead[k] == false then
            self.AddSmoke(p.x, p.y)
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
            love.graphics.setLineWidth(5)
            p:Draw()
            local playerTargetIndex = targets[k]
            if(isDead[playerTargetIndex] == false) then
                local playerTarget = PlayerManager:GetPlayers()[playerTargetIndex]
                love.graphics.line(p.x,p.y,playerTarget.x,playerTarget.y)
            end
        end
    end
end

state.OnEnter = function()
    timeToReturn = 2
    scoreGiven = false
    gameIsFinished = false
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
