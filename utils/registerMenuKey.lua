function RegisterMenuKey(menuId, command, key, description)
    assert(type(menuId) == "string", "menuId must be a string")
    assert(type(command) == "string", "command must be a string")
    assert(key == nil or type(key) == "string", "key must be a string or nil")
    assert(description == nil or type(description) == "string", "description must be a string or nil")

    if not key then return end

    RegisterCommand(command, function()
        rlzMenu.SetVisible(menuId, not rlzMenu.IsVisible(menuId))
    end, false)

    RegisterKeyMapping(command, description or "Toggle menu", "keyboard", key)
end