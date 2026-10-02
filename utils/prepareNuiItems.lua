local function prepareNuiValue(value)
    if type(value) == "function" then
        return nil
    end

    if type(value) ~= "table" then
        return value
    end

    local preparedValue = {}

    for key, nestedValue in pairs(value) do
        local preparedNestedValue = prepareNuiValue(nestedValue)
        if preparedNestedValue ~= nil then
            preparedValue[key] = preparedNestedValue
        end
    end

    return preparedValue
end

function PrepareNuiItems(items)

    local nuiItems = {}

    for _, item in ipairs(items) do

        table.insert(nuiItems, prepareNuiValue(item))
    end

    return nuiItems
end