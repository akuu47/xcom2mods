class XComTacticalInput_FreeCameraRotation extends XComTacticalInput dependson(X2GameRuleset) config(TacticalInput_FreeCameraRotation);

var const config float CAMERA_ROTATION_FIXED;		// deg per key press
var const config float CAMERA_ROTATION_SPEED;		// deg per second
var const config float CAMERA_ZOOM_SPEED;			// zoom factor per second

var config bool bAnalogMode;						// enable analog mode

var float lastPressed;
var bool bPressed;
var float avDeltaYaw, avDeltaZoom;

exec function YawCameraFixed(float direction)
{
	XComTacticalController(Outer).YawCamera(CAMERA_ROTATION_FIXED * direction);
}

exec function PitchCamera(float Degrees)
{
	`CAMERASTACK.PitchCameras(Degrees);
}

exec function ToggleFreeLook()
{
	m_bMouseFreeLook = !m_bMouseFreeLook;
}

exec function ToggleAnalogMode()
{
	bAnalogMode = !bAnalogMode;
}

exec function ResetCamera()
{
	// using an event to properly reset the camera: total overkill, because every damn thing out there is made private or protected !!!
	`XEVENTMGR.TriggerEvent('OnResetCamera');
	/*
	local TPOV POV;
	local float PitchDiff, YawDiff;

	POV = `CAMERASTACK.GetCameraLocationAndOrientation();
	PitchDiff = -38.0f - POV.Rotation.Pitch/DegToUnrRot; // HumanTurnPitch=-38 deg
	YawDiff = 48.5f - POV.Rotation.Yaw/DegToUnrRot; // HumanTurnYaw=48.5 deg - for whatever reason both are protected
	`CAMERASTACK.PitchCameras(PitchDiff);
	`CAMERASTACK.YawCameras(YawDiff);
	XComPresentationLayer(XComTacticalController(Outer).Pres).ZoomCameraIn();
	*/
}

function bool CheckAndRotateCamera(int ActionMask, float direction)
{
	local float timeDelta;

	if(bAnalogMode)
	{
		if((ActionMask & class'UIUtilities_Input'.const.FXS_ACTION_PRESS) != 0) // on key pressed
		{
			bPressed = true;
			if(avDeltaYaw == 0.0f) avDeltaYaw = CAMERA_ROTATION_SPEED * 0.05;
			lastPressed = WorldInfo.TimeSeconds;
			XComTacticalController(Outer).YawCamera(avDeltaYaw * direction);
			return true;
		}
		if((ActionMask & class'UIUtilities_Input'.const.FXS_ACTION_PREHOLD_REPEAT) != 0 || (ActionMask & class'UIUtilities_Input'.const.FXS_ACTION_POSTHOLD_REPEAT) != 0) // on key hold
		{
			timeDelta = (lastPressed > 0.0f) ? (WorldInfo.TimeSeconds - lastPressed) : 0.0f;
			lastPressed = WorldInfo.TimeSeconds;
			avDeltaYaw = 0.8 * avDeltaYaw + 0.2 * CAMERA_ROTATION_SPEED * timeDelta;
			XComTacticalController(Outer).YawCamera(avDeltaYaw * direction);
			return true;
		}
	}
	if((ActionMask & class'UIUtilities_Input'.const.FXS_ACTION_RELEASE) != 0)	// on key released
	{
		if(!bPressed)
			XComTacticalController(Outer).YawCamera(CAMERA_ROTATION_FIXED * direction);
		bPressed = false;
		return true;
	}
	return false;
}

function bool CheckAndRotateCameraRight(int ActionMask)
{
	return CheckAndRotateCamera(ActionMask, -1);
}

function bool CheckAndRotateCameraLeft(int ActionMask)
{
	return CheckAndRotateCamera(ActionMask, 1);
}

