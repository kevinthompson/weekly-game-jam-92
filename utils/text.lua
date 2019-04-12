function printCentered(text, y)
  local width, height = love.graphics.getDimensions()
	local textWidth = love.graphics.getFont():getWidth(text)
	love.graphics.print(text, width/2-(textWidth/2), y)
end