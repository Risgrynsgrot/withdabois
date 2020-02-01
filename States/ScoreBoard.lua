local state = {}


state.name = "Intermission!"


function lerp(a,b,t) return (1-t)*a + t*b end

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
 

local scoreTable = { }
local scoreValue = { }

local timer = 4

state.OnEnter = function(self)

	timer = 4

	for k, p in ipairs(PlayerManager:GetPlayers()) do
			table.insert(scoreTable, p)
	end

	sort(scoreTable)

	y = 32
	for k, p in ipairs(scoreTable) do
		
		p.y = y
		p.x = -p.wh
		y = y + height / #scoreTable * (#scoreTable / 10)
	end
end

state.Update = function(self, dt)
  
	timer = timer - dt

	for k, p in ipairs(scoreTable) do
		if timer >= 0 then
			p.x = lerp(p.x, width *  (#PlayerManager:GetPlayers() / 10) / 2 - p.wh * 2, 0.05 + (height - p.y) / height * 0.01)
		else 
			p.x = lerp(p.x, -p.wh * 4, 0.05 + (height - p.y) / height * 0.01)
		end
	end

	if scoreTable[#scoreTable].x <= -scoreTable[#scoreTable].wh * 2 then
	    return true
	end

  return false
end

state.Draw = function(self)
	

	love.graphics.push()
	love.graphics.scale(1 / (#PlayerManager:GetPlayers() / 10), 1 / ( #PlayerManager:GetPlayers() / 10))
  	for k, p in ipairs(scoreTable) do
  		p:Draw()

  		love.graphics.print(" - " .. p.score, (width + width) * ((#PlayerManager:GetPlayers() / 20)) - p.x - p.wh * 3, p.y - 20, 0, 0.5, 0.5, 0, 0, 0, 0)
  	end

  	love.graphics.scale(1, 1)
  	love.graphics.pop()
end

state.OnLeave = function(self)
  
end

return state