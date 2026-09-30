rlzMenu.Context.Register()

rlzMenu.Context.SetItems("vehicle", {
    title = "Vehicle",
    items = function(target)
        rlzMenu.Context.Button({
            label = "Delete",
            onClick = function()
                if target.entity then
                    DeleteEntity(target.entity)
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
rlzMenu.Context.SetItems("player", {
    title = "Player",
    items = function(target)
        rlzMenu.Context.Checkbox({
            label = "God Mode",
            isChecked = godmode,
            onToggle = function(isChecked)
                print("God Mode: " .. tostring(isChecked))
                godmode = isChecked
            end
        })
    end
})