class X2Ability_CarryUnit_Workaround extends X2Ability;

var localized string CarryUnitEffectFriendlyName;
var localized string CarryUnitEffectFriendlyDesc;
var name CarryUnitEffectName;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	Templates.AddItem(CarryUnit());

	return Templates;
}

static function X2AbilityTemplate CarryUnit()
{
	local X2AbilityTemplate             Template;
	local X2Condition_UnitProperty      TargetCondition, ShooterCondition;
	local X2AbilityTarget_Single        SingleTarget;
	local X2AbilityTrigger_PlayerInput  PlayerInput;
	local X2Effect_PersistentStatChange CarryUnitEffect;
	local X2Effect_Persistent           BeingCarriedEffect;
	local X2Condition_UnitEffects       ExcludeEffects;
	local X2Condition_CheckCarryStatus 	CheckCarryStatus;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'CarryUnitWorkaround');

	Template.RemoveTemplateAvailablility(Template.BITFIELD_GAMEAREA_Multiplayer); // Do not allow "Carrying" in MP!

	Template.AbilityCosts.AddItem(default.FreeActionCost);

	Template.AbilityToHitCalc = default.DeadEye;

	ShooterCondition = new class'X2Condition_UnitProperty';
	ShooterCondition.ExcludeDead = true;
	Template.AbilityShooterConditions.AddItem(ShooterCondition);

	Template.AddShooterEffectExclusions();

	TargetCondition = new class'X2Condition_UnitProperty';
	// This is the bug, our body is not being seen as game as able to carry
	TargetCondition.CanBeCarried = false;
	TargetCondition.ExcludeAlive = false;
	TargetCondition.ExcludeDead = false;
	TargetCondition.ExcludeFriendlyToSource = false;
	TargetCondition.ExcludeHostileToSource = false;     
	TargetCondition.RequireWithinRange = true;
	TargetCondition.WithinRange = class'X2Ability_CarryUnit'.default.CARRY_UNIT_RANGE;
	Template.AbilityTargetConditions.AddItem(TargetCondition);

	// Let's see if unit is bleeding or unconscious.
	CheckCarryStatus = new class'X2Condition_CheckCarryStatus';
    Template.AbilityTargetConditions.AddItem(CheckCarryStatus);

	// The target must not have a cocoon on top of it
	ExcludeEffects = new class'X2Condition_UnitEffects';
	ExcludeEffects.AddExcludeEffect(class'X2Ability_ChryssalidCocoon'.default.GestationStage1EffectName, 'AA_UnitHasCocoonOnIt');
	ExcludeEffects.AddExcludeEffect(class'X2Ability_ChryssalidCocoon'.default.GestationStage2EffectName, 'AA_UnitHasCocoonOnIt');
	Template.AbilityTargetConditions.AddItem(ExcludeEffects);

	SingleTarget = new class'X2AbilityTarget_Single';
	Template.AbilityTargetStyle = SingleTarget;

	PlayerInput = new class'X2AbilityTrigger_PlayerInput';
	Template.AbilityTriggers.AddItem(PlayerInput);

	Template.Hostility = eHostility_Neutral;

	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_ShowIfAvailable;
	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_carry_unit";
	Template.CinescriptCameraType = "Soldier_CarryPickup";

	Template.ActivationSpeech = 'PickingUpBody';

	Template.BuildNewGameStateFn = CarryUnit_BuildGameState;
	Template.BuildVisualizationFn = CarryUnit_BuildVisualization;
	Template.BuildAppliedVisualizationSyncFn = CarryUnit_BuildAppliedVisualization;
	Template.BuildAffectedVisualizationSyncFn = CarryUnit_BuildAffectedVisualization;

	CarryUnitEffect = new class'X2Effect_PersistentStatChange';
	CarryUnitEffect.BuildPersistentEffect(1, true, true);
	CarryUnitEffect.SetDisplayInfo(ePerkBuff_Penalty, default.CarryUnitEffectFriendlyName, default.CarryUnitEffectFriendlyDesc, Template.IconImage, true);
	CarryUnitEffect.AddPersistentStatChange(eStat_Mobility, class'X2Ability_CarryUnit'.default.CARRY_UNIT_MOBILITY_ADJUST);
	CarryUnitEffect.DuplicateResponse = eDupe_Ignore;
	CarryUnitEffect.EffectName = default.CarryUnitEffectName;
	Template.AddShooterEffect(CarryUnitEffect);

	BeingCarriedEffect = new class'X2Effect_Persistent';
	BeingCarriedEffect.BuildPersistentEffect(1, true, true);
	BeingCarriedEffect.DuplicateResponse = eDupe_Ignore;
	BeingCarriedEffect.EffectName = class'X2AbilityTemplateManager'.default.BeingCarriedEffectName;
	BeingCarriedEffect.EffectAddedFn = BeingCarried_EffectAdded;
	Template.AddTargetEffect(BeingCarriedEffect);

	Template.AddAbilityEventListener('UnitMoveFinished', class'XComGameState_Ability'.static.CarryUnitMoveFinished, ELD_OnStateSubmitted);
	
	Template.bLimitTargetIcons = true; //When selected, show carry-able units, rather than typical targets

	Template.bDontDisplayInAbilitySummary = true;

	return Template;
}

