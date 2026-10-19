MENUS = {}
CURRENT_MENU = nil
MENU_COUNTER = 0

local MENU_PROPERTY_TYPES = {
    title = "string",
    subtitle = "string",
    position = "string",
    color = "string",
    banner = "string",
    enabled = "boolean",
    controls = "boolean",
}

local INHERITED_MENU_PROPERTIES = {
    position = "positionForced",
}

--- Validates a menu color value: a single CSS color string, or a non-empty
--- array of color strings for a gradient banner.
---
---@param value any The color value to validate.
---@param context string The calling function name, used in error messages.
---@return boolean always true, errors otherwise
--
function ValidateMenuColor(value, context)
    if value == nil or type(value) == "string" then
        return true
    end

    if type(value) == "table" then
        if #value == 0 then
            error(("%s: color table must not be empty"):format(context))
        end

        for _, color in ipairs(value) do
            if type(color) ~= "string" then
                error(("%s: color table entries must be strings"):format(context))
            end
        end

        return true
    end

    error(("%s: color must be a string, a table of strings, or nil"):format(context))
end

--- Creates a new menu.
---
---@param options table
---@field options.title? string Menu title.
---@field options.subtitle? string Menu subtitle.
---@field options.command? string Command used to toggle the menu.
---@field options.key? string Key used to toggle the menu.
---@field options.position? "left"|"right" Menu position.
---@field options.color? string|string[] Base accent color for the menu: a CSS color (hex, rgb() or a named color such as "red"), the reserved "rainbow", or a table of colors for a gradient banner.
---@field options.banner? string Path or URL to a custom banner image displayed instead of the colored banner. Local files must live under web/dist (or be listed in the fxmanifest files).
---@field options.enabled? boolean Menu enabled state. Defaults to true.
---@field options.controls? boolean Whether to display the menu navigation controls. Defaults to false.
---@return string menuId
--
rlzMenu.Create = function(options)
    assert(type(options) == "table", "rlzMenu.Create: options must be a table")
    assert(options.title == nil or type(options.title) == "string", "rlzMenu.Create: title must be a string or nil")
    assert(options.subtitle == nil or type(options.subtitle) == "string", "rlzMenu.Create: subtitle must be a string or nil")
    assert(options.command == nil or type(options.command) == "string", "rlzMenu.Create: command must be a string or nil")
    assert(options.key == nil or type(options.key) == "string", "rlzMenu.Create: key must be a string or nil")
    assert(options.position == nil or options.position == "left" or options.position == "right", "rlzMenu.Create: position must be 'left', 'right' or nil")
    ValidateMenuColor(options.color, "rlzMenu.Create")
    assert(options.banner == nil or type(options.banner) == "string", "rlzMenu.Create: banner must be a string or nil")
    assert(options.enabled == nil or type(options.enabled) == "boolean", "rlzMenu.Create: enabled must be a boolean or nil")
    assert(options.controls == nil or type(options.controls) == "boolean", "rlzMenu.Create: controls must be a boolean or nil")

    local self = {}
    MENU_COUNTER += 1

    self.id = generateId("menu", MENU_COUNTER)
    self.title = options.title or ""
    self.subtitle = options.subtitle or ""
    self.visible = false
    self.position = options.position or "left"
    self.positionForced = options.position ~= nil
    self.command = options.command
    self.key = options.key
    self.color = options.color
    self.banner = options.banner
    self.enabled = options.enabled ~= false
    self.controls = options.controls == true

    MENUS[self.id] = self

    RegisterMenuKey(
        self.id,
        self.command,
        self.key,
        "Toggle menu: " .. self.title
    )

    return self.id
end

