local stateManager = {}

stateManager.states = {}
stateManager.currentState = 1

stateManager.Init = function(self)
 table.insert(self.states, require("States/JumpOverIt"))
end

stateManager.Update = function(self, dt)
  self.states[self.currentState]:Update(dt)
end

stateManager.Draw = function(self)
  self.states[self.currentState]:Draw()
end

return stateManager