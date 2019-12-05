class X2Effect_SmokeGrenade_Regen extends X2Effect_Regeneration;

var int RegenAmount;

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	RegenerationTicked(self, ApplyEffectParameters, NewEffectState, NewGameState, true);
}

function bool RegenerationTicked(X2Effect_Persistent PersistentEffect, const out EffectAppliedData ApplyEffectParameters, XComGameState_Effect kNewEffectState, XComGameState NewGameState, bool FirstApplication)
{
	local XComGameState_Unit OldTargetState, NewTargetState;
	local int AmountToHeal;
	local XComGameState_Unit SourceUnit;

	SourceUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(ApplyEffectParameters.SourceStateObjectRef.ObjectID));

	if (SourceUnit.HasSoldierAbility('RestorativeSmoke'))
	{
		OldTargetState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(ApplyEffectParameters.TargetStateObjectRef.ObjectID));

		// If no value tracking for health regenerated is set, heal for the default amount
		AmountToHeal = RegenAmount;
			
		// Perform the heal
		NewTargetState = XComGameState_Unit(NewGameState.ModifyStateObject(OldTargetState.Class, OldTargetState.ObjectID));
		NewTargetState.ModifyCurrentStat(estat_HP, AmountToHeal);

		if (EventToTriggerOnHeal != '')
			`XEVENTMGR.TriggerEvent(EventToTriggerOnHeal, NewTargetState, NewTargetState, NewGameState);
		
		return false;
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

	Healed = NewUnit.GetCurrentStat(eStat_HP) - OldUnit.GetCurrentStat(eStat_HP);
	
	if( Healed > 0 )
	{
		Vis = "Restorative Smoke: </Heal>";
		SoundAndFlyOver = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext(), false, ActionMetadata.LastActionAdded));
		Msg = Repl(Vis, "<Heal/>", Healed);
		SoundAndFlyOver.SetSoundAndFlyOverParameters(None, Msg, '', eColor_Good);
	}
}

defaultproperties
{
	EffectName="SmokeGrenade_Regen"
	RegenAmount=2
}