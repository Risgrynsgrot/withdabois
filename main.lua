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
  --local newParticle = CreateParticleStruct()
  --
  --newParticle.minSpeed = 50
  --newParticle.maxSpeed = 200

  --newParticle.color.r = 0.5
  --newParticle.color.g = 0.2
  --newParticle.color.b = 0.7
  --newParticle.color.a = 0.3


  --newParticle.shape = 7
  --newParticle.startSize = 10
  --newParticle.endSize = 20
  --newParticle.lifetime = 3
  
  --newParticle.angle = 0
  --newParticle.spread = 6.28
  --newParticle.gravity.y = 200
  
  --ParticleManager:SpawnParticle(newParticle,200,{x=500,y=200})
end

function love.update(dt)
  sm:Update(dt)
  ParticleManager:Update(dt)
end

function love.draw()
  sm:Draw()
  ParticleManager:Draw(dt)
end