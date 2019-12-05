class UISL_TacticalHUD extends UIScreenListener;

// This event is triggered after a screen is initialized
event OnInit(UIScreen Screen)
{
	class'MNT_Utility'.static.GCandValidationChecks();
	FixStrikeMinimums();
}

//Until I figure out why this happens...
static function FixStrikeMinimums(){

	local array<XComGameState_Unit> Soldiers;
	local XComGameState_Unit Unit;

	Soldiers = `XCOMHQ.GetSoldiers();
	foreach Soldiers(Unit)
	{
		if(Unit.GetBaseStat(eStat_HP) < 4){
			`LOG("Found a unit where Beta+Delta Strike resulted in no HP." $ Unit.GetFullName());
			Unit.SetBaseMaxStat(eStat_HP, 4);
			Unit.SetCurrentStat(eStat_HP, 4);
		}
	}
}


defaultProperties
{
	// Leaving this assigned to none will cause every screen to trigger its signals on this class
	ScreenClass = UITacticalHUD
}