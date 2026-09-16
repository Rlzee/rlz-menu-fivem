SEARCH_BAR = nil

rlzMenu.Refresh = function(menuId)
    assert(type(menuId) == "string", "Menu ID must be a string")

    local menu = MENUS[menuId]

    if not menu then
        print(("[rlzMenu] Menu with ID '%s' does not exist"):format(menuId))
        return false
    end

    if CURRENT_MENU ~= menu.id or not menu.visible then
        return false
    end

    TriggerNuiEvent("rlz_menu:setData", {
        title = menu.title,
        subtitle = menu.subtitle,
        color = menu.color,
        hoverColor = menu.hoverColor,
        position = menu.position,
        items = PrepareNuiItems(ITEMS),
    })

    return true
end

rlzMenu.GetCurrentMenu = function()
    return CURRENT_MENU
end

rlzMenu.IsVisible = function(id)
    assert(type(id) == "string", "rlzMenu.IsVisible: The menu ID must be a string")

    if not MENUS[id] then
        print(("[rlzMenu] Menu with ID '%s' does not exist"):format(id))
        return false
    end

    return MENUS[id].visible
end

rlzMenu.GetParent = function(menuId)
    assert(type(menuId) == "string", "rlzMenu.GetParent: The menu ID must be a string")

    local menu = MENUS[menuId]

    if not menu then
        print(("[rlzMenu] Menu with ID '%s' does not exist"):format(menuId))
        return nil
    end

    return menu.parent
end

rlzMenu.Exists = function(menuId)
    assert(type(menuId) == "string", "rlzMenu.Exists: The menu ID must be a string")

    return MENUS[menuId] ~= nil
end

rlzMenu.OpenSearchBar = function(label, onSubmit, onCancel)
    assert(type(label) == "string", "rlzMenu.OpenSearchBar: label must be a string")
    assert(type(onSubmit) == "function", "rlzMenu.OpenSearchBar: onSubmit must be a function")
    assert(type(onCancel) == "function", "rlzMenu.OpenSearchBar: onCancel must be a function")

    SEARCH_BAR = {
        onSubmit = onSubmit,
        onCancel = onCancel,
    }

    SetNuiFocus(true, true)
    SetNuiFocusKeepInput(false)

    TriggerNuiEvent("rlz_menu:openSearch", {
        label = label,
    })
end

rlzMenu.GoTo = function(menuId)
    assert(type(menuId) == "string", "Menu ID must be a string")

    local menu = MENUS[menuId]

    if not menu then
        print(("[rlzMenu] Menu with ID '%s' does not exist"):format(menuId))
        return false
    end

    if CURRENT_MENU and MENUS[CURRENT_MENU] then
        MENUS[CURRENT_MENU].visible = false
    end

    rlzMenu.SetVisible(menuId, true)

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