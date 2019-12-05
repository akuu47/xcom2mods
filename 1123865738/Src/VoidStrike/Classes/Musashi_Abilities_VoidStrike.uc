class Musashi_Abilities_VoidStrike extends X2Ability
	dependson (XComGameStateContext_Ability) config(VoidStrike);

var config int VOIDSTRIKE_COOLDOWN;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> AbilityTemplates;

	//AbilityTemplates.AddItem(VoidStrikeFleche());
	AbilityTemplates.AddItem(VoidStrike());

	return AbilityTemplates;
}

static function X2AbilityTemplate VoidStrikeFleche()
{
	local X2AbilityTemplate						Template;
	local Musashi_Effect_FlecheBonusDamage		FlecheBonusDamageEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'VoidStrikeFleche');
	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilityFleche";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.bDisplayInUITacticalText = false;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	Template.bIsPassive = true;
	Template.bHideOnClassUnlock = true;
	Template.bCrossClassEligible = false;

	// Fleche
	FlecheBonusDamageEffect = new class 'Musashi_Effect_FlecheBonusDamage';
	FlecheBonusDamageEffect.AbilityNames.AddItem('MusashiVoidStrike');
	FlecheBonusDamageEffect.BuildPersistentEffect (1, true, true);
	Template.AddTargetEffect(FlecheBonusDamageEffect);
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

static function X2AbilityTemplate VoidStrike()
{
	local X2AbilityTemplate									Template;
	local X2AbilityToHitCalc_StandardMelee					StandardMelee;
	local X2AbilityTarget_MovingMelee						MeleeTarget;
	local X2Effect_ApplyWeaponDamage						WeaponDamageEffect;
	local array<name>										SkipExclusions;
	local Musashi_Conditional_AbilityCooldown				Cooldown;
	local X2Effect_AdditionalAnimSets						AnimSets;
	local X2AbilityCost_ActionPoints						ActionPointCost;
	local X2Effect_Persistent								ShadowStepEffect;
	local Musashi_Effect_VoidStrikeReaper					VoidReaperEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MusashiVoidStrike');

	Template.AbilitySourceName = 'eAbilitySource_Item';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	
	Template.CinescriptCameraType = "Ranger_Reaper";
	Template.IconImage = "img:///MusashAnimations.Icons.UIPerk_void_strike";
	Template.bHideOnClassUnlock = false;
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_SQUADDIE_PRIORITY;
	Template.AbilityConfirmSound = "TacticalUI_SwordConfirm";
	
	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Cooldown = new class'Musashi_Conditional_AbilityCooldown';
	Cooldown.iNumTurns = default.VOIDSTRIKE_COOLDOWN;
	Cooldown.bDoNotApplyOnCrit = true;
	Cooldown.bDoNotApplyOnReaper = true;
	Template.AbilityCooldown = Cooldown;

	StandardMelee = new class'X2AbilityToHitCalc_StandardMelee';
	Template.AbilityToHitCalc = StandardMelee;
	
	MeleeTarget = new class'X2AbilityTarget_MovingMelee';
	Template.AbilityTargetStyle = MeleeTarget;
	Template.TargetingMethod = class'X2TargetingMethod_MeleePath';

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	Template.AbilityTriggers.AddItem(new class'X2AbilityTrigger_EndOfMove');

	// Target Conditions
	//
	Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);
	Template.AbilityTargetConditions.AddItem(default.MeleeVisibilityCondition);

	// Shooter Conditions
	//
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	SkipExclusions.AddItem(class'X2StatusEffects'.default.BurningName);
	Template.AddShooterEffectExclusions(SkipExclusions);
	
	// Add missing animation sequences
	// HL_TeleportStart HL_TeleportStop
	AnimSets = new class'X2Effect_AdditionalAnimSets';
	AnimSets.AddAnimSetWithPath("MusashAnimations.Anims.AS_VoidStrike");
	AnimSets.BuildPersistentEffect(1, false, false, false);
	AnimSets.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, false, , Template.AbilitySourceName);
	Template.AddShooterEffect(AnimSets);

	// Do not trigger overwatch
	ShadowStepEffect = new class'X2Effect_Persistent';
	ShadowStepEffect.EffectName = 'Shadowstep';
	ShadowStepEffect.DuplicateResponse = eDupe_Ignore;
	ShadowStepEffect.BuildPersistentEffect(1, false, false);
	ShadowStepEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage,false,,Template.AbilitySourceName);
	Template.AddShooterEffect(ShadowStepEffect);

	// One addition action point for reaper
	VoidReaperEffect = new class'Musashi_Effect_VoidStrikeReaper';
	VoidReaperEffect.EffectName = 'VoidReaper';
	VoidReaperEffect.BuildPersistentEffect(1, false, false);
	VoidReaperEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage,false,,Template.AbilitySourceName);
	Template.AddShooterEffect(VoidReaperEffect);

	// Damage Effect
	//
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.bBypassShields = true;
	WeaponDamageEffect.bIgnoreArmor = true;
	Template.AddTargetEffect(WeaponDamageEffect);
	
	Template.bAllowBonusWeaponEffects = true;
	Template.bSkipMoveStop = true;
	
	// Voice events
	//
	Template.SourceMissSpeech = 'SwordMiss';

	Template.ModifyNewContextFn = Teleport_ModifyActivatedAbilityContext;
	Template.BuildNewGameStateFn = Teleport_BuildGameState;
	Template.BuildVisualizationFn = Teleport_BuildVisualization;

	return Template;
}

