function FindItemById(items, itemId)
    for _, item in ipairs(items) do
        if item.id == itemId then
            return item
        end

        if item.items then
            local nestedItem = FindItemById(item.items, itemId)
            if nestedItem then
                return nestedItem
            end
        end
    end

    return nil
end
