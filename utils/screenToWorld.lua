function ScreenToWorld(screenPosition, maxDistance)
    local cameraCoords = GetGameplayCamCoord()
    local cameraRotation = GetGameplayCamRot(0)
    local cameraFov = GetGameplayCamFov()

    local camera = CreateCamWithParams(
        "DEFAULT_SCRIPTED_CAMERA",
        cameraCoords.x,
        cameraCoords.y,
        cameraCoords.z,
        cameraRotation.x,
        cameraRotation.y,
        cameraRotation.z,
        cameraFov,
        0,
        2
    )

    local cameraRight, cameraForward, cameraUp, cameraPos = GetCamMatrix(camera)

    DestroyCam(camera, true)

    screenPosition = vector2(
        screenPosition.x - 0.5,
        screenPosition.y - 0.5
    ) * 2.0

    local fovRadians = math.rad(cameraFov)

    local target = cameraPos
        + cameraForward
        + cameraRight * screenPosition.x * fovRadians * GetAspectRatio(false) * 0.534375
        - cameraUp * screenPosition.y * fovRadians * 0.534375

    local direction = (target - cameraPos) * maxDistance
    local endPoint = cameraPos + direction

    local rayHandle = StartShapeTestRay(
        cameraPos.x,
        cameraPos.y,
        cameraPos.z,
        endPoint.x,
        endPoint.y,
        endPoint.z,
        -1,
        PlayerPedId(),
        0
    )

    local _, hit, worldPosition, normalDirection, entity =
        GetShapeTestResult(rayHandle)

    if hit == 1 then
        return true, worldPosition, normalDirection, entity
    end

    return false, vector3(0, 0, 0), vector3(0, 0, 0), nil
end