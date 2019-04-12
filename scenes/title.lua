
scenes.title = {
  nextScene=nil,

  load=function(self)
    self.scenes = {
      scenes.prototypes.runner
    }
  end,

  update=function(self, dt)
    if self.nextScene then
      game.scene = self.nextScene
      game.scene:load()
    end
  end,

  draw=function(self)
    lg.setFont(game.font, 24)

    local textHeight = game.font:getHeight()
    printCentered(game.title, 200)

    withColor({0,1,0}, function()
      printCentered("Select a prototype:", 200 + textHeight*2)
    end)

    withColor({.8,.8,.8}, function()
      for i=1,#self.scenes do
        local scene = self.scenes[i]
        lg.print(i..". "..tostring(scene.title), 280, 300)
      end
    end)
  end,

  keypressed=function(self, key, scancode, isrepeat)
    for i=1,#self.scenes do
      if key == tostring(i) then
        self.nextScene = self.scenes[i]
      end
    end
  end
}