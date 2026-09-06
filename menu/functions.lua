rlzMenu.GetCurrentMenu = function()
    return CURRENT_MENU
end

rlzMenu.IsVisible = function(id)
    assert(type(id) == "string", "rlzMenu.IsVisible: The menu ID must be a string")
    assert(MENUS[id], "rlzMenu.IsVisible: The menu with ID '" .. id .. "' does not exist")

    return MENUS[id].visible
end

rlzMenu.GoBack = function()

    local currentMenu = MENUS[CURRENT_MENU]

    if not currentMenu then
        return
    end

    local parentId = currentMenu.parent

    if not parentId then
        rlzMenu.SetMenuVisible(CURRENT_MENU, false)
        return
    end

    local parentMenu = MENUS[parentId]

    if not parentMenu then
        rlzMenu.SetMenuVisible(CURRENT_MENU, false)
        return
    end

    rlzMenu.SetMenuVisible(CURRENT_MENU, false)
    rlzMenu.SetMenuVisible(parentId, true)

end