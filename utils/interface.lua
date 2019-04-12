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

function withColor(color, callback)
	local r, g, b, a = love.graphics.getColor()
	love.graphics.setColor(color)
	callback()
	love.graphics.setColor({r,g,b,a})
end