Player = Class{}

function Player:init(x, y, width, height)
    assert(type(x) == "number", "please provide a number value for x")
    self.collider = world:newRectangleCollider(x, y, width, height)
    self.collider:setFixedRotation(true)

    self.speed = 400
    self.collider:setCollisionClass('player')
    
    self.bullets = {}
    self.currency = 0
    -- default is 100
    self.maxCurrency = 50
    self.autoShootTimer = 0
    self.enemyShootRange = WINDOW_HEIGHT / 2
    self.aquiredPowerupManagers = {}
    self.shooting_sfx = love.audio.newSource('assets/sounds/shooting_sfx.wav', "static")
end

function Player:shootEnemy(enemy)
    local slope = math.atan2(enemy.collider:getY() - self.collider:getY(), enemy.collider:getX() - self.collider:getX())
    local xDir = math.cos(slope)
    local yDir = math.sin(slope)

    local bullet = world:newCircleCollider(self.collider:getX(), self.collider:getY(), 10)
    bullet.xVelo = xDir
    bullet.yVelo = yDir
    bullet.speed = 1000
    bullet:setCollisionClass('bullet')
    table.insert(self.bullets, bullet)
    self.shooting_sfx:play()
end

function Player:updateBullet(dt, bullet)
    -- update the bullet's position
    if bullet.body then
        bullet:setX(bullet:getX() + bullet.xVelo * bullet.speed * dt)
        bullet:setY(bullet:getY() + bullet.yVelo * bullet.speed * dt)

        if bullet:enter('enemy') then
            local collision_data = bullet:getEnterCollisionData('enemy')
            collision_data.collider:destroy()
            self.currency = self.currency + 10
            bullet:destroy()
        end
    end
end

function Player:autoShootEnemy(enemyTable)
    local minDistance = math.huge
    local targetEnemy = {nil}
    for key, enemy in pairs(enemyTable) do
        if enemy.collider.body then
            local distanceToEnemy = math.sqrt(math.pow(self.collider:getX() - enemy.collider:getX(), 2) + math.pow(self.collider:getY() - enemy.collider:getY(), 2))
            if distanceToEnemy < minDistance then
                minDistance = distanceToEnemy
                targetEnemy[1] = enemy
            end
        end
    end

    -- only shoot if enemy is within our range
    if minDistance < self.enemyShootRange then
        if targetEnemy[1] ~= nil then
            self:shootEnemy(targetEnemy[1])
        end
    end
end

function Player:update(dt)
    self.autoShootTimer = self.autoShootTimer + dt

    -- player movement
    if love.keyboard.isDown('w') then
        self.collider:setY(self.collider:getY() - math.floor(self.speed * dt))
    end
    if love.keyboard.isDown('s') then
        self.collider:setY(self.collider:getY() + math.floor(self.speed * dt))
    end
    if love.keyboard.isDown('a') then
        self.collider:setX(self.collider:getX() - math.floor(self.speed * dt))
    end
    if love.keyboard.isDown('d') then
        self.collider:setX(self.collider:getX() + math.floor(self.speed * dt))
    end  

    -- update the shot bullet
    for key, bullet in pairs(self.bullets) do
        self:updateBullet(dt, bullet)

        -- this is for the optimisation purpose, remove the bullet if it hit the enemy
        if bullet.body == nil then
            table.remove(self.bullets, key)
        end
    end

    self:updateSpawnManagers(dt)
end

function Player:updateSpawnManagers(dt)
    for key, sm in pairs(self.aquiredPowerupManagers) do
        sm:update(dt, {self.collider:getX(), self.collider:getY()})
    end
end

function Player:renderSpawnManagers()
    for key, value in pairs(self.aquiredPowerupManagers) do
        value:render()
    end
end

function Player:render()
    -- render the player
    love.graphics.rectangle("fill", self.collider:getX() - 20, self.collider:getY() - 40, 40, 80)


    for key, value in pairs(self.bullets) do
        if value.body then
            love.graphics.circle("fill", value:getX(), value:getY(), 5)
        else
            table.remove(self.bullets, key)
        end
    end

    self:renderSpawnManagers()
    love.graphics.circle("line", self.collider:getX(), self.collider:getY(), self.enemyShootRange)
end