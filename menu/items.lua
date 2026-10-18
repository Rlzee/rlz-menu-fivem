ITEMS = {}
ITEM_COUNTER = 0
ITEM_IDS = {}
RADIO_GROUP_COUNTER = 0

local ITEM_PROPERTY_TYPES = {
    button = {
        label = "string",
        anchor = "string",
        description = "string",
        onSelect = "function",
        submenu = "string",
        disabled = "boolean",
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
        onHover = "function",
        onLeave = "function",
    },

    switch = {
        label = "string",
        description = "string",
        isChecked = "boolean",
        onChange = "function",
        disabled = "boolean",
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
        onHover = "function",
        onLeave = "function",
    },

    slider = {
        label = "string",
        description = "string",
        min = "number",
        max = "number",
        value = "number",
        step = "number",
        percent = "number",
        onChange = "function",
        disabled = "boolean",
        onHover = "function",
        onLeave = "function",
    },

    radio = {
        label = "string",
        description = "string",
        index = "number",
        isChecked = "boolean",
        disabled = "boolean",
        onHover = "function",
        onLeave = "function",
    },

    level = {
        label = "string",
        description = "string",
        value = "number",
        max = "number",
        onChange = "function",
        disabled = "boolean",
        onHover = "function",
        onLeave = "function",
    },
}

--- Computes the fill percentage (0-100) of a slider item from its value.
---
---@param item table The slider item.
---@return number percent
--
function ComputeSliderPercent(item)
    local range = item.max - item.min

    if range <= 0 then
        return 0
    end

    local ratio = (item.value - item.min) / range

    if ratio < 0 then
        ratio = 0
    elseif ratio > 1 then
        ratio = 1
    end

    return math.floor(ratio * 100 + 0.5)
end

--- Selects one option of a radio group and unchecks the others.
---
---@param groupId string The ID of the radio group.
---@param index number The option index (1-based) to select.
--
function SelectRadioGroupIndex(groupId, index)
    for _, item in ipairs(ITEMS) do
        if item.type == "radio" and item.group == groupId then
            item.isChecked = item.index == index
        end
    end
end

--- Returns the number of options of a radio group.
---
---@param groupId string The ID of the radio group.
---@return number size
--
function GetRadioGroupSize(groupId)
    local size = 0

    for _, item in ipairs(ITEMS) do
        if item.type == "radio" and item.group == groupId then
            size += 1
        end
    end

    return size
end

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

    elseif item.type == "slider" and (property == "value" or property == "min" or property == "max") then
        item[property] = value

        if item.min > item.max then
            item.min, item.max = item.max, item.min
        end

        if item.value < item.min then
            item.value = item.min
        elseif item.value > item.max then
            item.value = item.max
        end

        item.percent = ComputeSliderPercent(item)

    elseif item.type == "radio" and property == "index" then
        local size = GetRadioGroupSize(item.group)

        if value < 1 or value > size then
            error((
                "Radio index must be between 1 and %s"
            ):format(size))
        end

        item.index = value
        SelectRadioGroupIndex(item.group, value)

    elseif item.type == "level" and (property == "value" or property == "max") then
        item[property] = value

        if item.max < 1 then
            item.max = 1
        end

        if item.value < 0 then
            item.value = 0
        elseif item.value > item.max then
            item.value = item.max
        end

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

--- Add a switch item.
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
rlzMenu.Switch = function(options)
    assert(type(options) == "table", "rlzMenu.Switch: options must be a table")
    assert(type(options.label) == "string", "rlzMenu.Switch: label must be a string")
    assert(options.description == nil or type(options.description) == "string","rlzMenu.Switch: description must be a string or nil")
    assert(type(options.isChecked) == "boolean", "rlzMenu.Switch: isChecked must be a boolean")
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

--- Add a slider item.
---
---@param options table
---@field options.label string Slider label.
---@field options.description? string Slider description.
---@field options.min? number Minimum value. Defaults to 0.
---@field options.max? number Maximum value. Defaults to 100.
---@field options.value? number Initial value. Defaults to min.
---@field options.step? number Increment applied with the arrow keys. Defaults to 1.
---@field options.onChange? function Function called when the value changes, receives (value, percent).
---@field options.disabled? boolean Whether the slider is disabled.
---@field options.onHover? function Function called when the slider is hovered.
---@field options.onLeave? function Function called when the cursor leaves the slider.
---@return string itemId
--
rlzMenu.Slider = function(options)
    assert(type(options) == "table", "rlzMenu.Slider: options must be a table")
    assert(type(options.label) == "string", "rlzMenu.Slider: label must be a string")
    assert(options.description == nil or type(options.description) == "string", "rlzMenu.Slider: description must be a string or nil")
    assert(options.min == nil or type(options.min) == "number", "rlzMenu.Slider: min must be a number or nil")
    assert(options.max == nil or type(options.max) == "number", "rlzMenu.Slider: max must be a number or nil")
    assert(options.value == nil or type(options.value) == "number", "rlzMenu.Slider: value must be a number or nil")
    assert(options.step == nil or type(options.step) == "number", "rlzMenu.Slider: step must be a number or nil")
    assert(options.onChange == nil or type(options.onChange) == "function", "rlzMenu.Slider: onChange must be a function or nil")
    assert(options.disabled == nil or type(options.disabled) == "boolean", "rlzMenu.Slider: disabled must be a boolean or nil")
    assert(options.onHover == nil or type(options.onHover) == "function", "rlzMenu.Slider: onHover must be a function or nil")
    assert(options.onLeave == nil or type(options.onLeave) == "function", "rlzMenu.Slider: onLeave must be a function or nil")

    local self = {}
    ITEM_COUNTER += 1

    local min = options.min or 0
    local max = options.max or 100

    if min > max then
        min, max = max, min
    end

    local step = options.step or 1

    if step <= 0 then
        step = 1
    end

    local value = options.value or min

    if value < min then
        value = min
    elseif value > max then
        value = max
    end

    self.id = getItemId("slider", ITEM_COUNTER)
    self.type = "slider"
    self.label = options.label
    self.description = options.description or ""
    self.min = min
    self.max = max
    self.step = step
    self.value = value
    self.percent = ComputeSliderPercent(self)
    self.onChange = options.onChange
    self.disabled = options.disabled or false
    self.onHover = options.onHover
    self.onLeave = options.onLeave

    table.insert(ITEMS, self)

    return self.id
