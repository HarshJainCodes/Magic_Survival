PlayState = Class{__includes = BaseState}

require 'modules.player'
require 'modules.enemy'
require 'modules.powerups'
require 'gui.powerUpSelect'
require 'modules.SpawnManager'

function PlayState:init()
    --collectgarbage("stop")
    math.randomseed(os.time())
    self.tileImage = love.graphics.newImage('tile.jpg')

    --this will store all our tiles surrounded by the players
    self.map = {}

    TILE_WIDTH = 100
    TILE_HEIGHT = 100

    MAPSIZE = 13    -- default is 17
       -- increasing the mapsize will reduce frames

    --initialise our map with tiles
    for i = 1, MAPSIZE do
        local row = {}
        for j = 1, MAPSIZE do
            -- table consists {x position of tile, y position of tile}
            table.insert(row, {TILE_WIDTH * j, TILE_HEIGHT * i})
        end
        table.insert(self.map, row)
    end

    -- player
    self.player = Player(WINDOW_WIDTH/2 - 20, WINDOW_HEIGHT/2 - 40, 40, 80)

    -- enemy
    self.enemies = {}
    self.enemyTimer = 0

    -- camera
    camera = require 'camera'
    self.camera = camera()

    self.stopGame = false

end

function PlayState:update(dt)

    if not self.stopGame then
        world:update(dt)
        self.player:update(dt)

        local playerXroundedto100 = self.player.collider:getX() - 10 - ((self.player.collider:getX() - 10)  % TILE_WIDTH)
        local playerYroundedto100 = self.player.collider:getY() - 10 - ((self.player.collider:getY() -10) % TILE_HEIGHT)

        -- local noise = love.math.noise(playerXroundedto100 + 0.1, playerYroundedto100 + 0.1)
        -- print(noise)

        --update the location of every tile
        for x = -(math.floor(MAPSIZE / 2)), math.floor(MAPSIZE / 2) do
            for y = -math.floor(MAPSIZE / 2), math.floor(MAPSIZE / 2) do
                local noise = love.math.noise((playerXroundedto100 + x * TILE_WIDTH) * (playerYroundedto100 + y * TILE_HEIGHT) * 0.00001 + 0.0015)
                -- print(noise)
                self.map[x + math.ceil(MAPSIZE / 2)][y + math.ceil(MAPSIZE / 2)] = {playerXroundedto100 + x * TILE_WIDTH, playerYroundedto100 + y * TILE_HEIGHT, noise}
            end
        end

        self.camera:lookAt(self.player.collider:getX() - 10, self.player.collider:getY() - 10)

        -- enemy generation
        self.enemyTimer = self.enemyTimer + dt

        if self.enemyTimer > 0.5 then
            -- spawns the enemy in all the directions
            local enemyDir = math.random(0, 6.28)
            local enemyX = self.player.collider:getX() + math.cos(enemyDir) * math.max(WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2)
            local enemyY = self.player.collider:getY() + math.sin(enemyDir) * math.max(WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2)
            table.insert(self.enemies, Enemy(enemyX, enemyY, 30))
            self.enemyTimer = 0
        end

        for key, value in pairs(self.enemies) do
            value:update(dt, self.player.collider)

            -- this is for optimisation remove the enemy if it is deleted
            if value.collider.body == nil then
                table.remove(self.enemies, key)
            end
        end

        if self.player.autoShootTimer > 1 then
            self.player:autoShootEnemy(self.enemies)
            self.player.autoShootTimer = 0
        end

        if self.player.currency >= self.player.maxCurrency then
            self.player.currency = 0
            self.player.maxCurrency = self.player.maxCurrency * 1.2
            self.stopGame = true
            SelectThreeRandomPowerups()
        end
    end
    
end

function PlayState:keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end

function PlayState:mousepressed(x, y)
    if self.stopGame then
        -- generate the three powerups for the player to choose
        if x > button1.x and x < button1.x + button1.width and y > button1.y and y < button1.y + button1.height then
            if selectedPowerups[1][2] == "FireBall" then
                table.insert(self.player.aquiredPowerupManagers, selectedPowerups[1][4](self.enemies))
            else
                table.insert(self.player.aquiredPowerupManagers, selectedPowerups[1][4]())
            end
        elseif x > button2.x and x < button2.x + button2.width and y > button2.y and y < button2.y + button2.height then
            if selectedPowerups[2][2] == "FireBall" then
                table.insert(self.player.aquiredPowerupManagers, selectedPowerups[2][4](self.enemies))
            else
                table.insert(self.player.aquiredPowerupManagers, selectedPowerups[2][4]())
            end
        elseif x > button3.x and x < button3.x + button3.width and y > button3.y and y < button3.y + button3.height then
            if selectedPowerups[3][2] == "FireBall" then
                table.insert(self.player.aquiredPowerupManagers, selectedPowerups[3][4](self.enemies))
            else
                table.insert(self.player.aquiredPowerupManagers, selectedPowerups[3][4]())
            end
        end
        self.stopGame = false
    end
end


function PlayState:render()
    self.camera:attach()
    for i = 1, MAPSIZE do
        for j = 1, MAPSIZE do
            --love.graphics.setColor(1, 0, 1)
            if self.map[i][j][3] > 0.7 and self.map[i][j][3] < 0.8 then
                -- local tempRec = world:newRectangleCollider(self.map[i][j][1], self.map[i][j][2], 100, 100)
                -- tempRec:setCollisionClass('tempClass')
                love.graphics.setColor(1, 0, 0)
                love.graphics.draw(self.tileImage, self.map[i][j][1], self.map[i][j][2], 0, TILE_WIDTH/self.tileImage:getWidth(), TILE_HEIGHT/self.tileImage:getHeight())
            elseif self.map[i][j][3] > 0.6 and self.map[i][j][3] < 0.7 then
                love.graphics.setColor(0, 1, 0)
                love.graphics.draw(self.tileImage, self.map[i][j][1], self.map[i][j][2], 0, TILE_WIDTH/self.tileImage:getWidth(), TILE_HEIGHT/self.tileImage:getHeight())
            else
                love.graphics.setColor(1, 1, 1)
                love.graphics.draw(self.tileImage, self.map[i][j][1], self.map[i][j][2], 0, TILE_WIDTH/self.tileImage:getWidth(), TILE_HEIGHT/self.tileImage:getHeight())
            end
            --love.graphics.draw(self.tileImage, self.map[i][j][1], self.map[i][j][2], 0, TILE_WIDTH/self.tileImage:getWidth(), TILE_HEIGHT/self.tileImage:getHeight())
            -- love.graphics.setColor(1, 0, 1)
            -- love.graphics.rectangle("line", self.map[i][j][1], self.map[i][j][2],TILE_WIDTH, TILE_HEIGHT)
            -- love.graphics.setColor(self.map[i][j][3], self.map[i][j][3], self.map[i][j][3])
            -- love.graphics.rectangle("fill", self.map[i][j][1], self.map[i][j][2], TILE_WIDTH, TILE_HEIGHT)
        end
    end

    love.graphics.setColor(0.6, 0.2, 0.8)
    
    for key, enemy in pairs(self.enemies) do
        enemy:render()
    end

    self.player:render()
    -- self.shield:render()
    world:draw()
    self.camera:detach()
    
    love.graphics.rectangle("line", 0, 0, WINDOW_WIDTH, 30)
    love.graphics.rectangle("fill", 0, 0, (self.player.currency / self.player.maxCurrency) * WINDOW_WIDTH, 30)

    if self.stopGame then
        PowerUpSelectGui()
    end
end
