function CreatePlayer(id, x, y)
  local p = {}
  
  colors = {
    { r = 1, g = 0,    b = 0 },
    { r = 1, g = 1,    b = 0 },
    { r = 0, g = 1,    b = 0 },
    { r = 1, g = 0.65, b = 0 },
    { r = 0, g = 0.4,  b = 1 }
  }
  
  p.x = x
  p.y = y
  p.wh = 32
  p.r = 0
  p.id = id
  p.colorIndex = ((id - 1) % 5) + 1
  p.controllerId = math.ceil(id / 5)
  p.oldState = false
  p.newState = false
  p.score = 0
  p.color = colors[p.colorIndex]
  
  p.GetInput = function(self)
    return ((joystick ~= nil and joystick:isDown(self.id)) or love.keyboard.isDown(string.char(string.byte("a")+self.id-1)))
  end

  p.UpdateInput = function(self)
    self.oldState = self.newState
    self.newState = self:GetInput()
  end
  
  p.GetPressed = function(self)
    return self.newState == true and p.oldState == false
  end
  
  p.GetReleased = function(self)
    return self.newState == false and p.oldState == true
  end
  
  p.GetDown = function(self)
    return self.newState == true
  end
  
   p.GetUp = function(self)
    return self.newState == false
  end
  
  p.Draw = function(self)
    love.graphics.push()
    love.graphics.setColor(self.color.r, self.color.g, self.color.b)
    love.graphics.translate(self.x, self.y)
    love.graphics.rotate(self.r - 3.14/4)
    love.graphics.translate(-self.x, -self.y)
    if self.controllerId == 4 then
      love.graphics.circle("fill", self.x, self.y, self.wh, 20)
    else
      love.graphics.circle("fill", self.x, self.y, self.wh, self.controllerId + 2)
    end
    love.graphics.pop()
  end
  
  return p
end