class Musashi_Effect_PlantX4 extends X2Effect_Persistent;

var string ParticleEffectName;

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local XComGameState_Unit TargetUnit;
	local Musashi_Gamestate_X4 X4EffectState;
	local X2EventManager EventMgr;
	local Object ListenerObj;
	local XComWorldData World;
	
	World = `XWORLD;

	if (GetX4Component(NewEffectState) == none)
	{
		TargetUnit = XComGameState_Unit(kNewTargetState);

		// Create component and attach it to GameState_Effect, adding the new state object to the NewGameState container
		X4EffectState = Musashi_Gamestate_X4(NewGameState.CreateStateObject(class'Musashi_Gamestate_X4'));
		//X4EffectState.TargetLocations.AddItem(World.GetPositionFromTileCoordinates(TargetUnit.TileLocation));
		X4EffectState.TargetLocations.AddItem(ApplyEffectParameters.AbilityInputContext.TargetLocations[0]);
		X4EffectState.EffectName = EffectName;
		//X4EffectState.TargetLocations = ApplyEffectParameters.AbilityInputContext.TargetLocations;
		NewEffectState.AddComponentObject(X4EffectState);
		NewGameState.AddStateObject(X4EffectState);

		TargetUnit = XComGameState_Unit(NewGameState.CreateStateObject(TargetUnit.Class, TargetUnit.ObjectID));
		TargetUnit.SetUnitFloatValue(EffectName, float(1), eCleanup_BeginTactical);
		TargetUnit.SetUnitFloatValue('ExplosivesPlantedThisRound', float(1), eCleanup_BeginTurn);
		NewGameState.AddStateObject(TargetUnit);

		EventMgr = `XEVENTMGR;
		ListenerObj = X4EffectState;

		// This callback will intercept the unit's AbilityActivated notifications...
		EventMgr.RegisterForEvent(ListenerObj, 'AbilityActivated', X4EffectState.OnAbilityActivated, ELD_OnStateSubmitted, , TargetUnit);
		EventMgr.UnRegisterFromEvent(TargetUnit, 'AbilityActivated');


		EventMgr.RegisterForEvent(ListenerObj, 'TacticalGameEnd', X4EffectState.OnTacticalGameEnd, ELD_OnStateSubmitted);
		`LOG("X4 effect listeners registered for events.",, 'TacticalX4');
	}

	super.OnEffectAdded(ApplyEffectParameters, kNewTargetState, NewGameState, NewEffectState);
}

static function Musashi_Gamestate_X4 GetX4Component(XComGameState_Effect Effect)
{
    if (Effect != none) 
        return Musashi_Gamestate_X4(Effect.FindComponentObject(class'Musashi_Gamestate_X4'));
    return none;
}

simulated function AddX2ActionsForVisualization(XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata, name EffectApplyResult)
{
	local XComGameState_Effect X4Effect, EffectState;
	local X2Action_PlayEffect EffectAction;
	local X2Action_StartStopSound SoundAction;


	if (EffectApplyResult != 'AA_Success' || ActionMetadata.VisualizeActor == none)
		return;

	foreach VisualizeGameState.IterateByClassType(class'XComGameState_Effect', EffectState)
	{
		if (EffectState.GetX2Effect() == self)
		{
			X4Effect = EffectState;
			break;
		}
	}
	`assert(X4Effect != none);

	//For multiplayer: don't visualize mines on the enemy team.
	if (X4Effect.GetSourceUnitAtTimeOfApplication().ControllingPlayer.ObjectID != `TACTICALRULES.GetLocalClientPlayerObjectID())
		return;

	EffectAction = X2Action_PlayEffect(class'X2Action_PlayEffect'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext()));
	EffectAction.EffectName = ParticleEffectName;
	EffectAction.EffectLocation = X4Effect.ApplyEffectParameters.AbilityInputContext.TargetLocations[0];

	SoundAction = X2Action_StartStopSound(class'X2Action_StartStopSound'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext()));
	SoundAction.Sound = new class'SoundCue';
	SoundAction.Sound.AkEventOverride = AkEvent'SoundSpeechTacticalCentral.CEN_Sabotage_BombSmartPlanted';
	SoundAction.iAssociatedGameStateObjectId = X4Effect.ObjectID;
	SoundAction.bStartPersistentSound = true;
	SoundAction.bIsPositional = false;
	SoundAction.vWorldPosition = X4Effect.ApplyEffectParameters.AbilityInputContext.TargetLocations[0];
}

simulated function AddX2ActionsForVisualization_Sync(XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata)
{
	//We assume 'AA_Success', because otherwise the effect wouldn't be here (on load) to get sync'd
	AddX2ActionsForVisualization(VisualizeGameState, ActionMetadata, 'AA_Success');
}

simulated function AddX2ActionsForVisualization_Removed(XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata, const name EffectApplyResult, XComGameState_Effect RemovedEffect)
{
	local XComGameState_Effect X4Effect, EffectState;
	local X2Action_PlayEffect EffectAction;
	local X2Action_StartStopSound SoundAction;

	if (EffectApplyResult != 'AA_Success' || ActionMetadata.VisualizeActor == none)
		return;

	foreach VisualizeGameState.IterateByClassType(class'XComGameState_Effect', EffectState)
	{
		if (EffectState.GetX2Effect() == self)
		{
			X4Effect = EffectState;
			break;
		}
	}
	`assert(X4Effect != none);

	//For multiplayer: don't visualize mines on the enemy team.
	if (X4Effect.GetSourceUnitAtTimeOfApplication().ControllingPlayer.ObjectID != `TACTICALRULES.GetLocalClientPlayerObjectID())
		return;

	EffectAction = X2Action_PlayEffect(class'X2Action_PlayEffect'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext()));
	EffectAction.EffectName = ParticleEffectName;
	EffectAction.EffectLocation = X4Effect.ApplyEffectParameters.AbilityInputContext.TargetLocations[0];
	EffectAction.bStopEffect = true;
	`LOG("Remove Plant X4 visualization for " @ ParticleEffectName,, 'TacticalX4');

	SoundAction = X2Action_StartStopSound(class'X2Action_StartStopSound'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext()));
	SoundAction.Sound = new class'SoundCue';
	SoundAction.Sound.AkEventOverride = AkEvent'SoundSpeechTacticalCentral.CEN_Sabotage_BombSmartPlanted';
	SoundAction.iAssociatedGameStateObjectId = X4Effect.ObjectID;
	SoundAction.bIsPositional = true;
	SoundAction.bStopPersistentSound = true;
}

DefaultProperties
{
	EffectName="X4_Effect"
	DuplicateResponse = eDupe_Allow;
}