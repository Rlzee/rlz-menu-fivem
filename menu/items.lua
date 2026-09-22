ITEMS = {}
ITEM_COUNTER = 0
ITEM_IDS = {}

local ITEM_PROPERTY_TYPES = {
    button = {
        label = "string",
        anchor = "string",
        description = "string",
        onSelect = "function",
        submenu = "string",
        disabled = "boolean",
        color = "string",
        onHover = "function",
        onLeave = "function",
    },

    label = {
        label = "string",
    },

    separator = {
        visible = "boolean",
    },

    checkbox = {
        label = "string",
        description = "string",
        isChecked = "boolean",
        onChange = "function",
        disabled = "boolean",
        color = "string",
        onHover = "function",
        onLeave = "function",
    },

    switch = {
        label = "string",
        description = "string",
        isChecked = "boolean",
        onChange = "function",
        disabled = "boolean",
        color = "string",
        onHover = "function",
        onLeave = "function",
    },

    list = {
        label = "string",
        description = "string",
        values = "table",
        index = "number",
        onChange = "function",
        disabled = "boolean",
        color = "string",
        onHover = "function",
        onLeave = "function",
    },
}

local function getItemId(itemType, itemIndex)
    assert(type(itemType) == "string", "itemType must be a string")
    assert(type(itemIndex) == "number", "itemIndex must be a number")
    assert(CURRENT_MENU ~= nil, "CURRENT_MENU must be set")

    if not ITEM_IDS[CURRENT_MENU] then
        ITEM_IDS[CURRENT_MENU] = {}
    end

    local itemId = ITEM_IDS[CURRENT_MENU][itemIndex]

    if not itemId then
        itemId = generateId("item-" .. itemType, itemIndex)
        ITEM_IDS[CURRENT_MENU][itemIndex] = itemId
    end

    return itemId
end

local function findItemById(itemId)
    for _, item in ipairs(ITEMS) do
        if item.id == itemId then
            return item
        end
    end

    return nil
end

--- Gets a property of an item.
---
---@param itemId string The ID of the item.
---@param property string The property to get. Supported properties depend on the item type.
---@return any The value of the property, or nil if the item does not exist.
--
rlzMenu.GetItemProperty = function(itemId, property)
    assert(type(itemId) == "string", "rlzMenu.GetItemProperty: itemId must be a string")
    assert(type(property) == "string", "rlzMenu.GetItemProperty: property must be a string")

    local item = findItemById(itemId)

    if not item then
        print(("[rlzMenu] Item with ID '%s' does not exist"):format(itemId))
        return nil
    end

    local allowedProperties = ITEM_PROPERTY_TYPES[item.type]
    if allowedProperties == nil or allowedProperties[property] == nil then
        error((
            "Property '%s' is not supported for item type '%s'"
        ):format(property, item.type))
    end

    return item[property]
end

