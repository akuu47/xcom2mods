class Musashi_Effect_SuspicionToHitModifier extends X2Effect_Persistent;

var array<X2Condition>              ToHitConditions;
//
//function GetToHitModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
//{
//	local UnitValue					UnitSuspicionLevel;
//	local int						Suspicionlevel, j;
//	local ShotModifierInfo			ModInfo;
//	local name AvailableCode;
//
//	if (!Attacker.HasSoldierAbility('Shadowstrike_LW', true))
//	{
//		return;
//	}
//
//	AvailableCode = 'AA_Success';
//	for (j = 0; j < ToHitConditions.Length; ++j)
//	{
//		AvailableCode = ToHitConditions[j].MeetsCondition(Target);
//		if (AvailableCode != 'AA_Success')
//			return;
//		AvailableCode = ToHitConditions[j].MeetsConditionWithSource(Target, Attacker);
//		if (AvailableCode != 'AA_Success')
//			return;
//	}
//	
//	if (class'Musashi_Gamestate_Takedown'.default.bUseGlobalSuspicion) {
//		Suspicionlevel = class'Musashi_Gamestate_Takedown'.static.GetGlobalSuspicionLevel();
//	}
//	else
//	{
//		Attacker.GetUnitValue('SuspicionLevel', UnitSuspicionLevel);
//		SuspicionLevel = int(UnitSuspicionLevel.fValue);
//	}
//
//	if (Suspicionlevel > 50) {
//		Suspicionlevel = 50;
//	}
//
//	ModInfo.ModType = eHit_Success;
//	ModInfo.Reason = FriendlyName;
//	ModInfo.Value = SuspicionLevel * -1;
//	ShotModifiers.AddItem(ModInfo);
//
//	ModInfo.ModType = eHit_Crit;
//	ModInfo.Reason = FriendlyName;
//	ModInfo.Value = SuspicionLevel * -1;
//	ShotModifiers.AddItem(ModInfo);
//}	