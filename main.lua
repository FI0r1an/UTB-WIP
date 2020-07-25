
local love = _G.love
local lg = love.graphics

_G.class = require("class")
local lua = require("lua/hotFix/sourceUpdate")()

function love.load()

end

function love.update(dt)

end

function love.draw()

end

function love.keypressed(...)

end

function love.keyreleased(...)

end

function love.mousepressed(...)

end

function love.mousereleased(...)

end

function love.errorhandler(msg)
    lg.setBackgroundColor(1, 0.5, 1, 1)
    lg.setColor(1, 1, 1, 1)
    return function ()
        lg.print(msg, 96, 64)
    end
end
