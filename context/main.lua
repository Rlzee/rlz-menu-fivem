CONTEXT_REGISTERED = false
CONTEXT_ACTIVE = false
CONTEXT_CURRENT = nil

local RIGHT_CLICK = 25 -- INPUT_AIM
local LEFT_CLICK = 24 -- INPUT_ATTACK

local function isColor(value)
    if type(value) == "string" then
        return true
    end

    if type(value) ~= "table" or #value == 0 then
        return false
    end

    for _, color in ipairs(value) do
        if type(color) ~= "string" then
            return false
        end
    end

    return true
end

CreateThread(function()
    while true do
        Wait(0)

        if not CONTEXT_REGISTERED then
            goto continue
        end

        -- The search bar owns NUI focus while it is open.
        if SEARCH_BAR then
            goto continue
        end

        if IsControlPressed(0, rlzMenu.Context.Key) then
            if not CONTEXT_ACTIVE then
                SetCursorLocation(0.5, 0.5)
            end

            CONTEXT_ACTIVE = true

            SetNuiFocus(CONTEXT_ACTIVE, true)
            SetNuiFocusKeepInput(CONTEXT_ACTIVE)

            DisableControlAction(0, RIGHT_CLICK, true)
            DisableControlAction(0, LEFT_CLICK, true)

            if IsDisabledControlJustPressed(0, RIGHT_CLICK) then
                rlzMenu.Context.SetVisible(true, target)
            end
        else
            local wasContextActive = CONTEXT_ACTIVE
            CONTEXT_ACTIVE = false

            if wasContextActive then
                rlzMenu.Context.SetVisible(false)
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
--- @field Options.hoverColor? string|string[] Item hover color or a list of colors for a gradient. Use "rainbow" for an animated color.
--- @field Options.items function The function that returns the items for the context menu
--- @return boolean True if the items were set successfully, false otherwise
--
rlzMenu.Context.SetItems = function(entityType, options)
    assert(type(entityType) == "string", "rlzMenu.Context.SetItems: entityType must be a string")
    assert(type(options) == "table", "rlzMenu.Context.SetItems: options must be a table")
    assert(options.title == nil or type(options.title) == "string", "rlzMenu.Context.SetItems: title must be a string or nil")
    assert(options.hoverColor == nil or isColor(options.hoverColor), "rlzMenu.Context.SetItems: hoverColor must be a string or a non-empty array of strings")
    assert(type(options.items) == "function", "rlzMenu.Context.SetItems: items must be a function")

    local self = {}
    self.title = options.title or "Context Menu"
    self.hoverColor = options.hoverColor
    self.items = options.items

    CONTEXT_ITEMS[entityType] = self

    return true
end

rlzMenu.Context.SetVisible = function(state)
    assert(type(state) == "boolean", "rlzMenu.Context.SetVisible: state must be a boolean")

    if state then
        local target = rlzMenu.Context.GetTarget()

        if not target or not target.type then
            print("[rlzMenu:Context] No target found for context menu")
            return false
        end

        local context = CONTEXT_ITEMS[target.type]

        if not context then
            print("[rlzMenu:Context] No context menu registered for entity type: " .. target.type)
            return false
        end

        local items = {}
        local screenWidth, screenHeight = GetActiveScreenResolution()
        local cursorX = GetControlNormal(0, 239) * screenWidth
        local cursorY = GetControlNormal(0, 240) * screenHeight

        CONTEXT_CURRENT = {
            target = target,
            type = target.type,
            coords = target.coords,
            normal = target.normal,
            title = context.title,
            hoverColor = context.hoverColor,
            items = items,
            x = cursorX,
            y = cursorY,
        }

        context.items(target)

        rlzMenu.Context.Refresh()

        playSound("select")
    else
        CONTEXT_CURRENT = nil
        local menuIsVisible = rlzMenu.GetCurrentMenu() ~= nil
        SetNuiFocus(menuIsVisible, false)
        SetNuiFocusKeepInput(menuIsVisible)
        playSound("back")
    end

    TriggerNuiEvent("rlz_menu:context:setVisible", {
        state = state
    })

    return true
end