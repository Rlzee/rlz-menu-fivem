rlzMenu.Context.Refresh = function()
    if not CONTEXT_CURRENT then
        return false
    end

    TriggerNuiEvent("rlz_menu:context:setData", {
        type = CONTEXT_CURRENT.type,
        title = CONTEXT_CURRENT.title,
        items = PrepareNuiItems(CONTEXT_CURRENT.items),
        x = CONTEXT_CURRENT.x,
        y = CONTEXT_CURRENT.y,
    })

    return true
end

local function GetTargetEntityType(entity)
    if not entity or entity == 0 then
        return nil
    end

    local entityType = GetEntityType(entity)

    if entityType == 1 then
        if IsPedAPlayer(entity) then
            return "player"
        else
            return "ped"
        end
    end

    if entityType == 2 then
        return "vehicle"
    end

    if entityType == 3 then
        return "object"
    end

    return nil
end

rlzMenu.Context.GetTarget = function()
    local cursorScreenPosition = GetCursorScreenPosition()

    local hit, positionImpact, normalDirection, entity =
        ScreenToWorld(
            cursorScreenPosition,
            rlzMenu.Context.MaxDistance
        )

    local entityType = GetTargetEntityType(entity)

    if entityType then
        return {
            type = entityType,
            entity = entity,
            coords = positionImpact,
            normal = normalDirection
        }
    end

    if hit then
        -- if IsWaterAtCoords(positionImpact) then
        --     return {
        --         type = "water",
        --         entity = nil,
        --         coords = positionImpact,
        --         normal = normalDirection
        --     }
        -- end

        return {
            type = "world",
            entity = nil,
            coords = positionImpact,
            normal = normalDirection
        }
    end

    return {
        type = "sky",
        entity = nil,
        coords = positionImpact,
        normal = normalDirection
    }
end

rlzMenu.Context.GetCurrent = function()
    return CONTEXT_CURRENT
end

rlzMenu.Context.IsVisible = function()
    return CONTEXT_CURRENT ~= nil
end

rlzMenu.Context.Exists = function(entityType)
    assert(type(entityType) == "string", "rlzMenu.Context.Exists: entityType must be a string")

    return CONTEXT_ITEMS[entityType] ~= nil
end