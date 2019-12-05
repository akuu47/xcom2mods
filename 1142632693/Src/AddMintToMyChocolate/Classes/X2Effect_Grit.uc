//--------------------------------------------------------------------------------------- 
//  FILE:    X2Effect_Grit
//  AUTHOR:  John Lumpkin (Pavonis Interactive)
//  PURPOSE: Sets up armor bonuses for Damage Control effect
//---------------------------------------------------------------------------------------
class X2Effect_Grit extends X2Effect_BonusArmor;

function int GetArmorChance(XComGameState_Effect EffectState, XComGameState_Unit UnitState)
{
	if (UnitState.HasSoldierAbility('MNT_Prevail'))
		return 100;
	
    return 100;
}

function int GetArmorMitigation(XComGameState_Effect EffectState, XComGameState_Unit UnitState)
{
    return 2;
}