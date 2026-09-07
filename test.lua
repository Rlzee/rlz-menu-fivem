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

    rlzMenu.Button("Bouton désactivé", nil, nil,
    function()
        print("Ne sera pas exécuté")
    end, nil, true)

    rlzMenu.List("List", "Description list", {"Option 1", "Option 2", "Option 3"}, 1, function(selectedIndex)
        print("List selected index:", selectedIndex)
    end)

    rlzMenu.Checkbox(
        "Mode admin",
        "Option actuellement indisponible",
        false,
        function(isChecked)
            print("Mode admin :", isChecked)
        end,
        true -- disabled
    )

    rlzMenu.List(
        "Mode de jeu",
        "Choix actuellement indisponible",
        {
            "Normal",
            "Hardcore",
            "Sandbox"
        },
        1,
        function(index, value)
            print("Mode sélectionné :", index, value)
        end,
        true -- disabled
    )
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