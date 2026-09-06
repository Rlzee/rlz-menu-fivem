RegisterNUICallback("rlz_menu:selectButton", function(data, cb)

    local itemId = data.itemId

    for _, item in ipairs(ITEMS) do

        if item.id == itemId and item.type == "button" then

            if item.onSelect then
                item.onSelect()
            end

            break
        end

    end

    cb({ ok = true })

end)

RegisterNUICallback("rlz_menu:toggleCheckbox", function(data, cb)

    local itemId = data.itemId

    for _, item in ipairs(ITEMS) do

        if item.id == itemId and item.type == "checkbox" then

            item.isChecked = not item.isChecked

            TriggerNuiEvent("rlz_menu:setData", {
                title = MENUS[CURRENT_MENU].title,
                subtitle = MENUS[CURRENT_MENU].subtitle,
                items = PrepareNuiItems(ITEMS),
            })

            if item.onChange then
                item.onChange(item.isChecked)
            end

            break
        end

    end

    cb({ ok = true })

end)