local testMenu = rlzMenu.CreateMenu(
    "rlzMenu",
    "Menu de test"
)

local optionsMenu = rlzMenu.CreateSubMenu(
    testMenu,
    "Options",
    "Sous-menu d'options"
)

rlzMenu.SetItems(testMenu, function()
    rlzMenu.Button("Options", nil, "Ouvrir les options", function(onSelected)
        print("Options selected")
    end,
    optionsMenu
    )

    rlzMenu.Button("Button", nil, "Description button 1", function(onSelected)
        print("Button selected")
    end)

    rlzMenu.Button("Button", nil, "Description button 2", function(onSelected)
        print("Button selected")
    end)

    rlzMenu.Separator()

    rlzMenu.Checkbox("Checkbox", "Description checkbox 1", false, function(isChecked)
        print("Checkbox changed:", isChecked)
    end)

    rlzMenu.Checkbox("Checkbox", "Description checkbox 2", true, function(isChecked)
        print("Checkbox changed:", isChecked)
    end)

    rlzMenu.Label("Label")

    rlzMenu.Button("Button", nil, "Description button 3", function(onSelected)
        print("Button selected")
    end)
end)

rlzMenu.SetItems(optionsMenu, function()
    rlzMenu.Button(
        "Test",
        nil,
        "Test du submenu",
        function()
            print("Test")
        end
    )
end)

RegisterCommand("toggleMenu", function()
    local isVisible = rlzMenu.IsVisible(testMenu)
    rlzMenu.SetMenuVisible(testMenu, not isVisible)
end, false)