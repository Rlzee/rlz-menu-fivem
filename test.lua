-- test.lua

local testMenu = rlzMenu.Create(
    "rlzMenu",
    "Test Menu",
    "toggleMenu",
    "F1",
    "#10b981",
    "left"
)

local optionsMenu = rlzMenu.CreateSubMenu(
    testMenu,
    "Options",
    "Test menu properties"
)

local itemsMenu = rlzMenu.CreateSubMenu(
    testMenu,
    "Items",
    "Test different item types"
)

local dynamicMenu = rlzMenu.CreateSubMenu(
    testMenu,
    "Dynamic",
    "Test SetItemProperty"
)

-- =========================================================
-- Developer-managed state
-- =========================================================

local godMode = false
local playerVisible = true
local selectedMode = 1
local density = "Normal"

-- =========================================================
-- MAIN MENU
-- =========================================================

rlzMenu.SetItems(testMenu, function()

    rlzMenu.Button(
        "Options",
        nil,
        "Modify menu properties",
        nil,
        optionsMenu
    )

    rlzMenu.Button(
        "Items",
        nil,
        "Test different item types",
        nil,
        itemsMenu
    )

    rlzMenu.Button(
        "Dynamic",
        nil,
        "Test item modification",
        nil,
        dynamicMenu
    )

    rlzMenu.Separator()

    rlzMenu.Checkbox(
        "God Mode",
        "Enable or disable god mode",
        godMode,
        function(value)
            godMode = value
            print("[rlzMenu] God Mode :", value)
        end
    )

    rlzMenu.Checkbox(
        "Visibility",
        "Make the player visible",
        playerVisible,
        function(value)
            playerVisible = value
            print("[rlzMenu] Visibility:", value)
        end
    )

    rlzMenu.List(
        "Game mode",
        "Choose the game mode",
        {
            "Normal",
            "Hardcore",
            "Sandbox"
        },
        selectedMode,
        function(index, value)
            selectedMode = index

            print(
                "[rlzMenu] Game mode:",
                index,
                value
            )
        end
    )

    rlzMenu.Separator()

    rlzMenu.Button(
        "Action",
        "→",
        "Test button",
        function()
            print("[rlzMenu] Action executed")
        end
    )

    rlzMenu.Button(
        "Disabled button",
        nil,
        "This button cannot be used",
        function()
            print("This should never appear")
        end,
        nil,
        true
    )

    rlzMenu.Label("rlzMenu - Test Menu")
end)

-- =========================================================
-- OPTIONS MENU
-- =========================================================

rlzMenu.SetItems(optionsMenu, function()

    rlzMenu.Button(
        "Change title",
        nil,
        "Modify the main menu title",
        function()
            rlzMenu.SetTitle(
                testMenu,
                "New title"
            )
        end
    )

    rlzMenu.Button(
        "Change subtitle",
        nil,
        "Modify the main menu subtitle",
        function()
            rlzMenu.SetSubtitle(
                testMenu,
                "Subtitle changed"
            )
        end
    )

    rlzMenu.Button(
        "Original title",
        nil,
        "Restore the original title",
        function()
            rlzMenu.SetTitle(
                testMenu,
                "rlzMenu"
            )

            rlzMenu.SetSubtitle(
                testMenu,
                "Test Menu"
            )
        end
    )

    rlzMenu.Separator()

    rlzMenu.Button(
        "Left position",
        nil,
        "Place the menu on the left",
        function()
            rlzMenu.SetPosition(
                testMenu,
                "left"
            )
        end
    )

    rlzMenu.Button(
        "Right position",
        nil,
        "Place the menu on the right",
        function()
            rlzMenu.SetPosition(
                testMenu,
                "right"
            )
        end
    )

    rlzMenu.Separator()

    rlzMenu.Button(
        "Green color",
        nil,
        "Change the menu color",
        function()
            rlzMenu.SetColor(
                testMenu,
                "#10b981"
            )
        end
    )

    rlzMenu.Button(
        "Red color",
        nil,
        "Change the menu color",
        function()
            rlzMenu.SetColor(
                testMenu,
                "#ef4444"
            )
        end
    )

    rlzMenu.Button(
        "Blue color",
        nil,
        "Change the menu color",
        function()
            rlzMenu.SetColor(
                testMenu,
                "#3b82f6"
            )
        end
    )

    rlzMenu.Separator()

    rlzMenu.Button(
        "Show parent",
        nil,
        "Show the parent menu ID",
        function()
            print(
                "[rlzMenu] Parent:",
                rlzMenu.GetParent(optionsMenu)
            )
        end
    )

    rlzMenu.Button(
        "Test Exists",
        nil,
        "Check whether a menu exists",
        function()
            print(
                "[rlzMenu] testMenu exists:",
                rlzMenu.Exists(testMenu)
            )

            print(
                "[rlzMenu] optionsMenu exists:",
                rlzMenu.Exists(optionsMenu)
            )
        end
    )
end)

