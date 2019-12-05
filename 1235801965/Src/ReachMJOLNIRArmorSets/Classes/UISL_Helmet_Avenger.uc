// This is an Unreal Script
// Yerp. Applies textures on load. Sort of. Does it when you hit the armory. Close enough.

class UISL_Helmet_Avenger extends UIScreenListener;

Event OnInit(UIScreen S) {
	ApplyVisorTints(S);
}

Event OnReceiveFocus(UIScreen S) {
	ApplyVisorTints(S);
}

function ApplyVisorTints(UIScreen S) {
	local UnitValue UnitValSave;
	local XComGameState_Unit UnitState;
	local XComHumanPawn HumanPawn;
	local bool HasUnitValue;

	// Check if we need to apply the tint here.
	// UIMenu = UIArmory_MainMenu(`SCREENSTACK.GetScreen(class'UIArmory_MainMenu'));
	HumanPawn = XComHumanPawn(UIArmory_MainMenu(S).ActorPawn);
	UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(HumanPawn.ObjectID));
	HasUnitValue = UnitState.GetUnitValue('Halo_VisorColour', UnitValSave);
	if(HasUnitValue) {
		class'Helmet_Tinter'.static.ApplyTint(HumanPawn, int(UnitValSave.fValue));
	}
}


defaultproperties
{
	ScreenClass = UIArmory_MainMenu;
}