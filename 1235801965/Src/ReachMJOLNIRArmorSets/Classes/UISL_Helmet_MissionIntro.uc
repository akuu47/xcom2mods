
class UISL_Helmet_MissionIntro extends UIScreenListener;

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
	ScreenClass = UIMissionIntro;
}