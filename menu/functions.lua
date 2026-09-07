rlzMenu.GetCurrentMenu = function()
    return CURRENT_MENU
end

rlzMenu.IsVisible = function(id)
    assert(type(id) == "string", "rlzMenu.IsVisible: The menu ID must be a string")
    assert(MENUS[id], "rlzMenu.IsVisible: The menu with ID '" .. id .. "' does not exist")

    return MENUS[id].visible
end

rlzMenu.SetPosition = function(menuId, position)
    assert(type(menuId) == "string", "menuId must be a string")
    assert(position == "left" or position == "right", "Menu position must be 'left' or 'right'")

    local menu = MENUS[menuId]

    if not menu then
        error(("Menu with ID '%s' does not exist"):format(menuId))
    end

    menu.position = position

    for _, childMenu in pairs(MENUS) do

        if childMenu.parent == menuId and not childMenu.positionForced then
            rlzMenu.SetPosition(childMenu.id, position)
        end

    end

    if CURRENT_MENU == menuId and menu.visible then
        TriggerNuiEvent("rlz_menu:setData", {
            title = menu.title,
            subtitle = menu.subtitle,
            position = menu.position,
            items = PrepareNuiItems(ITEMS),
        })
    end

    return true
end

rlzMenu.GoBack = function()

    local currentMenu = MENUS[CURRENT_MENU]

    if not currentMenu then
        return
    end

    local parentId = currentMenu.parent

    if not parentId then
        rlzMenu.SetVisible(CURRENT_MENU, false)
        return
    end

    local parentMenu = MENUS[parentId]

    if not parentMenu then
        rlzMenu.SetVisible(CURRENT_MENU, false)
        return
    end

    rlzMenu.SetVisible(CURRENT_MENU, false)
    rlzMenu.SetVisible(parentId, true)

end