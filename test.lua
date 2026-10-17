-- test.lua

local testMenu = rlzMenu.Create({
    title = "rlzMenu",
    subtitle = "Test Menu",
    command = "toggleMenu",
    key = "F1",
    position = "left",
    controls = true,
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

local positionMenu = rlzMenu.CreateSubMenu(testMenu, {
    title = "Position",
    subtitle = "Test menu positioning",
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

    rlzMenu.Button({
        label = "Position",
        description = "Test the menu positioning",
        submenu = positionMenu,
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

    rlzMenu.Switch({
        label = "God Mode Switch",
        description = "Enable or disable god mode",
        isChecked = godMode,

        onChange = function(value)
            godMode = value
            print("[rlzMenu] God Mode Switch:", value)
        end,
    })

    rlzMenu.Switch({
        label = "Visibility Switch",
        description = "Make the player visible",
        isChecked = playerVisible,

        onChange = function(value)
            playerVisible = value
            print("[rlzMenu] Visibility Switch:", value)
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

    rlzMenu.Label("Test label")

    rlzMenu.Button({
        label = "Action",
        anchor = "→",
        description = "Test button",

        onHover = function()
            print("[rlzMenu] Action hovered")
        end,

        onLeave = function()
            print("[rlzMenu] Action left")
        end,

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

    rlzMenu.Button({
        label = "Anchor test",
        description = "Test button with anchor",
        anchor = "TEST",
    })
    rlzMenu.Button({
        label = "Anchor test",
        description = "Test button with anchor",
        anchor = "TEST",
    })
end)

-- =========================================================
-- OPTIONS MENU
-- =========================================================

rlzMenu.SetItems(optionsMenu, function()
    rlzMenu.Button({
        label = "Item Menu",
        description = "Go to the items menu",
        submenu = itemsMenu,
    })

    rlzMenu.Separator()

    rlzMenu.Button({
        label = "Change title",
        description = "Modify the main menu title",

        onSelect = function()
            rlzMenu.SetMenuProperty(
                testMenu,
                "title",
                "New title"
            )
        end,
    })

    rlzMenu.Button({
        label = "Change subtitle",
        description = "Modify the main menu subtitle",

        onSelect = function()
            rlzMenu.SetMenuProperty(
                testMenu,
                "subtitle",
                "Subtitle changed"
            )
        end,
    })

    rlzMenu.Button({
        label = "Original title",
        description = "Restore the original title",

        onSelect = function()
            rlzMenu.SetMenuProperty(
                testMenu,
                "title",
                "rlzMenu"
            )

            rlzMenu.SetMenuProperty(
                testMenu,
                "subtitle",
                "Test Menu"
            )
        end,
    })

    rlzMenu.Label("Submenu options")

    rlzMenu.Button({
        label = "Toggle controls",
        description = "Show or hide the navigation controls of the menu",

        onSelect = function()
            rlzMenu.SetMenuProperty(
                testMenu,
                "controls",
                not rlzMenu.GetMenuProperty(testMenu, "controls")
            )
        end,
    })

    rlzMenu.Button({
        label = "Change submenu title",
        description = "Modify only the options submenu title",

        onSelect = function()
            rlzMenu.SetMenuProperty(
                optionsMenu,
                "title",
                "Submenu options"
            )
        end,
    })

    rlzMenu.Button({
        label = "Change submenu subtitle",
        description = "Modify only the options submenu subtitle",

        onSelect = function()
            rlzMenu.SetMenuProperty(
                optionsMenu,
                "subtitle",
                "Submenu-only settings"
            )
        end,
    })

    rlzMenu.Separator()

    rlzMenu.Button({
        label = "Search bar",
        description = "Open the search input",

        onSelect = function()
            rlzMenu.OpenSearchBar(
                "Search",
                function(value)
                    print("[rlzMenu] Search:", value)
                end,
                function()
                    print("[rlzMenu] Search cancelled")
                end
            )
        end,
    })

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

    rlzMenu.Button({
        label = "Button",
        anchor = "TEST",
        description = "Button example",

        onSelect = function()
            print("[rlzMenu] Button selected")
        end,
    })

    rlzMenu.Label("This is a label")

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

-- =========================================================
-- POSITION MENU
-- =========================================================

rlzMenu.SetItems(positionMenu, function()
    rlzMenu.Label("Edit position")

    rlzMenu.Button({
        label = "This menu",
        description = "Move the menu with the arrow keys, Enter to save, Backspace to cancel",

        onSelect = function()
            rlzMenu.EditPosition(positionMenu, false)
        end,
    })

    rlzMenu.Button({
        label = "All menus",
        description = "Move with the arrow keys and apply the position to the main menu and all submenus",

        onSelect = function()
            rlzMenu.EditPosition(positionMenu, true)
        end,
    })

    rlzMenu.Label("Alignment")

    rlzMenu.Button({
        label = "Left",
        description = "Align this menu to the left of the screen",

        onSelect = function()
            rlzMenu.SetMenuProperty(positionMenu, "position", "left", false)
        end,
    })

    rlzMenu.Button({
        label = "Right",
        description = "Align this menu to the right of the screen",

        onSelect = function()
            rlzMenu.SetMenuProperty(positionMenu, "position", "right", false)
        end,
    })

    rlzMenu.Button({
        label = "Left (all menus)",
        description = "Align the main menu and all submenus to the left",

        onSelect = function()
            rlzMenu.SetMenuProperty(testMenu, "position", "left", true)
        end,
    })

    rlzMenu.Button({
        label = "Right (all menus)",
        description = "Align the main menu and all submenus to the right",

        onSelect = function()
            rlzMenu.SetMenuProperty(testMenu, "position", "right", true)
        end,
    })

    rlzMenu.Label("Custom position")

    rlzMenu.Button({
        label = "Center",
        description = "Move this menu to the center of the screen",

        onSelect = function()
            rlzMenu.SetMenuProperty(
                positionMenu,
                "position",
                { x = 0.4, y = 0.35 }
            )
        end,
    })

    rlzMenu.Button({
        label = "Random position",
        description = "Move this menu to a random position",

        onSelect = function()
            rlzMenu.SetMenuProperty(
                positionMenu,
                "position",
                { x = math.random(), y = math.random() }
            )
        end,
    })

    rlzMenu.Label("Reset position")

    rlzMenu.Button({
        label = "This menu",
        description = "Restore the default alignment of this menu",

        onSelect = function()
            rlzMenu.ResetPosition(positionMenu, false)
        end,
    })

    rlzMenu.Button({
        label = "All menus",
        description = "Restore the default alignment of the main menu and all submenus",

        onSelect = function()
            rlzMenu.ResetPosition(positionMenu, true)
        end,
    })

    rlzMenu.Separator()

    rlzMenu.Button({
        label = "Get position",
        description = "Print the current position of this menu in the console",

        onSelect = function()
            local alignment, x, y = rlzMenu.GetPosition(positionMenu)

            if x and y then
                print((
                    "[rlzMenu] Position of '%s': alignment '%s', custom position x=%.3f y=%.3f"
                ):format(positionMenu, alignment, x, y))
            else
                print((
                    "[rlzMenu] Position of '%s': alignment '%s', no custom position"
                ):format(positionMenu, alignment))
            end
        end,
    })
end)