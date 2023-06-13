local Collision = {}

function verticesConverter(vertices)
    local t = {}
    for i = 1, #vertices / 2, 1 do
        table.insert(t, {x = vertices[i * 2 - 1], y = vertices[i * 2]})
    end
    return t
end

function Collision.PolygonCollides(vertices, mousePos) --http://www.jeffreythompson.org/collision-detection/poly-point.php
    vertices = verticesConverter(vertices)

    local collides = false

    -- go through each of the vertices, plus
    -- the next vertex in the list
    local next = 1
    for current = 1, #vertices, 1 do 

        -- get next vertex in list
        -- if we've hit the end, wrap around to 0
        next = current + 1
        if (next > #vertices) then next = 1 end

        -- get the PVectors at our current position
        -- this makes our if statement a little cleaner
        local vc = vertices[current]    -- c for "current"
        local vn = vertices[next]       -- n for "next"

        -- compare position, flip 'collision' variable
        -- back and forth
        if (
            (
                (
                    vc.y >= mousePos.y and vn.y < mousePos.y
                ) or (
                    vc.y < mousePos.y and vn.y >= mousePos.y
                )
            ) and (
                mousePos.x < 
                (
                    vn.x-vc.x
                )*(
                    mousePos.y-vc.y
                ) / (
                    vn.y-vc.y
                )+vc.x
            )
        ) then
            collides = not collides
        end
    end
    return collides;
end

function Collision.RectangleCollides(x, y, width, height, mousePos)
    local collides = 
        mousePos.x >= x and
        mousePos.x <= x + width and
        mousePos.y >= y and
        mousePos.y <= y + height
    return collides
end

return Collision