-- =========================================================
-- ITEMS MENU
-- =========================================================

rlzMenu.SetItems(itemsMenu, function()

    rlzMenu.Label("Item types")

    rlzMenu.Separator()

    rlzMenu.Button(
        "Button",
        "TEST",
        "Button example",
        function()
            print("[rlzMenu] Button selected")
        end
    )

    rlzMenu.Label(
        "This is a label"
    )

    rlzMenu.Separator()

    rlzMenu.Checkbox(
        "Checkbox",
        "Checkbox example",
        false,
        function(value)
            print(
                "[rlzMenu] Checkbox :",
                value
            )
        end
    )

    rlzMenu.Checkbox(
        "Disabled checkbox",
        "This checkbox is disabled",
        false,
        function(value)
            print("This should never be executed")
        end,
        true
    )

    rlzMenu.Separator()

    rlzMenu.List(
        "List",
        "List example",
        {
            "Option 1",
            "Option 2",
            "Option 3",
            "Option 4"
        },
        1,
        function(index, value)
            print(
                "[rlzMenu] List:",
                index,
                value
            )
        end
    )

    rlzMenu.List(
        "Disabled list",
        "This list is disabled",
        {
            "Option A",
            "Option B",
            "Option C"
        },
        1,
        function(index, value)
            print("This should never be executed")
        end,
        true
    )

    rlzMenu.Separator()

    rlzMenu.Button(
        "Close",
        nil,
        "Close the menu",
        function()
            rlzMenu.SetVisible(
                testMenu,
                false
            )
        end
    )
end)

-- =========================================================
-- DYNAMIC MENU
-- =========================================================

rlzMenu.SetItems(dynamicMenu, function()

    rlzMenu.Label(
        "SetItemProperty"
    )

    rlzMenu.Separator()

    local buttonId

    buttonId = rlzMenu.Button(
        "Dynamic button",
        "Initial",
        "Its anchor can be modified",
        function()
            rlzMenu.SetItemProperty(
                buttonId,
                "anchor",
                "Modified"
            )

            print(
                "[rlzMenu] Anchor modified"
            )
        end
    )

    local checkboxId

    checkboxId = rlzMenu.Checkbox(
        "Dynamic checkbox",
        "Its state can be modified",
        false,
        function(value)
            print(
                "[rlzMenu] Checkbox :",
                value
            )
        end
    )

    local listId

    listId = rlzMenu.List(
        "Dynamic list",
        "Its index can be modified",
        {
            "Normal",
            "Hardcore",
            "Sandbox"
        },
        1,
        function(index, value)
            print(
                "[rlzMenu] List:",
                index,
                value
            )
        end
    )

    rlzMenu.Separator()

    rlzMenu.Button(
        "Change anchor",
        nil,
        "Modify the button anchor",
        function()
            rlzMenu.SetItemProperty(
                buttonId,
                "anchor",
                "NEW"
            )
        end
    )

    rlzMenu.Button(
        "Change label",
        nil,
        "Modify the button label",
        function()
            rlzMenu.SetItemProperty(
                buttonId,
                "label",
                "Modified button"
            )
        end
    )

    rlzMenu.Button(
        "Enable checkbox",
        nil,
        "Force the checkbox to true",
        function()
            rlzMenu.SetItemProperty(
                checkboxId,
                "isChecked",
                true
            )
        end
    )

    rlzMenu.Button(
        "Disable checkbox",
        nil,
        "Force the checkbox to false",
        function()
            rlzMenu.SetItemProperty(
                checkboxId,
                "isChecked",
                false
            )
        end
    )

    rlzMenu.Button(
        "Select Hardcore",
        nil,
        "Change the list index",
        function()
            rlzMenu.SetItemProperty(
                listId,
                "index",
                2
            )
        end
    )

    rlzMenu.Button(
        "Disable button",
        nil,
        "Disable the dynamic button",
        function()
            rlzMenu.SetItemProperty(
                buttonId,
                "disabled",
                true
            )
        end
    )

    rlzMenu.Button(
        "Enable button",
        nil,
        "Enable the dynamic button",
        function()
            rlzMenu.SetItemProperty(
                buttonId,
                "disabled",
                false
            )
        end
    )
end)