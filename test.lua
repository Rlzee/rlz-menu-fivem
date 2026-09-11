-- test.lua

local testMenu = rlzMenu.Create({
    title = "rlzMenu",
    subtitle = "Test Menu",
    command = "toggleMenu",
    key = "F1",
    color = "#10b981",
    position = "left",
})

local optionsMenu = rlzMenu.CreateSubMenu(testMenu, {
    title = "Options",
    subtitle = "Test menu properties",
})

local itemsMenu = rlzMenu.CreateSubMenu(testMenu, {
    title = "Items",
    subtitle = "Test different item types",
})

local dynamicMenu = rlzMenu.CreateSubMenu(testMenu, {
    title = "Dynamic",
    subtitle = "Test SetItemProperty",
})

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
    rlzMenu.Button({
        label = "Options",
        description = "Modify menu properties",
        submenu = optionsMenu,
    })

    rlzMenu.Button({
        label = "Items",
        description = "Test different item types",
        submenu = itemsMenu,
    })

    rlzMenu.Button({
        label = "Dynamic",
        description = "Test item modification",
        submenu = dynamicMenu,
    })

    rlzMenu.Separator()

    rlzMenu.Checkbox({
        label = "God Mode",
        description = "Enable or disable god mode",
        isChecked = godMode,

        onChange = function(value)
            godMode = value
            print("[rlzMenu] God Mode:", value)
        end,
    })

    rlzMenu.Checkbox({
        label = "Visibility",
        description = "Make the player visible",
        isChecked = playerVisible,

        onChange = function(value)
            playerVisible = value
            print("[rlzMenu] Visibility:", value)
        end,
    })

    rlzMenu.List({
        label = "Game mode",
        description = "Choose the game mode",
        values = {
            "Normal",
            "Hardcore",
            "Sandbox",
        },
        index = selectedMode,

        onChange = function(index, value)
            selectedMode = index

            print(
                "[rlzMenu] Game mode:",
                index,
                value
            )
        end,
    })

    rlzMenu.Separator()

    rlzMenu.Button({
        label = "Action",
        anchor = "→",
        description = "Test button",

        onSelect = function()
            print("[rlzMenu] Action executed")
        end,
    })

    rlzMenu.Button({
        label = "Disabled button",
        description = "This button cannot be used",

        onSelect = function()
            print("This should never appear")
        end,

        disabled = true,
    })

    rlzMenu.Label("rlzMenu - Test Menu")
end)

-- =========================================================
-- OPTIONS MENU
-- =========================================================

rlzMenu.SetItems(optionsMenu, function()
    rlzMenu.Button({
        label = "Change title",
        description = "Modify the main menu title",

        onSelect = function()
            rlzMenu.SetTitle(
                testMenu,
                "New title"
            )
        end,
    })

    rlzMenu.Button({
        label = "Change subtitle",
        description = "Modify the main menu subtitle",

        onSelect = function()
            rlzMenu.SetSubtitle(
                testMenu,
                "Subtitle changed"
            )
        end,
    })

    rlzMenu.Button({
        label = "Original title",
        description = "Restore the original title",

        onSelect = function()
            rlzMenu.SetTitle(
                testMenu,
                "rlzMenu"
            )

            rlzMenu.SetSubtitle(
                testMenu,
                "Test Menu"
            )
        end,
    })

    rlzMenu.Separator()

    rlzMenu.Button({
        label = "Left position",
        description = "Place the menu on the left",

        onSelect = function()
            rlzMenu.SetPosition(
                testMenu,
                "left"
            )
        end,
    })

    rlzMenu.Button({
        label = "Right position",
        description = "Place the menu on the right",

        onSelect = function()
            rlzMenu.SetPosition(
                testMenu,
                "right"
            )
        end,
    })

    rlzMenu.Separator()

    rlzMenu.Button({
        label = "Green color",
        description = "Change the menu color",

        onSelect = function()
            rlzMenu.SetColor(
                testMenu,
                "#10b981"
            )
        end,
    })

    rlzMenu.Button({
        label = "Red color",
        description = "Change the menu color",

        onSelect = function()
            rlzMenu.SetColor(
                testMenu,
                "#ef4444"
            )
        end,
    })

    rlzMenu.Button({
        label = "Blue color",
        description = "Change the menu color",

        onSelect = function()
            rlzMenu.SetColor(
                testMenu,
                "#3b82f6"
            )
        end,
    })

    rlzMenu.Separator()

    rlzMenu.Button({
        label = "Show parent",
        description = "Show the parent menu ID",

        onSelect = function()
            print(
                "[rlzMenu] Parent:",
                rlzMenu.GetParent(optionsMenu)
            )
        end,
    })

    rlzMenu.Button({
        label = "Test Exists",
        description = "Check whether a menu exists",

        onSelect = function()
            print(
                "[rlzMenu] testMenu exists:",
                rlzMenu.Exists(testMenu)
            )

            print(
                "[rlzMenu] optionsMenu exists:",
                rlzMenu.Exists(optionsMenu)
            )
        end,
    })
end)

