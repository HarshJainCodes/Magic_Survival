Powerups = {
    {["name"] = "ElectricShield", ["ability"] = "Generates a shield around player"},
    {["name"] = "LavaZone", ["ability"] = "Creates a lavaZone randomly in the map"},
    {["name"] = "haste", ["ability"] = "increases the player speed by 1%"}
}

ElectricShield = Class{}

function ElectricShield:init(x, y, radius)
    self.collider = world:newCircleCollider(x, y, radius)
    self.radius = radius
    self.collider:setCollisionClass('electricShield')
end

function ElectricShield:update(dt)
    
end

function ElectricShield:render()
    love.graphics.circle("line", self.collider:getX(), self.collider:getY(), self.radius)
end

LavaZone = Class{}

function LavaZone:init(x, y, radius)
    self.collider = world:newCircleCollider(x, y, radius)
end

function Haste(player)
    player.speed = player.speed + player.speed * 0.01
end

