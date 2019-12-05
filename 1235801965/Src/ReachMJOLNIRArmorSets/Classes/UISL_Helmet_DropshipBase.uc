// This is an Unreal Script
// Yerp. Applies tint on tactical load.
// Still need to be applied on (at least)
// Main Menu (UILoadGame, I think)
// Skyranger Mission Flyin
// Skyranger Mission Flyout (UIDropShipBriefing_MissionEnd maybe, although it seems to keep it from tactical, actually. Just checked)
// Returning from battle (where they walk up to the screen - oh! And this keeps it too. Sweet. Just mission flyin and main menu to fix then)
// To do this, just find out the screen class that's being used, copy this entire script, change the class name, and change the ScreenClass at the bottom to match the class
// so for the main menu, just copy this, rename the class to Helmet_LoadGame_Earworm or whatever, and change ScreenClass to UILoadGame at the bottom.
// To find out what the other screens are called, 


class UISL_Helmet_DropshipBase extends UIScreenListener;

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

	ForEach S.AllActors(class'XComHumanPawn', HumanPawn) {
		// Check if we need to apply the tint here.
		UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(HumanPawn.ObjectID));
		UnitState.GetUnitValue('Halo_VisorColour', UnitValSave);
		HasUnitValue = UnitState.GetUnitValue('Halo_VisorColour', UnitValSave);
		if(HasUnitValue) {
			class'Helmet_Tinter'.static.ApplyTint(HumanPawn, int(UnitValSave.fValue));
		}
	}
}


defaultproperties
{
	// Change this to be the screen you want to catch.
	ScreenClass = UIDropShipBriefingBase;
}