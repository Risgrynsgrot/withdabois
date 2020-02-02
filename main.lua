require("CreatePlayer")
PlayerManager = require("PlayerManager")
ParticleManager = require("ParticleManager")
local sm = require("StateManager")
font = love.graphics.newFont("soupofjustice.ttf", 120)
height = 720
width = 1280
love.graphics.setLineWidth(5)
gameover = false
local timeStamp = love.timer.getTime()

function love.load()
	gameover = false
    music = love.audio.newSource('mainSong.wav', 'static')
    music:setLooping(true)
    music:play()
  love.math.setRandomSeed(love.timer.getTime())
  love.graphics.setFont(font)
  joystick = love.joystick.getJoysticks()[1]
  PlayerManager:Init()
  sm:Init()
end

function love.update(dt)
    music:setPitch(1 + (love.timer.getTime() - timeStamp) * 0.001)
  sm:Update(dt)
  ParticleManager:Update(dt)
end

function love.draw()
  sm:Draw()
  ParticleManager:Draw(dt)
end
