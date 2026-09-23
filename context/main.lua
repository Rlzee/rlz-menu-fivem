local contextKey

CreateThread(function()
    local contextActive = false

    while true do
        Wait(0)

        if not contextKey then
            goto continue
        end

        local contextKeyPressed = IsControlPressed(0, contextKey)

        if contextKeyPressed and not contextActive then
            contextActive = true

            SetNuiFocus(false, true)
            SetNuiFocusKeepInput(true)
        elseif not contextKeyPressed and contextActive then
            contextActive = false

            SetNuiFocus(false, false)
            SetNuiFocusKeepInput(false)
        end

        if contextActive then
            DisableControlAction(0, 1, true) -- Look Left/Right
            DisableControlAction(0, 2, true) -- Look Up/Down
        end

        ::continue::
    end
end)

rlzMenu.Context.Register = function(key)
    assert(type(key) == "number", "Key must be a control ID number")

    contextKey = key
end