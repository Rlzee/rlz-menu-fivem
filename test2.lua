rlzMenu.Context.Register()

rlzMenu.Context.SetItems("vehicle", {
    title = "Vehicle",
    items = function(target)

        rlzMenu.Context.SubMenu({
            label = "Vehicle actions",
            items = function(submenuTarget)
                rlzMenu.Context.Button({
                    label = "Repair",
                    onClick = function()
                        if submenuTarget.entity then
                            SetVehicleFixed(submenuTarget.entity)
                        end
                    end,
                })

                local engineIsOn = false
                if target.entity and DoesEntityExist(target.entity) then
                    local engineState = GetIsVehicleEngineRunning(target.entity)
                    engineIsOn = engineState == true or engineState == 1
                end
                rlzMenu.Context.Checkbox({
                    label = "Engine on",
                    isChecked = engineIsOn,
                    onToggle = function(isChecked)
                        if submenuTarget.entity then
                            SetVehicleEngineOn(submenuTarget.entity, isChecked, true, true)
                        end
                    end,
                })
            end,
        })

        rlzMenu.Context.Button({
            label = "Delete",
            onClick = function()
                if target.entity then
                    DeleteEntity(target.entity)
                    rlzMenu.Context.SetVisible(false)
                end
            end,
        })
    end
})

rlzMenu.Context.SetItems("ped", {
    title = "Ped",
    items = function(target)
        rlzMenu.Context.Button({
            label = "Delete",
            onClick = function()
                if target.entity then
                    DeleteEntity(target.entity)
                end
            end
        })
    end
})

rlzMenu.Context.SetItems("object", {
    title = "Object",
    items = function(target)
        rlzMenu.Context.Button({
            label = "Delete",
            onClick = function()
                if target.entity then
                    DeleteEntity(target.entity)
                end
            end
        })
    end
})

local godmode = false
local playerMode = "normal"
rlzMenu.Context.SetItems("player", {
    title = "Player",
    hoverColor = { "#ff0000", "#0000ff", "#00ff00" },
    items = function(target)
        rlzMenu.Context.Checkbox({
            label = "God Mode",
            isChecked = godmode,
            onToggle = function(isChecked)
                print("God Mode: " .. tostring(isChecked))
                godmode = isChecked
            end
        })
        rlzMenu.Context.Switch({
            label = "Switch",
            isChecked = godmode,
            onToggle = function(isChecked)
                print("Switch: " .. tostring(isChecked))
                godmode = isChecked
            end
        })
        rlzMenu.Context.Radio({
            isChecked = playerMode,
            items = {
                {
                    id = "normal",
                    label = "Normal",
                    onSelect = function()
                        playerMode = "normal"
                        print("Player mode: " .. playerMode)
                    end,
                },
                {
                    id = "aggressive",
                    label = "Aggressive",
                    onSelect = function()
                        playerMode = "aggressive"
                        print("Player mode: " .. playerMode)
                    end,
                },
                {
                    id = "stealth",
                    label = "Stealth",
                    onSelect = function()
                        playerMode = "stealth"
                        print("Player mode: " .. playerMode)
                    end,
                },
            },
        })
    end
})