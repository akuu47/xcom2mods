class X2Effect_ShieldVest extends X2Effect_ModifyStats;

var int ShieldAmount;
var int ShieldRegen;

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local StatChange Change;

	Change.StatType = eStat_ShieldHP;
	Change.StatAmount = ShieldAmount;
	NewEffectState.StatChanges.AddItem(Change);

	RegenerationTicked(self, ApplyEffectParameters, NewEffectState, NewGameState, true);
	super.OnEffectAdded(ApplyEffectParameters, kNewTargetState, NewGameState, NewEffectState);
	
}

function bool RegenerationTicked(X2Effect_Persistent PersistentEffect, const out EffectAppliedData ApplyEffectParameters, XComGameState_Effect kNewEffectState, XComGameState NewGameState, bool FirstApplication)
{
	local XComGameState_Unit OldTargetState, NewTargetState;
	local int AmountToHeal;

	OldTargetState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(ApplyEffectParameters.TargetStateObjectRef.ObjectID));

	// If no value tracking for health regenerated is set, heal for the default amount
	AmountToHeal = ShieldRegen;
	
	//only kicks in when completely gone
	if(OldTargetState.GetCurrentStat(eStat_ShieldHP) < ShieldAmount){
		// Perform the heal
		NewTargetState = XComGameState_Unit(NewGameState.ModifyStateObject(OldTargetState.Class, OldTargetState.ObjectID));
		NewTargetState.ModifyCurrentStat(eStat_ShieldHP, AmountToHeal);
	}

	return false;
	
}

simulated function AddX2ActionsForVisualization_Tick(XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata, const int TickIndex, XComGameState_Effect EffectState)
{
	local XComGameState_Unit OldUnit, NewUnit;
	local X2Action_PlaySoundAndFlyOver SoundAndFlyOver;
	local int Healed;
	local string Msg;
	local string Vis;

	OldUnit = XComGameState_Unit(ActionMetadata.StateObject_OldState);
	NewUnit = XComGameState_Unit(ActionMetadata.StateObject_NewState);

	Healed = NewUnit.GetCurrentStat(eStat_ShieldHP) - OldUnit.GetCurrentStat(eStat_ShieldHP);
	
	if( Healed > 0 )
	{
		Vis = "Rebuilding Shields: </Heal>";
		SoundAndFlyOver = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext(), false, ActionMetadata.LastActionAdded));
		Msg = Repl(Vis, "<Heal/>", Healed);
		SoundAndFlyOver.SetSoundAndFlyOverParameters(None, Msg, '', eColor_Good);
	}
}


defaultproperties
{
	EffectName="ShieldVest_Regen"
	EffectTickedFn=RegenerationTicked
}