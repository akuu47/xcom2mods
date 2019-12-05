class Musashi_Effect_RemoveEffects extends X2Effect;

var array<name> EffectNamesToRemove;
var bool        bCleanse;               //  Indicates the effect was removed "safely" for gameplay purposes so any bad "wearing off" effects should not trigger
										//  e.g. Bleeding Out normally kills the soldier it is removed from, but if cleansed, it won't.
var bool        bCheckSource;           //  Match each effect to the target of this one (rather than the source of this one)
var bool		bCheckTarget;			//  Match the target of each effect (rather than the source of each effect)

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local XComGameState_Effect	EffectState;
	local X2Effect_Persistent	PersistentEffect;
	local StateObjectReference	OtherRef, ThisRef;

	foreach `XCOMHISTORY.IterateByClassType(class'XComGameState_Effect', EffectState)
	{
		OtherRef = bCheckSource ? EffectState.ApplyEffectParameters.SourceStateObjectRef : EffectState.ApplyEffectParameters.TargetStateObjectRef;
		ThisRef = bCheckTarget ? ApplyEffectParameters.TargetStateObjectRef : ApplyEffectParameters.SourceStateObjectRef;
		if (OtherRef.ObjectID == ThisRef.ObjectID)
		{
			PersistentEffect = EffectState.GetX2Effect();
			if (ShouldRemoveEffect(EffectState, PersistentEffect))
			{
				EffectState.RemoveEffect(NewGameState, NewGameState, bCleanse);
			}
		}
	}
}

simulated function bool ShouldRemoveEffect(XComGameState_Effect EffectState, X2Effect_Persistent PersistentEffect)
{
	return EffectNamesToRemove.Find(PersistentEffect.EffectName) != INDEX_NONE;
}

simulated function AddX2ActionsForVisualization(XComGameState VisualizeGameState, out VisualizationActionMetadata BuildTrack, const name EffectApplyResult)
{
	local XComGameState_Effect EffectState;
	local X2Effect_Persistent Effect;

	if (EffectApplyResult != 'AA_Success')
		return;

	//  We are assuming that any removed effects were cleansed by this RemoveEffects. If this turns out to not be a good assumption, something will have to change.
	foreach VisualizeGameState.IterateByClassType(class'XComGameState_Effect', EffectState)
	{
		if (EffectState.bRemoved)
		{
			if (EffectState.ApplyEffectParameters.TargetStateObjectRef.ObjectID == BuildTrack.StateObject_NewState.ObjectID)
			{
				Effect = EffectState.GetX2Effect();
				if (Effect.CleansedVisualizationFn != none && bCleanse)
				{
					Effect.CleansedVisualizationFn(VisualizeGameState, BuildTrack, EffectApplyResult);
				}
				else
				{
					Effect.AddX2ActionsForVisualization_Removed(VisualizeGameState, BuildTrack, EffectApplyResult, EffectState);
				}
			}
			else if (EffectState.ApplyEffectParameters.SourceStateObjectRef.ObjectID == BuildTrack.StateObject_NewState.ObjectID)
			{
				Effect = EffectState.GetX2Effect();
				Effect.AddX2ActionsForVisualization_RemovedSource(VisualizeGameState, BuildTrack, EffectApplyResult, EffectState);
			}
		}
	}
}

DefaultProperties
{
	bCleanse = true
}