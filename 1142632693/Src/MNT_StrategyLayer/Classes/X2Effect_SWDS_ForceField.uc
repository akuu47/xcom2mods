//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class X2Effect_SWDS_ForceField extends X2Effect_Persistent config(GameData_SoldierSkills);

var config int ACC_CUT;

function GetToHitAsTargetModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
	local ShotModifierInfo AccInfo;

	// DISABLE IF NO DELTA STRIKE
	if(!`SecondWaveEnabled('DeltaStrike'))
		return;

	// only give a bonus if shielded
	if(Target.GetCurrentStat(eStat_ShieldHP) <= 0)
		return;

	`LOG("SWDS: Forcefield - Accuracy cut: -" $ default.ACC_CUT);

	// Cuts accuracy chance while shields exists
	AccInfo.ModType = eHit_Success;
	AccInfo.Value = -default.ACC_CUT;
	AccInfo.Reason = FriendlyName;
	ShotModifiers.AddItem(AccInfo);
}


defaultproperties
{
	EffectName="SWDS_ForceField"
	bDisplayInSpecialDamageMessageUI = true
}
