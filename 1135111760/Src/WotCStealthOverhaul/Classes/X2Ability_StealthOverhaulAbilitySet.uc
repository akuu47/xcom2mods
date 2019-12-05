class X2Ability_StealthOverhaulAbilitySet  extends X2Ability config(StealthOverhaul);

var config bool SILENT_TAKEDOWN_SHOW_GHOST_EFFECT;
var config int SILENT_TAKEDOWN_DURATION;
var config int SILENT_TAKEDOWN_CRITICAL_HIT_BONUS;
var config int SILENT_TAKEDOWN_CRITICAL_DMG_BONUS;
var config int SILENT_TAKEDOWN_CHARGES;
var config int SILENT_TAKEDOWN_COOLDOWN;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	Templates.AddItem(SilentKillPassive());
	Templates.AddItem(SilentTakedown());

	return Templates;
}

static function X2AbilityTemplate SilentKillPassive()
{
	local X2AbilityTemplate						Template;
	local X2Effect_SilentKill					Effect;
	local X2AbilityTrigger_EventListener		Trigger;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'SilentKillPassive');

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_shadow";
	Template.bDisplayInUITacticalText = false;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	Trigger = new class'X2AbilityTrigger_EventListener';
	Trigger.ListenerData.Deferral = ELD_Immediate;
	Trigger.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self;
	Trigger.ListenerData.EventID = 'EffectEnterUnitConcealment';
	Template.AbilityTriggers.AddItem(Trigger);

	Effect = new class'X2Effect_SilentKill';
	Effect.BuildPersistentEffect(1, true, false);
	Template.AddTargetEffect(Effect);

	//Template.AddTargetEffect(ShadowAnimEffect());

	Template.bSkipFireAction = true;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	return Template;
}

static function X2Effect ShadowAnimEffect()
{
	local X2Effect_AdditionalAnimSets			Effect;

	Effect = new class'X2Effect_AdditionalAnimSets';
	Effect.EffectName = 'ShadowAnims';
	Effect.DuplicateResponse = eDupe_Ignore;
	Effect.BuildPersistentEffect(1, true, true, false, eGameRule_PlayerTurnEnd);
	Effect.bRemoveWhenTargetConcealmentBroken = true;
	Effect.AddAnimSetWithPath("Reaper.Anims.AS_ReaperShadow");

	return Effect;
}

