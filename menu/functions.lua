rlzMenu.GetCurrentMenu = function()
    return CURRENT_MENU
end

rlzMenu.IsVisible = function(id)
    assert(type(id) == "string", "rlzMenu.IsVisible: The menu ID must be a string")
    assert(MENUS[id], "rlzMenu.IsVisible: The menu with ID '" .. id .. "' does not exist")

    return MENUS[id].visible
end