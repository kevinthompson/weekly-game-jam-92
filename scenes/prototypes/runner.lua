scenes.prototypes.runner = {
  title="Runner",
  gameOver=false,
  gameTimer=0,
  gravity=20,
  meter=64,
  obstacles={},
  obstacleTimer=0,

  -- LÖVE Methods
  load=function(self)
    love.physics.setMeter(self.meter)

    self.world = love.physics.newWorld(0, self.gravity*self.meter, true)
    self.level:load()
    self.player:load()
  end,

  update=function(self, dt)
    self.obstacleTimer = self.obstacleTimer - 1

    if not self.gameOver then
      self.world:update(dt)
      self.player:update(dt)
      self.gameTimer = self.gameTimer + dt

      for i=#self.obstacles,1,-1 do
        local obstacle = self.obstacles[i]
        obstacle.body:setLinearVelocity(-200, 0)

        if obstacle.body:isTouching(self.player.body) then
          self.gameOver = true
        end

        if obstacle.body:getX() < -50 then
          table.remove(self.obstacles, i)
          obstacle.body:destroy()
        end
      end

      if self.obstacleTimer <= 0 then
        local minTime = 30
        local maxTime = 180
        self:spawnObstacle()
        self.obstacleTimer = math.random(minTime,maxTime)
      end
    end
  end,

  draw=function(self)
    self.level:draw()
    self.player:draw()

    for i=1,#self.obstacles do
      local obstacle = self.obstacles[i]

      withColor(obstacle.color, function()
        love.graphics.polygon("fill", obstacle.body:getWorldPoints(obstacle.shape:getPoints()))
      end)
    end

    local time = tonumber(string.format("%." .. (2) .. "f", self.gameTimer))

    if self.gameOver then
      withColor({1,.2,.2}, function()
        printCentered("GAME OVER", 120)
      end)

      withColor({1,1,1}, function()
        printCentered("You survived for "..time.." seconds.", 160)
      end)

      withColor({0.5,0.5,0.5}, function()
        printCentered("Press [Space] to play again...", 200)
      end)
    else
      lg.print("Time: "..time.."s", 300, 20)
    end
  end,

  keypressed=function(self, key, scancode, isrepeat)
    if self.gameOver then
      if key=="space" then
        self:restartGame()
      end
    else
      local ground = self.level.geometry[1]

      if key=="space" and self.player.body:isTouching(ground.body) then
        self.player.jumping = true
      end
    end
  end,

  -- Objects
  player={
    x=100,
    y=375,
    width=64,
    height=64,

    jumping=false,
    jumpSpeed=400,

    load=function(self, attributes)
      attributes = attributes or {}

      for key, value in pairs(attributes) do
        self[key] = value
      end

      self.body = love.physics.newBody(game.scene.world, self.x, self.y, "dynamic")
      self.shape = love.physics.newRectangleShape(self.width-16, self.height-16)
      self.fixture = love.physics.newFixture(self.body, self.shape)
      self.spritesheet = lg.newImage("assets/PlayerIdle.png")
      self.sprites = makeSprites(self.spritesheet, 64)
    end,

    update=function(self, dt)
      if self.jumping then
        self.body:applyLinearImpulse(0,-self.jumpSpeed)
        self.jumping = false
      end
    end,

    draw=function(self)
      local x, y = self.body:getPosition()
      -- love.graphics.polygon("fill", self.body:getWorldPoints(self.shape:getPoints()))
      love.graphics.draw(self.spritesheet, self.sprites[1][1], x-self.width/2, y-(self.height+16)/2)
    end
  },

  level={
    geometry={},

    load=function(self)
      local ground = {}

      ground.color = {.2,1,.4}
      ground.body = love.physics.newBody(game.scene.world, -100, 600, "static")
      ground.shape = love.physics.newRectangleShape(game.width * 4, 100)
      ground.fixture = love.physics.newFixture(ground.body, ground.shape)

      table.insert(self.geometry, ground)
    end,

    update=function(self)
    end,

    draw=function(self)
      for i=1,#self.geometry do
        local geometry = self.geometry[i]
        withColor(geometry.color, function()
          love.graphics.polygon("fill", geometry.body:getWorldPoints(geometry.shape:getPoints()))
        end)
      end
    end
  },

  spawnObstacle = function(self)
    local obstacle = {}
    local width = math.random(10,20)
    local height = math.random(10,50)

    obstacle.color = {1,0,0}
    obstacle.body = love.physics.newBody(game.scene.world, game.width + 200, 600 - height, "dynamic")
    obstacle.shape = love.physics.newRectangleShape(width, height)
    obstacle.fixture = love.physics.newFixture(obstacle.body, obstacle.shape)

    table.insert(self.obstacles, obstacle)
  end,

  restartGame = function(self)
    for i=#self.obstacles,1,-1 do
      local obstacle = self.obstacles[i]
      obstacle.body:destroy()
    end

    self.obstacles = {}
    self.gameOver = false
    self.gameTimer = 0
    self.obstacleTimer = 0

    self.player.body:destroy()
    self.player:load()
  end
}
