PlayState = Class{__includes = BaseState}

function PlayState:init()
    self.tileImage = love.graphics.newImage('tile.jpg')

    self.map = {}

    TILE_WIDTH = 100
    TILE_HEIGHT = 100

    for i = 1, 15 do
        local row = {}
        for j = 1, 15 do
            table.insert(row, {TILE_WIDTH * j, TILE_HEIGHT * i})
        end
        table.insert(self.map, row)
    end

    -- player

    self.player = {}
    self.player.x = WINDOW_WIDTH / 2 - 10
    self.player.y = WINDOW_HEIGHT / 2 - 10

    camera = require 'camera'
    self.camera = camera()
end

function PlayState:update(dt)
    if love.keyboard.isDown('w') then
        self.player.y = self.player.y - math.floor(200 * dt)
    end
    if love.keyboard.isDown('s') then
        self.player.y = self.player.y + math.floor(200 * dt)
    end
    if love.keyboard.isDown('a') then
        self.player.x = self.player.x - math.floor(200 * dt)
    end
    if love.keyboard.isDown('d') then
        self.player.x = self.player.x + math.floor(200 * dt)
    end    

    local playerXroundedto100 = self.player.x - (self.player.x % 100)
    local playerYroundedto100 = self.player.y - (self.player.y % 100)

    for x = -7, 7 do
        for y = -7, 7 do
            self.map[x + 8][y + 8] = {playerXroundedto100 + x * TILE_WIDTH, playerYroundedto100 + y * TILE_HEIGHT}
        end
    end

    self.camera:lookAt(self.player.x, self.player.y)
end

function PlayState:keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end

function PlayState:render()
    self.camera:attach()
    for i = 1, 15 do
        for j = 1, 15 do
            love.graphics.draw(self.tileImage, self.map[i][j][1], self.map[i][j][2], 0, TILE_WIDTH/self.tileImage:getWidth(), TILE_HEIGHT/self.tileImage:getHeight())
        end
    end

    love.graphics.rectangle("fill", self.player.x, self.player.y, 20, 20)
    self.camera:detach()
end