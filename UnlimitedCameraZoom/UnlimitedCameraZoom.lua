--[[

Unlimited Camera Zoom
by CaptainBlagbird
https://github.com/CaptainBlagbird

--]]

-- Constants
local ZOOM_MAX  = 10
local ZOOM_MIN  = 2
local ZOOM_POV  = 0
local ZOOM_STEP = 0.5

-- Local variables
local lastZoom = tonumber(GetSetting(SETTING_TYPE_CAMERA, CAMERA_SETTING_DISTANCE))


local function IsZoomLimited()
	return (IsMounted() or IsWerewolf())
end

-- Overwrite original function
local origToggleGameCameraFirstPerson = ToggleGameCameraFirstPerson
ToggleGameCameraFirstPerson = function(...)
	local zoom = tonumber(GetSetting(SETTING_TYPE_CAMERA, CAMERA_SETTING_DISTANCE))
	if IsZoomLimited() or zoom <= ZOOM_POV then
		if zoom <= ZOOM_POV then
			SetSetting(SETTING_TYPE_CAMERA, CAMERA_SETTING_DISTANCE, lastZoom)
		else
			lastZoom = zoom
			SetSetting(SETTING_TYPE_CAMERA, CAMERA_SETTING_DISTANCE, ZOOM_POV)
		end
	else  -- Zoom is not limited
		origToggleGameCameraFirstPerson(...)
	end
end

-- Overwrite original function
local origCameraZoomIn = CameraZoomIn
CameraZoomIn = function(...)
	if IsGameCameraSiegeControlled() then
		origCameraZoomIn(...)
	else
		local zoom = tonumber(GetSetting(SETTING_TYPE_CAMERA, CAMERA_SETTING_DISTANCE))
		local newZoom = zoom - ZOOM_STEP
		if newZoom < ZOOM_POV then newZoom = ZOOM_POV end
		if newZoom < zoom then
			SetSetting(SETTING_TYPE_CAMERA, CAMERA_SETTING_DISTANCE, newZoom)
			-- Remember zoom for FPV toggle
			lastZoom = zoom
		end
	end
end

-- Overwrite original function
local origCameraZoomOut = CameraZoomOut
CameraZoomOut = function(...)
	if IsGameCameraSiegeControlled() then
		origCameraZoomOut(...)
	else
		local zoom = tonumber(GetSetting(SETTING_TYPE_CAMERA, CAMERA_SETTING_DISTANCE))
		local newZoom = zoom + ZOOM_STEP
		if newZoom > ZOOM_MAX then newZoom = ZOOM_MAX end
		if newZoom > zoom then
			SetSetting(SETTING_TYPE_CAMERA, CAMERA_SETTING_DISTANCE, newZoom)
		end
	end
end