static function BeingCarried_EffectAdded(X2Effect_Persistent PersistentEffect, const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState)
{
	`XWORLD.ClearTileBlockedByUnitFlag(XComGameState_Unit(kNewTargetState));
}

static function XComGameState CarryUnit_BuildGameState(XComGameStateContext Context)
{
	local XComGameState NewGameState;
	local XComGameState_Unit SourceUnit, TargetUnit;
	local XComGameStateContext_Ability AbilityContext;
	local array<XComGameState_BaseObject> ComponentObjs;
	local int i;

	NewGameState = `XCOMHISTORY.CreateNewGameState(true, Context);

	TypicalAbility_FillOutGameState(NewGameState);

	//	check for the target unit to be a mission objective, and if so, break concealment
	AbilityContext = XComGameStateContext_Ability(NewGameState.GetContext());
	SourceUnit = XComGameState_Unit(NewGameState.GetGameStateForObjectID(AbilityContext.InputContext.SourceObject.ObjectID));
	TargetUnit = XComGameState_Unit(NewGameState.GetGameStateForObjectID(AbilityContext.InputContext.PrimaryTarget.ObjectID));
	`assert(SourceUnit != none && TargetUnit != none);

	if (SourceUnit.IsConcealed())
	{
		TargetUnit.GetAllComponentObjects(ComponentObjs);
		for (i = 0; i < ComponentObjs.Length; ++i)
		{
			if (XComGameState_ObjectiveInfo(ComponentObjs[i]) != none)
			{
				`XEVENTMGR.TriggerEvent('EffectBreakUnitConcealment', SourceUnit, SourceUnit, NewGameState);
				break;
			}
		}
	}

	return NewGameState;
}

simulated function CarryUnit_BuildVisualization(XComGameState VisualizeGameState)
{
	local XComGameStateHistory History;
	local XComGameStateContext_Ability  Context;
	local VisualizationActionMetadata	EmptyTrack;
	local VisualizationActionMetadata	ActionMetadata;

	local XComGameState_Ability Ability;
	local X2Action_PlaySoundAndFlyOver SoundAndFlyover;
	local XComGameState_Unit CarriedUnit;	

	local XComGameStateVisualizationMgr VisMgr;
	local X2Action_MarkerNamed JoinActions;
	local array<X2Action> LeafNodes;

	History = `XCOMHISTORY;
	VisMgr = `XCOMVISUALIZATIONMGR;

	Context = XComGameStateContext_Ability(VisualizeGameState.GetContext());


	//Configure the visualization track for the target - target comes first since it sets the picked up unit into the correct animation state
	//****************************************************************************************
	ActionMetadata = EmptyTrack;
	ActionMetadata.StateObject_OldState = History.GetGameStateForObjectID(Context.InputContext.PrimaryTarget.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
	ActionMetadata.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(Context.InputContext.PrimaryTarget.ObjectID);
	ActionMetadata.VisualizeActor = History.GetVisualizer(Context.InputContext.PrimaryTarget.ObjectID);

	class'X2Action_GetPickedUp'.static.AddToVisualizationTree(ActionMetadata, Context, false, VisMgr.BuildVisTree);
	//****************************************************************************************

	//Configure the visualization track for the shooter
	//****************************************************************************************
	ActionMetadata = EmptyTrack;
	ActionMetadata.StateObject_OldState = History.GetGameStateForObjectID(Context.InputContext.SourceObject.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
	ActionMetadata.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(Context.InputContext.SourceObject.ObjectID);
	ActionMetadata.VisualizeActor = History.GetVisualizer(Context.InputContext.SourceObject.ObjectID);
	ActionMetadata.AdditionalVisualizeActors.AddItem(History.GetVisualizer(Context.InputContext.PrimaryTarget.ObjectID));

	class'X2Action_CarryUnitPickUp'.static.AddToVisualizationTree(ActionMetadata, Context, false, VisMgr.BuildVisTree);

	CarriedUnit = XComGameState_Unit(History.GetGameStateForObjectID(Context.InputContext.PrimaryTarget.ObjectID));
	Ability = XComGameState_Ability(History.GetGameStateForObjectID(Context.InputContext.AbilityRef.ObjectID));
	SoundAndFlyOver = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTree(ActionMetadata, Context, false, ActionMetadata.LastActionAdded));

	if (CarriedUnit.GetMyTemplateName() == 'HostileVIPCivilian')
	{
		// The HostileVIP is a special case sound cue, eg "We've got the target in custody."
		SoundAndFlyOver.SetSoundAndFlyOverParameters(None, "", 'HostileVip', eColor_Good);
	}
	else
	{
		SoundAndFlyOver.SetSoundAndFlyOverParameters(None, "", Ability.GetMyTemplate().ActivationSpeech, eColor_Good);
	}
	//****************************************************************************************

	VisMgr.GetAllLeafNodes(VisMgr.BuildVisTree, LeafNodes);

	if( VisMgr.BuildVisTree.ChildActions.Length > 0 )
	{
		JoinActions = X2Action_MarkerNamed(class'X2Action_MarkerNamed'.static.AddToVisualizationTree(ActionMetadata, Context, false, none, LeafNodes));
		JoinActions.SetName("Join");
	}
}

simulated function CarryUnit_BuildAppliedVisualization(name EffectName, XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata )
{
	if (EffectName == class'X2AbilityTemplateManager'.default.BeingCarriedEffectName)
	{
		class'X2Action_CarryUnitPickUp'.static.AddToVisualizationTree( ActionMetadata, VisualizeGameState.GetContext() );
	}
}

simulated function CarryUnit_BuildAffectedVisualization(name EffectName, XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata )
{
	if (EffectName == class'X2AbilityTemplateManager'.default.BeingCarriedEffectName)
	{
		class'X2Action_GetPickedUp'.static.AddToVisualizationTree( ActionMetadata, VisualizeGameState.GetContext() );
	}
}

DefaultProperties
{
	CarryUnitEffectName="CarryUnit"
}