-- UTILITY SCRIPT --

-- GLOBALS --
dbug = false -- turn it to true in love.load to show debug variables
db = {} -- add variables to show through debug() using db[1], db[2], etc.
DIGITAL, ANALOG = 0, 1
input = {
	left= false,
	right= false,
	moving= false,
	mode= DIGITAL,
	x= 0, y= 0,
	angle= 0.0,
	a= 0, b= 0,
	acting= false,
	sens = 40,
	invert = 1}
local inpts = {}

lg = lg or love.graphics
lf = lf or love.filesystem
lk = lk or love.keyboard
Scale = Scale or 1
Sx = Sx or lg.getWidth()/Scale
Sy = Sy or lg.getHeight()/Scale
input.divider = lg.getWidth()/2
World = World or {x= 0, y= 0}

-- FUNCTIONS --

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

----
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

----
-- in love.touchpressed()
function inputPressed(id, x, y)
	inpts[id] = {x= x, y= y}
end

-- in love.touchreleased()
function inputReleased(id)
	inpts[id] = nil
end

-- in love.update()
function inputUpdate()
	local Sx, Sy = lg.getWidth()/Scale, lg.getHeight()/Scale
	input.x = 0
	input.y = 0
	input.a = 0
	input.b = 0
	input.moving = false
	input.acting = false
	local touches = love.touch.getTouches()
	for j, id in ipairs(touches) do
		local tx, ty = love.touch.getPosition(id)
		-- motion
		if inpts[id].x/Scale < input.divider/Scale and input.left then
			
			local mx, my = inpts[id].x-tx, inpts[id].y-ty
			
			input.moving = true
			if input.mode == DIGITAL then
				-- along Y axis
				if my < -input.sens then input.y = 1*input.invert
				elseif my > input.sens then input.y = -1*input.invert
				else input.y = 0
				end
				-- along X axis
				if mx < -input.sens then input.x = 1*input.invert
				elseif mx > input.sens then input.x = -1*input.invert
				else input.x = 0
				end
			elseif input.mode == ANALOG then
				if math.abs(mx) > input.sens then input.x = -mx*input.invert
				else input.x = 0
				end
				if math.abs(my) > input.sens then input.y = -my*input.invert
				else input.y = 0
				end
			end
		-- actions
		elseif inpts[id].x/Scale > (Sx-input.divider)/Scale then
			if input.right then
				input.acting = true
				if (inpts[id].x/Scale - (Sx - Sy)) > inpts[id].y/Scale then
					input.a = 1
				end
				if (inpts[id].x/Scale - (Sx - Sy)) < inpts[id].y/Scale then
					input.b = 1
				end
			end
		end
	end
	-- keyboard input
	if lk.isDown("up", "down", "left", "right") then
		input.moving = true
		if lk.isDown("up") then input.y = -1*input.invert
		elseif lk.isDown("down") then input.y = 1*input.invert
		end
		if lk.isDown("left") then input.x = -1*input.invert
		elseif lk.isDown("right") then input.x = 1*input.invert
		end
	end
	if lk.isDown("z", "x") then
		input.acting = true
		if lk.isDown("z") then input.a = 1 end
		if lk.isDown("x") then input.b = 1 end
	end
	input.x, input.y = normalize(input.x, input.y)
	input.angle = math.atan2(input.y, input.x)+math.pi/2
end

-- in love.draw()
function inputDraw()
	lg.setColor(1.0, 1.0, 1.0, 0.5)
	local tx, ty = lg.inverseTransformPoint(0, 0)
	
	if input.left or input.right then
		for i, id in ipairs(love.touch.getTouches()) do
			
			local r = 40/Scale
			local dx, dy = inpts[id].x/Scale+tx, inpts[id].y/Scale+ty
			
			if inpts[id].x/Scale < input.divider/Scale and input.left then
				lg.circle("line", dx, dy, r)
				lg.circle("fill", dx+(input.x*r)*input.invert, dy+(input.y*r)*input.invert, r/2)
			elseif inpts[id].x/Scale > (Sx-input.divider)/Scale and input.right then
				lg.circle("line", dx, dy, r)
			end
		end
	end
	lg.setColor(1.0, 1.0, 1.0, 1.0)
end

----
-- returns a button object
function newButton(img, x, y, text)
	local button = {}
	button.x = x or 0
	button.y = y or 0
	button.image = img or love.graphics.newImage("Assets/Btn.png")
	button.width = button.image:getWidth()
	button.height = button.image:getHeight()
	button.text = text or ""
	
	function button:draw()
		self.x = clamp(self.x, self.width/2, Sx-self.width/2)
		self.y = clamp(self.y, self.height/2, Sy-self.height/2)
		lg.draw(self.image, self.x, self.y)
		lg.print(self.text, self.x, self.y)
	end
	
	function button:pressed(ix, iy)
		if ix > (self.x - self.width/2) and (ix < self.x + self.width/2) then
			if iy > (self.y - self.height/2) and (iy < self.y + self.height/2) then
				return true
			end
		end
		
		return false
	end
	
	return button
end

----
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

-- returns a table of quads, cell sizes & number of cells
function makeSprite(img, cellSizeX, cellSizeY)
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

-- MAP FUNCTIONS


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





