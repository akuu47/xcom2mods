class X2Effect_SignalBurst extends X2Effect_Persistent;

var int TauntBoost;
var int DodgeBoost;

function GetToHitAsTargetModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
    local ShotModifierInfo				TauntInfo, DodgeInfo;

	// Doesn't apply on organic enemies
	if(!Attacker.IsRobotic())
		return;
	
	TauntInfo.ModType = eHit_Success;
	TauntInfo.Reason = FriendlyName;
	TauntInfo.Value = TauntBoost;
	ShotModifiers.AddItem(TauntInfo);

	DodgeInfo.ModType = eHit_Graze;
	DodgeInfo.Reason = FriendlyName;
	DodgeInfo.Value = DodgeBoost;
	ShotModifiers.AddItem(DodgeInfo);

}
