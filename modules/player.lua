Player = Class{}

function Player:init(x, y, width, height)
    assert(type(x) == "number", "please provide a number value for x")
    self.collider = world:newRectangleCollider(x, y, width, height)
    self.speed = 400
    self.collider:setCollisionClass('player')
    self.bullets = {}
    self.currency = 0
    self.maxCurrency = 100
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
    if minDistance < WINDOW_HEIGHT * 2 / 3 then
        if targetEnemy[1] ~= nil then
            self:shootEnemy(targetEnemy[1])
        end
    end
end

function Player:update(dt)
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
            print("bullet removed fromt the table")
            table.remove(self.bullets, key)
        end
    end
end

function Player:render()
    for key, value in pairs(self.bullets) do
        if value.body then
            love.graphics.circle("fill", value:getX(), value:getY(), 5)
        end
    end


end