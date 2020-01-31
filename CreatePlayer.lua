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
  
  p.color = colors[p.colorIndex]
  
  p.GetInput = function(self)
    return joystick:isDown(self.id)
  end
  
  p.Draw = function(self)
    love.graphics.setColor(self.color.r, self.color.g, self.color.b)
    love.graphics.rectangle("fill", self.x, self.y, self.wh, self.wh)
  end
  
  return p
  
  
  
end