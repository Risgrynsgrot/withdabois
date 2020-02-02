local ParticleManager = {}

function RandomFloat(min, max, precision)
	local range = max - min
	local offset = range * math.random()
	local unrounded = min + offset

	if not precision then
		return unrounded
	end

	local powerOfTen = 10 ^ precision
	return math.floor(unrounded * powerOfTen + 0.5) / powerOfTen
end

ParticleManager.particles = {}

CreateParticleStruct = function()
  local pstruct = {
    color = {
      r = 1,
      g = 1,
      b = 1,
      a = 1
    },
    pos = {
      x = 0,
      y = 0
    },
    gravity = {
      x = 0,
      y = 0
    },
    shape = 0,
    angle = 0.0,
    spread = 0.0,
    minSpeed = 0.0,
    maxSpeed = 0.0,
    lifetime = 0.0,
    startSize = 0.0,
    endSize = 0.0,
    fadeSpeed = 0.0
  }
  return pstruct
end

function copy(obj, seen)
  if type(obj) ~= 'table' then return obj end
  if seen and seen[obj] then return seen[obj] end
  local s = seen or {}
  local res = setmetatable({}, getmetatable(obj))
  s[obj] = res
  for k, v in pairs(obj) do res[copy(k, s)] = copy(v, s) end
  return res
end

--use "struct" from CreateParticleStruct()
ParticleManager.SpawnParticle = function(self,particleStruct, count, pos)
  
  for index = 1, count do
    local newParticle = copy(particleStruct)
    if pos ~= nil then
      newParticle.pos = copy(pos)
    end
    
    newParticle.angle = newParticle.angle + RandomFloat(-newParticle.spread, newParticle.spread)
    newParticle.speed = RandomFloat(newParticle.minSpeed,newParticle.maxSpeed)
    
    newParticle.vel = {
        x = math.cos(newParticle.angle) * math.max(newParticle.speed,00000.1),
        y = math.sin(newParticle.angle) * math.max(newParticle.speed,00000.1)
      }
      
    newParticle.timer = 0
    
    table.insert(self.particles,newParticle)
  end

end




ParticleManager.Update = function(self,dt)
  for index = #self.particles, 1, -1 do
    
    local currentParticle = self.particles[index]
    
    currentParticle.timer = currentParticle.timer + dt
    currentParticle.color.a = currentParticle.color.a - currentParticle.fadeSpeed
    
    if  currentParticle.timer < currentParticle.lifetime then
    
      currentParticle.vel.x = currentParticle.vel.x + currentParticle.gravity.x * dt
      currentParticle.vel.y = currentParticle.vel.y + currentParticle.gravity.y * dt
      
      currentParticle.pos.x = currentParticle.pos.x + currentParticle.vel.x * dt
      currentParticle.pos.y = currentParticle.pos.y + currentParticle.vel.y * dt

    else
      table.remove(self.particles,index)
    end
  end
end

ParticleManager.Draw = function(self)
  for index = #self.particles, 1, -1 do
    
    local particle = self.particles[index]
    
    love.graphics.push()
    love.graphics.setColor(particle.color.r, particle.color.g, particle.color.b, particle.color.a)
    love.graphics.translate(particle.pos.x, particle.pos.y)
    
    local angle = math.atan2(particle.vel.y,particle.vel.x)
    
    
    love.graphics.rotate(angle - 3.14/4)
    love.graphics.translate(-particle.pos.x, -particle.pos.y)
    
    local T = particle.timer / math.max(particle.lifetime,0.00001)

    local size = T * particle.endSize + (1-T) * particle.startSize
        
    love.graphics.setColor(0.2, 0.3, 0.4, particle.color.a)
   -- if particle.timer < particle.lifetime then
    --love.graphics.print(particle.vel.x, particle.pos.x + 50, particle.pos.y)
    --end
    love.graphics.setColor(particle.color.r, particle.color.g, particle.color.b, particle.color.a)

    
    love.graphics.circle("fill", particle.pos.x, particle.pos.y, size, particle.shape)
    love.graphics.pop()
  end
end

return ParticleManager