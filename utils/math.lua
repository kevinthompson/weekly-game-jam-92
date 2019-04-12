function clamp(x, m, M)
	y = math.min(x, M)
	y = math.max(x, m)
	return y
end

function rollClamp(x, m, M)
	y = x
	if x < m then
		y = M - (m-x) + 1
	elseif x > M then
		y = m + (x-M) - 1
	end
	return y
end

function normalize(x, y)
	local mag = math.sqrt(x^2 + y^2)
	if mag > 0 then return x/mag, y/mag
	else return 0, 0
	end
end

function lerp(st, en, pr)
	return (1-pr)*st + pr*en
end

function biasedRandom(weights)
  local totals = {}
  local runningTotal = 0

  for i, w in ipairs(weights) do
    runningTotal = runningTotal + w
    table.insert(totals, runningTotal)
  end

  local rnd = math.random() * runningTotal

  for i, total in ipairs(totals) do
    if rnd < total then
      return i-1
    end
  end
end
