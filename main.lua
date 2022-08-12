WINDOW_WIDTH = 1200
WINDOW_HEIGHT = 700

push = require 'push'
Class = require 'Class'
require 'StateMachine'
require 'states/BaseState'
require 'states/PlayState'
wf = require 'libraries.windfield.windfield'

function love.load()
    push:setupScreen(WINDOW_WIDTH, WINDOW_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        vsync = true,
        resizable = true
    })
    --love.window.setVSync(0)

    love.graphics.setDefaultFilter("nearest", "nearest")

    gStateMachine = StateMachine{
        ['play'] = function () return PlayState() end
    }

    gStateMachine:change('play')
end

world = wf.newWorld(0, 0, false)
world:addCollisionClass('player')
world:addCollisionClass('enemy')
world:addCollisionClass('bullet', {ignores = {'player'}})


function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    gStateMachine.current:keypressed(key)
end

function love.update(dt)
    gStateMachine:update(dt)
    world:update(dt)
end

function love.draw()
    push:apply('start')
    gStateMachine:render()

    --world:draw() does not cooperate with camera so comment the world draw to see the result
    --world:draw()
    love.graphics.setColor(0, 0, 0)
    love.graphics.print(love.timer.getFPS(), 0, 0)
    push:apply('end')
end