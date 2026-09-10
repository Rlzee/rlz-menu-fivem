SEARCH_BAR = nil

rlzMenu.Refresh = function(menuId)
    assert(type(menuId) == "string", "Menu ID must be a string")

    local menu = MENUS[menuId]

    if not menu then
        error(("Menu with ID '%s' does not exist"):format(menuId))
    end

    if CURRENT_MENU ~= menu.id or not menu.visible then
        return false
    end

    TriggerNuiEvent("rlz_menu:setData", {
        title = menu.title,
        subtitle = menu.subtitle,
        color = menu.color,
        position = menu.position,
        items = PrepareNuiItems(ITEMS),
    })

    return true
end

local ITEM_PROPERTY_TYPES = {
    button = {
        label = "string",
        anchor = "string",
        description = "string",
        onSelect = "function",
        submenu = "string",
        disabled = "boolean",
    },

    label = {
        label = "string",
    },

    separator = {},

    checkbox = {
        label = "string",
        description = "string",
        isChecked = "boolean",
        onChange = "function",
        disabled = "boolean",
    },

    list = {
        label = "string",
        description = "string",
        values = "table",
        index = "number",
        onChange = "function",
        disabled = "boolean",
    },
}

local function findItemById(itemId)
    for _, item in ipairs(ITEMS) do
        if item.id == itemId then
            return item
        end
    end

    return nil
end

rlzMenu.SetItemProperty = function(itemId, property, value)
    assert(
        type(itemId) == "string",
        "rlzMenu.SetItemProperty: itemId must be a string"
    )

    assert(
        type(property) == "string",
        "rlzMenu.SetItemProperty: property must be a string"
    )

    local item = findItemById(itemId)

    if not item then
        error(("Item with ID '%s' does not exist"):format(itemId))
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

rlzMenu.GetCurrentMenu = function()
    return CURRENT_MENU
end

rlzMenu.IsVisible = function(id)
    assert(
        type(id) == "string",
        "rlzMenu.IsVisible: The menu ID must be a string"
    )

    assert(
        MENUS[id],
        "rlzMenu.IsVisible: The menu with ID '" .. id .. "' does not exist"
    )

    return MENUS[id].visible
end

rlzMenu.GetPosition = function(menuId)
    assert(
        type(menuId) == "string",
        "rlzMenu.GetPosition: The menu ID must be a string"
    )

    local menu = MENUS[menuId]

    if not menu then
        error(("Menu with ID '%s' does not exist"):format(menuId))
    end

    return menu.position
end

rlzMenu.SetPosition = function(menuId, position)
    assert(type(menuId) == "string", "menuId must be a string")
    assert(
        position == "left" or position == "right",
        "Menu position must be 'left' or 'right'"
    )

    local menu = MENUS[menuId]

    if not menu then
        error(("Menu with ID '%s' does not exist"):format(menuId))
    end

    menu.position = position

    for _, childMenu in pairs(MENUS) do
        if childMenu.parent == menuId and not childMenu.positionForced then
            rlzMenu.SetPosition(childMenu.id, position)
        end
    end

    rlzMenu.Refresh(menu.id)

    return true
end

rlzMenu.SetColor = function(menuId, color)
    assert(type(menuId) == "string", "menuId must be a string")
    assert(type(color) == "string", "Menu color must be a string")

    local menu = MENUS[menuId]

    if not menu then
        error(("Menu with ID '%s' does not exist"):format(menuId))
    end

    menu.color = color

    for _, childMenu in pairs(MENUS) do
        if childMenu.parent == menuId and not childMenu.colorForced then
            rlzMenu.SetColor(childMenu.id, color)
        end
    end

    rlzMenu.Refresh(menu.id)

    return true
end

rlzMenu.SetTitle = function(menuId, title)
    assert(
        type(menuId) == "string",
        "rlzMenu.SetTitle: The menu ID must be a string"
    )

    assert(
        type(title) == "string",
        "rlzMenu.SetTitle: The title must be a string"
    )

    local menu = MENUS[menuId]

    if not menu then
        error(("Menu with ID '%s' does not exist"):format(menuId))
    end

    menu.title = title

    rlzMenu.Refresh(menu.id)

    return true
end

rlzMenu.SetSubtitle = function(menuId, subtitle)
    assert(
        type(menuId) == "string",
        "rlzMenu.SetSubtitle: The menu ID must be a string"
    )

    assert(
        type(subtitle) == "string",
        "rlzMenu.SetSubtitle: The subtitle must be a string"
    )

    local menu = MENUS[menuId]

    if not menu then
        error(("Menu with ID '%s' does not exist"):format(menuId))
    end

    menu.subtitle = subtitle

    rlzMenu.Refresh(menu.id)

    return true
end

rlzMenu.GetParent = function(menuId)
    assert(
        type(menuId) == "string",
        "rlzMenu.GetParent: The menu ID must be a string"
    )

    local menu = MENUS[menuId]

    if not menu then
        error(("Menu with ID '%s' does not exist"):format(menuId))
    end

    return menu.parent
end

rlzMenu.Exists = function(menuId)
    assert(
        type(menuId) == "string",
        "rlzMenu.Exists: The menu ID must be a string"
    )

    return MENUS[menuId] ~= nil
end

rlzMenu.OpenSearchBar = function(label, onSubmit, onCancel)
    assert(
        type(label) == "string",
        "rlzMenu.OpenSearchBar: label must be a string"
    )

    assert(
        type(onSubmit) == "function",
        "rlzMenu.OpenSearchBar: onSubmit must be a function"
    )

    assert(
        type(onCancel) == "function",
        "rlzMenu.OpenSearchBar: onCancel must be a function"
    )

    SEARCH_BAR = {
        onSubmit = onSubmit,
        onCancel = onCancel,
    }

    SetNuiFocus(true, true)
    SetNuiFocusKeepInput(false)

    TriggerNuiEvent("rlz_menu:openSearch", {
        label = label,
    })
end

rlzMenu.GoTo = function(menuId)
    assert(type(menuId) == "string", "Menu ID must be a string")

    local menu = MENUS[menuId]

    if not menu then
        error(("Menu with ID '%s' does not exist"):format(menuId))
    end

    if CURRENT_MENU and MENUS[CURRENT_MENU] then
        MENUS[CURRENT_MENU].visible = false
    end

    rlzMenu.SetVisible(menuId, true)

    return true
end

rlzMenu.GoBack = function()
    local currentMenu = MENUS[CURRENT_MENU]

    if not currentMenu then
        return
    end

    local parentId = currentMenu.parent

    if not parentId then
        rlzMenu.SetVisible(CURRENT_MENU, false)
        return
    end

    local parentMenu = MENUS[parentId]

    if not parentMenu then
        rlzMenu.SetVisible(CURRENT_MENU, false)
        return
    end

    rlzMenu.SetVisible(CURRENT_MENU, false)
    rlzMenu.SetVisible(parentId, true)
end