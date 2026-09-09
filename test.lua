local testMenu = rlzMenu.Create(
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

    rlzMenu.Button("SetTitle", nil, "Changer le titre du menu", function()
        rlzMenu.SetTitle(testMenu, "Nouveau titre")
    end)

    rlzMenu.Button("SetSubtitle", nil, "Changer le sous-titre du menu", function()
        rlzMenu.SetSubtitle(testMenu, "Nouveau sous-titre")
    end)

    rlzMenu.Separator()

    rlzMenu.Checkbox("Checkbox", "Description checkbox 1", false, function(isChecked)
        print("Checkbox changed:", isChecked)
    end)

    rlzMenu.Checkbox("Checkbox", "Description checkbox 2", true, function(isChecked)
        print("Checkbox changed:", isChecked)
    end)

    rlzMenu.Label("Label")

    local density = ""
    local densityButtonId
    rlzMenu.Button(
        "Density",
        "0.0",
        nil,
        function()
            rlzMenu.OpenSearchBar(
                "Search:",
                function(value)
                    local numericValue

                    if value == "" then
                        numericValue = 0.0
                    else
                        numericValue = tonumber(value)
                    end

                    if numericValue == nil then
                        print("La valeur doit être un nombre")
                        return
                    end

                    if numericValue < 0 or numericValue > 1 then
                        print("La valeur doit être comprise entre 0 et 1")
                        return
                    end

                    density = tostring(numericValue)

                    rlzMenu.SetItemProperty(
                        densityButtonId,
                        "anchor",
                        density
                    )
                end,
                function()
                    print("Search Cancelled")
                end
            )
        end
    )
    densityButtonId = ITEMS[#ITEMS].id

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

    rlzMenu.List(
        "Position du menu",
        "Choix actuellement indisponible",
        {
            "left",
            "right"
        },
        1,
        function(index, value)
            rlzMenu.SetPosition(testMenu, value:lower())
        end,
        false
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