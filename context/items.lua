CONTEXT_ITEMS = {}
CONTEXT_ITEM_COUNTER = 0
CONTEXT_ITEM_IDS = {}
CONTEXT_ITEM_LIST = nil

local CONTEXT_ITEM_PROPERTY_TYPES = {
    button = {
        label = "string",
        disabled = "boolean",
    },
    checkbox = {
        label = "string",
        isChecked = "boolean",
        disabled = "boolean",
    },
    switch = {
        label = "string",
        isChecked = "boolean",
        disabled = "boolean",
    },
    radio = {
        isChecked = "string",
    },
    submenu = {
        label = "string",
        disabled = "boolean",
    },
}

local function getContextItemList()
    return CONTEXT_ITEM_LIST or CONTEXT_CURRENT.items
end

--- Gets a property of a context item.
---
---@param itemId string The ID of the item.
---@param property string The property to get.
---@return any The value of the property, or nil if the item does not exist.
--
rlzMenu.Context.GetItemProperty = function(itemId, property)
    assert(type(itemId) == "string", "rlzMenu.Context.GetItemProperty: itemId must be a string")
    assert(type(property) == "string", "rlzMenu.Context.GetItemProperty: property must be a string")

    if not CONTEXT_CURRENT then
        print("[rlzMenu:Context] No context menu is currently active")
        return nil
    end

    local item = FindItemById(CONTEXT_CURRENT.items, itemId)
    if not item then
        print(("[rlzMenu:Context] Item with ID '%s' does not exist"):format(itemId))
        return nil
    end

    local allowedProperties = CONTEXT_ITEM_PROPERTY_TYPES[item.type]
    if not allowedProperties or not allowedProperties[property] then
        error(("Property '%s' is not supported for context item type '%s'"):format(property, item.type))
    end

    return item[property]
end

--- Sets a property of a context item.
---
---@param itemId string The ID of the item.
---@param property string The property to set.
---@param value any The value to set for the property.
---@return boolean True if the property was set successfully, false otherwise.
--
rlzMenu.Context.SetItemProperty = function(itemId, property, value)
    assert(type(itemId) == "string", "rlzMenu.Context.SetItemProperty: itemId must be a string")
    assert(type(property) == "string", "rlzMenu.Context.SetItemProperty: property must be a string")

    if not CONTEXT_CURRENT then
        print("[rlzMenu:Context] No context menu is currently active")
        return false
    end

    local item = FindItemById(CONTEXT_CURRENT.items, itemId)
    if not item then
        print(("[rlzMenu:Context] Item with ID '%s' does not exist"):format(itemId))
        return false
    end

    local allowedProperties = CONTEXT_ITEM_PROPERTY_TYPES[item.type]
    local expectedType = allowedProperties and allowedProperties[property]
    if not expectedType then
        error(("Property '%s' is not supported for context item type '%s'"):format(property, item.type))
    end

    if type(value) ~= expectedType then
        error(("Property '%s' must be a %s, got %s"):format(property, expectedType, type(value)))
    end

    item[property] = value

    rlzMenu.Context.Refresh()

    return true
end

local function getContextItemId(itemType, itemIndex)
    assert(type(itemType) == "string", "getContextItemId: itemType must be a string")
    assert(type(itemIndex) == "number", "getContextItemId: itemIndex must be a number")
    assert(CONTEXT_CURRENT ~= nil, "getContextItemId: CONTEXT_CURRENT is nil")

    local contextType = CONTEXT_CURRENT.type

    if not CONTEXT_ITEM_IDS[contextType] then
        CONTEXT_ITEM_IDS[contextType] = {}
    end

    local itemId = CONTEXT_ITEM_IDS[contextType][itemIndex]

    if not itemId then
        itemId = generateId("context-item-" .. itemType, itemIndex)
        CONTEXT_ITEM_IDS[contextType][itemIndex] = itemId
    end

    return itemId
end

