Enemy = Class{}

function Enemy:init(x, y, radius)
    self.collider = world:newCircleCollider(x, y, radius)
    self.collider.underAttack = false
    self.collider.health = 100

    self.radius = radius
    self.slope = 0
    self.speed = 0.5
    self.collider:setCollisionClass('enemy')
    self.normalColor = {1, 0, 1}
    self.attackedColor = {0, 0, 1}
end

function Enemy:update(dt, target)
    if self.collider.underAttack then
        self.collider.health = self.collider.health - 1
        if self.collider.health <= 0 then
            if self.collider.body then
                self.collider:destroy()
            end
            
        end
    end

    -- sets the direction is which the enemy needs to go
    if self.collider.body then
        self.slope = math.atan2(target:getY() - self.collider:getY(), target:getX() - self.collider:getX())
        self.dirX = math.cos(self.slope) * WINDOW_WIDTH / 8 
        self.dirY = math.sin(self.slope) * WINDOW_WIDTH / 8

        -- updates the enemy direction
        self.collider:setX(self.collider:getX() + self.dirX * self.speed * dt)
        self.collider:setY(self.collider:getY() + self.dirY * self.speed * dt)
    end
    
end

function Enemy:render()
    if self.collider.body then
        if self.collider.underAttack then
            love.graphics.setColor(self.attackedColor)
        else
            love.graphics.setColor(self.normalColor)
        end
        love.graphics.circle("fill", self.collider:getX(), self.collider:getY(), self.radius)
    end
    
end