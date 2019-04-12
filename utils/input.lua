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

input.divider = lg.getWidth()/2

local inpts = {}

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