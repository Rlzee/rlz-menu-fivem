function IsColor(value)
    if type(value) == "string" then
        return true
    end

    if type(value) ~= "table" or #value == 0 then
        return false
    end

    for _, color in ipairs(value) do
        if type(color) ~= "string" then
            return false
        end
    end

    return true
end
