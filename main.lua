local sm = require("StateManager")

function love.load()
  sm:Init()
end

function love.update(dt)
  sm:Update(dt)
end

function love.draw()
  sm:Draw()
end