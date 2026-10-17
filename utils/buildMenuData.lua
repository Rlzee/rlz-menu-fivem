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
        position = menu.position,
        controls = menu.controls,
        x = savedPosition and savedPosition.x or nil,
        y = savedPosition and savedPosition.y or nil,
        items = PrepareNuiItems(ITEMS),
    }
end
