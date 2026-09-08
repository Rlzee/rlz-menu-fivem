local function RefreshCurrentMenu(menu)
    if CURRENT_MENU ~= menu.id or not menu.visible then
        return
    end

    TriggerNuiEvent("rlz_menu:setData", {
        title = menu.title,
        subtitle = menu.subtitle,
        color = menu.color,
        position = menu.position,
        items = PrepareNuiItems(ITEMS),
    })
end

rlzMenu.GetCurrentMenu = function()
    return CURRENT_MENU
end

rlzMenu.IsVisible = function(id)
    assert(type(id) == "string", "rlzMenu.IsVisible: The menu ID must be a string")
    assert(MENUS[id], "rlzMenu.IsVisible: The menu with ID '" .. id .. "' does not exist")

    return MENUS[id].visible
end

rlzMenu.GetPosition = function(menuId)
    assert(type(menuId) == "string", "rlzMenu.GetPosition: The menu ID must be a string")

    local menu = MENUS[menuId]

    if not menu then
        error(("Menu with ID '%s' does not exist"):format(menuId))
    end

    return menu.position
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

    RefreshCurrentMenu(menu)

    return true
end

rlzMenu.SetColor = function(menuId, color)
    assert(type(menuId) == "string", "menuId must be a string")
    assert(type(color) == "string", "Menu color must be a string")

    local menu = MENUS[menuId]

    if not menu then
        error(("Menu with ID '%s' does not exist"):format(menuId))
    end

    menu.color = color

    for _, childMenu in pairs(MENUS) do
        if childMenu.parent == menuId and not childMenu.colorForced then
            rlzMenu.SetColor(childMenu.id, color)
        end
    end

    RefreshCurrentMenu(menu)

    return true
end

rlzMenu.SetTitle = function(menuId, title)
    assert(type(menuId) == "string", "rlzMenu.SetTitle: The menu ID must be a string")
    assert(type(title) == "string", "rlzMenu.SetTitle: The title must be a string")

    local menu = MENUS[menuId]

    if not menu then
        error(("Menu with ID '%s' does not exist"):format(menuId))
    end

    menu.title = title

    RefreshCurrentMenu(menu)

    return true
end

rlzMenu.SetSubtitle = function(menuId, subtitle)
    assert(type(menuId) == "string", "rlzMenu.SetSubtitle: The menu ID must be a string")
    assert(type(subtitle) == "string", "rlzMenu.SetSubtitle: The subtitle must be a string")

    local menu = MENUS[menuId]

    if not menu then
        error(("Menu with ID '%s' does not exist"):format(menuId))
    end

    menu.subtitle = subtitle

    RefreshCurrentMenu(menu)

    return true
end

rlzMenu.GetParent = function(menuId)
    assert(type(menuId) == "string", "rlzMenu.GetParent: The menu ID must be a string")

    local menu = MENUS[menuId]

    if not menu then
        error(("Menu with ID '%s' does not exist"):format(menuId))
    end

    return menu.parent
end

rlzMenu.Exists = function(menuId)
    assert(type(menuId) == "string", "rlzMenu.Exists: The menu ID must be a string")

    return MENUS[menuId] ~= nil
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