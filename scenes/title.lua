
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
    end
  end,

  draw=function(self)
    local textHeight = game.font:getHeight()
    printCentered(game.title, 200)
    lg.setColor(0, 255, 0, 1)
    printCentered("Select a scene:", 200 + textHeight*2)
    lg.setColor(255,255,255,1)

    for i=1,#self.scenes do
      local scene = self.scenes[i]
      lg.print(i..". "..tostring(scene.title), 300, 300)
    end
  end,

  keypressed=function(self, key, scancode, isrepeat)
    for i=1,#self.scenes do
      if key == tostring(i) then
        self.nextScene = self.scenes[i]
      end
    end
  end
}