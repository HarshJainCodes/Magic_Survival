PlayState = Class{__includes = BaseState}

require 'modules.player'
require 'modules.enemy'
require 'modules.powerups'
require 'gui.powerUpSelect'

function PlayState:init()
    math.randomseed(os.time())

    self.tileImage = love.graphics.newImage('tile.jpg')

    self.map = {}

    TILE_WIDTH = 100
    TILE_HEIGHT = 100

    MAPSIZE = 17    -- default is 17
       -- increasing the mapsize will recude frames

    for i = 1, MAPSIZE do
        local row = {}
        for j = 1, MAPSIZE do
            -- table consists {x position of tile, y position of tile}
            table.insert(row, {TILE_WIDTH * j, TILE_HEIGHT * i})
        end
        table.insert(self.map, row)
    end

    -- player
    self.player = Player(WINDOW_WIDTH/2 - 10, WINDOW_HEIGHT/2 - 10, 20, 20)

    -- enemy
    self.enemies = {}
    self.enemyTimer = 0
    --table.insert(self.enemies, Enemy(100, 200, 30))

    -- camera
    camera = require 'camera'
    self.camera = camera()

    -- auto shoot
    self.autoShootTimer = 0

    --self.shield = ElectricShield(self.player.collider:getX(), self.player.collider:getY(), 100)
    self.aquiredPowerups = {}
    self.stopGame = false

    
end

function PlayState:update(dt)
    if self.player.currency >= self.player.maxCurrency then
        self.stopGame = true
    end

    if not self.stopGame then
        self.player:update(dt)

        local playerXroundedto100 = self.player.collider:getX() - 10 - ((self.player.collider:getX() - 10)  % TILE_WIDTH)
        local playerYroundedto100 = self.player.collider:getY() - 10 - ((self.player.collider:getY() -10) % TILE_HEIGHT)

        -- local noise = love.math.noise(playerXroundedto100 + 0.1, playerYroundedto100 + 0.1)
        -- print(noise)

        --update the location of every tile
        for x = -(math.floor(MAPSIZE / 2)), math.floor(MAPSIZE / 2) do
            for y = -math.floor(MAPSIZE / 2), math.floor(MAPSIZE / 2) do
                local noise = love.math.noise((playerXroundedto100 + x * TILE_WIDTH) * (playerYroundedto100 + y * TILE_HEIGHT) * 0.00001 + 0.0015)
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
                print("enemy removed from the table")
                table.remove(self.enemies, key)
            end
        end


        -- autoBulletShoot
        self.autoShootTimer = self.autoShootTimer + dt
        if self.autoShootTimer > 1 then
            self.player:autoShootEnemy(self.enemies)
            self.autoShootTimer = 0
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
        if x > powerup1.x and x < powerup1.x + powerup1.width and y > powerup1.y and y < powerup1.y + powerup1.height then
            powerupSelected = powerup1.power.name
            self.stopGame = false
            self.player.currency = 0
            powerSelected = false
        elseif x > powerup2.x and x < powerup2.x + powerup2.width and y > powerup2.y and y < powerup2.y + powerup2.height then
            powerupSelected = powerup2.power.name
            self.stopGame = false
            self.player.currency = 0
            powerSelected = false
        elseif x > powerup3.x and powerup3.x + powerup3.width and y > powerup3.y and y < powerup3.y + powerup3.height then
            powerupSelected = powerup3.power.name
            self.stopGame = false
            self.player.currency = 0
            powerSelected = false
        end
    end
end

function PlayState:render()
    self.camera:attach()
    for i = 1, MAPSIZE do
        for j = 1, MAPSIZE do
            --love.graphics.setColor(1, 0, 1)
            love.graphics.draw(self.tileImage, self.map[i][j][1], self.map[i][j][2], 0, TILE_WIDTH/self.tileImage:getWidth(), TILE_HEIGHT/self.tileImage:getHeight())
            -- love.graphics.setColor(1, 0, 1)
            -- love.graphics.rectangle("line", self.map[i][j][1], self.map[i][j][2],TILE_WIDTH, TILE_HEIGHT)
            -- love.graphics.setColor(self.map[i][j][3], self.map[i][j][3], self.map[i][j][3])
            -- love.graphics.rectangle("fill", self.map[i][j][1], self.map[i][j][2], TILE_WIDTH, TILE_HEIGHT)
        end
    end

    love.graphics.setColor(0.6, 0.2, 0.8)
    love.graphics.rectangle("fill", self.player.collider:getX() - 10, self.player.collider:getY() - 10, 20, 20)
    
    for key, enemy in pairs(self.enemies) do
        enemy:render()
    end

    self.player:render()
    -- self.shield:render()
    self.camera:detach()
    love.graphics.rectangle("line", 0, 0, WINDOW_WIDTH, 30)
    love.graphics.rectangle("fill", 0, 0, (self.player.currency / self.player.maxCurrency) * WINDOW_WIDTH, 30)

    if self.stopGame then
        PowerUpSelectGui()
    end

    if powerupSelected ~= nil then
        print(powerupSelected)
    end
end
