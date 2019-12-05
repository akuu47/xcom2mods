//---------------------------------------------------------------------------------------
//  FILE:    Musashi_X4_AbilitySet.uc
//  AUTHOR:  Musashi  --  04/18/2016
//  PURPOSE: Defines all SpecOps Class Abilities
//           
//---------------------------------------------------------------------------------------
class Musashi_X4_AbilitySet extends X2Ability
	dependson (XComGameStateContext_Ability) config (X4);

var config int PLANT_ACTION_POINT_COST;
var config int TRIGGER_ACTION_POINT_COST;
//var config bool bBreakSquadConcealment;
var config bool bBreakIndividualConcealment;

var name PlantX4AbilityName;
var name PlantC4AbilityName;
var name PlantE4AbilityName;
var name TriggerC4AbilityName;
var name TriggerX4AbilityName;
var name TriggerE4AbilityName;
var name ExplodeC4AbilityName;
var name ExplodeX4AbilityName;
var name ExplodeE4AbilityName;
var name C4EffectName;
var name X4EffectName;
var name E4EffectName;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	Templates.AddItem(PlantExplosive(default.PlantC4AbilityName));
	Templates.AddItem(PlantExplosive(default.PlantX4AbilityName));
	Templates.AddItem(PlantExplosive(default.PlantE4AbilityName));
	Templates.AddItem(TriggerExplosive(default.TriggerC4AbilityName));
	Templates.AddItem(TriggerExplosive(default.TriggerX4AbilityName));
	Templates.AddItem(TriggerExplosive(default.TriggerE4AbilityName));
	Templates.AddItem(Explode(default.ExplodeC4AbilityName));
	Templates.AddItem(Explode(default.ExplodeX4AbilityName));
	Templates.AddItem(Explode(default.ExplodeE4AbilityName));
	return Templates;
}

