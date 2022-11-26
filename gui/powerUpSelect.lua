-- contains the gui for selecting the powerup
-- implements one of the core feature of the game that is to select the powerups on the go
math.randomseed(os.time())

local allPowerUps = {
    {
        1,
        "LavaZone",
        "Cast a LavaZone that damages enemy at a random location on the map",
        function ()
            return LavaSpawnManager()
        end
    },
    {
        2,
        "ArcaneRay",
        "shoot a ray that pierces through enemy",
        function ()
            return ArcaneRayManager()
        end
    },
    {
        3,
        "FireBall",
        "cast a FireBall towards the closest enemy casing splash damage upon burst",
        function (enemies)
            return FireBallManager(enemies)
        end
    }
}

selectedPowerups = {

}

Button = Class{}
function Button:init(x, y, width, height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
end

button1 = Button(WINDOW_WIDTH/8, WINDOW_HEIGHT/8, 2 * WINDOW_WIDTH/8, 6 * WINDOW_HEIGHT/8)
button2 = Button(3 * WINDOW_WIDTH/8, WINDOW_HEIGHT/8, 2 * WINDOW_WIDTH/8, 6 * WINDOW_HEIGHT/8)
button3 = Button(5 * WINDOW_WIDTH/8, WINDOW_HEIGHT/8, 2 * WINDOW_WIDTH/8, 6 * WINDOW_HEIGHT/8)

function SelectThreeRandomPowerups()
    selectedPowerups = {}
    local start = math.random(#allPowerUps)
    for i = 1, 3 do
        start = start % (#allPowerUps)
        table.insert(selectedPowerups, allPowerUps[start + 1])
        start = start + 1
    end
end

local levelupFont = love.graphics.newFont(50)
local displayFont = love.graphics.newFont(35)
local descriptionFont = love.graphics.newFont(25)


function PowerUpSelectGui()
    if #selectedPowerups == 3 then
        love.graphics.setColor(1, 1, 1, 0.7)
        -- for the outer rectangle
        love.graphics.rectangle("fill", WINDOW_WIDTH/8, WINDOW_HEIGHT/8, 6 * WINDOW_WIDTH/8, 6 * WINDOW_HEIGHT/8, 30, 30)

        -- for the three options

                                                        --BUTTON 1
        love.graphics.setColor(1, 0, 0, 0.6)
        love.graphics.rectangle("fill", button1.x, button1.y, button1.width, button1.height, 20, 20)
        love.graphics.setFont(displayFont)
        love.graphics.setColor(1, 1, 1, 1)
        --display the name of the powerup
        love.graphics.printf(selectedPowerups[1][2], button1.x, button1.y + 20, button1.width, "center")
        love.graphics.setFont(descriptionFont)
        --display the description of the powerup
        love.graphics.printf(selectedPowerups[1][3], button1.x, button1.y + 80, button1.width, "center")

                                                        --BUTTON2
        love.graphics.setColor(0, 1, 0, 0.6)
        love.graphics.rectangle("fill", button2.x, button2.y, button2.width, button2.height, 20)
        love.graphics.setFont(displayFont)
        love.graphics.setColor(1, 1, 1, 1)
        --display the name of the powerup
        love.graphics.printf(selectedPowerups[2][2], button2.x, button2.y + 20, button2.width, "center")
        love.graphics.setFont(descriptionFont)
        --display the description of the powerup
        love.graphics.printf(selectedPowerups[2][3], button2.x, button2.y + 80, button2.width, "center")
        
                                                        --BUTTON 3
        love.graphics.setColor(0, 0, 1, 0.6)
        love.graphics.rectangle("fill", button3.x, button3.y, button3.width, button3.height, 20)
        love.graphics.setFont(displayFont)
        love.graphics.setColor(1, 1, 1, 1)
        --display the name of the powerup
        love.graphics.printf(selectedPowerups[3][2], button3.x, button3.y + 20, button3.width, "center")
        love.graphics.setFont(descriptionFont)
        --display the description of the powerup
        love.graphics.printf(selectedPowerups[3][3], button3.x, button3.y + 80, button3.width, "center")
    end
end