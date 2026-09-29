CONTEXT_ITEMS = {}
CONTEXT_ITEM_COUNTER = 0
CONTEXT_ITEM_IDS = {}

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
--- @return table The button item
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

    table.insert(CONTEXT_CURRENT.items, self)

    return self.id
end