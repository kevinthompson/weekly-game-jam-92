dbug = false -- turn it to true in love.load to show debug variables
db = {} -- add variables to show through debug() using db[1], db[2], etc.

-- to be called in love.draw()
function debug()
	lg.setColor(1, 1, 1, 1)
	local tx, ty = lg.inverseTransformPoint(0, 0)

	-- print debug variables
	if dbug then
		for i, d in ipairs(db) do
			if d ~= nil then
				lg.print(d, tx, 11*(i-1)+ty)
			end
		end

		-- print input areas
		if input.moving then lg.setColor(0.3, 0.3, 0.9, 0.3)
		else lg.setColor(0, 0, 0, 0)
		end
		lg.rectangle("fill", tx, ty, input.divider/Scale, Sy/Scale)

		if input.acting then lg.setColor(0.2, 0.4, 0.4, 0.5)
		else lg.setColor(0, 0, 0, 0)
		end
		lg.rectangle("fill", tx+(Sx-input.divider)/Scale, ty, input.divider/Scale, Sy/Scale)

		lg.line(tx+(Sx-input.divider)/Scale, ty, tx+Sx/Scale, ty+Sy/Scale)

		lg.setColor(1, 1, 1, 1)
	end
end