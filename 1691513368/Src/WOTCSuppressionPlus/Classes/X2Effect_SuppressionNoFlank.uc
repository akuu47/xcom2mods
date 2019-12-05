class X2Effect_SuppressionNoFlank extends X2Effect_Persistent;

var string Reason;

function GetToHitModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
	local ShotModifierInfo ModInfo;

	if (class'X2Ability_SuppressionPlus'.default.SuppressionShotAbility.Find(AbilityState.GetMyTemplateName()) != INDEX_NONE)
	{
		if (class'X2Ability_SuppressionPlus'.default.DISABLE_FLANK_CRIT && bFlanking && !bMelee)
		{
			ModInfo.ModType = eHit_Crit;
			ModInfo.Reason = Reason;
			ModInfo.Value = -Attacker.GetCurrentStat(eStat_FlankingCritChance);
			ShotModifiers.AddItem(ModInfo);
		}
	}
}

function bool UniqueToHitModifiers() { return true; } // If someone has multiple suppression, this effect might stack, we don't want that.

function bool AllowReactionFireCrit(XComGameState_Unit UnitState, XComGameState_Unit TargetState) 
{
	if (UnitState.ReserveActionPoints.Find('Suppression') != INDEX_NONE) // You are suppressing if you have reserve action point of suppression
	{
		return class'X2Ability_SuppressionPlus'.default.ALLOW_SUPPRESSION_CRIT;
	}
	return false;
}