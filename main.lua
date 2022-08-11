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

    love.graphics.setDefaultFilter("nearest", "nearest")

    gStateMachine = StateMachine{
        ['play'] = function () return PlayState() end
    }

    gStateMachine:change('play')
end

world = wf.newWorld(0, 10, false)


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
    world:draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.print(love.timer.getFPS(), 0, 0)
    push:apply('end')
end