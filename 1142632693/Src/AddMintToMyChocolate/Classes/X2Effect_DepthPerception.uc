class X2Effect_DepthPerception extends X2Effect_Persistent;

function GetToHitModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{	
	local ShotModifierInfo		Undodgeable;

	if (Attacker.HasHeightAdvantageOver(Target, true))
	{
		Undodgeable.ModType = eHit_Graze;
		Undodgeable.Reason = FriendlyName;
		Undodgeable.Value = -1 * Target.GetCurrentStat(eStat_Dodge);
		ShotModifiers.AddItem(Undodgeable);		
	}

}

