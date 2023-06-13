--imports
local TextButton = require "require.buttons.TextButton"

--variables
local buttons = {}

local exit = function ()
    love.window.close()
end

function love.load()
    local border = {
        color = {100/255, 100/255, 100/255},
        width = 3
    }
    table.insert(buttons, TextButton:new("Click me!", nil, nil, 100, 100, 200, 30, {0, 0, 0}, {1, 192/255, 203/255}, {0, 1, 1}, exit, border))
end

function love.update(dt)
    for _, button in pairs(buttons) do
        button:update(dt)
    end
end

function love.draw()
    for _, button in pairs(buttons) do
        button:draw()
    end
end

function love.mousemoved(x, y, dx, dy, istouch)
    
end

function love.mousereleased(x, y, button, istouch, presses)
    if button ~= 1 and not istouch then return end

    for _, button in pairs(buttons) do
        if button.isPressed then
            button.action()
        end
    end
end