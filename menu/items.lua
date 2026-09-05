ITEMS = {}

rlzMenu.Button = function(label, anchor, description, onSelect)
    assert(type(label) == "string", "Button label must be a string")
    assert(anchor == nil or type(anchor) == "string", "Button anchor must be a string or nil")
    assert(description == nil or type(description) == "string", "Button description must be a string or nil")
    assert(onSelect == nil or type(onSelect) == "function", "Button onSelect must be a function or nil")

    local self = {}
    self.type = "button"
    self.label = label
    self.anchor = anchor or ""
    self.description = description or ""
    self.onSelect = onSelect

    table.insert(ITEMS, self)
end

rlzMenu.Label = function(label)
    assert(type(label) == "string", "Label label must be a string")

    local self = {}
    self.type = "label"
    self.label = label

    table.insert(ITEMS, self)
end

rlzMenu.Separator = function()
    local self = {}
    self.type = "separator"

    table.insert(ITEMS, self)
end

rlzMenu.Checkbox = function(label, description, isChecked, onChange)
    assert(type(label) == "string", "Checkbox label must be a string")
    assert(description == nil or type(description) == "string", "Checkbox description must be a string or nil")
    assert(type(isChecked) == "boolean", "Checkbox isChecked must be a boolean")
    assert(onChange == nil or type(onChange) == "function", "Checkbox onChange must be a function or nil")

    local self = {}
    self.type = "checkbox"
    self.label = label
    self.description = description or ""
    self.isChecked = isChecked
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

