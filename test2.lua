rlzMenu.Context.Register()

rlzMenu.Context.SetItems("vehicle", {
    title = "Vehicle",
    items = function(entity)

        rlzMenu.Button({
            label = "Item",
            description = "Test item",
        })

        rlzMenu.Separator()

        rlzMenu.Checkbox({
            label = "God Mode",
            description = "Enable or disable god mode",
            isChecked = godMode,

            onChange = function(value)
                godMode = value
                print("[rlzMenu-Context] God Mode:", value)
            end,
        })

        rlzMenu.Switch({
            label = "God Mode Switch",
            description = "Enable or disable god mode",
            isChecked = godMode,

            onChange = function(value)
                godMode = value
                print("[rlzMenu-Context] God Mode Switch:", value)
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
                    "[rlzMenu-Context] Game mode:",
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
                print("[rlzMenu-Context] Action hovered")
            end,

            onLeave = function()
                print("[rlzMenu-Context] Action left")
            end,

            onSelect = function()
                print("[rlzMenu-Context] Action executed")
            end,
        })

    end,
})