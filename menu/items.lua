ITEMS = {}
ITEM_COUNTER = 0
ITEM_IDS = {}

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

--- Add a button item.
---
---@param options table
---@field options.label string Button label.
---@field options.anchor? string Button anchor.
---@field options.description? string Button description.
---@field options.onSelect? function Function called when the button is selected.
---@field options.submenu? string Submenu ID opened when the button is selected.
---@field options.disabled? boolean Whether the button is disabled.
---@field options.onHover? function Function called when the button is hovered.
---@field options.onLeave? function Function called when the cursor leaves the button.
---@return string itemId
--
rlzMenu.Button = function(options)
    assert(type(options) == "table", "rlzMenu.Button: options must be a table")
    assert(type(options.label) == "string", "rlzMenu.Button: label must be a string")
    assert(options.anchor == nil or type(options.anchor) == "string", "rlzMenu.Button: anchor must be a string or nil")
    assert(options.description == nil or type(options.description) == "string", "rlzMenu.Button: description must be a string or nil")
    assert(options.onSelect == nil or type(options.onSelect) == "function", "rlzMenu.Button: onSelect must be a function or nil")
    assert(options.submenu == nil or type(options.submenu) == "string", "rlzMenu.Button: submenu must be a string or nil")
    assert(options.disabled == nil or type(options.disabled) == "boolean", "rlzMenu.Button: disabled must be a boolean or nil")
    assert(options.onHover == nil or type(options.onHover) == "function", "rlzMenu.Button: onHover must be a function or nil")
    assert(options.onLeave == nil or type(options.onLeave) == "function", "rlzMenu.Button: onLeave must be a function or nil")

    local self = {}
    ITEM_COUNTER += 1

    self.id = getItemId("button", ITEM_COUNTER)
    self.type = "button"
    self.label = options.label
    self.anchor = options.anchor or ""
    self.description = options.description or ""
    self.onSelect = options.onSelect
    self.submenu = options.submenu
    self.disabled = options.disabled or false
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
---@return string itemId
--
rlzMenu.Separator = function()
    local self = {}
    ITEM_COUNTER += 1

    self.id = getItemId("separator", ITEM_COUNTER)
    self.type = "separator"

    table.insert(ITEMS, self)

    return self.id
end

--- Add a checkbox item.
---
---@param options table
---@field options.label string Checkbox label.
---@field options.description? string Checkbox description.
---@field options.isChecked boolean Whether the checkbox is checked.
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
    self.onChange = options.onChange
    self.disabled = options.disabled or false
    self.onHover = options.onHover
    self.onLeave = options.onLeave

    table.insert(ITEMS, self)

    return self.id
end