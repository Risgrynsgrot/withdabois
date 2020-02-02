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
  
  return false
end

state.Draw = function(self)
	if #self.scoreTable > 0
		-- player 1
	end
	if #self.scoreTable > 1
		-- player 2
	end
	if #self.scoreTable > 2
		-- player 3
	end
end

state.OnLeave = function(self)
  
end

return state