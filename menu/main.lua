MENUS = {}
CURRENT_MENU = nil
MENU_COUNTER = 0

--- Creates a new menu.
---
---@param options table
---@field options.title? string Menu title.
---@field options.subtitle? string Menu subtitle.
---@field options.command? string Command used to toggle the menu.
---@field options.key? string Key used to toggle the menu.
---@field options.color? string Menu color.
---@field options.position? "left"|"right" Menu position.
---@return string menuId
--
rlzMenu.Create = function(options)
    assert(type(options) == "table", "rlzMenu.Create: options must be a table")
    assert(options.title == nil or type(options.title) == "string", "rlzMenu.Create: title must be a string or nil")
    assert(options.subtitle == nil or type(options.subtitle) == "string", "rlzMenu.Create: subtitle must be a string or nil")
    assert(options.command == nil or type(options.command) == "string", "rlzMenu.Create: command must be a string or nil")
    assert(options.key == nil or type(options.key) == "string", "rlzMenu.Create: key must be a string or nil")
    assert(options.color == nil or type(options.color) == "string", "rlzMenu.Create: color must be a string or nil")
    assert(options.position == nil or options.position == "left" or options.position == "right", "rlzMenu.Create: position must be 'left', 'right' or nil")

    local self = {}
    MENU_COUNTER += 1

    self.id = generateId("menu", MENU_COUNTER)
    self.title = options.title or ""
    self.subtitle = options.subtitle or ""
    self.visible = false
    self.color = options.color or "default"
    self.position = options.position or "left"
    self.positionForced = options.position ~= nil
    self.command = options.command
    self.key = options.key

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
---@field options.color? string Submenu color. Inherits the parent color if not specified.
---@return string menuId
--
rlzMenu.CreateSubMenu = function(parentId, options)
    assert(type(parentId) == "string", "rlzMenu.CreateSubMenu: parentId must be a string")
    assert(type(options) == "table", "rlzMenu.CreateSubMenu: options must be a table")
    assert(MENUS[parentId] ~= nil, "rlzMenu.CreateSubMenu: parent menu does not exist")
    assert(options.title == nil or type(options.title) == "string", "rlzMenu.CreateSubMenu: title must be a string or nil")
    assert(options.subtitle == nil or type(options.subtitle) == "string", "rlzMenu.CreateSubMenu: subtitle must be a string or nil")
    assert(options.position == nil or options.position == "left" or options.position == "right", "rlzMenu.CreateSubMenu: position must be 'left', 'right' or nil")
    assert(options.color == nil or type(options.color) == "string", "rlzMenu.CreateSubMenu: color must be a string or nil")

    local parent = MENUS[parentId]

    local self = {}
    MENU_COUNTER += 1

    self.id = generateId("submenu", MENU_COUNTER)
    self.title = options.title or ""
    self.subtitle = options.subtitle or ""
    self.visible = false
    self.color = options.color or parent.color or "default"
    self.colorForced = options.color ~= nil
    self.position = options.position or parent.position or "left"
    self.positionForced = options.position ~= nil
    self.parent = parentId

    MENUS[self.id] = self

    return self.id
end

rlzMenu.SetItems = function(menuId, builder)
    assert(type(menuId) == "string", "Menu ID must be a string")
    assert(type(builder) == "function", "Items builder must be a function")

    local menu = MENUS[menuId]

    if not menu then
        error(("Menu with ID '%s' does not exist"):format(menuId))
    end

    menu.items = builder
end

rlzMenu.SetVisible = function(menuId, state)
    assert(type(menuId) == "string", "Menu ID must be a string")
    assert(type(state) == "boolean", "State must be a boolean")

    local menu = MENUS[menuId]
    if not menu then
        error(("Menu with ID '%s' does not exist"):format(menuId))
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
            title = menu.title,
            subtitle = menu.subtitle,
            color = menu.color,
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
end
