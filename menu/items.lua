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
end

rlzMenu.Label = function(label)
    assert(type(label) == "string", "Label label must be a string")

    local self = {}
    ITEM_COUNTER += 1

    self.id = getItemId("label", ITEM_COUNTER)
    self.type = "label"
    self.label = label

    table.insert(ITEMS, self)
end

rlzMenu.Separator = function()
    local self = {}
    ITEM_COUNTER += 1

    self.id = getItemId("separator", ITEM_COUNTER)
    self.type = "separator"

    table.insert(ITEMS, self)
end

CHECKBOX_STATES = {}
rlzMenu.Checkbox = function(label, description, isChecked, onChange)
    assert(type(label) == "string", "Checkbox label must be a string")
    assert(description == nil or type(description) == "string", "Checkbox description must be a string or nil")
    assert(type(isChecked) == "boolean", "Checkbox isChecked must be a boolean")
    assert(onChange == nil or type(onChange) == "function", "Checkbox onChange must be a function or nil")

    local self = {}
    ITEM_COUNTER += 1

    local itemId = getItemId("checkbox", ITEM_COUNTER)

    self.id = itemId

    if CHECKBOX_STATES[itemId] ~= nil then
        self.isChecked = CHECKBOX_STATES[itemId]
    else
        self.isChecked = isChecked
    end

    self.type = "checkbox"
    self.label = label
    self.description = description or ""
    self.onChange = onChange

    table.insert(ITEMS, self)
end

-- rlzMenu.List = function(label, description, options, selectedIndex, onChange)
--     assert(type(label) == "string", "List label must be a string")
--     assert(description == nil or type(description) == "string", "List description must be a string or nil")
--     assert(type(options) == "table", "List options must be a table")
--     assert(type(selectedIndex) == "number", "List selectedIndex must be a number")
--     assert(onChange == nil or type(onChange) == "function", "List onChange must be a function or nil")

--     local self = {}
--     self.type = "list"
--     self.label = label
--     self.description = description or ""
--     self.options = options
--     self.selectedIndex = selectedIndex
--     self.onChange = onChange

--     table.insert(ITEMS, self)
-- end

