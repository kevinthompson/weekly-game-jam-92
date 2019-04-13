require("utils")
require("scenes")

game={
  title = "Weekly Game Jam 92 - One Direction",
  scene = scenes.title,
  font = lg.setNewFont("fonts/minecraft.ttf", 24)
}

function love.load()
 game.width, game.height = lg.getDimensions()
 game.scene:load()
end

function love.update(dt)
	game.scene:update(dt)
end

function love.draw()
	game.scene:draw()
end

function love.keypressed(key, scancode, isrepeat)
	if game.scene.keypressed then
		game.scene:keypressed(key, scancode, isrepeat)
	end

	if key == "escape" then
		love.event.quit()
	end
end