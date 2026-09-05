function TriggerNuiEvent(name, data)
    SendNUIMessage({
        action = name,
        data = data
    })
end