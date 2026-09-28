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