--- Creates a submenu linked to a parent menu.
---
---@param parentId string Parent menu ID.
---@param options table
---@field options.title? string Submenu title.
---@field options.subtitle? string Submenu subtitle.
---@field options.position? "left"|"right" Submenu position. Inherits the parent position if not specified.
---@field options.color? string|string[] Base accent color (a color string, "rainbow", or a table of colors for a gradient). Inherits the parent color if not specified.
---@field options.inheritColor? boolean Whether the submenu keeps following the parent color when it changes later. Defaults to true when no color is given, false when an own color is given.
---@field options.banner? string Path or URL to a custom banner image. Inherits the parent banner if not specified.
---@field options.inheritBanner? boolean Whether the submenu keeps following the parent banner when it changes later. Defaults to true when no banner is given, false when an own banner is given.
---@field options.enabled? boolean Menu enabled state. Defaults to true.
---@field options.controls? boolean Whether to display the submenu navigation controls. Inherits the parent value if not specified.
---@return string menuId
--
rlzMenu.CreateSubMenu = function(parentId, options)
    assert(type(parentId) == "string", "rlzMenu.CreateSubMenu: parentId must be a string")
    assert(type(options) == "table", "rlzMenu.CreateSubMenu: options must be a table")
    assert(MENUS[parentId] ~= nil, "rlzMenu.CreateSubMenu: parent menu does not exist")
    assert(options.title == nil or type(options.title) == "string", "rlzMenu.CreateSubMenu: title must be a string or nil")
    assert(options.subtitle == nil or type(options.subtitle) == "string", "rlzMenu.CreateSubMenu: subtitle must be a string or nil")
    assert(options.position == nil or options.position == "left" or options.position == "right", "rlzMenu.CreateSubMenu: position must be 'left', 'right' or nil")
    ValidateMenuColor(options.color, "rlzMenu.CreateSubMenu")
    assert(options.inheritColor == nil or type(options.inheritColor) == "boolean", "rlzMenu.CreateSubMenu: inheritColor must be a boolean or nil")
    assert(options.banner == nil or type(options.banner) == "string", "rlzMenu.CreateSubMenu: banner must be a string or nil")
    assert(options.inheritBanner == nil or type(options.inheritBanner) == "boolean", "rlzMenu.CreateSubMenu: inheritBanner must be a boolean or nil")
    assert(options.enabled == nil or type(options.enabled) == "boolean", "rlzMenu.CreateSubMenu: enabled must be a boolean or nil")
    assert(options.controls == nil or type(options.controls) == "boolean", "rlzMenu.CreateSubMenu: controls must be a boolean or nil")

    local parent = MENUS[parentId]

    local self = {}
    MENU_COUNTER += 1

    self.id = generateId("submenu", MENU_COUNTER)
    self.title = options.title or ""
    self.subtitle = options.subtitle or ""
    self.visible = false
    self.position = options.position or parent.position or "left"
    self.positionForced = options.position ~= nil
    self.parent = parentId

    local inheritColor = options.inheritColor

    if inheritColor == nil then
        inheritColor = options.color == nil
    end

    self.inheritColor = inheritColor

    if inheritColor then
        self.color = parent.color or options.color
    else
        self.color = options.color
    end

    local inheritBanner = options.inheritBanner

    if inheritBanner == nil then
        inheritBanner = options.banner == nil
    end

    self.inheritBanner = inheritBanner

    if inheritBanner then
        self.banner = parent.banner or options.banner
    else
        self.banner = options.banner
    end

    self.enabled = options.enabled ~= false

    if options.controls == nil then
        self.controls = parent.controls
    else
        self.controls = options.controls
    end

    MENUS[self.id] = self

    return self.id
end