--- Add a Button item to the context menu
---
--- @param options table The options for the button item
--- @field options.label string The label for the button item
--- @field options.disabled? boolean Whether the button item is disabled
--- @field options.onClick? function The function to call when the button item is clicked
--- @field options.onHover? function Function called when the button is hovered.
--- @field options.onLeave? function Function called when the cursor leaves the button.
--- @return string itemId
--
rlzMenu.Context.Button = function(options)
    assert(type(options) == "table", "rlzMenu.Context.Button: options must be a table")
    assert(type(options.label) == "string", "rlzMenu.Context.Button: label must be a string")
    assert(options.disabled == nil or type(options.disabled) == "boolean", "rlzMenu.Context.Button: disabled must be a boolean or nil")
    assert(options.onClick == nil or type(options.onClick) == "function", "rlzMenu.Context.Button: onClick must be a function or nil")
    assert(options.onHover == nil or type(options.onHover) == "function", "rlzMenu.Context.Button: onHover must be a function or nil")
    assert(options.onLeave == nil or type(options.onLeave) == "function", "rlzMenu.Context.Button: onLeave must be a function or nil")

    local self = {}
    CONTEXT_ITEM_COUNTER += 1

    self.id = getContextItemId("button", CONTEXT_ITEM_COUNTER)
    self.type = "button"
    self.label = options.label
    self.disabled = options.disabled or false
    self.onClick = options.onClick
    self.onHover = options.onHover
    self.onLeave = options.onLeave

    table.insert(getContextItemList(), self)

    return self.id
end

--- Add a Checkbox item to the context menu
---
--- @param options table The options for the checkbox item
--- @field options.label string The label for the checkbox item
--- @field options.isChecked boolean Whether the checkbox item is checked
--- @field options.disabled? boolean Whether the checkbox item is disabled
--- @field options.onToggle? function The function to call when the checkbox item is toggled
--- @field options.onHover? function Function called when the checkbox is hovered.
--- @field options.onLeave? function Function called when the cursor leaves the checkbox.
--- @return string itemId
--
rlzMenu.Context.Checkbox = function(options)
    assert(type(options) == "table", "rlzMenu.Context.Checkbox: options must be a table")
    assert(type(options.label) == "string", "rlzMenu.Context.Checkbox: label must be a string")
    assert(type(options.isChecked) == "boolean", "rlzMenu.Context.Checkbox: isChecked must be a boolean")
    assert(options.disabled == nil or type(options.disabled) == "boolean", "rlzMenu.Context.Checkbox: disabled must be a boolean or nil")
    assert(options.onToggle == nil or type(options.onToggle) == "function", "rlzMenu.Context.Checkbox: onToggle must be a function or nil")
    assert(options.onHover == nil or type(options.onHover) == "function", "rlzMenu.Context.Checkbox: onHover must be a function or nil")
    assert(options.onLeave == nil or type(options.onLeave) == "function", "rlzMenu.Context.Checkbox: onLeave must be a function or nil")

    local self = {}
    CONTEXT_ITEM_COUNTER += 1

    self.id = getContextItemId("checkbox", CONTEXT_ITEM_COUNTER)
    self.type = "checkbox"
    self.label = options.label
    self.isChecked = options.isChecked
    self.disabled = options.disabled or false
    self.onToggle = options.onToggle
    self.onHover = options.onHover
    self.onLeave = options.onLeave

    table.insert(getContextItemList(), self)

    return self.id
end

--- Add a Switch item to the context menu
---
--- @param options table The options for the switch item
--- @field options.label string The label for the switch item
--- @field options.isChecked boolean Whether the switch item is checked
--- @field options.disabled? boolean Whether the switch item is disabled
--- @field options.onToggle? function The function to call when the switch item is toggled
--- @field options.onHover? function Function called when the switch is hovered.
--- @field options.onLeave? function Function called when the cursor leaves the switch.
--- @return string itemId
--
rlzMenu.Context.Switch = function(options)
    assert(type(options) == "table", "rlzMenu.Context.Switch: options must be a table")
    assert(type(options.label) == "string", "rlzMenu.Context.Switch: label must be a string")
    assert(type(options.isChecked) == "boolean", "rlzMenu.Context.Switch: isChecked must be a boolean")
    assert(options.disabled == nil or type(options.disabled) == "boolean", "rlzMenu.Context.Switch: disabled must be a boolean or nil")
    assert(options.onToggle == nil or type(options.onToggle) == "function", "rlzMenu.Context.Switch: onToggle must be a function or nil")
    assert(options.onHover == nil or type(options.onHover) == "function", "rlzMenu.Context.Switch: onHover must be a function or nil")
    assert(options.onLeave == nil or type(options.onLeave) == "function", "rlzMenu.Context.Switch: onLeave must be a function or nil")
    
    local self = {}
    CONTEXT_ITEM_COUNTER += 1

    self.id = getContextItemId("switch", CONTEXT_ITEM_COUNTER)
    self.type = "switch"
    self.label = options.label
    self.isChecked = options.isChecked
    self.disabled = options.disabled or false
    self.onToggle = options.onToggle
    self.onHover = options.onHover
    self.onLeave = options.onLeave

    table.insert(getContextItemList(), self)

    return self.id
