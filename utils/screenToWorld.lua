function ScreenToWorld(screenPosition, maxDistance)
	local cameraPosition = GetGameplayCamCoord()
	local cameraRotation = GetGameplayCamRot(0)
	local fieldOfView = GetGameplayCamFov()
	local camera = CreateCamWithParams(
		"DEFAULT_SCRIPTED_CAMERA",
		cameraPosition.x,
		cameraPosition.y,
		cameraPosition.z,
		cameraRotation.x,
		cameraRotation.y,
		cameraRotation.z,
		fieldOfView,
		false,
		2
	)

	local cameraRight, cameraForward, cameraUp, rayOrigin = GetCamMatrix(camera)
	DestroyCam(camera, true)

	local normalizedScreenPosition = vector2(
		screenPosition.x - 0.5,
		screenPosition.y - 0.5
	) * 2.0
	local fieldOfViewRadians = degreesToRadians(fieldOfView)
	local rayDirection = cameraForward
		+ (cameraRight * normalizedScreenPosition.x * fieldOfViewRadians * GetAspectRatio(false) * 0.534375)
		- (cameraUp * normalizedScreenPosition.y * fieldOfViewRadians * 0.534375)
	local rayEnd = rayOrigin + (rayDirection * maxDistance)
	local raycast = StartShapeTestRay(
		rayOrigin.x,
		rayOrigin.y,
		rayOrigin.z,
		rayEnd.x,
		rayEnd.y,
		rayEnd.z,
		-1,
		nil,
		0
	)

	local _, hit, hitPosition, surfaceNormal, entity = GetShapeTestResult(raycast)
	if (hit == 1) then
		return true, hitPosition, surfaceNormal, entity
	end

	return false, vector3(0, 0, 0), vector3(0, 0, 0), nil
end