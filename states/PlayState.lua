PlayState = Class{__includes = BaseState}

function PlayState:init()
    
end

function PlayState:update(dt)

end

function PlayState:keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end

function PlayState:render()
    
end