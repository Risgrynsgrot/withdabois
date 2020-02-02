local state = {}
state.name = "Lobby!"

local xOffset = 64
local yOffset = 128

state.OnEnter = function(self)
    for k, p in ipairs(PlayerManager:GetAllPlayers()) do
        p.x = width / 8 + (p.controllerId - 1) * width / 4
        p.y = height / 3 + (p.colorIndex - 1) * height / 8
    end
end

state.Update = function(self, dt)
    for k, p in ipairs(PlayerManager:GetAllPlayers()) do
        if p:GetPressed() then
            local joined = false
            for k2, p2 in ipairs(PlayerManager:GetPlayers()) do
                if p2 == p then
                    joined = true
                    break
                end
            end
            if not joined then
                PlayerManager:JoinGame(k)
            end
        end
    end
    return love.keyboard.isDown("space")
end

state.Draw = function(self)
    PlayerManager:Draw()
    local text = "Press a button to join!"
    local w = font:getWidth(text)
    local h = font:getHeight(text)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print(text, width/2, height/5, textRot, textScale, textScale, w/2, h/2, 0, 0)
end

state.OnLeave = function(self)

end

return state
