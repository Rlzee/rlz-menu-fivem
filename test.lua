local testMenu = rlzMenu.CreateMenu(
    "rlzMenu",
    "Menu de test",
    "toggleMenu",
    "F1"
)

local optionsMenu = rlzMenu.CreateSubMenu(
    testMenu,
    "Options",
    "Sous-menu d'options"
)

rlzMenu.SetItems(testMenu, function()
    rlzMenu.Button("Options", nil, "Ouvrir les options", function()
        print("Options selected")
    end,
    optionsMenu
    )

    rlzMenu.Button("Button", nil, "Description button 1", function()
        print("Button selected")
    end)

    rlzMenu.Button("Button", nil, "Description button 2", function()
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

    rlzMenu.Button("Button", nil, "Description button 3", function()
        print("Button selected")
    end)

    rlzMenu.Button("Bouton désactivé", nil, "Cette action est indisponible",
    function()
        print("Ne sera pas exécuté")
    end, nil, true)
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