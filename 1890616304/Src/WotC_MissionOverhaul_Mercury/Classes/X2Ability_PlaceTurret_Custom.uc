class X2Ability_PlaceTurret_Custom extends X2Ability_DefaultAbilitySet config (GameData_MissionAbilities);

var config int InitialTurretCharges;
var config int ExtraTurretCharges;

/// <summary>
/// Creates the set of default abilities every unit should have in X-Com 2
/// </summary>
static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;
	
	Templates.AddItem(AddPlaceTurretAbility());

	return Templates;
}

//******** Interact With Objective Ability **********
static function X2AbilityTemplate AddPlaceTurretAbility()
{
	local X2AbilityTemplate					Template;
	local X2AbilityCost_ActionPoints		ActionPointCost;
	//local X2AbilityCost_Ammo				AmmoCost;
	local X2AbilityTarget_Cursor			CursorTarget;
	local X2AbilityMultiTarget_Radius		RadiusMultiTarget;
	local X2Effect_SpawnTurretScaled_XCom	SpawnTurretObj_XCom;
	local X2Condition_GameplayTag			GameplayTags;
	local X2AbilityCharges_DefenseMatrix	Charges;
	local X2Condition_UnitProperty			UnitPropertyCondition;
	local X2Condition_Visibility			VisibilityCondition;
	local X2AbilityCost_SharedCharges		ChargeCost;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Interactive_PlaceTurretObject');

	Template.IconImage = "img:///UILibrary_Common.TargetIcons.target_turret_bg";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	//Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_ShowIfAvailable;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.Hostility = eHostility_Neutral;
	Template.bDisplayInUITacticalText = false;

	Template.AbilityIconColor = class'UIUtilities_Colors'.const.OBJECTIVEICON_HTML_COLOR;
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.OBJECTIVE_INTERACT_PRIORITY;
	Template.DefaultKeyBinding = class'UIUtilities_Input'.const.FXS_KEY_V;

	//Template.bUseAmmoAsChargesForHUD = true;
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.OBJECTIVE_INTERACT_PRIORITY;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	Template.TargetingMethod = class'X2TargetingMethod_Pillar';

	CursorTarget = new class'X2AbilityTarget_Cursor';
//	CursorTarget.FixedAbilityRange = 64;
	CursorTarget.bRestrictToSquadsightRange = true;
	Template.AbilityTargetStyle = CursorTarget;

	RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
	RadiusMultiTarget.fTargetRadius = 0.25;
//	RadiusMultiTarget.bIgnoreBlockingCover = true;
	Template.AbilityMultiTargetStyle = RadiusMultiTarget;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = false;
	Template.AbilityCosts.AddItem(ActionPointCost);

	//Add Charges
	Charges = new class'X2AbilityCharges_DefenseMatrix';
	Charges.InitialCharges = default.InitialTurretCharges;
	Charges.ExtraCharges = default.ExtraTurretCharges;
	Template.AbilityCharges = Charges;

    ChargeCost = new class'X2AbilityCost_SharedCharges';
    ChargeCost.NumCharges = 1;
    Template.AbilityCosts.AddItem(ChargeCost);

	//Exclude ability if AvengerDefenseTurrets Gameplay Tag is not built
	GameplayTags = new class'X2Condition_GameplayTag';
	GameplayTags.RequiredGameplayTag = 'AvengerDefenseTurrets';
	Template.AbilityShooterConditions.AddItem(GameplayTags);


	//Requires visibility to location
	VisibilityCondition = new class'X2Condition_Visibility';
	VisibilityCondition.bRequireLOS = true;
	Template.AbilityTargetConditions.AddItem(VisibilityCondition);

	//Exclude dead units from using this ability
	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeDead = true;
	Template.AbilityShooterConditions.AddItem(UnitPropertyCondition);

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	// BEGIN CUSTOM EFFECTS DRIVER //
	SpawnTurretObj_XCom = new class'X2Effect_SpawnTurretScaled_XCom';
	SpawnTurretObj_XCom.BuildPersistentEffect(1, false, true, false, eGameRule_PlayerTurnBegin);
	Template.AddShooterEffect(SpawnTurretObj_XCom);
	// END CUSTOM EFFECTS DRIVER //

	Template.CustomFireAnim = 'HL_CallReinforcementsA';
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = SpawnTurret_BuildVisualization;

	return Template;
}


