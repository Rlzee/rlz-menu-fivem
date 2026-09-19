MENUS = {}
CURRENT_MENU = nil
MENU_COUNTER = 0

local MENU_PROPERTY_TYPES = {
    title = "string",
    subtitle = "string",
    position = "string",
    color = "string",
    hoverColor = "string",
    enabled = "boolean",
}

local INHERITED_MENU_PROPERTIES = {
    position = "positionForced",
    color = "colorForced",
    hoverColor = "hoverColorForced",
}

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

--- Creates a new menu.
---
---@param options table
---@field options.title? string Menu title.
---@field options.subtitle? string Menu subtitle.
---@field options.command? string Command used to toggle the menu.
---@field options.key? string Key used to toggle the menu.
---@field options.color? string|string[] Menu color or a list of colors for a gradient. Use "rainbow" for an animated color.
---@field options.hoverColor? string|string[] Item hover color or a list of colors for a gradient. Use "rainbow" for an animated color.
---@field options.position? "left"|"right" Menu position.
---@field options.enabled? boolean Menu enabled state. Defaults to true.
---@return string menuId
--
rlzMenu.Create = function(options)
    assert(type(options) == "table", "rlzMenu.Create: options must be a table")
    assert(options.title == nil or type(options.title) == "string", "rlzMenu.Create: title must be a string or nil")
    assert(options.subtitle == nil or type(options.subtitle) == "string", "rlzMenu.Create: subtitle must be a string or nil")
    assert(options.command == nil or type(options.command) == "string", "rlzMenu.Create: command must be a string or nil")
    assert(options.key == nil or type(options.key) == "string", "rlzMenu.Create: key must be a string or nil")
    assert(options.color == nil or isColor(options.color), "rlzMenu.Create: color must be a string or a non-empty array of strings")
    assert(options.hoverColor == nil or isColor(options.hoverColor), "rlzMenu.Create: hoverColor must be a string or a non-empty array of strings")
    assert(options.position == nil or options.position == "left" or options.position == "right", "rlzMenu.Create: position must be 'left', 'right' or nil")
    assert(options.enabled == nil or type(options.enabled) == "boolean", "rlzMenu.Create: enabled must be a boolean or nil")

    local self = {}
    MENU_COUNTER += 1

    self.id = generateId("menu", MENU_COUNTER)
    self.title = options.title or ""
    self.subtitle = options.subtitle or ""
    self.visible = false
    self.color = options.color or "default"
    self.hoverColor = options.hoverColor
    self.position = options.position or "left"
    self.positionForced = options.position ~= nil
    self.command = options.command
    self.key = options.key
    self.enabled = options.enabled ~= false

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
---@field options.color? string|string[] Submenu color or a list of colors for a gradient. Inherits the parent color if not specified.
---@field options.hoverColor? string|string[] Submenu item hover color or a list of colors for a gradient. Inherits the parent hover color if not specified.
---@field options.enabled? boolean Menu enabled state. Defaults to true.
---@return string menuId
--
rlzMenu.CreateSubMenu = function(parentId, options)
    assert(type(parentId) == "string", "rlzMenu.CreateSubMenu: parentId must be a string")
    assert(type(options) == "table", "rlzMenu.CreateSubMenu: options must be a table")
    assert(MENUS[parentId] ~= nil, "rlzMenu.CreateSubMenu: parent menu does not exist")
    assert(options.title == nil or type(options.title) == "string", "rlzMenu.CreateSubMenu: title must be a string or nil")
    assert(options.subtitle == nil or type(options.subtitle) == "string", "rlzMenu.CreateSubMenu: subtitle must be a string or nil")
    assert(options.position == nil or options.position == "left" or options.position == "right", "rlzMenu.CreateSubMenu: position must be 'left', 'right' or nil")
    assert(options.color == nil or isColor(options.color), "rlzMenu.CreateSubMenu: color must be a string or a non-empty array of strings")
    assert(options.hoverColor == nil or isColor(options.hoverColor), "rlzMenu.CreateSubMenu: hoverColor must be a string or a non-empty array of strings")
    assert(options.enabled == nil or type(options.enabled) == "boolean", "rlzMenu.CreateSubMenu: enabled must be a boolean or nil")

    local parent = MENUS[parentId]

    local self = {}
    MENU_COUNTER += 1

    self.id = generateId("submenu", MENU_COUNTER)
    self.title = options.title or ""
    self.subtitle = options.subtitle or ""
    self.visible = false
    self.color = options.color or parent.color or "default"
    self.colorForced = options.color ~= nil
    self.hoverColor = options.hoverColor or parent.hoverColor
    self.hoverColorForced = options.hoverColor ~= nil
    self.position = options.position or parent.position or "left"
    self.positionForced = options.position ~= nil
    self.parent = parentId
    self.enabled = options.enabled ~= false

    MENUS[self.id] = self

    return self.id
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

        TriggerNuiEvent("rlz_menu:setData", {
            menuId = menu.id,
            selectedItemId = menu.selectedItemId,
            title = menu.title,
            subtitle = menu.subtitle,
            color = menu.color,
            hoverColor = menu.hoverColor,
            position = menu.position,
            items = PrepareNuiItems(ITEMS),
        })

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
---@param property string The property to get. Supported properties: "title", "subtitle", "position", "color", "hoverColor", "enabled".
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

local function setMenuProperty(menuId, property, value, forced)
    local menu = MENUS[menuId]

    if not menu then
        return false
    end

    menu[property] = value

    local forcedProperty = INHERITED_MENU_PROPERTIES[property]

    if forcedProperty and forced then
        menu[forcedProperty] = true

        for _, childMenu in pairs(MENUS) do
            if childMenu.parent == menuId and not childMenu[forcedProperty] then
                setMenuProperty(childMenu.id, property, value, false)
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
---@param property string The property to set. Supported properties: "title", "subtitle", "position", "color", "hoverColor", "enabled".
---@param value any The value to set for the property.
---@param applyToSubmenus? boolean Whether the property should also be applied to descendant submenus. Defaults to true.
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

    if (property == "color" or property == "hoverColor") and not isColor(value) then
        error((
            "Property '%s' must be a string or a non-empty array of strings"
        ):format(property))
    elseif property ~= "color" and property ~= "hoverColor" and type(value) ~= expectedType then
        error((
            "Property '%s' must be a %s, got %s"
        ):format(property, expectedType, type(value)))
    end

    if property == "position" and value ~= "left" and value ~= "right" then
        error("Menu position must be 'left' or 'right'")
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
    assert(type(destroyChildren) == "boolean" or destroyChildren == true, "rlzMenu.DestroySubMenu: destroyChildren must be a boolean or nil")

    local menu = MENUS[menuId]

    if not menu then
        print(("[rlzMenu] Menu with ID '%s' does not exist"):format(menuId))
        return false
    end

    if not menu.parent then
        error("rlzMenu.DestroySubMenu: cannot destroy a root menu")
    end

    if destroyChildren then
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

    return true
end