function bool CheckAndZoomCamera(int ActionMask, bool bZoomIn)
{
	local float timeDelta;

	if(bAnalogMode)
	{
		if((ActionMask & class'UIUtilities_Input'.const.FXS_ACTION_PRESS) != 0) // on key pressed
		{
			bPressed = true;
			if(avDeltaZoom == 0.0f) avDeltaZoom = CAMERA_ZOOM_SPEED * 0.05;
			lastPressed = WorldInfo.TimeSeconds;
			XComPresentationLayer(XComTacticalController(Outer).Pres).ZoomCameraScroll(bZoomIn, avDeltaZoom);
			return true;
		}
		if((ActionMask & class'UIUtilities_Input'.const.FXS_ACTION_PREHOLD_REPEAT) != 0 || (ActionMask & class'UIUtilities_Input'.const.FXS_ACTION_POSTHOLD_REPEAT) != 0) // on key hold
		{
			timeDelta = (lastPressed > 0.0f) ? (WorldInfo.TimeSeconds - lastPressed) : 0.0f;
			lastPressed = WorldInfo.TimeSeconds;
			avDeltaZoom = 0.8 * avDeltaZoom + 0.2 * CAMERA_ZOOM_SPEED * timeDelta;
			XComPresentationLayer(XComTacticalController(Outer).Pres).ZoomCameraScroll(bZoomIn, avDeltaZoom);
			return true;
		}
	}
	if ((ActionMask & class'UIUtilities_Input'.const.FXS_ACTION_RELEASE) != 0)	// on key released
	{
		if(!bPressed)
			XComPresentationLayer(XComTacticalController(Outer).Pres).ZoomCameraScroll(bZoomIn);
		bPressed = false;
		return true;
	}
	return false;
}

state InReplayPlayback
{
	function bool Key_E(int ActionMask)
	{
		return CheckAndRotateCameraRight(ActionMask);
	}

	function bool Key_Q(int ActionMask)
	{
		return CheckAndRotateCameraLeft(ActionMask);
	}
}

state UsingTargetingMethod
{
	function bool Key_E(int ActionMask)
	{
		return CheckAndRotateCameraRight(ActionMask);
	}

	function bool Key_Q( int ActionMask )
	{
		return CheckAndRotateCameraLeft(ActionMask);
	}
}

state Multiplayer_Inactive
{
	function bool Key_E(int ActionMask)
	{
		return CheckAndRotateCameraRight(ActionMask);
	}
	function bool Key_Q(int ActionMask)
	{
		return CheckAndRotateCameraLeft(ActionMask);
	}
}

state ActiveUnit_Moving
{
	function bool Key_E(int ActionMask)
	{
		return CheckAndRotateCameraRight(ActionMask);
	}
	function bool Key_Q(int ActionMask)
	{
		return CheckAndRotateCameraLeft(ActionMask);
	}
	function bool Key_T(int ActionMask)
	{
		return CheckAndZoomCamera(ActionMask, false);
	}
	function bool Key_G(int ActionMask)
	{
		return CheckAndZoomCamera(ActionMask, true);
	}
	function bool MMouse(int ActionMask)
	{
		if((ActionMask & class'UIUtilities_Input'.const.FXS_ACTION_PRESS) != 0)
		{
			if(`CHEATMGR.bAllowFancyCameraStuff) // keeping debug functionality in place
			{
				m_bMouseFreeLook = true;
			}
			else
			{
				XComPresentationLayer(XComTacticalController(Outer).Pres).ZoomCameraOut();
			}
		}
		else if((ActionMask & class'UIUtilities_Input'.const.FXS_ACTION_RELEASE) != 0)
		{
			if(`CHEATMGR.bAllowFancyCameraStuff) // keeping debug functionality in place
			{
				m_bMouseFreeLook = false;
			}
			else
			{
				XComPresentationLayer(XComTacticalController(Outer).Pres).ZoomCameraIn();
			}
		}
		return true;
	}
}