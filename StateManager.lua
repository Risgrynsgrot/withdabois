local stateManager = {}

stateManager.states = {}
stateManager.currentState = 0
stateManager.titleTimer = 0
stateManager.titleTime = 2
stateManager.titleText = ""

stateManager.ShowTitle = function(self, text)
  self.titleTimer = 0
  self.titleText = text
  print("Show")
end

stateManager.Init = function(self)
 table.insert(self.states, require("States/JumpOverIt"))
 table.insert(self.states, require("States/HotPotato"))
 table.insert(self.states, require("States/FlapTheBird"))
 table.insert(self.states, require("States/Shoot"))
 table.insert(self.states, require("States/SuckTheBall"))
 table.insert(self.states, require("States/CountDown"))
 table.insert(self.states, require("States/Tinder"))
 table.insert(self.states, require("States/Run"))
 table.insert(self.states, require("States/CongaLine"))
 table.insert(self.states, require("States/ZigZag"))
 table.insert(self.states, require("States/Canoe"))
 table.insert(self.states, require("States/Push"))
 
 self.currentState = love.math.random(#self.states)
 --self.currentState = #self.states
 self.states[self.currentState]:OnEnter()
 self:ShowTitle(self.states[self.currentState].name)
end

stateManager.Update = function(self, dt)
  if self.titleTimer < self.titleTime then
    self.titleTimer = self.titleTimer + dt
  else
    PlayerManager:Update(dt)
    if (self.states[self.currentState]:Update(dt)) then
      
      self.states[self.currentState]:OnLeave() 
      
      PlayerManager:ResetRound()
      local old = self.currentState
      repeat
        self.currentState = love.math.random(#self.states)
      until self.currentState ~= old
      self.states[self.currentState]:OnEnter() 
      self:ShowTitle(self.states[self.currentState].name)
    end
  end
end

stateManager.Draw = function(self)
  self.states[self.currentState]:Draw()
  local alpha = (self.titleTime - self.titleTimer) * 10
  if alpha > 0 then
    print(alpha)
    love.graphics.setColor(1, 1, 1, alpha)
    love.graphics.rectangle("fill", 0, 0, width, height)
    love.graphics.setColor(0, 0, 0, alpha)
    local w = font:getWidth(self.titleText)
    local h = font:getHeight(self.titleText)
    love.graphics.print(self.titleText, width/2, height/2, 0.1, 1, 1, w/2, h/2, 0, 0)
  end
end

return stateManager