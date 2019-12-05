class X2AbilityCooldown_Bonus extends X2AbilityCooldown;

var name ModifierAbility;
var int iModifier;

simulated function int GetNumTurns(XComGameState_Ability kAbility, XComGameState_BaseObject AffectState, XComGameState_Item AffectWeapon, XComGameState NewGameState)
{
	if (XComGameState_Unit(AffectState).HasSoldierAbility(ModifierAbility))
		return iNumTurns - iModifier;

	return iNumTurns;
}