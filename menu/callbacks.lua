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
                    MENUS[CURRENT_MENU].selectedItemId = item.id
                    submenu.previousMenu = CURRENT_MENU
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

        if item.id == itemId and (item.type == "checkbox" or item.type == "switch") then

            if item.disabled then
                cb({ ok = false, disabled = true })
                return
            end

            item.isChecked = not item.isChecked

            rlzMenu.Refresh(CURRENT_MENU)

            playSound("select")

            if item.onChange then
                item.onChange(item.isChecked)
            end

            cb({ ok = true })
            return
        end

    end

    cb({ ok = false })

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
            else
                nextIndex += 1
            end

            if nextIndex < 1 then
                nextIndex = #item.values
            elseif nextIndex > #item.values then
                nextIndex = 1
            end

            item.index = nextIndex
            item.value = item.values[nextIndex]

            rlzMenu.Refresh(CURRENT_MENU)

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

RegisterNUICallback("rlz_menu:changeSlider", function(data, cb)

    local itemId = data.itemId
    local direction = data.direction

    if direction ~= "left" and direction ~= "right" then
        cb({ ok = false })
        return
    end

    for _, item in ipairs(ITEMS) do

        if item.id == itemId and item.type == "slider" then

            if item.disabled then
                cb({ ok = false, disabled = true })
                return
            end

            local delta = item.step or 1

            if direction == "left" then
                delta = -delta
            end

            local nextValue = item.value + delta

            if nextValue < item.min then
                nextValue = item.min
            elseif nextValue > item.max then
                nextValue = item.max
            end

            if nextValue == item.value then
                cb({ ok = true })
                return
            end

            item.value = nextValue
            item.percent = ComputeSliderPercent(item)

            rlzMenu.Refresh(CURRENT_MENU)

            playSound("navigate")

            if item.onChange then
                item.onChange(item.value, item.percent)
            end

            cb({ ok = true })
            return
        end

    end

    cb({ ok = false })

end)

RegisterNUICallback("rlz_menu:selectRadio", function(data, cb)

    local itemId = data.itemId
    local selectedItem

    for _, item in ipairs(ITEMS) do
        if item.id == itemId and item.type == "radio" then
            selectedItem = item
            break
        end
    end

    if not selectedItem then
        cb({ ok = false })
        return
    end

    if selectedItem.disabled then
        cb({ ok = false, disabled = true })
        return
    end

    local wasChecked = selectedItem.isChecked

    SelectRadioGroupIndex(selectedItem.group, selectedItem.index)

    rlzMenu.Refresh(CURRENT_MENU)

    playSound("select")

    if selectedItem.onChange and not wasChecked then
        selectedItem.onChange(selectedItem.index, selectedItem.label)
    end

    cb({ ok = true })

end)

RegisterNUICallback("rlz_menu:hoverItem", function(data, cb)
    local itemId = data.itemId

    if type(itemId) ~= "string" then
        cb({ ok = false })
        return
    end

    for _, item in ipairs(ITEMS) do
        if item.id == itemId then
            if item.disabled then
                cb({
                    ok = false,
                    disabled = true,
                })
                return
            end

            if item.onHover then
                item.onHover()
            end

            cb({ ok = true })
            return
        end
    end

    cb({ ok = false })
end)

RegisterNUICallback("rlz_menu:leaveItem", function(data, cb)
    local itemId = data.itemId

    if type(itemId) ~= "string" then
        cb({ ok = false })
        return
    end

    for _, item in ipairs(ITEMS) do
        if item.id == itemId then
            if item.disabled then
                cb({
                    ok = false,
                    disabled = true,
                })
                return
            end

            if item.onLeave then
                item.onLeave()
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
        searchBar.onSubmit(
            type(data.value) == "string" and data.value or ""
        )
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


RegisterNUICallback("rlz_menu:savePosition", function(data, cb)

    local menuId = data.menuId
    local x = tonumber(data.x)
    local y = tonumber(data.y)

    if type(menuId) ~= "string" or not x or not y then
        cb({ ok = false })
        return
    end

    if not MENUS[menuId] then
        cb({ ok = false })
        return
    end

    if data.applyToAll then
        for _, id in ipairs(GetMenuTreeIds(menuId)) do
            SaveMenuPosition(id, x, y)
        end
    else
        SaveMenuPosition(menuId, x, y)
    end

    playSound("select")

    cb({ ok = true })

end)


RegisterNUICallback("rlz_menu:resetPosition", function(data, cb)

    local menuId = data.menuId

    if type(menuId) ~= "string" or not MENUS[menuId] then
        cb({ ok = false })
        return
    end

    if data.applyToAll then
        for _, id in ipairs(GetMenuTreeIds(menuId)) do
            DeleteMenuPosition(id)
        end
    else
        DeleteMenuPosition(menuId)
    end

    rlzMenu.Refresh(menuId)

    cb({ ok = true })

end)