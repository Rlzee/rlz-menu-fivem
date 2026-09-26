function GetCursorScreenPosition()
    if not IsControlEnabled(0, 239) then
        EnableControlAction(0, 239, true)
    end

    if not IsControlEnabled(0, 240) then
        EnableControlAction(0, 240, true)
    end

    return vector2(
        GetControlNormal(0, 239),
        GetControlNormal(0, 240)
    )
end