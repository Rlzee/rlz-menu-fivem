CONTEXT_REGISTERED = false
CONTEXT_ACTIVE = false

local RIGHT_CLICK = 25 -- INPUT_AIM

CreateThread(function()
    while true do
        Wait(0)

        if not CONTEXT_REGISTERED then break end

        if (IsControlPressed(0, rlzMenu.Context.Key)) then
            if not CONTEXT_ACTIVE then
                SetCursorLocation(0.5, 0.5)
            end

            CONTEXT_ACTIVE = true
			SetMouseCursorActiveThisFrame()
			DisableControlAction(0, RIGHT_CLICK, true)
			DisableControlAction(0, 1, true)
			DisableControlAction(0, 2, true)

			if (IsDisabledControlJustPressed(0, RIGHT_CLICK)) then
				local cursorScreenPosition = GetCursorScreenPosition()
                local hit, positionImpact, _, entite = ScreenToWorld(cursorScreenPosition, rlzMenu.Context.MaxDistance)

                if not hit or not entite then
                    CONTEXT_ACTIVE = false
                    return
                end

                local entityType = GetEntityType(entite)
                print("Entity Type: " .. entityType)
			end
        else
            CONTEXT_ACTIVE = false
		end
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