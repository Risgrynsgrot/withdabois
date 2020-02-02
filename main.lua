require("CreatePlayer")
PlayerManager = require("PlayerManager")
ParticleManager = require("ParticleManager")
local sm = require("StateManager")
font = love.graphics.newFont("soupofjustice.ttf", 120)
height = 720
width = 1280
love.graphics.setLineWidth(5)

function love.load()
  love.math.setRandomSeed(love.timer.getTime())
  love.graphics.setFont(font)
  joystick = love.joystick.getJoysticks()[1]
  PlayerManager:Init()
  sm:Init()
  

end

function love.update(dt)
  sm:Update(dt)
  ParticleManager:Update(dt)
end

function love.draw()
  sm:Draw()
  ParticleManager:Draw(dt)
end