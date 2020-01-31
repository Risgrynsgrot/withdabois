local stateManager = {}

stateManager.states = {}
stateManager.currentState = 1

stateManager.Init = function(self)
 table.insert(self.states, require("States/JumpOverIt"))
end

stateManager.Update = function(self, dt)
  if (self.states[self.currentState]:Update(dt)) then
    self.currentState = love.math.random(#self.states)
  end
end

stateManager.Draw = function(self)
  self.states[self.currentState]:Draw()
end

return stateManager