end

--- Add a radio group to the context menu
---
--- @param options table The options for the radio group
--- @field options.items table The radio options
--- @field options.isChecked string The id of the selected radio option
--- @field options.items[].id string The radio option id
--- @field options.items[].label string The radio option label
--- @field options.items[].disabled? boolean Whether the radio option is disabled
--- @field options.items[].onSelect? function The function to call when the option is selected
--- @return string itemId
--
rlzMenu.Context.Radio = function(options)
    assert(type(options) == "table", "rlzMenu.Context.Radio: options must be a table")
    assert(type(options.items) == "table" and #options.items > 0, "rlzMenu.Context.Radio: items must be a non-empty table")
    assert(type(options.isChecked) == "string", "rlzMenu.Context.Radio: isChecked must be a string")

    local self = {}
    CONTEXT_ITEM_COUNTER += 1

    self.id = getContextItemId("radio", CONTEXT_ITEM_COUNTER)
    self.type = "radio"
    self.isChecked = options.isChecked
    self.items = {}

    for _, option in ipairs(options.items) do
        assert(type(option) == "table", "rlzMenu.Context.Radio: each item must be a table")
        assert(type(option.id) == "string", "rlzMenu.Context.Radio: item id must be a string")
        assert(type(option.label) == "string", "rlzMenu.Context.Radio: item label must be a string")
        assert(option.disabled == nil or type(option.disabled) == "boolean", "rlzMenu.Context.Radio: item disabled must be a boolean or nil")
        assert(option.onSelect == nil or type(option.onSelect) == "function", "rlzMenu.Context.Radio: item onSelect must be a function or nil")

        table.insert(self.items, {
            id = option.id,
            label = option.label,
            disabled = option.disabled or false,
            onSelect = option.onSelect,
        })
    end

    local selectedItem = nil
    for _, option in ipairs(self.items) do
        if option.id == self.isChecked then
            selectedItem = option
            break
        end
    end
    assert(selectedItem ~= nil, "rlzMenu.Context.Radio: isChecked must match an item id")

    table.insert(getContextItemList(), self)

    return self.id
end

--- Add a Separator item to the context menu
---
--- @return string itemId
--
rlzMenu.Context.Separator = function()
    local self = {}
    CONTEXT_ITEM_COUNTER += 1

    self.id = getContextItemId("separator", CONTEXT_ITEM_COUNTER)
    self.type = "separator"

    table.insert(getContextItemList(), self)

    return self.id
end

--- Add a submenu item to the context menu
---
--- @param options table The options for the submenu item
--- @field options.label string The submenu label
--- @field options.disabled? boolean Whether the submenu is disabled
--- @field options.items function Function that adds items to the submenu
--- @return string itemId
--
rlzMenu.Context.SubMenu = function(options)
    assert(type(options) == "table", "rlzMenu.Context.SubMenu: options must be a table")
    assert(type(options.label) == "string", "rlzMenu.Context.SubMenu: label must be a string")
    assert(options.disabled == nil or type(options.disabled) == "boolean", "rlzMenu.Context.SubMenu: disabled must be a boolean or nil")
    assert(type(options.items) == "function", "rlzMenu.Context.SubMenu: items must be a function")

    local self = {}
    CONTEXT_ITEM_COUNTER += 1

    self.id = getContextItemId("submenu", CONTEXT_ITEM_COUNTER)
    self.type = "submenu"
    self.label = options.label
    self.disabled = options.disabled or false
    self.items = {}

    local previousItemList = CONTEXT_ITEM_LIST
    CONTEXT_ITEM_LIST = self.items
    options.items(CONTEXT_CURRENT.target)
    CONTEXT_ITEM_LIST = previousItemList

    table.insert(getContextItemList(), self)

    return self.id
end