class Musashi_Conditional_AbilityCooldown extends X2AbilityCooldown;

var bool bDoNotApplyOnKill;
var bool bDoNotApplyOnCrit;
var bool bDoNotApplyOnReaper;

simulated function ApplyCooldown(XComGameState_Ability kAbility, XComGameState_BaseObject AffectState, XComGameState_Item AffectWeapon, XComGameState NewGameState)
{
	local XComGameStateContext_Ability AbilityContext;
	local XComGameState_Unit PrimaryTargetUnitState, SourceUnitState;
	local UnitValue UnitVal;

	// For debug only
	if(`CHEATMGR != None && `CHEATMGR.strAIForcedAbility ~= string(kAbility.GetMyTemplateName()))
		iNumTurns = 0;

	AbilityContext = XComGameStateContext_Ability(NewGameState.GetContext());

	SourceUnitState = XComGameState_Unit(AffectState);

	if(AbilityContext != None) {

		if(bDoNotApplyOnKill)
		{
			PrimaryTargetUnitState = XComGameState_Unit(AbilityContext.AssociatedState.GetGameStateForObjectID(AbilityContext.InputContext.PrimaryTarget.ObjectID));
			if (PrimaryTargetUnitState != none && PrimaryTargetUnitState.IsDead()) {
				return;
			}
		}

		if(bDoNotApplyOnCrit) {	
			if (AbilityContext.ResultContext.HitResult == eHit_Crit) {
				return;
			}
		}

		if(bDoNotApplyOnReaper) {
			SourceUnitState.GetUnitValue('Reaper_SuperKillCheck', UnitVal);
			if (UnitVal.fValue == 1) {
				return;
			}
		}
	}

		
	kAbility.iCooldown = GetNumTurns(kAbility, AffectState, AffectWeapon, NewGameState);

	ApplyAdditionalCooldown(kAbility, AffectState, AffectWeapon, NewGameState);
}

DefaultProperties
{
	bDoNotApplyOnKill = false
	bDoNotApplyOnCrit = false
	bDoNotApplyOnReaper = false
}