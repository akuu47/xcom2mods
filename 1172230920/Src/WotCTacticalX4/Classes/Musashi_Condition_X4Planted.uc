class Musashi_Condition_X4Planted extends X2Condition;

var name UnitValueName;

function SetUnitValueName(name UnitValueNameToSet)
{
	UnitValueName = UnitValueNameToSet;
}

event name CallMeetsConditionWithSource(XComGameState_BaseObject kTarget, XComGameState_BaseObject kSource) 
{
	local XComGameState_Unit UnitState;
	local UnitValue          Planted, ExplosivesPlantedThisRound;

	UnitState = XComGameState_Unit(kTarget);
	if (UnitState != none && UnitValueName != '')
	{
		UnitState.GetUnitValue(UnitValueName, Planted);
		UnitState.GetUnitValue('ExplosivesPlantedThisRound', ExplosivesPlantedThisRound);
		if(Planted.fValue == float(1) && ExplosivesPlantedThisRound.fValue == 0)
		{
			return 'AA_Success';
		}
	}

	return 'AA_NoTargets';
}