--- Sets a property of an item.
---
---@param itemId string The ID of the item.
---@param property string The property to set. Supported properties depend on the item type.
---@param value any The value to set for the property.
---@return boolean True if the property was set successfully, false if the item does not exist.
--
rlzMenu.SetItemProperty = function(itemId, property, value)
    assert(type(itemId) == "string", "rlzMenu.SetItemProperty: itemId must be a string")
    assert(type(property) == "string", "rlzMenu.SetItemProperty: property must be a string")

    local item = findItemById(itemId)

    if not item then
        print(("[rlzMenu] Item with ID '%s' does not exist"):format(itemId))
        return false
    end

    local allowedProperties = ITEM_PROPERTY_TYPES[item.type]
    local expectedType = allowedProperties and allowedProperties[property]

    if expectedType == nil then
        error((
            "Property '%s' is not supported for item type '%s'"
        ):format(property, item.type))
    end

    if type(value) ~= expectedType then
        error((
            "Property '%s' must be a %s, got %s"
        ):format(property, expectedType, type(value)))
    end

    if item.type == "list" and property == "index" then
        if value < 1 or value > #item.values then
            error((
                "List index must be between 1 and %s"
            ):format(#item.values))
        end

        item.index = value
        item.value = item.values[value]

    elseif item.type == "list" and property == "values" then
        if #value == 0 then
            error("List values must not be empty")
        end

        item.values = value

        if item.index > #item.values then
            item.index = #item.values
        end

        if item.index < 1 then
            item.index = 1
        end

        item.value = item.values[item.index]

    else
        item[property] = value
    end

    local currentMenu = MENUS[CURRENT_MENU]

    if currentMenu then
        rlzMenu.Refresh(currentMenu.id)
    end

    return true
end

--- Add a button item.
---
---@param options table
---@field options.label string Button label.
---@field options.anchor? string Button anchor or "loading" for an animated spinner.
---@field options.anchorColor? string Button anchor color or "rainbow" for an animated color.
---@field options.description? string Button description.
---@field options.onSelect? function Function called when the button is selected.
---@field options.submenu? string Submenu ID opened when the button is selected.
---@field options.disabled? boolean Whether the button is disabled.
---@field options.color? string Button color or "rainbow" for an animated color.
---@field options.onHover? function Function called when the button is hovered.
---@field options.onLeave? function Function called when the cursor leaves the button.
---@return string itemId
--
rlzMenu.Button = function(options)
    assert(type(options) == "table", "rlzMenu.Button: options must be a table")
    assert(type(options.label) == "string", "rlzMenu.Button: label must be a string")
    assert(options.anchor == nil or type(options.anchor) == "string", "rlzMenu.Button: anchor must be a string or nil")
    assert(options.anchorColor == nil or type(options.anchorColor) == "string", "rlzMenu.Button: anchorColor must be a string or nil")
    assert(options.description == nil or type(options.description) == "string", "rlzMenu.Button: description must be a string or nil")
    assert(options.onSelect == nil or type(options.onSelect) == "function", "rlzMenu.Button: onSelect must be a function or nil")
    assert(options.submenu == nil or type(options.submenu) == "string", "rlzMenu.Button: submenu must be a string or nil")
    assert(options.disabled == nil or type(options.disabled) == "boolean", "rlzMenu.Button: disabled must be a boolean or nil")
    assert(options.color == nil or type(options.color) == "string", "rlzMenu.Button: color must be a string or nil")
    assert(options.onHover == nil or type(options.onHover) == "function", "rlzMenu.Button: onHover must be a function or nil")
    assert(options.onLeave == nil or type(options.onLeave) == "function", "rlzMenu.Button: onLeave must be a function or nil")

    local self = {}
    ITEM_COUNTER += 1

    self.id = getItemId("button", ITEM_COUNTER)
    self.type = "button"
    self.label = options.label
    self.anchor = options.anchor or ""
    self.anchorColor = options.anchorColor
    self.description = options.description or ""
    self.onSelect = options.onSelect
    self.submenu = options.submenu
    self.disabled = options.disabled or false
    self.color = options.color
    self.onHover = options.onHover
    self.onLeave = options.onLeave

    table.insert(ITEMS, self)

    return self.id
end

--- Add a label item.
---
---@param label string Label text.
---@return string itemId
--
rlzMenu.Label = function(label)
    assert(type(label) == "string", "Label label must be a string")

    local self = {}
    ITEM_COUNTER += 1

    self.id = getItemId("label", ITEM_COUNTER)
    self.type = "label"
    self.label = label

    table.insert(ITEMS, self)

    return self.id
end

--- Add a separator item.
---
---@param options? table
---@field options.visible? boolean Whether the separator bar is visible.
---@return string itemId
--
rlzMenu.Separator = function(options)
    options = options or {}
    assert(type(options) == "table", "rlzMenu.Separator: options must be a table")
    assert(options.visible == nil or type(options.visible) == "boolean", "rlzMenu.Separator: visible must be a boolean or nil")

    local self = {}
    ITEM_COUNTER += 1

    self.id = getItemId("separator", ITEM_COUNTER)
    self.type = "separator"
    self.visible = options.visible ~= false

    table.insert(ITEMS, self)

    return self.id
end

--- Add a checkbox item.
---
---@param options table
---@field options.label string Checkbox label.
---@field options.description? string Checkbox description.
---@field options.isChecked boolean Whether the checkbox is checked.
---@field options.color? string Checkbox color or "rainbow" for an animated color.
---@field options.onChange? function Function called when the checkbox state changes.
---@field options.disabled? boolean Whether the checkbox is disabled.
---@field options.onHover? function Function called when the checkbox is hovered.
---@field options.onLeave? function Function called when the cursor leaves the checkbox.
---@return string itemId
--
rlzMenu.Checkbox = function(options)
    assert(type(options) == "table", "rlzMenu.Checkbox: options must be a table")
    assert(type(options.label) == "string", "rlzMenu.Checkbox: label must be a string")
    assert(options.description == nil or type(options.description) == "string","rlzMenu.Checkbox: description must be a string or nil")
    assert(type(options.isChecked) == "boolean", "rlzMenu.Checkbox: isChecked must be a boolean")
    assert(options.color == nil or type(options.color) == "string", "rlzMenu.Checkbox: color must be a string or nil")
    assert(options.onChange == nil or type(options.onChange) == "function", "rlzMenu.Checkbox: onChange must be a function or nil")
    assert(options.disabled == nil or type(options.disabled) == "boolean", "rlzMenu.Checkbox: disabled must be a boolean or nil")
    assert(options.onHover == nil or type(options.onHover) == "function", "rlzMenu.Checkbox: onHover must be a function or nil")
    assert(options.onLeave == nil or type(options.onLeave) == "function", "rlzMenu.Checkbox: onLeave must be a function or nil")

    local self = {}
    ITEM_COUNTER += 1

    self.id = getItemId("checkbox", ITEM_COUNTER)
    self.type = "checkbox"
    self.label = options.label
    self.description = options.description or ""
    self.isChecked = options.isChecked
    self.color = options.color
    self.onChange = options.onChange
    self.disabled = options.disabled or false
    self.onHover = options.onHover
    self.onLeave = options.onLeave

    table.insert(ITEMS, self)

    return self.id
end

--- Add a switch item.
---
---@param options table
---@field options.label string Checkbox label.
---@field options.description? string Checkbox description.
---@field options.isChecked boolean Whether the checkbox is checked.
---@field options.color? string Checkbox color or "rainbow" for an animated color.
---@field options.onChange? function Function called when the checkbox state changes.
---@field options.disabled? boolean Whether the checkbox is disabled.
---@field options.onHover? function Function called when the checkbox is hovered.
---@field options.onLeave? function Function called when the cursor leaves the checkbox.
---@return string itemId
--
rlzMenu.Switch = function(options)
    assert(type(options) == "table", "rlzMenu.Switch: options must be a table")
    assert(type(options.label) == "string", "rlzMenu.Switch: label must be a string")
    assert(options.description == nil or type(options.description) == "string","rlzMenu.Switch: description must be a string or nil")
    assert(type(options.isChecked) == "boolean", "rlzMenu.Switch: isChecked must be a boolean")
    assert(options.color == nil or type(options.color) == "string", "rlzMenu.Switch: color must be a string or nil")
    assert(options.onChange == nil or type(options.onChange) == "function", "rlzMenu.Switch: onChange must be a function or nil")
    assert(options.disabled == nil or type(options.disabled) == "boolean", "rlzMenu.Switch: disabled must be a boolean or nil")
    assert(options.onHover == nil or type(options.onHover) == "function", "rlzMenu.Switch: onHover must be a function or nil")
    assert(options.onLeave == nil or type(options.onLeave) == "function", "rlzMenu.Switch: onLeave must be a function or nil")

    local self = {}
    ITEM_COUNTER += 1

    self.id = getItemId("switch", ITEM_COUNTER)
    self.type = "switch"
    self.label = options.label
    self.description = options.description or ""
    self.isChecked = options.isChecked
    self.color = options.color
    self.onChange = options.onChange
    self.disabled = options.disabled or false
    self.onHover = options.onHover
    self.onLeave = options.onLeave

    table.insert(ITEMS, self)

    return self.id
end

--- Add a list item.
---
---@param options table
---@field options.label string List label.
---@field options.description? string List description.
---@field options.values table List values.
---@field options.index? number Selected value index.
---@field options.color? string List color or "rainbow" for an animated color.
---@field options.onChange? function Function called when the selected value changes.
---@field options.disabled? boolean Whether the list is disabled.
---@field options.onHover? function Function called when the list is hovered.
---@field options.onLeave? function Function called when the cursor leaves the list.
---@return string itemId
--
rlzMenu.List = function(options)
    assert(type(options) == "table", "rlzMenu.List: options must be a table")
    assert(type(options.label) == "string", "rlzMenu.List: label must be a string")
    assert(options.description == nil or type(options.description) == "string", "rlzMenu.List: description must be a string or nil")
    assert(type(options.values) == "table", "rlzMenu.List: values must be a table")
    assert(#options.values > 0, "rlzMenu.List: values must not be empty")
    assert(options.index == nil or type(options.index) == "number", "rlzMenu.List: index must be a number or nil")
    assert(options.color == nil or type(options.color) == "string", "rlzMenu.List: color must be a string or nil")
    assert(options.onChange == nil or type(options.onChange) == "function", "rlzMenu.List: onChange must be a function or nil")
    assert(options.disabled == nil or type(options.disabled) == "boolean", "rlzMenu.List: disabled must be a boolean or nil")
    assert(options.onHover == nil or type(options.onHover) == "function", "rlzMenu.List: onHover must be a function or nil")
    assert(options.onLeave == nil or type(options.onLeave) == "function", "rlzMenu.List: onLeave must be a function or nil")

    local self = {}
    ITEM_COUNTER += 1

    local itemId = getItemId("list", ITEM_COUNTER)

    local currentIndex = options.index or 1

    if currentIndex < 1 then
        currentIndex = 1
    elseif currentIndex > #options.values then
        currentIndex = #options.values
    end

    self.id = itemId
    self.type = "list"
    self.label = options.label
    self.description = options.description or ""
    self.values = options.values
    self.index = currentIndex
    self.value = options.values[currentIndex]
    self.color = options.color
    self.onChange = options.onChange
    self.disabled = options.disabled or false
    self.onHover = options.onHover
    self.onLeave = options.onLeave

    table.insert(ITEMS, self)

    return self.id
end