CreateThread(function()
    local contextActive = false

    while true do
        Wait(0)

        local altPressed = IsControlPressed(0, 19)

        if altPressed and not contextActive then
            contextActive = true

            SetNuiFocus(false, true)
            SetNuiFocusKeepInput(true)
        elseif not altPressed and contextActive then
            contextActive = false

            SetNuiFocus(false, false)
            SetNuiFocusKeepInput(false)
        end

        if contextActive then
            DisableControlAction(0, 1, true) -- Look Left/Right
            DisableControlAction(0, 2, true) -- Look Up/Down
        end
    end
end)