SEARCH_BAR = nil

--- Opens the reusable search bar.
---
---@param label string The label displayed above the input.
---@param onSubmit function Called with the submitted value.
---@param onCancel function Called when the search is cancelled.
--
rlzMenu.OpenSearchBar = function(label, onSubmit, onCancel)
    assert(type(label) == "string", "rlzMenu.OpenSearchBar: label must be a string")
    assert(type(onSubmit) == "function", "rlzMenu.OpenSearchBar: onSubmit must be a function")
    assert(type(onCancel) == "function", "rlzMenu.OpenSearchBar: onCancel must be a function")

    SEARCH_BAR = {
        onSubmit = onSubmit,
        onCancel = onCancel,
        menuVisible = CURRENT_MENU ~= nil,
        contextActive = CONTEXT_ACTIVE == true,
    }

    SetNuiFocus(true, true)
    SetNuiFocusKeepInput(false)

    TriggerNuiEvent("rlz_menu:openSearch", {
        label = label,
    })
end
