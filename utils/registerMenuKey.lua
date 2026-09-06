function RegisterMenuKey(menuId, command, key, description)
    if not key then return end

    RegisterCommand(command, function()
        rlzMenu.SetMenuVisible(menuId, not rlzMenu.IsVisible(menuId))
    end, false)

    RegisterKeyMapping(command, description or "Toggle menu", "keyboard", key)
end