//---------------------------------------------------------------------------------------------------
// PlantX4
//---------------------------------------------------------------------------------------------------
static function X2AbilityTemplate PlantExplosive(name AbilityName)
{
	local X2AbilityTemplate						Template;
	local X2AbilityTarget_Cursor				CursorTarget;
	local Musashi_Effect_PlantX4				PlantX4Effect;
	local X2AbilityCost_Ammo					AmmoCost;
	local X2Effect_AdditionalAnimSets			AnimSets;
	local X2AbilityCost_ActionPoints			ActionPointCost;

	`CREATE_X2ABILITY_TEMPLATE(Template, AbilityName);
	
	Template.AdditionalAbilities.AddItem(default.ExplodeX4AbilityName);
	
	if (default.PLANT_ACTION_POINT_COST <= 0) {
		Template.AbilityCosts.AddItem(default.FreeActionCost);
	} else {
		ActionPointCost = new class'X2AbilityCost_ActionPoints';
		ActionPointCost.iNumPoints = default.PLANT_ACTION_POINT_COST;
		ActionPointCost.bConsumeAllPoints = true;
		ActionPointCost.DoNotConsumeAllSoldierAbilities.AddItem('Salvo');
		ActionPointCost.DoNotConsumeAllSoldierAbilities.AddItem('TotalCombat');
		Template.AbilityCosts.AddItem(ActionPointCost);
	}

	AmmoCost = new class'X2AbilityCost_Ammo';
	AmmoCost.iAmmo = 1;
	Template.AbilityCosts.AddItem(AmmoCost);
	
	Template.AbilityTargetConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	
	CursorTarget = new class'X2AbilityTarget_Cursor';
	CursorTarget.bRestrictToWeaponRange = true;
	Template.AbilityTargetStyle = CursorTarget;
	
	Template.TargetingMethod = class'X2TargetingMethod_Grenade';

	Template = AddX4MultiTarget(Template);

	PlantX4Effect = new class 'Musashi_Effect_PlantX4';
	if (AbilityName == default.PlantC4AbilityName)
	{
		PlantX4Effect.ParticleEffectName = "X4Mod.ParticleEffects.P_C4_Armed";
		PlantX4Effect.EffectName = default.C4EffectName;
	}

	if (AbilityName == default.PlantX4AbilityName)
	{
		PlantX4Effect.ParticleEffectName = "X4Mod.ParticleEffects.P_X4_Armed";
		PlantX4Effect.EffectName = default.X4EffectName;
	}

	if (AbilityName == default.PlantE4AbilityName)
	{
		PlantX4Effect.ParticleEffectName = "X4Mod.ParticleEffects.P_E4_Armed";
		PlantX4Effect.EffectName = default.E4EffectName;
	}
	PlantX4Effect.BuildPersistentEffect(1, true, true, false, eGameRule_PlayerTurnBegin);
	Template.AddShooterEffect(PlantX4Effect);

	//AnimSets = new class'X2Effect_AdditionalAnimSets';
	//AnimSets.AddAnimSetWithPath("CIN_FaceMelt_ANIM.PlantBomb_insert.AS_SoldierFem");
	//AnimSets.BuildPersistentEffect(1, false, false, false);
	//AnimSets.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, false, , Template.AbilitySourceName);
	//Template.AddShooterEffect(AnimSets);
	
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_COLONEL_PRIORITY;
	Template.bUseAmmoAsChargesForHUD = true;
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_HideSpecificErrors;
	Template.HideErrors.AddItem('AA_CannotAfford_AmmoCost');
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_clusterbomb";
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";
	Template.Hostility = eHostility_Neutral;
	Template.bSilentAbility = true;

	//Template.bSkipFireAction = true;
	//Template.bShowActivation = true;
	Template.DamagePreviewFn = GrenadeDamagePreview;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	return Template;	
}

//---------------------------------------------------------------------------------------------------
// TriggerX4
//---------------------------------------------------------------------------------------------------
static function X2AbilityTemplate TriggerExplosive(name AbilityName)
{
	local X2AbilityTemplate						Template;
	local Musashi_Effect_RemoveEffects			RemoveEffect;
	local X2AbilityToHitCalc_StandardAim		StandardAim;
	local X2AbilityCost_ActionPoints			ActionPointCost;
	local Musashi_Condition_X4Planted			PlantedCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, AbilityName);
	
	if (default.TRIGGER_ACTION_POINT_COST <= 0) {
		Template.AbilityCosts.AddItem(default.FreeActionCost);
	} else {
		ActionPointCost = new class'X2AbilityCost_ActionPoints';
		ActionPointCost.iNumPoints = default.TRIGGER_ACTION_POINT_COST;
		Template.AbilityCosts.AddItem(ActionPointCost);
	}
	
	Template.AbilityTargetConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	PlantedCondition = new class'Musashi_Condition_X4Planted';
	if (AbilityName == default.TriggerC4AbilityName)
	{
		PlantedCondition.SetUnitValueName(default.C4EffectName);
	}

	if (AbilityName == default.TriggerX4AbilityName)
	{
		PlantedCondition.SetUnitValueName(default.X4EffectName);
	}

	if (AbilityName == default.TriggerE4AbilityName)
	{
		PlantedCondition.SetUnitValueName(default.E4EffectName);
	}
	Template.AbilityTargetConditions.AddItem(PlantedCondition);

	StandardAim = new class'X2AbilityToHitCalc_StandardAim';
	StandardAim.bIndirectFire = true;
	StandardAim.bGuaranteedHit = true;
	Template.AbilityToHitCalc = StandardAim;

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.TargetingMethod = class'X2TargetingMethod_TopDown';

	//if (default.bBreakSquadConcealment)
	//	Template.AddShooterEffect(new class'Musashi_Effect_BreakSquadConcealment');

	if (default.bBreakIndividualConcealment)
		Template.AddShooterEffect(new class'X2Effect_BreakUnitConcealment');

	RemoveEffect = new class'Musashi_Effect_RemoveEffects';
	if (AbilityName == default.TriggerC4AbilityName)
	{
		RemoveEffect.EffectNamesToRemove.AddItem(default.C4EffectName);
	}

	if (AbilityName == default.TriggerX4AbilityName)
	{
		RemoveEffect.EffectNamesToRemove.AddItem(default.X4EffectName);
	}

	if (AbilityName == default.TriggerE4AbilityName)
	{
		RemoveEffect.EffectNamesToRemove.AddItem(default.E4EffectName);
	}
	Template.AddTargetEffect(RemoveEffect);
	
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_COLONEL_PRIORITY + 1;
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_HideSpecificErrors;
	Template.HideErrors.AddItem('AA_NoTargets');
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_fuse";
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";
	Template.Hostility = eHostility_Neutral;
	Template.bSilentAbility = true;

	Template.bSkipFireAction = true;
	Template.bShowActivation = true;
	Template.DamagePreviewFn = GrenadeDamagePreview;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	return Template;	
}
//---------------------------------------------------------------------------------------------------
// ExplodeX4
//---------------------------------------------------------------------------------------------------
static function X2AbilityTemplate Explode(Name AbilityName)
{
	local X2AbilityTemplate					Template;
	local X2Effect_ApplyWeaponDamage		WeaponDamage;
	local X2AbilityTarget_Cursor			CursorTarget;
	local X2Condition_AbilitySourceWeapon	FriendlyFireCondition;
	local X2AbilityToHitCalc_StandardAim	StandardAim;

	`CREATE_X2ABILITY_TEMPLATE(Template, AbilityName);

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	StandardAim = new class'X2AbilityToHitCalc_StandardAim';
	StandardAim.bIndirectFire = true;
	StandardAim.bGuaranteedHit = true;
	Template.AbilityToHitCalc = StandardAim;

	CursorTarget = new class'X2AbilityTarget_Cursor';
	if (AbilityName == default.ExplodeC4AbilityName)
	{
		CursorTarget.IncreaseWeaponRange = class'Musashi_X4_Items'.default.C4_RADIUS;
	}

	if (AbilityName == default.ExplodeX4AbilityName)
	{
		CursorTarget.IncreaseWeaponRange = class'Musashi_X4_Items'.default.X4_RADIUS;
	}

	if (AbilityName == default.ExplodeE4AbilityName)
	{
		CursorTarget.IncreaseWeaponRange = class'Musashi_X4_Items'.default.E4_RADIUS;
	}
	Template.AbilityTargetStyle = CursorTarget;

	Template.AbilityTriggers.AddItem(new class'X2AbilityTrigger_Placeholder');
	Template = AddX4MultiTarget(Template);

	WeaponDamage = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamage.bExplosiveDamage = true;
	WeaponDamage.bIgnoreBaseDamage = false;
	Template.AddMultiTargetEffect(WeaponDamage);

	FriendlyFireCondition = new class'X2Condition_AbilitySourceWeapon';
	FriendlyFireCondition.CheckGrenadeFriendlyFire = true;
	Template.AbilityMultiTargetConditions.AddItem(FriendlyFireCondition);

	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_COLONEL_PRIORITY;
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_biggestbooms";
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";
	Template.bDisplayInUITacticalText = false;

	Template.FrameAbilityCameraType = eCameraFraming_Never;

	Template.bSkipFireAction = true;
	Template.bShowActivation = true;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = X4Detonation_BuildVisualization;
	Template.Hostility = eHostility_Neutral;

	return Template;	
}

