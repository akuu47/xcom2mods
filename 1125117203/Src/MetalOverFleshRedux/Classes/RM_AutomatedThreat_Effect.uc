class RM_AutomatedThreat_Effect extends X2Effect_Persistent;

	
function GetToHitAsTargetModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
    local ShotModifierInfo ShotInfo;

			ShotInfo.ModType = eHit_Success;
			ShotInfo.Reason = FriendlyName;
			ShotInfo.Value = -(class'RM_SPARKTechs_Helpers'.default.ATA_DEFENSE);
			ShotModifiers.AddItem(ShotInfo);
		
}

DefaultProperties
{
	EffectName = "SPARKDefense"
	DuplicateResponse = eDupe_Ignore
}