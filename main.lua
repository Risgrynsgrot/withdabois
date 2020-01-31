require("CreatePlayer")
PlayerManager = require("PlayerManager")
local sm = require("StateManager")

height = 720
width = 1280


function love.load()
  joystick = love.joystick.getJoysticks()[1]
  PlayerManager:Init()
  sm:Init()
end

function love.update(dt)
  sm:Update(dt)
end

function love.draw()
  sm:Draw()
end