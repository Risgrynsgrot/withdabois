function CreatePlayer(id, x, y)
  local p = {}
  
  colors = {
    { r = 1, g = 0,    b = 0, a = 1 },
    { r = 1, g = 1,    b = 0, a = 1 },
    { r = 0, g = 1,    b = 0, a = 1 },
    { r = 1, g = 0.65, b = 0, a = 1 },
    { r = 0, g = 0.4,  b = 1, a = 1 }
  }
  
  p.x = x
  p.y = y
  p.scale = 1
  p.wh = 32
  p.r = 0
  p.id = id
  p.colorIndex = ((id - 1) % 5) + 1
  p.controllerId = math.ceil(id / 5)
  p.oldState = false
  p.newState = false
  p.score = 0
  p.scoreTimer = 100
  p.color = colors[p.colorIndex]
  p.color.a = 1

  p.eyes = {}
  p.CreateEye = function(x, y, rad)
    local eye = {}
    eye.x = 0
    eye.y = 0
    eye.offx = x
    eye.offy = y
    eye.vx = 0
    eye.vy = 0
    eye.prevx = 0
    eye.prevy = 0
    eye.rad = rad
    eye.innerRad = rad/2
    return eye
  end
  
  table.insert(p.eyes, p.CreateEye(-p.wh/2, 0, 5 + love.math.random(10)))
  table.insert(p.eyes, p.CreateEye(p.wh/2, 0, 5 + love.math.random(10)))

  local Dot = function(firstVector, secondVector)
    return  firstVector.x * secondVector.x + firstVector.y * secondVector.y
  end

  p.UpdateEyes = function(self, dt)
    self.scoreTimer = self.scoreTimer + dt
    for k,eye in ipairs(self.eyes) do
      eye.vx = eye.vx * 0.9
      eye.vy = eye.vy * 0.9
      eye.vx = eye.vx + (self.x - eye.prevx) * 0.03
      eye.vy = eye.vy + (self.y - eye.prevy) * 0.03
      eye.vy = eye.vy + 0.1
      eye.prevx = self.x
      eye.prevy = self.y
      local distance = math.sqrt(eye.x*eye.x + eye.y*eye.y)
      --if the ball hits the arena limit
      if distance >= eye.rad - eye.innerRad then
        if distance >= eye.rad then
          eye.x = 0
          eye.y = 0
          eye.vx = 0
          eye.vy = 0
        else 
          --I - 2.0 * dot(N, I) * N.
          local diff = {
            x = - eye.x,
            y = - eye.y
          }
          length = math.sqrt(diff.x * diff.x + diff.y * diff.y)
          diff.x = diff.x / length
          diff.y = diff.y / length
          local eyeVel = {
            x = eye.vx, 
            y = eye.vy
          }
          eye.vx = eye.vx - 2.0 * Dot(diff, eyeVel) * diff.x
          eye.vy = eye.vy - 2.0 * Dot(diff, eyeVel) * diff.y
          eye.vx = eye.vx * 0.7
          eye.vy = eye.vy * 0.7
        end
      end
      eye.x = eye.x + eye.vx
      eye.y = eye.y + eye.vy
    end
  end

  p.jumpHeight = 0
  p.jumpVel = 0
  p.Jump = function(self)
    if self.jumpHeight == 0 then
      self.jumpVel = -200
    end
  end

  p.UpdateJump = function(self, dt)
    self.jumpVel = self.jumpVel + dt * 1000
    self.jumpHeight = self.jumpHeight + dt * self.jumpVel
    if self.jumpHeight > 0 then
      self.jumpVel = 0
      self.jumpHeight = 0
    end 
  end

  p.AddScore = function(self)
    self.score = self.score + 1
    self.scoreTimer = 0
  end


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

  p.ResetVisuals = function(self)
    self.scale = 1
    self.wh = 32
    self.r = 0
  end

  p.Draw = function(self)
    love.graphics.push()
    love.graphics.setColor(self.color.r, self.color.g, self.color.b, self.color.a)
    love.graphics.translate(self.x, self.y)
    love.graphics.rotate(self.r)
    love.graphics.translate(-self.x, -self.y)
    if self.controllerId == 4 then
      love.graphics.circle("fill", self.x, self.y + self.jumpHeight, self.wh * self.scale, 20)
    else
      love.graphics.circle("fill", self.x, self.y + self.jumpHeight, self.wh * self.scale, self.controllerId + 2)
    end
    for k,eye in ipairs(self.eyes) do
      love.graphics.setColor(1, 1, 1, 1)
      love.graphics.circle("fill", self.x + eye.offx, self.y + self.jumpHeight + eye.offy, eye.rad, 16)
      love.graphics.setColor(0, 0, 0, 1)
      love.graphics.circle("fill", self.x + eye.offx + eye.x, self.y + self.jumpHeight + eye.offy + eye.y, eye.innerRad, 16)
    end

    
    local w = font:getWidth("+1")
    local h = font:getHeight("+1")
    love.graphics.setColor(0, 0, 0, (1-self.scoreTimer)*2)
    love.graphics.print( "+1", self.x + 10, self.y - (self.scoreTimer*self.scoreTimer)*50 + 10, math.sin(self.scoreTimer)*0.1, math.max(self.scoreTimer/10, 1), math.max(self.scoreTimer/10, 1), w/2, h/2)
    love.graphics.setColor(1, 1, 1, (1-self.scoreTimer)*2)
    love.graphics.print( "+1", self.x, self.y - (self.scoreTimer*self.scoreTimer)*50, math.sin(self.scoreTimer)*0.1, math.max(self.scoreTimer/10, 1), math.max(self.scoreTimer/10, 1), w/2, h/2)
    love.graphics.setColor(1, 1, 1, 1)

    love.graphics.pop()
  end
  
  return p
end
