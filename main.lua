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
  sm:Update(dt)
  ParticleManager:Update(dt)
end

function love.draw()

if love.window.getFullscreen() == true then
  local sw, sh = love.window.getDesktopDimensions()
  love.graphics.scale(sw / width, sh / height)
  sm:Draw()
  ParticleManager:Draw(dt)
  love.graphics.scale(1, 1)
  else 
  sm:Draw()
  ParticleManager:Draw(dt)
  end
  
end
