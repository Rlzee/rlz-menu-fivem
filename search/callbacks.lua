local function closeSearch()
    local searchBar = SEARCH_BAR

    SEARCH_BAR = nil

    SetNuiFocus(
        searchBar and (searchBar.menuVisible or searchBar.contextActive) or false,
        searchBar and searchBar.contextActive or false
    )
    SetNuiFocusKeepInput(searchBar and searchBar.contextActive or false)

    TriggerNuiEvent("rlz_menu:closeSearch")

    return searchBar
end

RegisterNUICallback("rlz_menu:submitSearch", function(data, cb)
    local searchBar = closeSearch()

    if searchBar and searchBar.onSubmit then
        searchBar.onSubmit(
            type(data.value) == "string" and data.value or ""
        )
    end

    cb({ ok = true })
end)

RegisterNUICallback("rlz_menu:cancelSearch", function(data, cb)
    local searchBar = closeSearch()

    if searchBar and searchBar.onCancel then
        searchBar.onCancel()
    end

    cb({ ok = true })
end)
