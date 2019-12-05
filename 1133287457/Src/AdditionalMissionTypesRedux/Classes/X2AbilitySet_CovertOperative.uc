class X2AbilitySet_CovertOperative extends X2Ability config(GameCore);

var config int DisablerCooldown;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	Templates.AddItem(CreateDisabler());
	Templates.AddItem(CreateNetworkStun()); //is activated by an event from the operative escort kismet

	Templates.AddItem(CreateHiddenOperative()); //bonus to certain operatives so they can remain hidden better

	return Templates;
}


static function X2AbilityTemplate CreateHiddenOperative()
{
	local X2AbilityTemplate                 Template;	
	local X2Effect_PersistentStatChange		PersistentStatChangeEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'RM_HiddenOperative');
	Template.IconImage = "img:///gfxXComIcons.NanofiberVest";  

	Template.AbilitySourceName = 'eAbilitySource_Item';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.bDisplayInUITacticalText = false;
	
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	
	// Bonus to Mobility and DetectionRange stat effects
	PersistentStatChangeEffect = new class'X2Effect_PersistentStatChange';
	PersistentStatChangeEffect.BuildPersistentEffect(1, true, false, false);
	PersistentStatChangeEffect.SetDisplayInfo(ePerkBuff_Passive, "", "", Template.IconImage, false,,Template.AbilitySourceName);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_DetectionModifier, 0.5);
	Template.AddTargetEffect(PersistentStatChangeEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;	
}

static function X2DataTemplate CreateDisabler()
{
	local X2AbilityTemplate Template;
	local X2AbilityCost_ActionPoints ActionPointCost;
	local X2Condition_UnitProperty UnitPropertyCondition;
	local X2Condition_Visibility TargetVisibilityCondition;
	local X2AbilityTarget_Single SingleTarget;
	local X2AbilityTrigger_PlayerInput InputTrigger;
	//local X2Effect_Persistent MarkedEffect;
	local X2AbilityCooldown Cooldown;
	local X2Effect_DisableWeapon DisableWeapon;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'RM_Disabler');

	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_advent_marktarget";
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.Hostility = eHostility_Offensive;

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.DisablerCooldown;
	Template.AbilityCooldown = Cooldown;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bFreeCost = false;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	// Target must be an enemy
	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeDead = true;
	UnitPropertyCondition.ExcludeFriendlyToSource = true;
	UnitPropertyCondition.RequireWithinRange = false;
	Template.AbilityTargetConditions.AddItem(UnitPropertyCondition);
	
	// Target must be visible and may NOT use squad sight
	TargetVisibilityCondition = new class'X2Condition_Visibility';
	TargetVisibilityCondition.bRequireGameplayVisible = true;
	TargetVisibilityCondition.bAllowSquadsight = false;
	Template.AbilityTargetConditions.AddItem(TargetVisibilityCondition);

	Template.AbilityToHitCalc = default.DeadEye;

	SingleTarget = new class'X2AbilityTarget_Single';
	Template.AbilityTargetStyle = SingleTarget;

	InputTrigger = new class'X2AbilityTrigger_PlayerInput';
	Template.AbilityTriggers.AddItem(InputTrigger);

	//anything located here will always occur before the stat contest
	DisableWeapon = new class'X2Effect_DisableWeapon';
	DisableWeapon.TargetConditions.AddItem(default.LivingTargetUnitOnlyProperty);
	Template.AddTargetEffect(DisableWeapon);

	Template.bShowActivation = true;
	Template.CustomFireAnim = 'HL_SignalPoint';
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.CinescriptCameraType = "Mark_Target";
	
	return Template;
}


static function X2AbilityTemplate CreateNetworkStun()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityMultiTarget_AllUnits		MultiTargetUnits;
	local X2AbilityTrigger_EventListener	Trigger;
	local X2Condition_SoldierCheck SoldierCheck;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'RM_NetworkStun');

	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_faceoff";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Defensive;

	Template.AbilityToHitCalc = default.DeadEye;

	//Trigger on kismet event
	Trigger = new class'X2AbilityTrigger_EventListener';
	Trigger.ListenerData.EventID = 'RM_NetworkStunSuccess';
	Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
	Trigger.ListenerData.Filter = eFilter_None;
	Trigger.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self;
	Template.AbilityTriggers.AddItem(Trigger);
	
	Template.AbilityTargetStyle = default.SelfTarget;
	MultiTargetUnits = new class'X2AbilityMultiTarget_AllUnits';
	//MultiTargetUnits.bUseAbilitySourceAsPrimaryTarget = true;
	MultiTargetUnits.bAcceptEnemyUnits = true;
	Template.AbilityMultiTargetStyle = MultiTargetUnits;
	//Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	//Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	//Template.AddShooterEffectExclusions();

	//Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);
	//Template.AbilityTargetConditions.AddItem(default.LivingHostileUnitDisallowMindControlProperty);
	SoldierCheck = new class'X2Condition_SoldierCheck';
	SoldierCheck.Exclude = true;
	SoldierCheck.AlsoCivs = true;
	Template.AbilityMultiTargetConditions.additem(SoldierCheck);
	//Template.AddTargetEffect(class'X2StatusEffects'.static.CreateStunnedStatusEffect(4, 100, false));
	Template.AddMultiTargetEffect(class'X2StatusEffects'.static.CreateStunnedStatusEffect(4, 100, false));

	Template.bShowActivation = true;
	Template.bSkipFireAction = true;
	Template.SourceHitSpeech = 'StunnedAlien';
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

//BEGIN AUTOGENERATED CODE: Template Overrides 'Faceoff'
	Template.bFrameEvenWhenUnitIsHidden = true;
	//Template.ActivationSpeech = 'Faceoff';
//END AUTOGENERATED CODE: Template Overrides 'Faceoff'

	return Template;
}
