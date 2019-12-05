class X2Effect_CodexModule extends X2Effect_Persistent;


function GetToHitAsTargetModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{

    local ShotModifierInfo				ShotInfo;
	local int							BadGuys;

	BadGuys = Target.GetNumVisibleEnemyUnits (true, false, false, -1, false, false);

	if (BadGuys > 0)
	{
		ShotInfo.ModType = eHit_Graze;
		ShotInfo.Reason = FriendlyName;
		ShotInfo.Value = Clamp (BadGuys * class'RM_SPARKTechs_Helpers'.default.CodexDodge, 0, class'RM_SPARKTechs_Helpers'.default.CodexMax);
		ShotModifiers.AddItem(ShotInfo);
	}
}

defaultproperties
{
    DuplicateResponse=eDupe_Refresh
    EffectName="CodexModule"
}
