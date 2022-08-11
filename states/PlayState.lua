PlayState = Class{__includes = BaseState}

function PlayState:init()
    math.randomseed(os.time())
    self.player = {}
    self.player.width = 20
    self.player.height = 20
    -- self.player.x = WINDOW_WIDTH / 2 - self.player.width
    -- self.player.y = WINDOW_HEIGHT / 2 - self.player.height

    self.player.x = math.random(0, WINDOW_WIDTH / 2)
    self.player.y = math.random(0, WINDOW_HEIGHT / 2)
    self.player.speed = 200

    self.pixelMap = {}
    for i = 1, 400 do
        local row = {}
        for j = 1, 400 do
            table.insert(row, {self.player.x, self.player.y, 0, 0, 0})
            --table.insert(row, 0)
        end
        table.insert(self.pixelMap, row)
    end

    camera = require 'camera'
    self.camera = camera()

    colorOfPixel = "none"
end

function PlayState:update(dt)
    self.camera:lookAt(self.player.x  + 5, self.player.y + 5)


    if love.keyboard.isDown('w') then
        self.player.y = self.player.y - self.player.speed * dt
        -- if self.pixelMap[200][200][3] >= 0.5 then
        --     self.player.y = self.player.y
        -- else
        --     self.player.y = self.player.y - self.player.speed * dt
        -- end
    end
    if love.keyboard.isDown('s') then
        self.player.y = self.player.y + self.player.speed * dt
    end
    if love.keyboard.isDown('a') then
        self.player.x = self.player.x - self.player.speed * dt
    end
    if love.keyboard.isDown('d') then
        self.player.x = self.player.x + self.player.speed * dt
    end

    
    traverseY = 1
    for i = math.floor(self.player.x - 200), math.floor(self.player.x) + 199 do
        traverseX = 1
        for j = math.floor(self.player.y - 200), math.floor(self.player.y + 200) do
            local pixelX = i
            local pixelY = j

            --print(pixelX, pixelY)
            --randomValue = math.random(0.004, 0.007)

            local noise = love.math.noise(pixelX * 0.005 + 100.011, pixelY * 0.005 + 100.011)
            if noise >= 0.5 then
                noisex = {math.floor(self.player.x) - pixelX, math.floor(self.player.y) - pixelY, 222/255, 182/255, 135/255}
            else
                noisex = {math.floor(self.player.x), math.floor(self.player.y), 0, 0, 0}
            end

            if i == math.floor(self.player.x) and j == math.floor(self.player.y) then
                if noise > 0.5 then
                    colorOfPixel = "sand"
                else
                    colorOfPixel = "black"
                end
            end

            -- local noise1 = love.math.noise((pixelX / pixelY  + 100.105))
            -- local noise2 = love.math.noise((pixelX / pixelY + 110.104))
            -- local noise3 = love.math.noise((pixelX / pixelY + 120.103))
            --self.pixelMap[traverseY][traverseX] = {noise1, noise2, noise3}
            self.pixelMap[traverseY][traverseX] = noisex
            traverseX = traverseX + 1
        end
        traverseY = traverseY + 1
    end
end

function PlayState:keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end

function PlayState:render()
    self.camera:attach()
    for x = 1, 400 do
        for y = 1, 400 do
            love.graphics.setColor(self.pixelMap[y][x][3], self.pixelMap[y][x][4], self.pixelMap[y][x][5])
            --love.graphics.setColor(self.pixelMap[y][x], self.pixelMap[y][x], self.pixelMap[y][x])
            love.graphics.points(math.floor(self.player.x) + self.pixelMap[y][x][1], math.floor(self.player.y) + self.pixelMap[y][x][2])
        end
    end
    love.graphics.setColor(1, 1, 1)

    love.graphics.rectangle("fill", self.player.x, self.player.y, 5, 5)
    self.camera:detach()

    love.graphics.print(colorOfPixel, 100, 100)
end