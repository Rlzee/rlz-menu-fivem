RegisterNUICallback("rlz_menu:selectButton", function(data, cb)

    local itemId = data.itemId

    for _, item in ipairs(ITEMS) do

        if item.id == itemId and item.type == "button" then

            if item.disabled then
                cb({ ok = false, disabled = true })
                return
            end

            if not item.submenu then
                playSound("select")
            end

            if item.onSelect then
                item.onSelect()
            end

            if item.submenu then

                local submenu = MENUS[item.submenu]

                if submenu then
                    rlzMenu.SetVisible(CURRENT_MENU, false)
                    rlzMenu.SetVisible(item.submenu, true)
                end

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

            if item.disabled then
                cb({ ok = false, disabled = true })
                return
            end

            item.isChecked = not item.isChecked
            CHECKBOX_STATES[item.id] = item.isChecked

            TriggerNuiEvent("rlz_menu:setData", {
                title = MENUS[CURRENT_MENU].title,
                subtitle = MENUS[CURRENT_MENU].subtitle,
                color = MENUS[CURRENT_MENU].color,
                position = MENUS[CURRENT_MENU].position,
                items = PrepareNuiItems(ITEMS),
            })

            playSound("select")

            if item.onChange then
                item.onChange(item.isChecked)
            end

            break
        end

    end

    cb({ ok = true })

end)

RegisterNUICallback("rlz_menu:changeList", function(data, cb)

    local itemId = data.itemId
    local direction = data.direction

    if direction ~= "left" and direction ~= "right" then
        cb({ ok = false })
        return
    end

    for _, item in ipairs(ITEMS) do

        if item.id == itemId and item.type == "list" then

            if item.disabled then
                cb({ ok = false, disabled = true })
                return
            end

            local nextIndex = item.index

            if direction == "left" then
                nextIndex -= 1
            elseif direction == "right" then
                nextIndex += 1
            end

            if nextIndex < 1 then
                nextIndex = #item.values
            end

            if nextIndex > #item.values then
                nextIndex = 1
            end

            item.index = nextIndex
            item.value = item.values[nextIndex]

            LIST_STATES[item.id] = nextIndex

            TriggerNuiEvent("rlz_menu:setData", {
                title = MENUS[CURRENT_MENU].title,
                subtitle = MENUS[CURRENT_MENU].subtitle,
                color = MENUS[CURRENT_MENU].color,
                position = MENUS[CURRENT_MENU].position,
                items = PrepareNuiItems(ITEMS),
            })

            playSound("navigate")

            if item.onChange then
                item.onChange(item.index, item.value)
            end

            cb({ ok = true })
            return
        end

    end

    cb({ ok = false })

end)

RegisterNUICallback("rlz_menu:goBack", function(data, cb)
    rlzMenu.GoBack()
    cb({ ok = true })
end)

RegisterNUICallback("rlz_menu:navigate", function(data, cb)
    playSound("navigate")
    cb({ ok = true })
end)

RegisterNUICallback("rlz_menu:submitSearch", function(data, cb)
    local searchBar = SEARCH_BAR
    SEARCH_BAR = nil

    SetNuiFocus(CURRENT_MENU ~= nil, false)
    SetNuiFocusKeepInput(CURRENT_MENU ~= nil)
    TriggerNuiEvent("rlz_menu:closeSearch")

    if searchBar and searchBar.onSubmit then
        searchBar.onSubmit(type(data.value) == "string" and data.value or "")
    end

    cb({ ok = true })
end)

RegisterNUICallback("rlz_menu:cancelSearch", function(data, cb)
    local searchBar = SEARCH_BAR
    SEARCH_BAR = nil

    SetNuiFocus(CURRENT_MENU ~= nil, false)
    SetNuiFocusKeepInput(CURRENT_MENU ~= nil)
    TriggerNuiEvent("rlz_menu:closeSearch")

    if searchBar and searchBar.onCancel then
        searchBar.onCancel()
    end

    cb({ ok = true })
end)