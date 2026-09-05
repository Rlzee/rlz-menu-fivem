local testMenu = rlzMenu.CreateMenu(
    "rlzMenu",
    "Menu de test"
)

print("Menu créé :", testMenu)

rlzMenu.SetItems(testMenu, function()
    rlzMenu.Button("Button", nil, "Description", function(onSelected)
        print("Button selected")
    end)

    rlzMenu.Button("Button", nil, "Description", function(onSelected)
        print("Button selected")
    end)

    rlzMenu.Separator()

    rlzMenu.Checkbox("Checkbox", "Description", false, function(isChecked)
        print("Checkbox changed:", isChecked)
    end)

    rlzMenu.Checkbox("Checkbox", "Description", true, function(isChecked)
        print("Checkbox changed:", isChecked)
    end)

    rlzMenu.Label("Label")

    rlzMenu.Button("Button", nil, "Description", function(onSelected)
        print("Button selected")
    end)
end)

RegisterCommand("toggleMenu", function()
    local isVisible = rlzMenu.IsVisible(testMenu)
    rlzMenu.SetMenuVisible(testMenu, not isVisible)
end, false)