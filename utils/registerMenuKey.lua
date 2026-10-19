function RegisterMenuKey(menuId, command, key, description)
    assert(type(menuId) == "string", "menuId must be a string")
    assert(command == nil or type(command) == "string", "command must be a string or nil")
    assert(key == nil or type(key) == "string", "key must be a string or nil")
    assert(description == nil or type(description) == "string", "description must be a string or nil")

    if not command then
        if key then
            print(("[rlzMenu] Menu '%s' has a key binding but no command; the key will not be mapped"):format(menuId))
        end

        return
    end

    RegisterCommand(command, function()
        if not rlzMenu.Exists(menuId) then return end

        local menu = MENUS[menuId]

        if not menu.enabled then
            print(("[rlzMenu] Menu with ID '%s' is disabled and cannot be toggled"):format(menuId))
            return
        end

        rlzMenu.SetVisible(menuId, not menu.visible)
    end, false)

    if key then
        RegisterKeyMapping(command, description or "Toggle menu", "keyboard", key)
    end
end