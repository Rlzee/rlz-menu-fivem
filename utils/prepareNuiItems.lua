function PrepareNuiItems(items)

    local nuiItems = {}

    for _, item in ipairs(items) do

        local nuiItem = {}

        for key, value in pairs(item) do
            if type(value) ~= "function" then
                nuiItem[key] = value
            end
        end

        table.insert(nuiItems, nuiItem)
    end

    return nuiItems
end