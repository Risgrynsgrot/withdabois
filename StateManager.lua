local stateManager = {}

stateManager.states = {}
stateManager.currentState = 0

stateManager.Init = function(self)
 table.insert(self.states, require("States/JumpOverIt"))
 table.insert(self.states, require("States/HotPotato"))
 table.insert(self.states, require("States/FlapTheBird"))
 table.insert(self.states, require("States/Shoot"))
 table.insert(self.states, require("States/SuckTheBall"))
 --table.insert(self.states, require("States/CountDown"))
 table.insert(self.states, require("States/Tinder"))
 table.insert(self.states, require("States/Run"))
 table.insert(self.states, require("States/Roulette"))

 self.currentState = #self.states--love.math.random(#self.states)
 self.states[self.currentState]:OnEnter()
end

stateManager.Update = function(self, dt)
  PlayerManager:Update(dt)
  if (self.states[self.currentState]:Update(dt)) then
    
    self.states[self.currentState]:OnLeave() 
    
    PlayerManager:ResetRound()
    local old = self.currentState
    repeat
      self.currentState = love.math.random(#self.states)
    until self.currentState ~= old
    self.states[self.currentState]:OnEnter() 
    
  end
end

stateManager.Draw = function(self)
  self.states[self.currentState]:Draw()
end

return stateManager
