Enemy = Class{}

function Enemy:init(x, y, radius)
    self.collider = world:newCircleCollider(x, y, radius)
    self.radius = radius
    self.slope = 0
    self.speed = 0.5
    self.collider:setCollisionClass('enemy')
end

function Enemy:update(dt, target)

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
        love.graphics.setColor(1, 0, 1)
        love.graphics.circle("fill", self.collider:getX(), self.collider:getY(), self.radius)
    end
    
end