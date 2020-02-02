function HSV(h, s, v)
    if s <= 0 then return v,v,v end
    h, s, v = h/256*6, s/255, v/255
    local c = v*s
    local x = (1-math.abs((h%2)-1))*c
    local m,r,g,b = (v-c), 0,0,0
    if h < 1     then r,g,b = c,x,0
    elseif h < 2 then r,g,b = x,c,0
    elseif h < 3 then r,g,b = 0,c,x
    elseif h < 4 then r,g,b = 0,x,c
    elseif h < 5 then r,g,b = x,0,c
    else              r,g,b = c,0,x
    end return (r+m)*255,(g+m)*255,(b+m)*255
end

local stateManager = {}
local currentPitch = 1

stateManager.states = {}
stateManager.currentState = 0
stateManager.titleTimer = 0
stateManager.titleTime = 2
stateManager.titleText = ""
r,g,b= HSV(love.math.random(255),128,128)
love.graphics.setBackgroundColor(r/255,g/255,b/255)

stateManager.ShowTitle = function(self, text)
  self.titleTimer = 0
  self.titleText = text
  print(text)
end

stateManager.Shuffle = function(self)
  
  for i = 1, #self.states - 3 do
    local ri = love.math.random(1, #self.states - 3)
    local temp = self.states[i]
    self.states[i] = self.states[ri]
    self.states[ri] = temp
  end
  
  for i = 1, #self.states - 3 do
    print(self.states[i].name)
  end
  
end

stateManager.Init = function(self)
 table.insert(self.states, require("States/JumpOverIt"))
 table.insert(self.states, require("States/HotPotato"))
 table.insert(self.states, require("States/FlapTheBird"))
 table.insert(self.states, require("States/Shoot"))
 table.insert(self.states, require("States/SuckTheBall")) --5
 table.insert(self.states, require("States/CountDown"))
 table.insert(self.states, require("States/Tinder"))
 table.insert(self.states, require("States/Run"))
 table.insert(self.states, require("States/Roulette"))
 table.insert(self.states, require("States/CongaLine")) --10
 table.insert(self.states, require("States/ZigZag"))
 table.insert(self.states, require("States/Canoe"))
 table.insert(self.states, require("States/Push"))
 --table.insert(self.states, require("States/DontPop"))
 table.insert(self.states, require("States/Lobby"))
 table.insert(self.states, require("States/ScoreBoard")) --15
 table.insert(self.states, require("States/WinScreen"))
 --self.currentState = love.math.random(#self.states)
 self.currentState = #self.states - 2
self:Shuffle()
 self.intermissionCounter = 0
 self.oldState = 1
 
 --self.currentState = love.math.random(#self.states)
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
      for k, p in ipairs(PlayerManager:GetPlayers()) do
        p:ResetVisuals()
      end
      

      PlayerManager:ResetRound()
      
      if gameover then 
        self.currentState = #self.states -- WinScreen
      elseif self.intermissionCounter < 5 then
        
        
        if self.intermissionCounter == 0 then
          self.currentState  = self.oldState
        else
          self.currentState = self.currentState + 1
        end
        
        if self.currentState >= (#self.states - 2) then
          self.currentState = 1
          self:Shuffle()
        end
        
        self.intermissionCounter = self.intermissionCounter + 1
        currentPitch = currentPitch + 1 / 48
        music:setPitch(currentPitch)
      else -- player 2
        self.oldState = self.currentState + 1
        self.currentState = #self.states - 1 --intermission is at last index
        self.intermissionCounter = 0
      end
      
      
      print( self.currentState)
      r,g,b= HSV(love.math.random(255),128,128)
      love.graphics.setBackgroundColor(r/255,g/255,b/255)

      self.states[self.currentState]:OnEnter() 
      self:ShowTitle(self.states[self.currentState].name)
    end
  end
end

stateManager.Draw = function(self)
  self.states[self.currentState]:Draw()
  local alpha = (self.titleTime - self.titleTimer) * 10
  if alpha > 0 then
    love.graphics.setColor(0.6, 0.6, 0.6, alpha)
    love.graphics.rectangle("fill", 0, 0, width, height)
    love.graphics.setColor(0, 0, 0, alpha)
    local w = font:getWidth(self.titleText)
    local h = font:getHeight(self.titleText)
    love.graphics.print(self.titleText, width/2, height/2, math.sin(love.timer.getTime()*10)*0.1, 1, 1, w/2, h/2, 0, 0)
  end
end

return stateManager
