local POSITION_KEY = "rlz_menu:position:%s"

local function clamp(value, minValue, maxValue)
    if value < minValue then
        return minValue
    end

    if value > maxValue then
        return maxValue
    end

    return value
end

--- Returns the saved screen position of a menu, as ratios between 0 and 1.
---
---@param menuId string The ID of the menu.
---@return table|nil position The saved position { x = number, y = number }, or nil.
--
function GetSavedMenuPosition(menuId)
    local raw = GetResourceKvpString(POSITION_KEY:format(menuId))

    if not raw then
        return nil
    end

    local ok, position = pcall(json.decode, raw)

    if not ok or type(position) ~= "table" then
        return nil
    end

    local x = tonumber(position.x)
    local y = tonumber(position.y)

    if not x or not y then
        return nil
    end

    return {
        x = clamp(x, 0.0, 1.0),
        y = clamp(y, 0.0, 1.0),
    }
end

--- Saves the screen position of a menu, as ratios between 0 and 1.
---
---@param menuId string The ID of the menu.
---@param x number Horizontal ratio between 0 and 1.
---@param y number Vertical ratio between 0 and 1.
--
function SaveMenuPosition(menuId, x, y)
    SetResourceKvp(POSITION_KEY:format(menuId), json.encode({
        x = clamp(tonumber(x) or 0.0, 0.0, 1.0),
        y = clamp(tonumber(y) or 0.0, 0.0, 1.0),
    }))
end

--- Deletes the saved screen position of a menu.
---
---@param menuId string The ID of the menu.
--
function DeleteMenuPosition(menuId)
    DeleteResourceKvp(POSITION_KEY:format(menuId))
end

--- Builds the NUI data payload describing a menu.
---
---@param menu table The menu object.
---@return table data The NUI payload.
--
function BuildMenuData(menu)
    local savedPosition = GetSavedMenuPosition(menu.id)

    return {
        menuId = menu.id,
        selectedItemId = menu.selectedItemId,
        title = menu.title,
        subtitle = menu.subtitle,
        color = menu.color,
        hoverColor = menu.hoverColor,
        position = menu.position,
        x = savedPosition and savedPosition.x or nil,
        y = savedPosition and savedPosition.y or nil,
        items = PrepareNuiItems(ITEMS),
    }
end
