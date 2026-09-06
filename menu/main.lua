MENUS = {}
CURRENT_MENU = nil
MENU_COUNTER = 0

rlzMenu.CreateMenu = function(title, subtitle)
    assert(title == nil or type(title) == "string", "Menu title must be a string or nil")
    assert(subtitle == nil or type(subtitle) == "string", "Menu subtitle must be a string or nil")

    local self = {}
    MENU_COUNTER += 1

    self.id = generateId("menu", MENU_COUNTER)
    self.title = title or ""
    self.subtitle = subtitle or ""
    self.visible = false

    MENUS[self.id] = self

    return self.id
end

rlzMenu.CreateSubMenu = function(parentId, title, subtitle)
    assert(MENUS[parentId] ~= nil, "Submenu parent ID doesn't exists")
    assert(title == nil or type(title) == "string", "Menu title must be a string or nil")
    assert(subtitle == nil or type(subtitle) == "string", "Menu subtitle must be a string or nil")

    local self = {}
    MENU_COUNTER += 1

    self.id = generateId("submenu", MENU_COUNTER)
    self.parent = parentId
    self.title = title or ""
    self.subtitle = subtitle or ""
    self.visible = false

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

rlzMenu.SetMenuVisible = function(menuId, state)
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
            items = PrepareNuiItems(ITEMS),
        })
    else
        CURRENT_MENU = nil
    end

    SetNuiFocus(state, false)
    SetNuiFocusKeepInput(state)

    TriggerNuiEvent("rlz_menu:setVisible", {
        state = state
    })
end
