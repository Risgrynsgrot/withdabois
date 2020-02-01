local stateManager = {}

stateManager.states = {}
stateManager.currentState = 0

stateManager.Init = function(self)
 table.insert(self.states, require("States/JumpOverIt"))
 table.insert(self.states, require("States/HotPotato"))
 table.insert(self.states, require("States/FlapTheBird"))
 table.insert(self.states, require("States/Shoot"))
 self.currentState = 4--love.math.random(#self.states)
 self.states[self.currentState]:OnEnter()
end

stateManager.Update = function(self, dt)
  PlayerManager:Update()
  if (self.states[self.currentState]:Update(dt)) then
    
    self.states[self.currentState]:OnLeave() 
    
    PlayerManager:ResetRound()
    
    self.currentState = love.math.random(#self.states)
    
    self.states[self.currentState]:OnEnter() 
    
  end
end

stateManager.Draw = function(self)
  self.states[self.currentState]:Draw()
end

return stateManager
