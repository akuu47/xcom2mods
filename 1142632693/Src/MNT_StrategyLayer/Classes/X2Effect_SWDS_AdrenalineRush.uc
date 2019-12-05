//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class X2Effect_SWDS_AdrenalineRush extends X2Effect_Persistent config(GameData_SoldierSkills);

var config int BONUS_DEFENSE;
var config float HP_TRIGGER;

function GetToHitAsTargetModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
	local ShotModifierInfo AccInfo;

	// DISABLE IF NO DELTA STRIKE
	if(!`SecondWaveEnabled('DeltaStrike'))
		return;

	// CANCELED BY POISON
	if (Target.IsPoisoned())
		return;

	// only give a bonus if low health
	if(Target.GetCurrentStat(eStat_HP) > (Target.GetCurrentStat(eStat_HP) * default.HP_TRIGGER))
		return;

	`LOG("SWDS: Adrenaline Rush: Accuracy cut: -" $ default.BONUS_DEFENSE);

	// Cuts accuracy chance while low health
	AccInfo.ModType = eHit_Success;
	AccInfo.Value = -default.BONUS_DEFENSE;
	AccInfo.Reason = FriendlyName;
	ShotModifiers.AddItem(AccInfo);
}

defaultproperties
{
	EffectName="SWDS_AdrenalineRush"
	bDisplayInSpecialDamageMessageUI = true
}