end

--- Add a radio group: one selectable row per option, sharing a group ID.
--- Navigating with the arrow keys moves between the options and Enter selects
--- the highlighted one, unchecking the other options of the same group.
---
---@param options table
---@field options.label? string Optional header label displayed above the options.
---@field options.description? string Description displayed for every option.
---@field options.options table List of option labels.
---@field options.index? number Initially selected option index (1-based). Defaults to 1.
---@field options.onChange? function Function called when an option is selected, receives (index, value).
---@field options.disabled? boolean Whether every option of the group is disabled.
---@return string groupId
--
rlzMenu.RadioGroup = function(options)
    assert(type(options) == "table", "rlzMenu.RadioGroup: options must be a table")
    assert(options.label == nil or type(options.label) == "string", "rlzMenu.RadioGroup: label must be a string or nil")
    assert(options.description == nil or type(options.description) == "string", "rlzMenu.RadioGroup: description must be a string or nil")
    assert(type(options.options) == "table", "rlzMenu.RadioGroup: options must be a table")
    assert(#options.options > 0, "rlzMenu.RadioGroup: options must not be empty")
    assert(options.index == nil or type(options.index) == "number", "rlzMenu.RadioGroup: index must be a number or nil")
    assert(options.onChange == nil or type(options.onChange) == "function", "rlzMenu.RadioGroup: onChange must be a function or nil")
    assert(options.disabled == nil or type(options.disabled) == "boolean", "rlzMenu.RadioGroup: disabled must be a boolean or nil")

    RADIO_GROUP_COUNTER += 1

    local groupId = generateId("radio-group", RADIO_GROUP_COUNTER)

    if options.label then
        rlzMenu.Label(options.label)
    end

    local selectedIndex = options.index or 1

    if selectedIndex < 1 then
        selectedIndex = 1
    elseif selectedIndex > #options.options then
        selectedIndex = #options.options
    end

    for optionIndex, option in ipairs(options.options) do
        local self = {}
        ITEM_COUNTER += 1

        self.id = getItemId("radio", ITEM_COUNTER)
        self.type = "radio"
        self.group = groupId
        self.index = optionIndex
        self.label = tostring(option)
        self.description = options.description or ""
        self.isChecked = optionIndex == selectedIndex
        self.onChange = options.onChange
        self.disabled = options.disabled or false

        table.insert(ITEMS, self)
    end

    return groupId
end

--- Add a level item: a row of small circles where the filled count is the
--- current level. The level is raised or lowered with the arrow keys.
---
---@param options table
---@field options.label string Level label.
---@field options.description? string Level description.
---@field options.max? number Number of circles. Defaults to 5.
---@field options.value? number Initially filled circles, between 0 and max. Defaults to 0.
---@field options.onChange? function Function called when the level changes, receives (value).
---@field options.disabled? boolean Whether the level is disabled.
---@field options.onHover? function Function called when the level is hovered.
---@field options.onLeave? function Function called when the cursor leaves the level.
---@return string itemId
--
rlzMenu.Level = function(options)
    assert(type(options) == "table", "rlzMenu.Level: options must be a table")
    assert(type(options.label) == "string", "rlzMenu.Level: label must be a string")
    assert(options.description == nil or type(options.description) == "string", "rlzMenu.Level: description must be a string or nil")
    assert(options.max == nil or type(options.max) == "number", "rlzMenu.Level: max must be a number or nil")
    assert(options.value == nil or type(options.value) == "number", "rlzMenu.Level: value must be a number or nil")
    assert(options.onChange == nil or type(options.onChange) == "function", "rlzMenu.Level: onChange must be a function or nil")
    assert(options.disabled == nil or type(options.disabled) == "boolean", "rlzMenu.Level: disabled must be a boolean or nil")
    assert(options.onHover == nil or type(options.onHover) == "function", "rlzMenu.Level: onHover must be a function or nil")
    assert(options.onLeave == nil or type(options.onLeave) == "function", "rlzMenu.Level: onLeave must be a function or nil")

    local self = {}
    ITEM_COUNTER += 1

    local max = options.max or 5

    if max < 1 then
        max = 1
    end

    local value = options.value or 0

    if value < 0 then
        value = 0
    elseif value > max then
        value = max
    end

    self.id = getItemId("level", ITEM_COUNTER)
    self.type = "level"
    self.label = options.label
    self.description = options.description or ""
    self.max = max
    self.value = value
    self.onChange = options.onChange
    self.disabled = options.disabled or false
    self.onHover = options.onHover
    self.onLeave = options.onLeave

    table.insert(ITEMS, self)

    return self.id
end