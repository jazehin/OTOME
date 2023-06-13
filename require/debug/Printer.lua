local function Printer (obj, level)
    local tabs = ""
    for i = 1, level, 1 do
        tabs = tabs .. "\t"
    end
    for key, value in pairs(obj) do
        if type(value) == "table" then
            print(tabs .. key .. " :")
            Printer(value, level + 1)
        else
            if type(value) == "function" then
                print(tabs .. key .. " : function")
            elseif type(value) == "thread" then
                print(tabs .. key .. " : thread")
            elseif type(value) == "userdata" then
                print(tabs .. key .. " : userdata")
            else
                print(tabs .. key .. " : " .. value)
            end
        end
    end
end

return Printer