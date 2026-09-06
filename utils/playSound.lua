function playSound(type) 
    assert(type == "select" or type == "back" or type == "navigate", "Invalid sound type: " .. tostring(type))

    if type == "select" then
        PlaySoundFrontend(
            -1,
            "SELECT",
            "HUD_FRONTEND_DEFAULT_SOUNDSET",
            true
        )
    elseif type == "back" then
        PlaySoundFrontend(
            -1,
            "BACK",
            "HUD_FRONTEND_DEFAULT_SOUNDSET",
            true
        )
    elseif type == "navigate" then
        PlaySoundFrontend(
            -1,
            "NAV_UP_DOWN",
            "HUD_FRONTEND_DEFAULT_SOUNDSET",
            true
        )
    end
end