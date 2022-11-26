LavaSpawnManager = Class{}
ArcaneRayManager = Class{}
FireBallManager = Class{}

require "modules.powerups"

-- code for lawa spwan manager
function LavaSpawnManager:init()
    self.spawnTimer = 0
    self.lavaSpawnTime = 10
    self.lavaZoneRadius = 200
    self.activeSpawns = {}


end

function LavaSpawnManager:update(dt, playerPos)
    self.spawnTimer = self.spawnTimer + dt

    if (self.spawnTimer > self.lavaSpawnTime) then
        table.insert(self.activeSpawns, LavaZone(math.random(playerPos[1] - WINDOW_WIDTH/2 + 50, playerPos[1] + WINDOW_WIDTH/2 - 50), math.random(playerPos[2] - WINDOW_HEIGHT/2 + 50, playerPos[2] + WINDOW_HEIGHT/2 - 50), self.lavaZoneRadius))
        self.spawnTimer = 0
        
    end

    for key, value in pairs(self.activeSpawns) do
        if value.collider.body then
            value:update(dt)
        else
            table.remove(self.activeSpawns, key)
        end

    end
end

function LavaSpawnManager:render()
    for key, value in pairs(self.activeSpawns) do
        value:render()
    end
end

-- code for arcane ray manager
function ArcaneRayManager:init()
    self.spawnTimer = 0
    self.arcaneSpawnTime = 5
    self.activeRays = {}

    self.raySound_sfx = love.audio.newSource('assets/sounds/arcaneRay_sfx.wav', "static")
    self.raySound_sfx:setVolume(0.2)
end

function ArcaneRayManager:update(dt, playerPos)
    self.spawnTimer = self.spawnTimer + dt

    if self.spawnTimer > self.arcaneSpawnTime then
        table.insert(self.activeRays, ArcaneRay(playerPos[1], playerPos[2], playerPos))
        self.spawnTimer = 0
        self.raySound_sfx:play()
    end

    for key, ray in pairs(self.activeRays) do
        if (ray.collider.body) then
            ray:update(dt)
        else
            -- destroy the objects whose ray has been removed
            table.remove(self.activeRays, key)
        end
    end
end

function ArcaneRayManager:render()
    for key, ray in pairs(self.activeRays) do
        if ray.collider.body then
            ray:render()
        end
        
    end
end

--code for fireBallManager

function FireBallManager:init(enemies)
    self.enemies = enemies
    self.spwanTimer = 0
    self.fireBallSpawnTime = 2

    self.activeFireBalls = {}
end

function FireBallManager:update(dt, playerPos)
    self.spwanTimer = self.spwanTimer + dt

    if self.spwanTimer >= self.fireBallSpawnTime then
        table.insert(self.activeFireBalls, FireBall(playerPos[1], playerPos[2], self.enemies))
        self.spwanTimer = 0
    end

    for key, value in pairs(self.activeFireBalls) do
        if value.collider.body then
            value:update(dt)
        else
            table.remove(self.activeFireBalls, key)
        end
    end
end

function FireBallManager:render()
    for key, value in pairs(self.activeFireBalls) do
        if value.collider.body then
            value:render()
        end
        
    end
end