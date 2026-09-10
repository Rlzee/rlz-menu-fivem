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

rlzMenu.Button = function(label, anchor, description, onSelect, submenu, disabled)
    assert(type(label) == "string", "Button label must be a string")
    assert(anchor == nil or type(anchor) == "string", "Button anchor must be a string or nil")
    assert(description == nil or type(description) == "string", "Button description must be a string or nil")
    assert(onSelect == nil or type(onSelect) == "function", "Button onSelect must be a function or nil")
    assert(submenu == nil or type(submenu) == "string", "Button submenu must be a string or nil")
    assert(disabled == nil or type(disabled) == "boolean", "Button disabled must be a boolean or nil")

    local self = {}

    ITEM_COUNTER += 1

    self.id = getItemId("button", ITEM_COUNTER)
    self.type = "button"
    self.label = label
    self.anchor = anchor or ""
    self.description = description or ""
    self.onSelect = onSelect
    self.submenu = submenu
    self.disabled = disabled or false

    table.insert(ITEMS, self)

    return self.id
end

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

rlzMenu.Separator = function()
    local self = {}

    ITEM_COUNTER += 1

    self.id = getItemId("separator", ITEM_COUNTER)
    self.type = "separator"

    table.insert(ITEMS, self)

    return self.id
end

rlzMenu.Checkbox = function(label, description, isChecked, onChange, disabled)
    assert(type(label) == "string", "Checkbox label must be a string")
    assert(description == nil or type(description) == "string", "Checkbox description must be a string or nil")
    assert(type(isChecked) == "boolean", "Checkbox isChecked must be a boolean")
    assert(onChange == nil or type(onChange) == "function", "Checkbox onChange must be a function or nil")
    assert(disabled == nil or type(disabled) == "boolean", "Checkbox disabled must be a boolean or nil")

    local self = {}

    ITEM_COUNTER += 1

    self.id = getItemId("checkbox", ITEM_COUNTER)
    self.type = "checkbox"
    self.label = label
    self.description = description or ""
    self.isChecked = isChecked
    self.onChange = onChange
    self.disabled = disabled or false

    table.insert(ITEMS, self)

    return self.id
end

rlzMenu.List = function(label, description, values, selectedIndex, onChange, disabled)
    assert(type(label) == "string", "List label must be a string")
    assert(description == nil or type(description) == "string", "List description must be a string or nil")
    assert(type(values) == "table", "List values must be a table")
    assert(#values > 0, "List values must not be empty")
    assert(selectedIndex == nil or type(selectedIndex) == "number", "List selectedIndex must be a number or nil")
    assert(onChange == nil or type(onChange) == "function", "List onChange must be a function or nil")
    assert(disabled == nil or type(disabled) == "boolean", "List disabled must be a boolean or nil")

    local self = {}

    ITEM_COUNTER += 1

    local itemId = getItemId("list", ITEM_COUNTER)

    local currentIndex = selectedIndex or 1

    if currentIndex < 1 then
        currentIndex = 1
    elseif currentIndex > #values then
        currentIndex = #values
    end

    self.id = itemId
    self.type = "list"
    self.label = label
    self.description = description or ""
    self.values = values
    self.index = currentIndex
    self.value = values[currentIndex]
    self.onChange = onChange
    self.disabled = disabled or false

    table.insert(ITEMS, self)

    return self.id
end