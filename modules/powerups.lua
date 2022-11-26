-- this section is for lavaZone class
LavaZone = Class{}

function LavaZone:init(x, y, radius)
    self.radius = radius
    self.collider = world:newCircleCollider(x, y, radius)
    self.collider:setCollisionClass('lavaZone')
    self.durationTimer = 0
    self.lavaImage = love.graphics.newImage('assets/red_lava.png')
end

function LavaZone:update(dt)
    if self.collider.body then
        self.durationTimer = self.durationTimer + dt
        if self.durationTimer > 10 then
            self.collider:destroy()
        end

        if self.collider:enter('enemy') then
            local collision_data = self.collider:getEnterCollisionData('enemy')
            collision_data.collider.underAttack = true
        end
        if self.collider:exit('enemy') then
            local collision_data = self.collider:getExitCollisionData('enemy')
            collision_data.collider.underAttack = false
        end
    end
    
end

function LavaZone:render()
    --love.graphics.circle("fill", self.collider:getX(), self.collider:getY(), self.radius)
    if self.collider.body then
        love.graphics.setBlendMode("screen")
        love.graphics.draw(self.lavaImage, self.collider:getX(), self.collider:getY(), 0, 2 * self.radius/self.lavaImage:getWidth(), 2 * self.radius/self.lavaImage:getHeight(), self.lavaImage:getWidth()/2, self.lavaImage:getHeight()/2)
        love.graphics.setBlendMode("alpha")
        love.graphics.setColor(1, 1, 1, 1)
    end

end


-- this section is for arcane ray
ArcaneRay = Class{}

function ArcaneRay:init(x, y, playerPos)
    self.x = x
    self.y = y
    -- self.slope = math.random(-3.14, 3.14)
    -- self.targetX = playerPos[1] + math.cos(self.slope) * 2 * WINDOW_WIDTH
    -- self.targetY = playerPos[2] + math.sin(self.slope) * 2 * WINDOW_WIDTH
    self.targetX = math.random(playerPos[1] - 2 * WINDOW_WIDTH, playerPos[1] + 2 * WINDOW_WIDTH)
    self.targetY = math.random(playerPos[2] - 2 * WINDOW_HEIGHT, playerPos[2] + 2 * WINDOW_HEIGHT)
    self.slope = math.atan2(self.targetY - playerPos[2], self.targetX - playerPos[1])


    self.collider = world:newLineCollider(self.x, self.y, self.targetX, self.targetY)
    self.collider:setCollisionClass("arcaneRay")
    self.image = love.graphics.newImage('assets/laser.jpg')

    self.durationTimer = 0
end

function ArcaneRay:update(dt)
    if self.collider.body then
        self.durationTimer = self.durationTimer + dt
    
        if self.durationTimer > 0.3 then
            self.collider:destroy()
        end

        if self.collider:enter('enemy') then
            local collision_data = self.collider:getEnterCollisionData('enemy')
            if collision_data.collider.body then
                collision_data.collider:destroy()
            end
            
        end
    end
end

function ArcaneRay:render()
    if self.collider.body then
        love.graphics.setColor(1, 1, 1)
        --love.graphics.line(self.x, self.y, self.targetX, self.targetY)
        love.graphics.draw(self.image, self.x, self.y, self.slope, math.sqrt(math.pow(self.targetY - self.y, 2) + math.pow(self.targetX - self.x, 2))/self.image:getWidth(), 5/self.image:getHeight())
    end

end

-- this section is for fireball
FireBall = Class{}

function FireBall:init(x, y, enemies)
    self.enemies = enemies
    self.collider = world:newCircleCollider(x, y, 20)
    self.collider:setCollisionClass('fireBall')
    self.speed = 200
    self.image = love.graphics.newImage('assets/fireball.png')
    self.timeToLive = 10
    self.timeToLiveTimer = 0

    self.slope = nil

    local closestX = nil
    local closestY = nil
    local minDistance = math.huge

    for key, enemy in pairs(self.enemies) do
        if enemy.collider.body then
            local distance = math.sqrt(math.pow(enemy.collider:getY() - y, 2) + math.pow(enemy.collider:getX() - x, 2))
            if distance < minDistance then
                minDistance = distance
                closestX = enemy.collider:getX()
                closestY = enemy.collider:getY()
            end
        end
    end

    if closestX ~= nil and closestY ~= nil then
        self.slope = math.atan2(closestY - y, closestX - x)
    end

end

function FireBall:update(dt)
    if self.collider.body and self.slope ~= nil then
        self.collider:setX(self.collider:getX() + math.cos(self.slope) * self.speed * dt)
        self.collider:setY(self.collider:getY() + math.sin(self.slope) * self.speed * dt)
    end

    if self.collider.body then
        self.timeToLiveTimer = self.timeToLiveTimer + dt
        if self.timeToLiveTimer > self.timeToLive then
            self.collider:destroy()
            return
        end

        if self.collider:enter('enemy') then
            local collision_data = self.collider:getEnterCollisionData('enemy')
            if collision_data.collider.body then
                collision_data.collider:destroy()
            end
            
            self.collider:destroy()
        end
    end
end

function FireBall:render()
    if self.collider.body then
        love.graphics.draw(self.image, self.collider:getX(), self.collider:getY(), self.slope, 40/self.image:getWidth(), 40/self.image:getHeight(), self.image:getWidth()/2, self.image:getHeight()/2)
    end
end