--- Returns the IDs of every menu in the same tree as the given menu:
--- the menu itself, its ancestors and all of its descendants.
---
---@param menuId string The ID of any menu of the tree.
---@return string[] menuIds
--
function GetMenuTreeIds(menuId)
    local root = MENUS[menuId]

    if not root then
        return {}
    end

    while root.parent and MENUS[root.parent] do
        root = MENUS[root.parent]
    end

    local menuIds = {}

    local function collect(menu)
        menuIds[#menuIds + 1] = menu.id

        for _, other in pairs(MENUS) do
            if other.parent == menu.id then
                collect(other)
            end
        end
    end

    collect(root)

    return menuIds
end

--- Sets the items of a menu.
---
---@param menuId string The ID of the menu.
---@param builder function A function that builds the menu items. This function will be called when the menu is opened.
---@return boolean True if the items were set successfully, false if the menu does not exist.
--
rlzMenu.SetItems = function(menuId, builder)
    assert(type(menuId) == "string", "rlzMenu.SetItems: menuId must be a string")
    assert(type(builder) == "function", "rlzMenu.SetItems: builder must be a function")

    local menu = MENUS[menuId]

    if not menu then
        print(("[rlzMenu] Menu with ID '%s' does not exist"):format(menuId))
        return false
    end

    menu.items = builder

    return true
end

--- Sets the visibility of a menu.
---
---@param menuId string The ID of the menu.
---@param state boolean The visibility state of the menu.
---@return boolean True if the visibility was set successfully, false if the menu does not exist.
--
rlzMenu.SetVisible = function(menuId, state)
    assert(type(menuId) == "string", "Menu ID must be a string")
    assert(type(state) == "boolean", "State must be a boolean")

    local menu = MENUS[menuId]
    if not menu then
        print(("[rlzMenu] Menu with ID '%s' does not exist"):format(menuId))
        return false
    end

    if state and not menu.enabled then
        print(("[rlzMenu] Menu with ID '%s' is disabled and cannot be opened"):format(menuId))
        return false
    end

    menu.visible = state
    if state then
        CURRENT_MENU = menuId

        ITEMS = {}
        ITEM_COUNTER = 0
        if menu.items then
            menu.items()
        end

        TriggerNuiEvent("rlz_menu:setData", BuildMenuData(menu))

        playSound("select")
    else
        CURRENT_MENU = nil
        playSound("back")
    end

    SetNuiFocus(state, false)
    SetNuiFocusKeepInput(state)

    TriggerNuiEvent("rlz_menu:setVisible", {
        state = state
    })

    return true
end

--- Gets a property of a menu.
---
---@param menuId string The ID of the menu.
---@param property string The property to get. Supported properties: "title", "subtitle", "position", "color", "banner", "enabled", "controls".
---@return any The value of the property, or nil if the menu does not exist.
--
rlzMenu.GetMenuProperty = function(menuId, property)
    assert(type(menuId) == "string", "rlzMenu.GetMenuProperty: menuId must be a string")
    assert(type(property) == "string", "rlzMenu.GetMenuProperty: property must be a string")

    if MENU_PROPERTY_TYPES[property] == nil then
        error(("Property '%s' is not supported for menus"):format(property))
    end

    local menu = MENUS[menuId]

    if not menu then
        print(("[rlzMenu] Menu with ID '%s' does not exist"):format(menuId))
        return nil
    end

    return menu[property]
end

local function setMenuPositionOffset(menuId, x, y)
    local menu = MENUS[menuId]

    if not menu then
        return false
    end

    SaveMenuPosition(menuId, x, y)

    if CURRENT_MENU == menuId then
        rlzMenu.Refresh(menuId)
    end

    return true
end

local function setMenuProperty(menuId, property, value, forced)
    local menu = MENUS[menuId]

    if not menu then
        return false
    end

    menu[property] = value

    if property == "position" then
        DeleteMenuPosition(menuId)
    end

    local forcedProperty = INHERITED_MENU_PROPERTIES[property]

    if forcedProperty and forced then
        menu[forcedProperty] = true

        for _, childMenu in pairs(MENUS) do
            if childMenu.parent == menuId and not childMenu[forcedProperty] then
                setMenuProperty(childMenu.id, property, value, false)
            end
        end
    end

    if property == "color" and forced then
        for _, childMenu in pairs(MENUS) do
            if childMenu.parent == menuId and childMenu.inheritColor then
                setMenuProperty(childMenu.id, "color", value, true)
            end
        end
    end

    if property == "banner" and forced then
        for _, childMenu in pairs(MENUS) do
            if childMenu.parent == menuId and childMenu.inheritBanner then
                setMenuProperty(childMenu.id, "banner", value, true)
            end
        end
    end

    if property == "enabled" and not value and menu.visible then
        rlzMenu.SetVisible(menuId, false)
    else
        rlzMenu.Refresh(menu.id)
    end

    return true
end

--- Sets a property of a menu.
---
---@param menuId string The ID of the menu.
---@param property string The property to set. Supported properties: "title", "subtitle", "position", "color", "banner", "enabled", "controls".
---@param value any The value to set for the property. For "position": "left", "right", or a table { x = number, y = number } with the screen position as ratios between 0 and 1. For "color": a color string or a table of color strings (gradient).
---@param applyToSubmenus? boolean Whether the property should also be applied to descendant submenus. Defaults to true. Ignored for the table form of "position". For "color", only submenus created with inheritColor follow the change; for "banner", only submenus created with inheritBanner do.
---@return boolean True if the property was set successfully, false if the menu does not exist.
--
rlzMenu.SetMenuProperty = function(menuId, property, value, applyToSubmenus)
    assert(type(menuId) == "string", "rlzMenu.SetMenuProperty: menuId must be a string")
    assert(type(property) == "string", "rlzMenu.SetMenuProperty: property must be a string")
    assert(applyToSubmenus == nil or type(applyToSubmenus) == "boolean", "rlzMenu.SetMenuProperty: applyToSubmenus must be a boolean or nil")

    local expectedType = MENU_PROPERTY_TYPES[property]
    if expectedType == nil then
        error(("Property '%s' is not supported for menus"):format(property))
    end

    if property == "position" then
        local isAlignment = value == "left" or value == "right"
        local isOffset = type(value) == "table"
            and type(value.x) == "number"
            and type(value.y) == "number"

        if not isAlignment and not isOffset then
            error("Menu position must be 'left', 'right' or a table { x = number, y = number }")
        end
    elseif property == "color" then
        ValidateMenuColor(value, "rlzMenu.SetMenuProperty")
    elseif type(value) ~= expectedType then
        error((
            "Property '%s' must be a %s, got %s"
        ):format(property, expectedType, type(value)))
    end

    if property == "position" and type(value) == "table" then
        return setMenuPositionOffset(menuId, value.x, value.y)
    end

    return setMenuProperty(menuId, property, value, applyToSubmenus ~= false)
end

--- Destroys a submenu and all its descendant submenus.
---
---@param menuId string The ID of the menu to destroy.
---@param destroyChildren? boolean Whether to also destroy descendant submenus. Defaults to true.
---@return boolean True if the menu was destroyed, false if it did not exist.
--
rlzMenu.DestroySubMenu = function(menuId, destroyChildren)
    assert(type(menuId) == "string", "rlzMenu.DestroySubMenu: menuId must be a string")
    assert(destroyChildren == nil or type(destroyChildren) == "boolean", "rlzMenu.DestroySubMenu: destroyChildren must be a boolean or nil")

    local menu = MENUS[menuId]

    if not menu then
        print(("[rlzMenu] Menu with ID '%s' does not exist"):format(menuId))
        return false
    end

    if not menu.parent then
        error("rlzMenu.DestroySubMenu: cannot destroy a root menu")
    end

    if destroyChildren ~= false then
        for childId, childMenu in pairs(MENUS) do
            if childMenu.parent == menuId then
                rlzMenu.DestroySubMenu(childId)
            end
        end
    end

    if CURRENT_MENU == menuId then
        rlzMenu.GoBack()
    end

    MENUS[menuId] = nil

    -- Drop the menu's cached stable item IDs so long-running sessions don't
    -- accumulate stale entries for destroyed menus.
    ITEM_IDS[menuId] = nil

    return true
end