-- =========================================================
-- ITEMS MENU
-- =========================================================

rlzMenu.SetItems(itemsMenu, function()
    rlzMenu.Label("Item types")

    rlzMenu.Separator()

    rlzMenu.Button({
        label = "Button",
        anchor = "TEST",
        description = "Button example",

        onSelect = function()
            print("[rlzMenu] Button selected")
        end,
    })

    rlzMenu.Label("This is a label")

    rlzMenu.Separator()

    rlzMenu.Checkbox({
        label = "Checkbox",
        description = "Checkbox example",
        isChecked = false,

        onChange = function(value)
            print(
                "[rlzMenu] Checkbox:",
                value
            )
        end,
    })

    rlzMenu.Checkbox({
        label = "Disabled checkbox",
        description = "This checkbox is disabled",
        isChecked = false,

        onChange = function(value)
            print("This should never be executed")
        end,

        disabled = true,
    })

    rlzMenu.Separator()

    rlzMenu.List({
        label = "List",
        description = "List example",
        values = {
            "Option 1",
            "Option 2",
            "Option 3",
            "Option 4",
        },
        index = 1,

        onChange = function(index, value)
            print(
                "[rlzMenu] List:",
                index,
                value
            )
        end,
    })

    rlzMenu.List({
        label = "Disabled list",
        description = "This list is disabled",
        values = {
            "Option A",
            "Option B",
            "Option C",
        },
        index = 1,

        onChange = function(index, value)
            print("This should never be executed")
        end,

        disabled = true,
    })

    rlzMenu.Separator()

    rlzMenu.Button({
        label = "Close",
        description = "Close the menu",

        onSelect = function()
            rlzMenu.SetVisible(
                testMenu,
                false
            )
        end,
    })
end)

-- =========================================================
-- DYNAMIC MENU
-- =========================================================

rlzMenu.SetItems(dynamicMenu, function()
    rlzMenu.Label("SetItemProperty")

    rlzMenu.Separator()

    local buttonId

    buttonId = rlzMenu.Button({
        label = "Dynamic button",
        anchor = "Initial",
        description = "Its anchor can be modified",

        onSelect = function()
            rlzMenu.SetItemProperty(
                buttonId,
                "anchor",
                "Modified"
            )

            print("[rlzMenu] Anchor modified")
        end,
    })

    local checkboxId

    checkboxId = rlzMenu.Checkbox({
        label = "Dynamic checkbox",
        description = "Its state can be modified",
        isChecked = false,

        onChange = function(value)
            print(
                "[rlzMenu] Checkbox:",
                value
            )
        end,
    })

    local listId

    listId = rlzMenu.List({
        label = "Dynamic list",
        description = "Its index can be modified",
        values = {
            "Normal",
            "Hardcore",
            "Sandbox",
        },
        index = 1,

        onChange = function(index, value)
            print(
                "[rlzMenu] List:",
                index,
                value
            )
        end,
    })

    rlzMenu.Separator()

    rlzMenu.Button({
        label = "Change anchor",
        description = "Modify the button anchor",

        onSelect = function()
            rlzMenu.SetItemProperty(
                buttonId,
                "anchor",
                "NEW"
            )
        end,
    })

    rlzMenu.Button({
        label = "Change label",
        description = "Modify the button label",

        onSelect = function()
            rlzMenu.SetItemProperty(
                buttonId,
                "label",
                "Modified button"
            )
        end,
    })

    rlzMenu.Button({
        label = "Enable checkbox",
        description = "Force the checkbox to true",

        onSelect = function()
            rlzMenu.SetItemProperty(
                checkboxId,
                "isChecked",
                true
            )
        end,
    })

    rlzMenu.Button({
        label = "Disable checkbox",
        description = "Force the checkbox to false",

        onSelect = function()
            rlzMenu.SetItemProperty(
                checkboxId,
                "isChecked",
                false
            )
        end,
    })

    rlzMenu.Button({
        label = "Select Hardcore",
        description = "Change the list index",

        onSelect = function()
            rlzMenu.SetItemProperty(
                listId,
                "index",
                2
            )
        end,
    })

    rlzMenu.Button({
        label = "Disable button",
        description = "Disable the dynamic button",

        onSelect = function()
            rlzMenu.SetItemProperty(
                buttonId,
                "disabled",
                true
            )
        end,
    })

    rlzMenu.Button({
        label = "Enable button",
        description = "Enable the dynamic button",

        onSelect = function()
            rlzMenu.SetItemProperty(
                buttonId,
                "disabled",
                false
            )
        end,
    })
end)