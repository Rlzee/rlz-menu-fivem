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

    TriggerNuiEvent("rlz_menu:setData", BuildMenuData(menu))

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

    local parentId = currentMenu.previousMenu

    if not parentId or not MENUS[parentId] then
        parentId = currentMenu.parent
    end

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

--- Resets the saved screen position of a menu.
---
---@param menuId string The ID of the menu.
---@param applyToAll? boolean Whether the reset should apply to every menu of the menu tree. Defaults to false.
---@return boolean True if the position was reset successfully, false if the menu does not exist.
--
rlzMenu.ResetPosition = function(menuId, applyToAll)
    assert(type(menuId) == "string", "rlzMenu.ResetPosition: menuId must be a string")

    local menu = MENUS[menuId]

    if not menu then
        print(("[rlzMenu] Menu with ID '%s' does not exist"):format(menuId))
        return false
    end

    if applyToAll then
        for _, id in ipairs(GetMenuTreeIds(menuId)) do
            DeleteMenuPosition(id)
        end
    else
        DeleteMenuPosition(menuId)
    end

    if CURRENT_MENU == menuId then
        rlzMenu.Refresh(menuId)
    end

    return true
end

--- Returns the position information of a menu.
---
---@param menuId string The ID of the menu.
---@return string alignment The menu alignment, "left" or "right".
---@return number|nil x The saved horizontal position as a ratio between 0 and 1, or nil if there is none.
---@return number|nil y The saved vertical position as a ratio between 0 and 1, or nil if there is none.
--
rlzMenu.GetPosition = function(menuId)
    assert(type(menuId) == "string", "rlzMenu.GetPosition: menuId must be a string")

    local menu = MENUS[menuId]

    if not menu then
        print(("[rlzMenu] Menu with ID '%s' does not exist"):format(menuId))
        return "left", nil, nil
    end

    local savedPosition = GetSavedMenuPosition(menuId)

    return menu.position,
        savedPosition and savedPosition.x or nil,
        savedPosition and savedPosition.y or nil
end

--- Opens the position edit mode of a menu: the menu can then be moved
--- with the arrow keys, Enter saves the position and Backspace cancels.
---
---@param menuId string The ID of the menu.
---@param applyToAll? boolean Whether the saved position should apply to every menu of the menu tree. Defaults to false.
---@return boolean True if the edit mode was opened, false if the menu does not exist or is not displayed.
--
rlzMenu.EditPosition = function(menuId, applyToAll)
    assert(type(menuId) == "string", "rlzMenu.EditPosition: menuId must be a string")

    local menu = MENUS[menuId]

    if not menu then
        print(("[rlzMenu] Menu with ID '%s' does not exist"):format(menuId))
        return false
    end

    if CURRENT_MENU ~= menuId or not menu.visible then
        print(("[rlzMenu] Menu with ID '%s' is not displayed and cannot be edited"):format(menuId))
        return false
    end

    TriggerNuiEvent("rlz_menu:editPosition", {
        menuId = menuId,
        applyToAll = applyToAll == true,
    })

    return true
end