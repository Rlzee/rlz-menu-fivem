function RegisterMenuKey(menuId, command, key, description)
    assert(type(menuId) == "string", "menuId must be a string")
    assert(type(command) == "string", "command must be a string")
    assert(key == nil or type(key) == "string", "key must be a string or nil")
    assert(description == nil or type(description) == "string", "description must be a string or nil")

    if not key then return end

    RegisterCommand(command, function()
        if not rlzMenu.Exists(menuId) then return end
        
        local menu = MENUS[menuId]

        if not menu.enabled then
            print(("[rlzMenu] Menu with ID '%s' is disabled and cannot be toggled"):format(menuId))
            return
        end

        rlzMenu.SetVisible(menuId, not menu.visible)
    end, false)

    RegisterKeyMapping(command, description or "Toggle menu", "keyboard", key)
end