function X4Detonation_BuildVisualization(XComGameState VisualizeGameState)
{
	local XComGameStateContext_Ability AbilityContext;
	local X2Action_PlayEffect EffectAction;
	//local X2Action_WaitForAbilityEffect WaitAction;
	local VisualizationActionMetadata ActionMetadata;
	local X2Action_CameraLookAt LookAtAction;
	local X2Action_Delay DelayAction;
	local X2Action_StartStopSound SoundAction;
	local XComGameState_Unit UnitState;

	AbilityContext = XComGameStateContext_Ability(VisualizeGameState.GetContext());
	TypicalAbility_BuildVisualization(VisualizeGameState);

	UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(AbilityContext.InputContext.SourceObject.ObjectID));
	ActionMetadata.StateObject_NewState = UnitState;
	ActionMetadata.VisualizeActor = UnitState.GetVisualizer();

	`LOG(GetFuncName() @ "TargetLocation" @ AbilityContext.InputContext.TargetLocations[0],, 'TacticalX4');
	
	//Do the detonation
	EffectAction = X2Action_PlayEffect(class'X2Action_PlayEffect'.static.AddToVisualizationTree(ActionMetadata, AbilityContext));
	EffectAction.EffectName = "FX_Explosion_X4.P_X4_Explosion"; //class'X2Ability_Grenades'.default.ProximityMineExplosion;
	EffectAction.EffectLocation = AbilityContext.InputContext.TargetLocations[0];
	EffectAction.EffectRotation = Rotator(vect(0, 0, 1));
	EffectAction.bWaitForCompletion = false;
	EffectAction.bWaitForCameraArrival = true;
	EffectAction.bWaitForCameraCompletion = false;
	EffectAction.CenterCameraOnEffectDuration = 2.0f;
	EffectAction.RevealFOWRadius = class'XComWorldData'.const.WORLD_StepSize * 5.0f;

	SoundAction = X2Action_StartStopSound(class'X2Action_StartStopSound'.static.AddToVisualizationTree(ActionMetadata, AbilityContext));
	SoundAction.Sound = new class'SoundCue';
	SoundAction.Sound.AkEventOverride = AkEvent'SoundX2CharacterFX.Proximity_Mine_Explosion';
	SoundAction.bIsPositional = true;
	SoundAction.vWorldPosition = AbilityContext.InputContext.TargetLocations[0];

	//Keep the camera there after things blow up
	DelayAction = X2Action_Delay(class'X2Action_Delay'.static.AddToVisualizationTree(ActionMetadata, AbilityContext));
	DelayAction.Duration = 0.5;
}

static function X2AbilityTemplate AddX4MultiTarget(X2AbilityTemplate Template)
{
	local X2Condition_UnitProperty			UnitPropertyCondition;
	local X2AbilityMultiTarget_Radius		RadiusMultiTarget;

	RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
	RadiusMultiTarget.bUseWeaponRadius = true;
	RadiusMultiTarget.bExcludeSelfAsTargetIfWithinRadius=false;
	RadiusMultiTarget.bUseWeaponBlockingCoverFlag = true;
	RadiusMultiTarget.bIgnoreBlockingCover = true;
	RadiusMultiTarget.AddAbilityBonusRadius('VolatileMix', class'X2Ability_GrenadierAbilitySet'.default.VOLATILE_RADIUS);

	Template.AbilityMultiTargetStyle = RadiusMultiTarget;

	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeDead = false;
	UnitPropertyCondition.ExcludeFriendlyToSource = false;
	UnitPropertyCondition.ExcludeHostileToSource = false;
	UnitPropertyCondition.FailOnNonUnits = false;
	Template.AbilityMultiTargetConditions.AddItem(UnitPropertyCondition);

	return Template;
}

function bool GrenadeDamagePreview(XComGameState_Ability AbilityState, StateObjectReference TargetRef, out WeaponDamageValue MinDamagePreview, out WeaponDamageValue MaxDamagePreview, out int AllowsShield)
{
	local XComGameState_Item ItemState;
	local X2GrenadeTemplate GrenadeTemplate;
	local XComGameState_Ability DetonationAbility;
	local XComGameState_Unit SourceUnit;
	local XComGameStateHistory History;
	local StateObjectReference AbilityRef;
	local array<name> Explosives;

	ItemState = AbilityState.GetSourceAmmo();

	if (ItemState == none)
		ItemState = AbilityState.GetSourceWeapon();
	if (ItemState == none)
		return false;

	GrenadeTemplate = X2GrenadeTemplate(ItemState.GetMyTemplate());
	if (GrenadeTemplate == none)
		return false;

	Explosives.AddItem('TacticalC4');
	Explosives.AddItem('TacticalX4');
	Explosives.AddItem('TacticalE4');

	if (Explosives.Find(GrenadeTemplate.DataName) == INDEX_NONE)
		return false;

	History = `XCOMHISTORY;
	SourceUnit = XComGameState_Unit(History.GetGameStateForObjectID(AbilityState.OwnerStateObject.ObjectID));

	if (GrenadeTemplate.DataName == Explosives[0])
		AbilityRef = SourceUnit.FindAbility(default.ExplodeC4AbilityName);
	
	if (GrenadeTemplate.DataName == Explosives[1])
		AbilityRef = SourceUnit.FindAbility(default.ExplodeX4AbilityName);

	if (GrenadeTemplate.DataName == Explosives[2])
		AbilityRef = SourceUnit.FindAbility(default.ExplodeE4AbilityName);
	
	DetonationAbility = XComGameState_Ability(History.GetGameStateForObjectID(AbilityRef.ObjectID));
	if (DetonationAbility == none)
		return false;

	TargetRef.ObjectID = 0;
	DetonationAbility.GetDamagePreview(TargetRef, MinDamagePreview, MaxDamagePreview, AllowsShield);
	//`LOG("GetDamagePreview for " @ DetonationAbility.GetMyTemplateName() @ MinDamagePreview.Damage @ MaxDamagePreview.Damage,, 'TacticalX4');
	return true;
}

DefaultProperties
{
	PlantC4AbilityName="MusashiPlantTacticalC4"
	PlantX4AbilityName="MusashiPlantTacticalX4"
	PlantE4AbilityName="MusashiPlantTacticalE4"
	TriggerC4AbilityName="MusashiTriggerTacticalC4"
	TriggerX4AbilityName="MusashiTriggerTacticalX4"
	TriggerE4AbilityName="MusashiTriggerTacticalE4"
	ExplodeC4AbilityName="MusashiExplodeTacticalC4"
	ExplodeX4AbilityName="MusashiExplodeTacticalX4"
	ExplodeE4AbilityName="MusashiExplodeTacticalE4"
	C4EffectName="C4_Effect"
	X4EffectName="X4_Effect"
	E4EffectName="E4_Effect"
}