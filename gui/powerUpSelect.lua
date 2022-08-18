-- contains the gui for selecting the powerup

local levelupFont = love.graphics.newFont(50)
local displayFont = love.graphics.newFont(35)
powerSelected = false

function PowerUpSelectGui()
    
    love.graphics.setColor(1, 1, 1, 0.5)
    --love.graphics.printf("select an upgrade", WINDOW_WIDTH/4, WINDOW_HEIGHT/4 + 20, WINDOW_WIDTH/2, "center")

    --powerup1 = Powerups[1]
    -- powerup2 = Powerups[2]
    -- powerup3 = Powerups[3]


    --powerup3.power = Powerups[math.random(1, 3)]

    if not powerSelected then
        powerup1 = {}
        powerup1.x = WINDOW_WIDTH/8 + 75
        powerup1.y = WINDOW_HEIGHT/8 + 125
        powerup1.width = 3 / 4  * WINDOW_WIDTH / 3.6
        powerup1.height = 2.5 * WINDOW_HEIGHT/4 - 100
    
        powerup2 = {}
        powerup2.x = 250 + WINDOW_WIDTH/8 + 75
        powerup2.y = WINDOW_HEIGHT/8 + 125
        powerup2.width = 3 / 4  * WINDOW_WIDTH / 3.6
        powerup2.height = 2.5 * WINDOW_HEIGHT/4 - 100
        --powerup2.power = Powerups[math.random(1, 3)]
    
        powerup3 = {}
        powerup3.x = 500 + WINDOW_WIDTH/8 + 75
        powerup3.y = WINDOW_HEIGHT/8 + 125
        powerup3.width = 3 / 4  * WINDOW_WIDTH / 3.6
        powerup3.height = 2.5 * WINDOW_HEIGHT/4 - 100
        powerup1.power = Powerups[math.random(1, #Powerups)]
        powerup2.power = Powerups[math.random(1, #Powerups)]
        powerup3.power = Powerups[math.random(1, #Powerups)]
        powerSelected = true
    end

    love.graphics.setFont(levelupFont)
    love.graphics.rectangle("fill", WINDOW_WIDTH/8, WINDOW_HEIGHT/8, 3 * WINDOW_WIDTH / 4, 3 * WINDOW_HEIGHT / 4, 30, 30)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.printf("Level Up", WINDOW_WIDTH/8, WINDOW_HEIGHT/8 + 30, 3 * WINDOW_WIDTH / 4, "center")

    love.graphics.rectangle("line", powerup1.x, powerup1.y, powerup1.width, powerup1.height, 20, 20)
    love.graphics.setFont(displayFont)
    love.graphics.printf(powerup1.power.name, powerup1.x, powerup1.y, powerup1.width, "center")
    love.graphics.printf(powerup1.power.ability, powerup1.x, powerup1.y + 100, powerup1.width, "center")


    love.graphics.rectangle("line", powerup2.x, powerup2.y,  powerup2.width, powerup2.height, 20, 20)
    love.graphics.printf(powerup2.power.name, powerup2.x, powerup2.y, powerup2.width, "center")
    love.graphics.printf(powerup2.power.ability, powerup2.x, powerup2.y + 100, powerup2.width, "center")


    love.graphics.rectangle("line", powerup3.x, powerup3.y,  powerup3.width, powerup3.height, 20, 20)
    love.graphics.printf(powerup3.power.name, powerup3.x, powerup3.y, powerup3.width, "center")
    love.graphics.printf(powerup3.power.ability, powerup3.x, powerup3.y + 100, powerup3.width, "center")
end