//---------------------------------------------------------------------------------------------------
// Silent Takedown
//---------------------------------------------------------------------------------------------------
static function X2AbilityTemplate SilentTakedown()
{
	local X2AbilityTemplate						Template;
	local X2Effect_MaxDetectionModifier			NoDetectionRadiusEffect;
	local X2AbilityCharges						Charges;
	local X2ConditionConcealed					ConcealedCondition;
	local X2Effect_SilentMelee					SilentMeleeEffect;
	local X2Effect_ToHitModifier				CriticalEffect;
	local X2Effect_MeleeCriticalDamage			DamageEffect;
	local X2AbilityCooldown						Cooldown;
	local int									CritDamageBonus, CritChanceBonus;
	local X2Effect_SilentKill					Effect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'SilentTakedown');

	Template.bDisplayInUITooltip = true;
	Template.bDisplayInUITacticalText = true;
	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_AlwaysShow;
	Template.IconImage = "img:///StealthOverhaulUILibrary.UIPerk_takedown";
	Template.AbilityConfirmSound = "TacticalUI_Activate_Ability_Wraith_Armor";
	Template.bHideOnClassUnlock = true;
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_SQUADDIE_PRIORITY;
	Template.bIsPassive = true;

	Template.AbilityCosts.AddItem(default.FreeActionCost);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.SILENT_TAKEDOWN_COOLDOWN;
	Template.AbilityCooldown = Cooldown;

	CritChanceBonus = default.SILENT_TAKEDOWN_CRITICAL_HIT_BONUS;
	CritDamageBonus = default.SILENT_TAKEDOWN_CRITICAL_DMG_BONUS;

	if (default.SILENT_TAKEDOWN_CHARGES > 0)
	{
		Template.AbilityCosts.AddItem(new class'X2AbilityCost_Charges');
 		Charges = new class'X2AbilityCharges';
		Charges.InitialCharges = default.SILENT_TAKEDOWN_CHARGES; 
		Template.AbilityCharges = Charges;
	}
	
	ConcealedCondition = new class'X2ConditionConcealed';
	Template.AbilityTargetConditions.AddItem(ConcealedCondition);

	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	// No detection radius effect
	NoDetectionRadiusEffect = new class'X2Effect_MaxDetectionModifier';
	NoDetectionRadiusEffect.EffectName = 'MusashiTakedownNoDetectionRadius';
	NoDetectionRadiusEffect.BuildPersistentEffect(default.SILENT_TAKEDOWN_DURATION, false, true, false, eGameRule_PlayerTurnEnd);
	NoDetectionRadiusEffect.bRemoveWhenTargetConcealmentBroken = true;
	NoDetectionRadiusEffect.DuplicateResponse = eDupe_Refresh;
	Template.AddTargetEffect(NoDetectionRadiusEffect);

	SilentMeleeEffect = new class'X2Effect_SilentMelee';
	SilentMeleeEffect.BuildPersistentEffect(default.SILENT_TAKEDOWN_DURATION, false, true, false, eGameRule_PlayerTurnEnd);
	SilentMeleeEffect.DuplicateResponse = eDupe_Allow;
	SilentMeleeEffect.bRemoveWhenTargetConcealmentBroken = true;
	Template.AddTargetEffect(SilentMeleeEffect);

	Effect = new class'X2Effect_SilentKill';
	Effect.BuildPersistentEffect(default.SILENT_TAKEDOWN_DURATION, false, true, false, eGameRule_PlayerTurnEnd);
	Template.AddTargetEffect(Effect);

	// Bonus Crit Chance
	CriticalEffect = new class'X2Effect_ToHitModifier';
	CriticalEffect.EffectName = 'SilentTakedownCriticalEffect';
	CriticalEffect.BuildPersistentEffect(default.SILENT_TAKEDOWN_DURATION, false, true, false, eGameRule_PlayerTurnEnd);
	CriticalEffect.bRemoveWhenTargetConcealmentBroken = true;
	CriticalEffect.DuplicateResponse = eDupe_Ignore;
	CriticalEffect.AddEffectHitModifier(eHit_Crit, CritChanceBonus, Template.LocFriendlyName, class'X2AbilityToHitCalc_StandardMelee', true, false);
	Template.AddTargetEffect(CriticalEffect);

	//increase damage on critical hit
	DamageEffect = new class'X2Effect_MeleeCriticalDamage';
	DamageEffect.EffectName = 'SilentTakedownCriticalDamageBonus';
	DamageEffect.BonusDamage = CritDamageBonus;
	DamageEffect.DuplicateResponse = eDupe_Ignore;
	DamageEffect.BuildPersistentEffect(default.SILENT_TAKEDOWN_DURATION, false, true, false, eGameRule_PlayerTurnEnd);
	DamageEffect.bRemoveWhenTargetConcealmentBroken = true;
	Template.AddTargetEffect(DamageEffect);

	Template.bShowActivation = true;
	Template.bSkipFireAction = true;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	if (default.SILENT_TAKEDOWN_SHOW_GHOST_EFFECT) {
		Template.BuildVisualizationFn = SilentTakedown_BuildVisualization;
	} else {
		Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	}
	Template.bCrossClassEligible = false;

	return Template;
}


simulated function SilentTakedown_BuildVisualization(XComGameState VisualizeGameState)
{
	local XComGameStateHistory			History;
	local XComGameStateContext_Ability	Context;
	local StateObjectReference			InteractingUnitRef;
	local XComGameState_Unit			UnitState;
	local VisualizationActionMetadata   BuildData;

	History = `XCOMHISTORY;

	Context = XComGameStateContext_Ability(VisualizeGameState.GetContext());
	InteractingUnitRef = Context.InputContext.SourceObject;

	UnitState = XComGameState_Unit(History.GetGameStateForObjectID(InteractingUnitRef.ObjectID));
	BuildData.StateObject_OldState = UnitState;
	BuildData.StateObject_NewState = UnitState;
	BuildData.VisualizeActor = UnitState.GetVisualizer();
	class'X2Action_Conceal'.static.AddToVisualizationTree(BuildData, VisualizeGameState.GetContext());
}
