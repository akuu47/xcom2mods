///---------------------------------------------------------------------------------------
//  FILE:    X2Effect_SmartMacrophages
//  AUTHOR:  Amineri (Long War Studios), modified by Realitymachina
//  PURPOSE: Implements effect for SmartMacrophages ability -- this allows healing of lowest hp at end of mission
//			similar to SmartMacrophages, but applies only to self, and always works (unless dead), and is independent of Field Surgeon
//--------------------------------------------------------------------------------------- 
//---------------------------------------------------------------------------------------
class X2Effect_Nanomachines extends X2Effect_Persistent;

function UnitEndedTacticalPlay(XComGameState_Effect EffectState, XComGameState_Unit UnitState)
{
	local XComGameStateHistory		History;
	local XComGameState_Unit		SourceUnitState; 

	History = `XCOMHISTORY;
	SourceUnitState = XComGameState_Unit(History.GetGameStateForObjectID(EffectState.ApplyEffectParameters.SourceStateObjectRef.ObjectID));


	if(!SmartMacrophagesEffectIsValidForSource(SourceUnitState)) { return; }

	if(UnitState == none) { return; }
	if(UnitState.IsDead()) { return; }
	if(UnitState.IsBleedingOut()) { return; }
	if(!CanBeHealed(UnitState)) { return; }


	UnitState.LowestHP += class'RM_SPARKTechs_Helpers'.default.NanoRepair;

	UnitState.ModifyCurrentStat(eStat_HP, class'RM_SPARKTechs_Helpers'.default.NanoRepair);

	super.UnitEndedTacticalPlay(EffectState, UnitState);
}

function bool CanBeHealed(XComGameState_Unit UnitState)
{
	 return (UnitState.LowestHP < UnitState.GetMaxStat(eStat_HP) && UnitState.LowestHP > 0);
}

function bool SmartMacrophagesEffectIsValidForSource(XComGameState_Unit SourceUnit)
{
	if(SourceUnit == none) { return false; }
	if(SourceUnit.IsDead()) { return false; }
	if(SourceUnit.bCaptured) { return false; }
	if(SourceUnit.LowestHP == 0) { return false; }
	return true;
}

DefaultProperties
{
	EffectName="Nanomachines"
	DuplicateResponse=eDupe_Ignore
}