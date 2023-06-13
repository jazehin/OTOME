--[[
TextButtons work on the foundation of the Box model, but without the extra spacing

        border
           |
border - "box" - border
           |
        border
]]

--imports
local Printer = require "require.debug.Printer"
local CollisionCheck = require "require.misc.Collision".RectangleCollides

--variables
local TextButton = {}
local CanvasTypes = {
    normal = 1,
    hover = 2,
    pressed = 3
}

function TextButton:new(text, font, fontcolor, x, y, width, height, bgcolor, hovercolor, pressedcolor, action, border)
    local args = {
        text = text,
        font = font,
        fontcolor = fontcolor,
        x = x,
        y = y,
        innerwidth = width,
        innerheight = height,
        bgcolor = bgcolor,
        hovercolor = hovercolor,
        pressedcolor = pressedcolor,
        action = action,
        border = border
    }

    if not border then
        args.border = {
            width = 0
        }
    end

    args.fullwidth = args.innerwidth + 2 * args.border.width
    args.fullheight = args.innerheight + 2 * args.border.width

    if not font then
        args.font = love.graphics.getFont()
    end

    if not fontcolor then
        args.fontcolor = {0, 0, 0}
    end

    if not hovercolor then
        args.hovercolor = {}
        if args.bgcolor[1] - 20/255 < 0 then
            args.hovercolor[1] = 0
        else
            args.hovercolor[1] = args.bgcolor[1] - 20/255
        end
        if args.bgcolor[2] - 20/255 < 0 then
            args.hovercolor[2] = 0
        else
            args.hovercolor[2] = args.bgcolor[2] - 20/255
        end
        if args.bgcolor[3] - 20/255 < 0 then
            args.hovercolor[3] = 0
        else
            args.hovercolor[3] = args.bgcolor[3] - 20/255
        end
    end

    if not pressedcolor then
        args.pressedcolor = {}
        if args.hovercolor[1] - 20/255 < 0 then
            args.pressedcolor[1] = 0
        else
            args.pressedcolor[1] = args.hovercolor[1] - 20/255
        end
        if args.hovercolor[2] - 20/255 < 0 then
            args.pressedcolor[2] = 0
        else
            args.pressedcolor[2] = args.hovercolor[2] - 20/255
        end
        if args.hovercolor[3] - 20/255 < 0 then
            args.pressedcolor[3] = 0
        else
            args.pressedcolor[3] = args.hovercolor[3] - 20/255
        end
    end

    self.x, self.y = args.x, args.y
    self.action = args.action
    self.canvas = CreateCanvas(args, CanvasTypes.normal)
    self.hoverCanvas = CreateCanvas(args, CanvasTypes.hover)
    self.pressedCanvas = CreateCanvas(args, CanvasTypes.pressed)
    self.isActive = true
    self.isPressed = false
    self.isHoveredOver = false

    return self
end

function CreateCanvas(args, type)
    local canvas = love.graphics.newCanvas(args.fullwidth, args.fullheight)
    love.graphics.setCanvas(canvas)

    if args.border.color then
        love.graphics.setColor(args.border.color)
        love.graphics.rectangle("fill", 0, 0, args.fullwidth, args.fullheight)
    end

    if type == CanvasTypes.normal then
        love.graphics.setColor(args.bgcolor)
    elseif type == CanvasTypes.hover then
        love.graphics.setColor(args.hovercolor)
    elseif type == CanvasTypes.pressed then
        love.graphics.setColor(args.pressedcolor)
    end
    love.graphics.rectangle("fill", args.border.width, args.border.width, args.innerwidth, args.innerheight)

    local textObj = love.graphics.newText(args.font, args.text)

    local textCoordinates = {
        x = args.border.width,
        y = args.border.width + args.innerheight / 2 - textObj:getHeight() / 2
    }

    love.graphics.setColor(args.fontcolor)
    love.graphics.printf(args.text, math.floor(textCoordinates.x), math.floor(textCoordinates.y), args.innerwidth, "center")

    love.graphics.setCanvas()
    love.graphics.reset()
    return canvas
end

function TextButton:update(dt)
    local mousePos = {}
    mousePos.x, mousePos.y = love.mouse.getPosition()
    self.isHoveredOver = CollisionCheck(self.x, self.y, self.canvas:getWidth(), self.canvas:getHeight(), mousePos)

    if self.isHoveredOver and love.mouse.isDown(1) then
        self.isPressed = true
    else
        self.isPressed = false
    end
end

function TextButton:draw()
    if self.isActive and self.isPressed then
        love.graphics.draw(self.pressedCanvas, self.x, self.y)
    elseif self.isActive and self.isHoveredOver then
        love.graphics.draw(self.hoverCanvas, self.x, self.y)
    else
        love.graphics.draw(self.canvas, self.x, self.y)
    end
end

return TextButton