simulated function SpawnTurret_BuildVisualization(XComGameState VisualizeGameState)
{
	local XComGameStateHistory History;
	local XComGameStateContext_Ability Context;
	local StateObjectReference InteractingUnitRef;
	local VisualizationActionMetadata EmptyTrack;
	local VisualizationActionMetadata SourceTrack, MimicBeaconTrack;
	local XComGameState_Unit MimicSourceUnit, SpawnedUnit;
	local UnitValue SpawnedUnitValue;
	local X2Effect_SpawnTurretScaled_XCom SpawnMimicBeaconEffect;
	local X2Action_MimicBeaconThrow		FireAction;
	local X2Action_PlayAnimation		AnimationAction;
	local X2Action_PlayEffect			EffectAction;
	local X2Action_Delay				DelayAction;
	local X2Action						CommonParent;
	local X2Action_PlaySoundAndFlyOver	SoundAndFlyover;

	History = `XCOMHISTORY;

	Context = XComGameStateContext_Ability(VisualizeGameState.GetContext());
	InteractingUnitRef = Context.InputContext.SourceObject;

	//Configure the visualization track for the shooter
	//****************************************************************************************
	SourceTrack = EmptyTrack;
	SourceTrack.StateObject_OldState = History.GetGameStateForObjectID(InteractingUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
	SourceTrack.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(InteractingUnitRef.ObjectID);
	SourceTrack.VisualizeActor = History.GetVisualizer(InteractingUnitRef.ObjectID);

	class'X2Action_ExitCover'.static.AddToVisualizationTree(SourceTrack, Context);
	FireAction = X2Action_MimicBeaconThrow(class'X2Action_MimicBeaconThrow'.static.AddToVisualizationTree(SourceTrack, Context));
	class'X2Action_EnterCover'.static.AddToVisualizationTree(SourceTrack, Context);

	// Configure the visualization track for the mimic beacon
	//******************************************************************************************
	MimicSourceUnit = XComGameState_Unit(VisualizeGameState.GetGameStateForObjectID(InteractingUnitRef.ObjectID));
	`assert(MimicSourceUnit != none);
	MimicSourceUnit.GetUnitValue(class'X2Effect_SpawnUnit'.default.SpawnedUnitValueName, SpawnedUnitValue);

	MimicBeaconTrack = EmptyTrack;
	MimicBeaconTrack.StateObject_OldState = History.GetGameStateForObjectID(SpawnedUnitValue.fValue, eReturnType_Reference, VisualizeGameState.HistoryIndex);
	MimicBeaconTrack.StateObject_NewState = MimicBeaconTrack.StateObject_OldState;
	SpawnedUnit = XComGameState_Unit(MimicBeaconTrack.StateObject_NewState);
	`assert(SpawnedUnit != none);
	MimicBeaconTrack.VisualizeActor = History.GetVisualizer(SpawnedUnit.ObjectID);

	// Set the Throwing Unit's FireAction to reference the spawned unit
	FireAction.MimicBeaconUnitReference = SpawnedUnit.GetReference();
	// Set the Throwing Unit's FireAction to reference the spawned unit
	class'X2Action_WaitForAbilityEffect'.static.AddToVisualizationTree(MimicBeaconTrack, Context);

	// Only one target effect and it is X2Effect_SpawnMimicBeacon
	SpawnMimicBeaconEffect = X2Effect_SpawnTurretScaled_XCom(Context.ResultContext.ShooterEffectResults.Effects[0]);
	
	if( SpawnMimicBeaconEffect == none )
	{
		`RedScreenOnce("MimicBeacon_BuildVisualization: Missing X2Effect_SpawnMimicBeacon -dslonneger @gameplay");
		return;
	}	

	CommonParent =  MimicBeaconTrack.LastActionAdded;

	SoundAndFlyover = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTree(MimicBeaconTrack, Context, false, CommonParent));
	SoundAndFlyover.SetSoundAndFlyOverParameters(SoundCue(`CONTENT.RequestGameArchetype("Mercury_Turret.Turret_Flight")), "", '', eColor_Good);

	EffectAction = X2Action_PlayEffect(class'X2Action_PlayEffect'.static.AddToVisualizationTree(MimicBeaconTrack, Context, false, CommonParent));
    EffectAction.EffectName = "Mercury_Turret.Meshes.PS_TurretFall"; //"FX_Mimic_Beacon_Hologram.P_Mimic_Activate";
    EffectAction.EffectLocation = Context.InputContext.TargetLocations[0];
    EffectAction.EffectRotation = Rotator(vect(0, 1, 0));
    EffectAction.bWaitForCompletion = false;
    EffectAction.bWaitForCameraArrival = false;
    EffectAction.bWaitForCameraCompletion = false;
    EffectAction.CenterCameraOnEffectDuration = 3.0f;
    //EffectAction.RevealFOWRadius = class'XComWorldData'.const.WORLD_StepSize * 5.0f;

	DelayAction = X2Action_Delay(class'X2Action_Delay'.static.AddToVisualizationTree(MimicBeaconTrack, Context, false, CommonParent));
	DelayAction.Duration = 1.92f;

	SpawnMimicBeaconEffect.AddSpawnVisualizationsToTracks_Parent(Context, SpawnedUnit, MimicBeaconTrack, MimicSourceUnit, DelayAction);

	class'X2Action_ViewShake'.static.AddToVisualizationTree(MimicBeaconTrack, Context, false, DelayAction);

	class'X2Action_SyncVisualizer'.static.AddToVisualizationTree(MimicBeaconTrack, Context, false, MimicBeaconTrack.LastActionAdded);

	SoundAndFlyover = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTree(MimicBeaconTrack, Context, false, MimicBeaconTrack.LastActionAdded));
	SoundAndFlyover.SetSoundAndFlyOverParameters(SoundCue(`CONTENT.RequestGameArchetype("Mercury_Turret.Turret_Impact")), "", '', eColor_Good);

	AnimationAction = X2Action_PlayAnimation(class'X2Action_PlayAnimation'.static.AddToVisualizationTree(MimicBeaconTrack, Context, false, MimicBeaconTrack.LastActionAdded));
	AnimationAction.Params.AnimName = 'NO_Activate_XcomA';		//	E3245 CHANGE ANIMATION NAME HERE IF YOU WANT YOUR FILTHY MITV
	AnimationAction.Params.BlendTime = 0.0f;
}