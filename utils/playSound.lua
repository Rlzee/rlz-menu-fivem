function playSound(soundType)

    assert(type(soundType) == "string", "soundType must be a string")
    assert(
        soundType == "select" or soundType == "back" or soundType == "navigate",
        "Invalid sound type: " .. tostring(soundType)
    )

    if soundType == "select" then
        PlaySoundFrontend(
            -1,
            "SELECT",
            "HUD_FRONTEND_DEFAULT_SOUNDSET",
            true
        )
    elseif soundType == "back" then
        PlaySoundFrontend(
            -1,
            "BACK",
            "HUD_FRONTEND_DEFAULT_SOUNDSET",
            true
        )
    elseif soundType == "navigate" then
        PlaySoundFrontend(
            -1,
            "NAV_UP_DOWN",
            "HUD_FRONTEND_DEFAULT_SOUNDSET",
            true
        )
    end
end