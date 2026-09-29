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
            end
        })
    end
})