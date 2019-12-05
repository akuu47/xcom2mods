//---------------------------------------------------------------------------------------
//  FILE:    X2Condition_Soldier.uc
//  AUTHOR:  Amineri / Pavonis Interactive
//  PURPOSE: Conditions to include/exclude soldier type characters
//---------------------------------------------------------------------------------------
class X2Condition_SoldierCheck extends X2Condition;

var bool Exclude; // if true, this condition excludes all soldiers, if false, it includes only soldiers
var bool AlsoCivs; //also exclude civilians if this is true

event name CallMeetsCondition(XComGameState_BaseObject kTarget) 
{ 
	local XComGameState_Unit UnitState;
	local bool IsASoldier;

	UnitState = XComGameState_Unit(kTarget);
	if (UnitState == none)
	{
		if (Exclude)
		{
			return 'AA_Success';
		}
		else
		{
			return 'AA_NotAUnit';
		}
	}
	IsASoldier = UnitState.GetMyTemplate().bIsSoldier;
	if (Exclude)
	{
		if (IsASoldier || (AlsoCivs && UnitState.GetMyTemplate().bIsCivilian))
		{
			return 'AA_UnitIsFriendly';
		}
	}
	else
	{
		if (!IsASoldier)
		{
			return 'AA_UnitIsHostile';
		}
	}

	return 'AA_Success';
}