static simulated function Teleport_ModifyActivatedAbilityContext(XComGameStateContext Context)
{
	local XComGameState_Unit UnitState;
	local XComGameStateContext_Ability AbilityContext;
	local XComGameStateHistory History;
	local PathPoint NextPoint, EmptyPoint;
	local PathingInputData InputData;
	local XComWorldData World;
	local vector NewLocation;
	local TTile NewTileLocation;
	local array<TTile> PathTiles;

	History = `XCOMHISTORY;
	World = `XWORLD;
	
	AbilityContext = XComGameStateContext_Ability(Context);
	`assert(AbilityContext.InputContext.TargetLocations.Length > 0);
	
	UnitState = XComGameState_Unit(History.GetGameStateForObjectID(AbilityContext.InputContext.SourceObject.ObjectID));
	
	// Build the MovementData for the path
	// First posiiton is the current location
	InputData.MovementTiles.AddItem(UnitState.TileLocation);
	
	NextPoint.Position = World.GetPositionFromTileCoordinates(UnitState.TileLocation);
	NextPoint.Traversal = eTraversal_Teleport;
	NextPoint.PathTileIndex = 0;
	InputData.MovementData.AddItem(NextPoint);

	if(`PRES.GetTacticalHUD().GetTargetingMethod().GetPreAbilityPath(PathTiles))
	{
		NewTileLocation = PathTiles[PathTiles.Length - 1];
		NewLocation = World.GetPositionFromTileCoordinates(NewTileLocation);
	}
	else
	{
		NewTileLocation = XComTacticalController(`PRES.GetTacticalHUD().PC).m_kPathingPawn.LastDestinationTile;
		NewLocation = World.GetPositionFromTileCoordinates(NewTileLocation);
	}

	NextPoint = EmptyPoint;
	NextPoint.Position = NewLocation;
	NextPoint.Traversal = eTraversal_Landing;
	NextPoint.PathTileIndex = 1;
	InputData.MovementData.AddItem(NextPoint);
	InputData.MovementTiles.AddItem(NewTileLocation);
	
    //Now add the path to the input context
	InputData.MovingUnitRef = UnitState.GetReference();
	AbilityContext.InputContext.MovementPaths.Length = 0;
	AbilityContext.InputContext.MovementPaths.AddItem(InputData);
}

static simulated function XComGameState Teleport_BuildGameState(XComGameStateContext Context)
{
	local XComGameState NewGameState;
	local XComGameState_Unit UnitState;
	local XComGameStateContext_Ability AbilityContext;
	local vector NewLocation;
	local TTile NewTileLocation;
	local XComWorldData World;
	local X2EventManager EventManager;
	local int LastElementIndex;

	World = `XWORLD;
	EventManager = `XEVENTMGR;

	//Build the new game state frame
	NewGameState = TypicalAbility_BuildGameState(Context);

	AbilityContext = XComGameStateContext_Ability(NewGameState.GetContext());	
	UnitState = XComGameState_Unit(NewGameState.ModifyStateObject(class'XComGameState_Unit', AbilityContext.InputContext.SourceObject.ObjectID));

	LastElementIndex = AbilityContext.InputContext.MovementPaths[0].MovementData.Length - 1;

	// Set the unit's new location
	// The last position in MovementData will be the end location
	`assert(LastElementIndex > 0);
	NewLocation = AbilityContext.InputContext.MovementPaths[0].MovementData[LastElementIndex].Position;
	NewTileLocation = World.GetTileCoordinatesFromPosition(NewLocation);
	UnitState.SetVisibilityLocation(NewTileLocation);

	AbilityContext.ResultContext.bPathCausesDestruction = MoveAbility_StepCausesDestruction(UnitState, AbilityContext.InputContext, 0, AbilityContext.InputContext.MovementPaths[0].MovementTiles.Length - 1);
	MoveAbility_AddTileStateObjects(NewGameState, UnitState, AbilityContext.InputContext, 0, AbilityContext.InputContext.MovementPaths[0].MovementTiles.Length - 1);

	EventManager.TriggerEvent('ObjectMoved', UnitState, UnitState, NewGameState);
	EventManager.TriggerEvent('UnitMoveFinished', UnitState, UnitState, NewGameState);

	return NewGameState;
}

function Teleport_BuildVisualization(XComGameState VisualizeGameState)
{
	XComGameStateContext_Ability(VisualizeGameState.GetContext()).InputContext.MovementPaths.Remove(1, 1);
	TypicalAbility_BuildVisualization(VisualizeGameState);
}
