local state = {}

local xOffset = 32
local yOffset = 32

state.OnEnter = function(self)
    for k, p in ipairs(PlayerManager:GetAllPlayers()) do
        p.x = xOffset + p.controllerId * width / 4
        p.y = yOffset + p.colorIndex * height / 5
    end
end

state.Update = function(self, dt)
    for k, p in ipairs(PlayerManager:GetAllPlayers()) do
        if p:GetPressed() then
            PlayerManager:JoinGame(k)
        end
    end
    return false
end

state.Draw = function(self)
    PlayerManager:Draw()
    local text = "Press a button to join!"
    local w = font:getWidth(text)
    local h = font:getHeight(text)
    love.graphics.print(text, 1280/2, 720/2, textRot, textScale, textScale, w/2, h/2, 0, 0)
end

state.OnLeave = function(self)

end

return state
