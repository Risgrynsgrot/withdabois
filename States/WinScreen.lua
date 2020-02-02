local state = {}
state.name = "Game over!"
state.scoreTable = {}

local sort = function (A)
  local itemCount=#A
  local hasChanged
  repeat
    hasChanged = false
    itemCount=itemCount - 1
    for i = 1, itemCount do
      if A[i].score < A[i + 1].score then
        A[i], A[i + 1] = A[i + 1], A[i]
        hasChanged = true
      end
    end
  until hasChanged == false
end

state.OnEnter = function(self)
	self.scoreTable = { }

	for k, p in ipairs(PlayerManager:GetPlayers()) do
			table.insert(self.scoreTable, p)
	end

	sort(self.scoreTable)
end

state.Update = function(self, dt)
  self.scoreTable[1]:Jump()
  return false
end

state.Draw = function(self)
	local x = width/2
	local y = height/2
	local w = 128
	self.scoreTable[1].x = x
	self.scoreTable[1].y = y
	self.scoreTable[1]:Draw()
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.rectangle("fill", x-w/2, y+64, w, height)
	local w = font:getWidth("#1")
    local h = font:getHeight("#1")
    local time = love.timer.getTime()

    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.print( "#1", x, y + 128, math.sin(time)*0.1, math.max(time/10, 1), math.max(time/10, 1), w/2, h/2)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print( "#1", x + 10, y + 128 + 10, math.sin(time)*0.1, math.max(time/10, 1), math.max(time/10, 1), w/2, h/2)
    love.graphics.setColor(1, 1, 1, 1)

	if #self.scoreTable > 1 then
		-- player 2
		x = width/2 - w
		y = height/2 + 128
		self.scoreTable[2].x = x
		self.scoreTable[2].y = y
		self.scoreTable[2]:Draw()
		love.graphics.setColor(1, 1, 1, 1)
		love.graphics.rectangle("fill", x-w/2, y+64, w, height)
		love.graphics.setColor(0, 0, 0, 1)
	    love.graphics.print( "#2", x, y + 128, math.sin(time)*0.1, math.max(time/10, 1), math.max(time/10, 1), w/2, h/2)
	    love.graphics.setColor(1, 1, 1, 1)
	    love.graphics.print( "#2", x + 10, y + 128 + 10, math.sin(time)*0.1, math.max(time/10, 1), math.max(time/10, 1), w/2, h/2)
	    love.graphics.setColor(1, 1, 1, 1)
	end
	if #self.scoreTable > 2 then
		-- player 3
		x = width/2 + w
		y = height/2 + 128 * 2
		self.scoreTable[3].x = x
		self.scoreTable[3].y = y
		self.scoreTable[3]:Draw()
		love.graphics.setColor(1, 1, 1, 1)
		love.graphics.rectangle("fill", x-w/2, y+64, w, height)
		love.graphics.setColor(0, 0, 0, 1)
	    love.graphics.print( "#3", x, y + 128, math.sin(time)*0.1, math.max(time/10, 1), math.max(time/10, 1), w/2, h/2)
	    love.graphics.setColor(1, 1, 1, 1)
	    love.graphics.print( "#3", x + 10, y + 128 + 10, math.sin(time)*0.1, math.max(time/10, 1), math.max(time/10, 1), w/2, h/2)
	    love.graphics.setColor(1, 1, 1, 1)
	end
end

state.OnLeave = function(self)
  
end

return state