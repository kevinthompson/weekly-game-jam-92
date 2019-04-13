-- returns a table of quads, cell sizes & number of cells
function makeSprites(img, cellSizeX, cellSizeY)
 cellSizeY = cellSizeY or cellSizeX
 local lg = love.graphics
	local sprites = {}
	local nx, ny = img:getWidth()/cellSizeX, img:getHeight()/cellSizeY
	-- cell size of sprites
	sprites.cellSizeX = cellSizeX
	sprites.cellSizeY = cellSizeY
	-- number of cells
	sprites.nx = nx
	sprites.ny = ny

	for i= 1, nx do
		sprites[i] = {}
		for j= 1, ny do
			sprites[i][j] = lg.newQuad(cellSizeX*(i-1), cellSizeY*(j-1), cellSizeX, cellSizeY, img:getDimensions())
		end
	end

	return sprites
end