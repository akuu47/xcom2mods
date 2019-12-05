class X2Camera_FollowMouseCursor_FreeCameraRotation extends X2Camera_FollowMouseCursor config(TacticalInput_FreeCameraRotation);

var const config float MIN_ZOOM_MULT;	// min allowed zoom multiplier is used to limit zoom in factor as ZoomedDistanceFromCursor affects both zoom in and zoom out

function ZoomCamera(float Amount) // override look at cam function to be able to limit zoom in factor
{
	TargetZoom = FClamp(TargetZoom + Amount, MIN_ZOOM_MULT, 1.0);
}

public function ResetToDefault() // reset target values to default human turn values
{
	TargetZoom = 0.0f;
	TargetRotation.Yaw = HumanTurnYaw * DegToUnrRot;
	TargetRotation.Pitch = HumanTurnPitch * DegToUnrRot;
	TargetRotation.Roll = HumanTurnRoll * DegToUnrRot;
}

function Activated(TPOV CurrentPOV, X2Camera PreviousActiveCamera, X2Camera_LookAt LastActiveLookAtCamera) // override base class function to subsribe to reset cam event
{
	local Object ThisObj;

	super.Activated(CurrentPOV, PreviousActiveCamera, LastActiveLookAtCamera);
	ThisObj = self;
	`XEVENTMGR.RegisterForEvent(ThisObj, 'OnResetCamera', OnResetCamera);
}

function Deactivated() // override base class function to unsubsribe from reset cam event
{
	local Object ThisObj;

	super.Deactivated();
	ThisObj = self;
	`XEVENTMGR.UnRegisterFromEvent(ThisObj, 'OnResetCamera');
}

function EventListenerReturn OnResetCamera(Object EventData, Object EventSource, XComGameState GameState, Name EventID) // process reset cam event
{
	ResetToDefault();
	return ELR_NoInterrupt;
}
