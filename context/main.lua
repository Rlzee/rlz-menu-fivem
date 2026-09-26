CONTEXT_REGISTERED = false
CONTEXT_ACTIVE = false

CreateThread(function()
    while true do
        Wait(0)

        if not CONTEXT_REGISTERED then
            goto continue
        end

        local contextKeyPressed = IsControlPressed(0, rlzMenu.Context.Key)

        if contextKeyPressed and not CONTEXT_ACTIVE then
            CONTEXT_ACTIVE = true

            SetNuiFocus(false, true)
            SetNuiFocusKeepInput(true)
        elseif not contextKeyPressed and CONTEXT_ACTIVE then
            CONTEXT_ACTIVE = false

            SetNuiFocus(false, false)
            SetNuiFocusKeepInput(false)
        end

        if CONTEXT_ACTIVE then
            DisableControlAction(0, 1, true) -- Look Left/Right
            DisableControlAction(0, 2, true) -- Look Up/Down

            if IsDisabledControlJustPressed(0, 25) then -- Right Mouse Click
                local cursorPosition = GetCursorScreenPosition()

                local hit, worldPosition, normalDirection, entity =
                    ScreenToWorld(cursorPosition, 10.0)

                if hit and entity and DoesEntityExist(entity) then
                    print("Entity:", entity)
                    print("Entity Type:", GetEntityType(entity))
                    print("Model:", GetEntityModel(entity))
                else
                    print("No entity")
                end
            end
        end

        ::continue::
    end
end)

--- Registers the context menu
---
--- @return boolean True if the context menu was registered successfully, false otherwise
--
rlzMenu.Context.Register = function()
    if CONTEXT_REGISTERED then
        return false
    end

    CONTEXT_REGISTERED = true

    return true
end

--- Sets the key used to open the context menu
---
--- @param EntityType string The entity type to set the items for
--- @param Options table The options for the context menu
--- @field Options.title string The title of the context menu
--- @field Options.items function The function that returns the items for the context menu
--- @return boolean True if the items were set successfully, false otherwise
--
rlzMenu.Context.SetItems = function(entityType, options)
    assert(type(entityType) == "string", "rlzMenu.Context.SetItems: entityType must be a string")
    assert(type(options) == "table", "rlzMenu.Context.SetItems: options must be a table")
    assert(options.title == nil or type(options.title) == "string", "rlzMenu.Context.SetItems: title must be a string or nil")
    assert(type(options.items) == "function", "rlzMenu.Context.SetItems: items must be a function")

    local self = {}
    self.title = options.title or "Context Menu"
    self.items = options.items

    CONTEXT_ITEMS[entityType] = self

    return true
end