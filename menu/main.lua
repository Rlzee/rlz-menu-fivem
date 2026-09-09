MENUS = {}
CURRENT_MENU = nil
MENU_COUNTER = 0
SEARCH_BAR = nil

rlzMenu.Create = function(title, subtitle, command, key, color, position)
    assert(title == nil or type(title) == "string", "Menu title must be a string or nil")
    assert(subtitle == nil or type(subtitle) == "string", "Menu subtitle must be a string or nil")
    assert(command == nil or type(command) == "string", "Menu command must be a string or nil")
    assert(key == nil or type(key) == "string", "Menu key must be a string or nil")
    assert(color == nil or type(color) == "string", "Menu color must be a string or nil")
    assert(position == nil or position == "left" or position == "right", "Menu position must be 'left', 'right' or nil")

    local self = {}
    MENU_COUNTER += 1

    self.id = generateId("menu", MENU_COUNTER)
    self.title = title or ""
    self.subtitle = subtitle or ""
    self.visible = false
    self.color = color or "default"
    self.position = position or "left"
    self.positionForced = position ~= nil

    MENUS[self.id] = self

    self.command = command
    self.key = key

    RegisterMenuKey(self.id, command, key, "Toggle menu: " .. self.title)

    return self.id
end

rlzMenu.CreateSubMenu = function(parentId, title, subtitle, position, color)
    assert(MENUS[parentId] ~= nil, "Submenu parent ID doesn't exists")
    assert(title == nil or type(title) == "string", "Menu title must be a string or nil")
    assert(subtitle == nil or type(subtitle) == "string", "Menu subtitle must be a string or nil")
    assert(position == nil or position == "left" or position == "right", "Menu position must be 'left', 'right' or nil")
    assert(color == nil or type(color) == "string", "Menu color must be a string or nil")

    local parent = MENUS[parentId]

    local self = {}
    MENU_COUNTER += 1

    self.id = generateId("submenu", MENU_COUNTER)
    self.title = title or ""
    self.subtitle = subtitle or ""
    self.visible = false
    self.color = color or parent.color or "default"
    self.colorForced = color ~= nil
    self.position = position or parent.position or "left"
    self.positionForced = position ~= nil
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
