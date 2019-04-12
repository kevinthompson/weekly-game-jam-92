-- returns a table of quads
function makeTileset(img, cellSize)
	local tileset = {}
	local nx, ny = img:getWidth()/cellSize, img:getHeight()/cellSize
	local k = 1
	tileset.cellSize = cellSize
	tileset.sheet = img
	tileset.len = k-1

	for i= 1, nx do
		for j= 1, ny do
			tileset[k] = lg.newQuad(cellSize*(i-1), cellSize*(j-1), cellSize, cellSize, img:getDimensions())
			k = k + 1
		end
	end

	return tileset
end

-- to be called in love.draw()
function drawMap(tileset, map)
	local Sx, Sy = lg.getWidth()/Scale, lg.getHeight()/Scale
	local x, y = toMap(lg.inverseTransformPoint(0, 0), map, tileset)
	for i= x, Sx/tileset.cellSize do
		for j= y, Sy/tileset.cellSize do
			lg.draw(tileset.sheet, tileset[map[i][j]], (i-1)*tileset.cellSize, (j-1)*tileset.cellSize)
		end
	end
end

-- returns map coords corresponding to pixel coords
function toMap(x, y, map, tileset)
	return clamp(math.floor(x/tileset.cellSize), 1, map.nx), clamp(math.floor(y/tileset.cellSize), 1, map.ny)
end
