rlzMenu = {}
rlzMenu.Context = {}
rlzMenu.Context.Key = 19 -- INPUT_CHARACTER_WHEEL (Left Alt)
rlzMenu.Context.MaxDistance = 1000.0 -- Maximum distance to interact with entities

exports("getObject", function()
    return rlzMenu
end)