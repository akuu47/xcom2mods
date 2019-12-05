class RM_SPARKTechs_AbilitySet extends X2Ability;

static function array<X2DataTemplate> CreateTemplates() 
{
	local array<X2DataTemplate> Templates;
	class'RM_SPARKTechs_Helpers'.static.SetValues();

	Templates.AddItem(RMGrimyMayhem('RMGrimyMayhem', "img:///UILibrary_PerkIcons.UIPerk_mayhem"));
	Templates.Additem(RMGrimyCloseCombat('RMGrimyCloseCombat', "img:///UILibrary_PerkIcons.UIPerk_closecombatspecialist"));
	Templates.AddItem(UtilityRigging());
	Templates.AddItem(PCSAdaptation());
	Templates.AddItem(SPARKShields());
	Templates.AddItem(HeavyWeaponStorage());
	Templates.AddItem(AutomatedThreatAssessment());
	Templates.AddItem(BerserkerGauntlet('BerserkerGauntlet', "img:///UILibrary_PerkIcons.UIPerk_kinetic_strike"));
	Templates.AddItem(NanomachinesSon());
	Templates.AddItem(SuppressionProtocol('SuppressionProtocol', "img:///UILibrary_PerkIcons.UIPerk_Suppression"));
	Templates.AddItem(AddSPARKPunchAbility());
	Templates.AddItem(SparkSUPPRESSION());
	//item granted abilites

	Templates.AddItem(HyperReactiveRounds());
	Templates.AddItem(ShieldHardener());
	Templates.AddItem(HardenerShield());
	Templates.AddItem(NanoweaveBonus());
	Templates.AddItem(NanoweavePassive());
	Templates.AddItem(CodexModuleBonus());

	return Templates;
}


static function X2AbilityTemplate SPARKSuppression()
{
	local X2AbilityTemplate                 Template;	
	local X2AbilityCost_Ammo                AmmoCost;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2Effect_ReserveActionPoints      ReserveActionPointsEffect;
	local X2Effect_Suppression              SuppressionEffect;
	local X2Effect_ApplyWeaponDamage						WeaponDamageEffect;
	local X2Condition_AbilityProperty						AbilityCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'RM_Suppression');

	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_supression";
	
	AmmoCost = new class'X2AbilityCost_Ammo';	
	AmmoCost.iAmmo = 2;
	Template.AbilityCosts.AddItem(AmmoCost);
	
	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.bConsumeAllPoints = true;   //  this will guarantee the unit has at least 1 action point
	ActionPointCost.bFreeCost = true;           //  ReserveActionPoints effect will take all action points away
	Template.AbilityCosts.AddItem(ActionPointCost);
	
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	
	Template.AddShooterEffectExclusions();
	
	ReserveActionPointsEffect = new class'X2Effect_ReserveActionPoints';
	ReserveActionPointsEffect.ReserveType = 'Suppression';
	Template.AddShooterEffect(ReserveActionPointsEffect);

	Template.AbilityToHitCalc = default.DeadEye;	
	Template.AbilityTargetConditions.AddItem(default.LivingHostileUnitDisallowMindControlProperty);
	Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);
	Template.AbilityTargetStyle = default.SimpleSingleTarget;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	SuppressionEffect = new class'X2Effect_Suppression';
	SuppressionEffect.BuildPersistentEffect(1, false, true, false, eGameRule_PlayerTurnBegin);
	SuppressionEffect.bRemoveWhenTargetDies = true;
	SuppressionEffect.bRemoveWhenSourceDamaged = true;
	SuppressionEffect.bBringRemoveVisualizationForward = true;
	SuppressionEffect.SetDisplayInfo(ePerkBuff_Penalty, Template.LocFriendlyName, class'X2Ability_GrenadierAbilitySet'.default.SuppressionTargetEffectDesc, Template.IconImage);
	SuppressionEffect.SetSourceDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, class'X2Ability_GrenadierAbilitySet'.default.SuppressionSourceEffectDesc, Template.IconImage);
	Template.AddTargetEffect(SuppressionEffect);
	Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());
	

	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.bIgnoreBaseDamage = true;
	WeaponDamageEffect.EffectDamageValue.Damage = class'X2DownloadableContentInfo_MetalOverFleshRedux'.default.MAYHEM_DMG;
	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('RMGrimyMayhem');
	WeaponDamageEffect.TargetConditions.AddItem(AbilityCondition);
	Template.AddTargetEffect(WeaponDamageEffect);

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_LIEUTENANT_PRIORITY;
	Template.bDisplayInUITooltip = false;
	Template.AdditionalAbilities.AddItem('SuppressionShot');
	Template.bIsASuppressionEffect = true;
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";
	Template.TargetingMethod = class'X2TargetingMethod_OverTheShoulder';

	Template.AssociatedPassives.AddItem('HoloTargeting');

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = SuppressionBuildVisualization;
	Template.BuildAppliedVisualizationSyncFn = SuppressionBuildVisualizationSync;
	Template.CinescriptCameraType = "StandardSuppression";

	Template.Hostility = eHostility_Offensive;

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;
//BEGIN AUTOGENERATED CODE: Template Overrides 'Suppression'
	Template.bFrameEvenWhenUnitIsHidden = true;
//END AUTOGENERATED CODE: Template Overrides 'Suppression'
	Template.DefaultSourceItemSlot = eInvSlot_PrimaryWeapon;
	Template.Requirements.RequiredTechs.AddItem('SPARKSuppression');


	return Template;	
}

simulated function SuppressionBuildVisualization(XComGameState VisualizeGameState)
{
	local XComGameStateHistory History;
	local XComGameStateContext_Ability  Context;
	local StateObjectReference          InteractingUnitRef;

	local VisualizationActionMetadata        EmptyTrack;
	local VisualizationActionMetadata        ActionMetadata;

	local XComGameState_Ability         Ability;
	local X2Action_PlaySoundAndFlyOver SoundAndFlyOver;
  
	// Variables for Issue #45
	local XComGameState_Item	SourceWeapon;
	local XGWeapon						WeaponVis;
    local XComUnitPawn					UnitPawn;
	local XComWeapon					Weapon;
	//local XComGameState_Unit			UnitState;
	History = `XCOMHISTORY;

	Context = XComGameStateContext_Ability(VisualizeGameState.GetContext());
	InteractingUnitRef = Context.InputContext.SourceObject;
	//UnitState = XComGameState_Unit(History.GetGameStateForObjectID(InteractingUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1));
	//Configure the visualization track for the shooter
	//****************************************************************************************
	ActionMetadata = EmptyTrack;
	ActionMetadata.StateObject_OldState = History.GetGameStateForObjectID(InteractingUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
	ActionMetadata.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(InteractingUnitRef.ObjectID);
	ActionMetadata.VisualizeActor = History.GetVisualizer(InteractingUnitRef.ObjectID);
  
	// Start Issue #45
  // Check the actor's pawn and weapon, see if they can play the suppression effect
	Ability = XComGameState_Ability(History.GetGameStateForObjectID(Context.InputContext.AbilityRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1));
	SourceWeapon = XComGameState_Item(History.GetGameStateForObjectID(Ability.SourceWeapon.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1));
	WeaponVis = XGWeapon(SourceWeapon.GetVisualizer());

	UnitPawn = XGUnit(ActionMetadata.VisualizeActor).GetPawn();
	Weapon = WeaponVis.GetEntity();
	if (
		Weapon != None &&
		!UnitPawn.GetAnimTreeController().CanPlayAnimation(Weapon.WeaponSuppressionFireAnimSequenceName) &&
		!UnitPawn.GetAnimTreeController().CanPlayAnimation(class'XComWeapon'.default.WeaponSuppressionFireAnimSequenceName))
	{
		// The unit can't play their weapon's suppression effect. Replace it with the normal fire effect so at least they'll look like they're shooting
		Weapon.WeaponSuppressionFireAnimSequenceName = Weapon.WeaponFireAnimSequenceName;
	}
  
  // End Issue #45
	
	class'X2Action_ExitCover'.static.AddToVisualizationTree(ActionMetadata, Context, false, ActionMetadata.LastActionAdded);
	class'X2Action_StartSuppression'.static.AddToVisualizationTree(ActionMetadata, Context, false, ActionMetadata.LastActionAdded);
		//****************************************************************************************
	//Configure the visualization track for the target
	InteractingUnitRef = Context.InputContext.PrimaryTarget;
	// Ability = XComGameState_Ability(History.GetGameStateForObjectID(Context.InputContext.AbilityRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1)); issue #45, collect earlier
	ActionMetadata = EmptyTrack;
	ActionMetadata.StateObject_OldState = History.GetGameStateForObjectID(InteractingUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
	ActionMetadata.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(InteractingUnitRef.ObjectID);
	ActionMetadata.VisualizeActor = History.GetVisualizer(InteractingUnitRef.ObjectID);
	SoundAndFlyOver = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTree(ActionMetadata, Context, false, ActionMetadata.LastActionAdded));
	SoundAndFlyOver.SetSoundAndFlyOverParameters(None, Ability.GetMyTemplate().LocFlyOverText, '', eColor_Good);
	if (XComGameState_Unit(ActionMetadata.StateObject_OldState).ReserveActionPoints.Length != 0 && XComGameState_Unit(ActionMetadata.StateObject_NewState).ReserveActionPoints.Length == 0)
	{
		SoundAndFlyOver = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTree(ActionMetadata, Context, false, ActionMetadata.LastActionAdded));
		SoundAndFlyOver.SetSoundAndFlyOverParameters(none, class'XLocalizedData'.default.OverwatchRemovedMsg, '', eColor_Good);
	}
	


}

simulated function SuppressionBuildVisualizationSync(name EffectName, XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata)
{
	local X2Action_ExitCover ExitCover;

	if (EffectName == class'X2Effect_Suppression'.default.EffectName)
	{
		ExitCover = X2Action_ExitCover(class'X2Action_ExitCover'.static.AddToVisualizationTree( ActionMetadata, VisualizeGameState.GetContext() ));
		ExitCover.bIsForSuppression = true;

		class'X2Action_StartSuppression'.static.AddToVisualizationTree( ActionMetadata, VisualizeGameState.GetContext() );
	}
}
static function X2AbilityTemplate AddSPARKPunchAbility()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2AbilityToHitCalc_StandardMelee  StandardMelee;
	local X2Effect_RM_StrikeDamage        PunchDamageEffect;
	local array<name>                       SkipExclusions;
	local X2Condition_UnitProperty			AdjacencyCondition;	
	local X2Effect_Knockback				KnockbackEffect;
	local X2Effect_ApplyWeaponDamage		WeaponDamageEffect;
	local X2Condition_AbilityProperty						AbilityCondition;
	local X2AbilityTarget_MovingMelee MeleeTarget;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'RM_Punch');

	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_AlwaysShow;
	Template.IconImage = "img:///UILibrary_DLC3Images.UIPerk_spark_strike";
	Template.bHideOnClassUnlock = false;
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_SQUADDIE_PRIORITY;
	Template.AbilityConfirmSound = "TacticalUI_SwordConfirm";
	Template.bCrossClassEligible = false;
	Template.bDisplayInUITooltip = true;
    Template.bDisplayInUITacticalText = true;
    Template.DisplayTargetHitChance = true;
	Template.bShowActivation = true;
	Template.bSkipFireAction = false;
	Template.bDontDisplayInAbilitySummary = true;
	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = false;
	Template.AbilityCosts.AddItem(ActionPointCost);
	
	StandardMelee = new class'X2AbilityToHitCalc_StandardMelee';
	Template.AbilityToHitCalc = StandardMelee;

	MeleeTarget = new class'X2AbilityTarget_MovingMelee';
	MeleeTarget.MovementRangeAdjustment = 1;
	Template.AbilityTargetStyle = MeleeTarget;

	Template.TargetingMethod = class'X2TargetingMethod_MeleePath';
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	// Target Conditions
	Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);
	Template.AbilityTargetConditions.AddItem(default.MeleeVisibilityCondition);
	AdjacencyCondition = new class'X2Condition_UnitProperty';
	AdjacencyCondition.RequireWithinRange = true;
	AdjacencyCondition.WithinRange = 144; //1.5 tiles in Unreal units, allows attacks on the diag
	Template.AbilityTargetConditions.AddItem(AdjacencyCondition);

	// Shooter Conditions
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	SkipExclusions.AddItem(class'X2StatusEffects'.default.BurningName); //not sure how this happens but ok
	Template.AddShooterEffectExclusions(SkipExclusions);
	
	// Damage Effect
	PunchDamageEffect = new class'X2Effect_RM_StrikeDamage';
	Template.AddTargetEffect(PunchDamageEffect);
	Template.bAllowBonusWeaponEffects = true;
	
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.bIgnoreBaseDamage = true;
	WeaponDamageEffect.EffectDamageValue.Damage = class'X2DownloadableContentInfo_MetalOverFleshRedux'.default.GAUNTLET_DMG;
	WeaponDamageEffect.EffectDamageValue.Pierce =  class'X2DownloadableContentInfo_MetalOverFleshRedux'.default.GAUNTLET_PIERCE;
	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('BerserkerGauntlet');
	WeaponDamageEffect.TargetConditions.AddItem(AbilityCondition);
	Template.AddTargetEffect(WeaponDamageEffect);

	Template.CustomFireAnim = 'FF_Melee';
	Template.CustomMovingFireAnim = 'MV_Melee';	

	KnockbackEffect = new class'X2Effect_Knockback';
	KnockbackEffect.KnockbackDistance = 5;
	//KnockbackEffect.bUseTargetLocation = true;
	Template.AddTargetEffect(KnockbackEffect);
	Template.bOverrideMeleeDeath = true;

	// VGamepliz matters
	Template.SourceMissSpeech = 'SwordMiss';
	Template.bSkipMoveStop = true;

	Template.BuildNewGameStateFn = TypicalMoveEndAbility_BuildGameState;
	Template.BuildInterruptGameStateFn = TypicalMoveEndAbility_BuildInterruptGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.CinescriptCameraType = "Spark_Strike";

	Template.Requirements.RequiredTechs.AddItem('SPARKGauntlet');

	return Template;
}

static function X2AbilityTemplate SuppressionProtocol(name TemplateName, string akIconImage)
{
	local X2AbilityTemplate             Template;
	local X2Effect_Persistent           PersistentEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);
	
	Template.IconImage = akIconImage;
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.bDontDisplayInAbilitySummary = true;
	Template.AbilitySourceName = 'eAbilitySource_Item';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.bIsPassive = true;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	//  This is a dummy effect so that an icon shows up in the UI.
	//  Shot and Suppression abilities make use of HoloTargetEffect().
	PersistentEffect = new class'X2Effect_Persistent';
	PersistentEffect.BuildPersistentEffect(1, true, true);
	PersistentEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.LocLongDescription, Template.IconImage, true,,Template.AbilitySourceName);
	Template.AddTargetEffect(PersistentEffect);

	//Template.AdditionalAbilities.AddItem('Suppression');

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	// Note: no visualization on purpose!

	Template.Requirements.RequiredTechs.AddItem('SPARKSuppression');

	return Template;
}


static function X2AbilityTemplate RMGrimyMayhem(name TemplateName, string akIconImage)
{
	local X2AbilityTemplate             Template;
	local X2Effect_Persistent           PersistentEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);
	
	Template.IconImage = akIconImage;
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;

	Template.AbilitySourceName = 'eAbilitySource_Item';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.bIsPassive = true;
	Template.bDontDisplayInAbilitySummary = true;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	//  This is a dummy effect so that an icon shows up in the UI.
	//  Shot and Suppression abilities make use of HoloTargetEffect().
	PersistentEffect = new class'X2Effect_Persistent';
	PersistentEffect.BuildPersistentEffect(1, true, true);
	PersistentEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.LocLongDescription, Template.IconImage, true,,Template.AbilitySourceName);
	Template.AddTargetEffect(PersistentEffect);


	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	// Note: no visualization on purpose!

	Template.Requirements.RequiredTechs.AddItem('SPARKMayhem');

	return Template;
}


static function X2AbilityTemplate BerserkerGauntlet(name TemplateName, string akIconImage)
{
	local X2AbilityTemplate             Template;
	local X2Effect_Persistent           PersistentEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);
	
	Template.IconImage = akIconImage;
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;

	Template.AbilitySourceName = 'eAbilitySource_Item';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.bIsPassive = true;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	Template.bDontDisplayInAbilitySummary = true;
	//  This is a dummy effect so that an icon shows up in the UI.
	//  Shot and Suppression abilities make use of HoloTargetEffect().
	PersistentEffect = new class'X2Effect_Persistent';
	PersistentEffect.BuildPersistentEffect(1, true, true);
	PersistentEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.LocLongDescription, Template.IconImage, true,,Template.AbilitySourceName);
	Template.AddTargetEffect(PersistentEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	// Note: no visualization on purpose!

	Template.Requirements.RequiredTechs.AddItem('SPARKGauntlet');

	return Template;
}


static function X2AbilityTemplate RMGrimyCloseCombat(name TemplateName, string akIconImage) 
{
	local X2AbilityTemplate						Template;
	local X2AbilityToHitCalc_StandardAim		StandardAim;
	local X2AbilityCost_Ammo					AmmoCost;

	local X2AbilityTrigger_EventListener	Trigger;
	local X2AbilityTrigger_EventListener			EventListener;
	local X2Effect_Persistent						BladestormTargetEffect;
	local X2Condition_UnitEffectsWithAbilitySource	BladestormTargetCondition;
	local X2Condition_Visibility					TargetVisibilityCondition;
	local X2Condition_UnitProperty					PropertyCondition;
	local X2Condition_UnitProperty					ShooterCondition;

	Template = class'X2Ability_WeaponCommon'.static.Add_StandardShot(TemplateName);

	Template.IconImage = akIconImage;
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;

	Template.AbilityCosts.length = 0;
	
	Template.bDontDisplayInAbilitySummary = true;
	AmmoCost = new class'X2AbilityCost_Ammo';
	AmmoCost.iAmmo = 1;	
	Template.AbilityCosts.AddItem(AmmoCost);
	
	StandardAim = new class'X2AbilityToHitCalc_StandardAim';
	StandardAim.bReactionFire = true;
	Template.AbilityToHitCalc = StandardAim;
	Template.AbilityToHitOwnerOnMissCalc = StandardAim;

	//  trigger on movement
	Trigger = new class'X2AbilityTrigger_EventListener';
	Trigger.ListenerData.EventID = 'ObjectMoved';
	Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
	Trigger.ListenerData.Filter = eFilter_None;
	Trigger.ListenerData.EventFn = class'XComGameState_Ability'.static.TypicalOverwatchListener;
	Template.AbilityTriggers.AddItem(Trigger);
	//  trigger on an attack
	Trigger = new class'X2AbilityTrigger_EventListener';
	Trigger.ListenerData.EventID = 'AbilityActivated';
	Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
	Trigger.ListenerData.Filter = eFilter_None;
	Trigger.ListenerData.EventFn = class'XComGameState_Ability'.static.TypicalAttackListener;
	Template.AbilityTriggers.AddItem(Trigger);

	//  it may be the case that enemy movement caused a concealment break, which made Bladestorm applicable - attempt to trigger afterwards
	EventListener = new class'X2AbilityTrigger_EventListener';
	EventListener.ListenerData.Deferral = ELD_OnStateSubmitted;
	EventListener.ListenerData.EventID = 'UnitConcealmentBroken';
	EventListener.ListenerData.Filter = eFilter_Unit;
	EventListener.ListenerData.EventFn = BladestormConcealmentListener;
	EventListener.ListenerData.Priority = 55;
	Template.AbilityTriggers.AddItem(EventListener);

	BladestormTargetEffect = new class'X2Effect_Persistent';
	BladestormTargetEffect.BuildPersistentEffect(1, false, true, true, eGameRule_PlayerTurnEnd);
	BladestormTargetEffect.EffectName = 'RMGrimyCloseCombatTarget';
	BladestormTargetEffect.bApplyOnMiss = true; //Only one chance, even if you miss (prevents crazy flailing counter-attack chains with a Muton, for example)
	Template.AddTargetEffect(BladestormTargetEffect);
	
	ShooterCondition = new class'X2Condition_UnitProperty';
	ShooterCondition.ExcludeConcealed = true;
	Template.AbilityShooterConditions.AddItem(ShooterCondition);

	Template.AbilityTargetConditions.length = 0;

	BladestormTargetCondition = new class'X2Condition_UnitEffectsWithAbilitySource';
	BladestormTargetCondition.AddExcludeEffect('RMGrimyCloseCombatTarget', 'AA_DuplicateEffectIgnored');
	Template.AbilityTargetConditions.AddItem(BladestormTargetCondition);

	Template.AbilityTargetConditions.AddItem(new class'GrimyClassRebalance_Condition_Distance');

	TargetVisibilityCondition = new class'X2Condition_Visibility';
	TargetVisibilityCondition.bRequireGameplayVisible = true;
	TargetVisibilityCondition.bRequireBasicVisibility = true;
	TargetVisibilityCondition.bDisablePeeksOnMovement = true; //Don't use peek tiles for over watch shots	
	Template.AbilityTargetConditions.AddItem(TargetVisibilityCondition);

	//Template.RequiredTechs.AddItem('SPARKCloseCombat');

	PropertyCondition = new class'X2Condition_UnitProperty';
	PropertyCondition.ExcludeFriendlyToSource = true;

	Template.AbilityTargetConditions.AddItem(PropertyCondition);
	Template.bShowActivation = true;
	Template.Requirements.RequiredTechs.AddItem('SPARKCloseCombat');
	Template.DefaultSourceItemSlot = eInvSlot_PrimaryWeapon;
	return Template;
}

static function EventListenerReturn BladestormConcealmentListener(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
	local XComGameStateContext_Ability AbilityContext;
	local XComGameState_Unit ConcealmentBrokenUnit;
	local StateObjectReference BladestormRef;
	local XComGameState_Ability BladestormState;
	local XComGameStateHistory History;

	History = `XCOMHISTORY;

	ConcealmentBrokenUnit = XComGameState_Unit(EventSource);	
	if (ConcealmentBrokenUnit == None)
		return ELR_NoInterrupt;

	//Do not trigger if the Bladestorm Ranger himself moved to cause the concealment break - only when an enemy moved and caused it.
	AbilityContext = XComGameStateContext_Ability(GameState.GetContext().GetFirstStateInEventChain().GetContext());
	if (AbilityContext != None && AbilityContext.InputContext.SourceObject != ConcealmentBrokenUnit.ConcealmentBrokenByUnitRef)
		return ELR_NoInterrupt;

	BladestormRef = ConcealmentBrokenUnit.FindAbility('RMGrimyCloseCombat');
	if (BladestormRef.ObjectID == 0)
		return ELR_NoInterrupt;

	BladestormState = XComGameState_Ability(History.GetGameStateForObjectID(BladestormRef.ObjectID));
	if (BladestormState == None)
		return ELR_NoInterrupt;
	
	BladestormState.AbilityTriggerAgainstSingleTarget(ConcealmentBrokenUnit.ConcealmentBrokenByUnitRef, false);
	return ELR_NoInterrupt;
}


static function X2AbilityTemplate UtilityRigging()
{
	local X2AbilityTemplate                 Template;
	//local X2AbilityTrigger					Trigger;
	//local X2AbilityTarget_Self				TargetStyle;
	local X2Effect_PersistentStatChange		PersistentStatChangeEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'UtilityRigging');
	
	//Template= new(None, string('UtilityRigging')) class'X2AbilityTemplate'; Template.SetTemplateName('UtilityRigging');;;
//	Template.RemoveTemplateAvailablility(Template.BITFIELD_GAMEAREA_Multiplayer);
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_fleetfoot";

	Template.AbilitySourceName = 'eAbilitySource_Item';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.bDisplayInUITacticalText = false;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	Template.bDontDisplayInAbilitySummary = true;
	// giving health here; medium plated doesn't have mitigation
	//
	PersistentStatChangeEffect = new class'X2Effect_PersistentStatChange';
	PersistentStatChangeEffect.BuildPersistentEffect(1, true, true);//(1, true, false, false, eGameRule_PlayerTurnBegin);
	PersistentStatChangeEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.LocLongDescription, Template.IconImage);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_Mobility, class'RM_SPARKTechs_Helpers'.default.MUSCLE_MOBILITY);
	Template.AddTargetEffect(PersistentStatChangeEffect);

	Template.SetUIStatMarkup(class'XLocalizedData'.default.MobilityLabel, eStat_Mobility, class'RM_SPARKTechs_Helpers'.default.MUSCLE_MOBILITY);
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	Template.Requirements.RequiredTechs.AddItem('SPARKRigging');

	return Template;
}


static function X2AbilityTemplate PCSAdaptation()
{
	local X2AbilityTemplate                 Template;
	//local X2AbilityTrigger					Trigger;
	//local X2AbilityTarget_Self				TargetStyle;
	local X2Effect_PersistentStatChange		PersistentStatChangeEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'PCSAdaptation');
	

//	Template= new(None, string('PCSAdaptation')) class'X2AbilityTemplate'; Template.SetTemplateName('PCSAdaptation');;;
//	Template.RemoveTemplateAvailablility(Template.BITFIELD_GAMEAREA_Multiplayer);
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_doubletap";

	Template.AbilitySourceName = 'eAbilitySource_Item';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	//Template.bDisplayInUITacticalText = false;

	// Add dead eye to guarantee
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	Template.bDontDisplayInAbilitySummary = true;

	// giving health here; medium plated doesn't have mitigation
	//
	PersistentStatChangeEffect = new class'X2Effect_PersistentStatChange';
	PersistentStatChangeEffect.BuildPersistentEffect(1, true, true);
	PersistentStatChangeEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.LocLongDescription, Template.IconImage);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_Offense, class'RM_SPARKTechs_Helpers'.default.AIM_POINTS);
	Template.AddTargetEffect(PersistentStatChangeEffect);

	Template.SetUIStatMarkup(class'XLocalizedData'.default.AimLabel, eStat_Offense, class'RM_SPARKTechs_Helpers'.default.AIM_POINTS);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	Template.Requirements.RequiredTechs.AddItem('SPARKPCS');

	return Template;
}

static function X2AbilityTemplate SPARKShields()
{
	local X2AbilityTemplate                 Template;
	local X2Effect_PersistentStatChange		ShieldedEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'SPARKShields');
//	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_adventshieldbearer_energyshield";

	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.AbilitySourceName = 'eAbilitySource_Item';
	Template.Hostility = eHostility_Neutral;
	Template.bDisplayInUITacticalText = false;

	// Add dead eye to guarantee
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	Template.bDontDisplayInAbilitySummary = true;

	// put the shield on self
	ShieldedEffect = new class'X2Effect_EnergyShield';
	ShieldedEffect.BuildPersistentEffect(1, true, true); //, , eGameRule_PlayerTurnEnd
	ShieldedEffect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyLongDescription(), "img:///UILibrary_PerkIcons.UIPerk_adventshieldbearer_energyshield", true);
	ShieldedEffect.AddPersistentStatChange(eStat_ShieldHP, class'RM_SPARKTechs_Helpers'.default.SHIELD_POINTS);
	ShieldedEffect.EffectRemovedVisualizationFn = OnShieldRemoved_BuildVisualization;
	Template.AddTargetEffect(ShieldedEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//Template.BuildVisualizationFn = Shielded_BuildVisualization;

	Template.Requirements.RequiredTechs.AddItem('SPARKShields');

	return Template;
}

simulated function OnShieldRemoved_BuildVisualization(XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata, const name EffectApplyResult)
{
	local X2Action_PlaySoundAndFlyOver SoundAndFlyOver;

	if (XGUnit(ActionMetadata.VisualizeActor).IsAlive())
	{
		SoundAndFlyOver = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext(), false, ActionMetadata.LastActionAdded));
		SoundAndFlyOver.SetSoundAndFlyOverParameters(None, class'XLocalizedData'.default.ShieldRemovedMsg, '', eColor_Bad, , 0.75, true);
	}
}



static function X2AbilityTemplate HeavyWeaponStorage()
{
	local X2AbilityTemplate                 Template;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'HeavyWeaponStorage');

	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_aceinthehole";

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.bIsPassive = true;
	Template.AbilityTriggers.AddItem(new class'X2AbilityTrigger_UnitPostBeginPlay');
	Template.bDontDisplayInAbilitySummary = true;
	Template.GetBonusWeaponAmmoFn = HeavyWeapon_BonusWeaponAmmo;

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	Template.Requirements.RequiredTechs.AddItem('SPARKHeavyWeapon');

	Template.bSkipFireAction = true;
	Template.bShowActivation = true;

	return Template;
}

function int HeavyWeapon_BonusWeaponAmmo(XComGameState_Unit UnitState, XComGameState_Item ItemState)
{
	local XComGameState_HeadquartersXCom XComHQ;
	local X2StrategyElementTemplateManager StratMgr;
	local X2TechTemplate TechTemplate;

	StratMgr = class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager();
	XComHQ = class'UIUtilities_Strategy'.static.GetXComHQ();
	TechTemplate = X2TechTemplate(StratMgr.FindStrategyElementTemplate('SPARKHeavyWeapon'));

	if(TechTemplate != none)
	{
		if(!XComHQ.TechTemplateIsResearched(TechTemplate))
		{
			return 0;
		}

		if(XComHQ.TechTemplateIsResearched(TechTemplate) && ItemState.InventorySlot == eInvSlot_HeavyWeapon)
		{
				return class'RM_SPARKTechs_Helpers'.default.HEAVY_CHARGES;
		}
	}


	return 0;
}

static function X2AbilityTemplate AutomatedThreatAssessment()
{
	local X2AbilityTemplate         Template;
	local RM_AutomatedThreat_Effect			DefenseEffect;
	local X2Condition_UnitValue			ValueCondition;
	local X2AbilityTrigger_EventListener	EventListener;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'AutomatedThreatAssessment');

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_threadtheneedle";

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	//Template.bIsPassive = true;

	//Template.AbilityTriggers.AddItem(new class'X2AbilityTrigger_UnitPostBeginPlay');
	EventListener = new class'X2AbilityTrigger_EventListener';
	EventListener.ListenerData.EventID = 'PlayerTurnEnded';
	EventListener.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self;
	EventListener.ListenerData.Deferral = ELD_OnStateSubmitted;
	EventListener.ListenerData.Filter = eFilter_Player;
	Template.AbilityTriggers.AddItem(EventListener);


	ValueCondition = new class'X2Condition_UnitValue';
	ValueCondition.AddCheckValue('AttacksThisTurn', 1, eCheck_LessThan);
	Template.AbilityTargetConditions.AddItem(ValueCondition);
	Template.bDontDisplayInAbilitySummary = true;
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);	

	//we do the checking in the effect now
	DefenseEffect = new class'RM_AutomatedThreat_Effect';
	DefenseEffect.BuildPersistentEffect(1, false, true, false, eGameRule_PlayerTurnEnd);
	DefenseEffect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.LocLongDescription, Template.IconImage, true,,Template.AbilitySourceName);;
	Template.AddShooterEffect(DefenseEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	Template.Requirements.RequiredTechs.AddItem('SPARKATA');

	//Template.bSkipFireAction = true;
	//Template.bShowActivation = true;


	return Template;

	//Template = PurePassive('AutomatedThreatAssessment', "img:///UILibrary_PerkIcons.UIPerk_one_for_all");

	//Template.Requirements.RequiredTechs.AddItem('SPARKATA');

	//return Template;
}


static function X2AbilityTemplate NanomachinesSon()
{
	local X2AbilityTemplate					Template;
	local X2Effect_Nanomachines		NanomachinesEffect;

	`CREATE_X2ABILITY_TEMPLATE (Template, 'NanomachinesSon');
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_repair_servos";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.Hostility = eHostility_Neutral;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;

	Template.AbilityToHitCalc = default.DeadEye;
    Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	Template.bCrossClassEligible = false;

	NanomachinesEffect = new class'X2Effect_Nanomachines';
	NanomachinesEffect.BuildPersistentEffect(1, true, false,);
	NanomachinesEffect.SetDisplayInfo (ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage,,, Template.AbilitySourceName);
	Template.AddTargetEffect(NanomachinesEffect);
	Template.bDontDisplayInAbilitySummary = true;
	Template.Requirements.RequiredTechs.AddItem('SPARKNanomachines');

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	return Template;
}


static function X2AbilityTemplate HyperReactiveRounds()
{
	local X2AbilityTemplate                 Template;	
	local X2Effect_HyperReactiveRounds		HyperReactivePupilsEffect;
	
	`CREATE_X2ABILITY_TEMPLATE(Template, 'HyperReactiveRounds');	
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_hyperactivepupils";
	Template.AbilitySourceName = 'eAbilitySource_Item';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.bDisplayInUITacticalText = false;
	Template.Hostility = eHostility_Neutral;
	Template.bIsPassive = true;
	Template.bDontDisplayInAbilitySummary = true;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);		

	HyperReactivePupilsEffect = new class'X2Effect_HyperReactiveRounds';
	HyperReactivePupilsEffect.BuildPersistentEffect(1, true, true,, eGameRule_TacticalGameStart);
	HyperReactivePupilsEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
	Template.AddTargetEffect(HyperReactivePupilsEffect);

	Template.bCrossClassEligible = false;

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

static function X2AbilityTemplate ShieldHardener()
{
	local X2AbilityTemplate                 Template;	
	local X2Effect_ShieldHarden		HyperReactivePupilsEffect;
	local X2Effect_PersistentStatChange		ShieldedEffect;
	
	`CREATE_X2ABILITY_TEMPLATE(Template, 'ShieldHardener');	
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_densesmoke";
	Template.AbilitySourceName = 'eAbilitySource_Item';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.bDisplayInUITacticalText = false;
	Template.Hostility = eHostility_Neutral;
	Template.bIsPassive = true;
	Template.bDontDisplayInAbilitySummary = true;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);		

	HyperReactivePupilsEffect = new class'X2Effect_ShieldHarden';
	HyperReactivePupilsEffect.BuildPersistentEffect(1, true, true,, eGameRule_TacticalGameStart);
	HyperReactivePupilsEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
	Template.AddTargetEffect(HyperReactivePupilsEffect);

	// put the shield on self
	ShieldedEffect = new class'X2Effect_EnergyShield';
	ShieldedEffect.BuildPersistentEffect(1, true, true); //, , eGameRule_PlayerTurnEnd
	ShieldedEffect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyLongDescription(), "img:///UILibrary_PerkIcons.UIPerk_adventshieldbearer_energyshield", true);
	ShieldedEffect.AddPersistentStatChange(eStat_ShieldHP, 1);
	ShieldedEffect.EffectRemovedVisualizationFn = OnShieldRemoved_BuildVisualization;
	Template.AddTargetEffect(ShieldedEffect);

	Template.AdditionalAbilities.AddItem('HardenerShield');

	Template.bCrossClassEligible = false;

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}


static function X2AbilityTemplate HardenerShield()
{
	local X2AbilityTemplate                 Template;	
	local X2Effect_PersistentStatChange		ShieldedEffect;
	
	`CREATE_X2ABILITY_TEMPLATE(Template, 'HardenerShield');	
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_densesmoke";
	Template.AbilitySourceName = 'eAbilitySource_Item';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.bDisplayInUITacticalText = false;
	Template.Hostility = eHostility_Neutral;
	Template.bIsPassive = true;
	Template.bDontDisplayInAbilitySummary = true;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);		

	// put the shield on self
	ShieldedEffect = new class'X2Effect_EnergyShield';
	ShieldedEffect.BuildPersistentEffect(1, true, true); //, , eGameRule_PlayerTurnEnd
	//ShieldedEffect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyLongDescription(), "img:///UILibrary_PerkIcons.UIPerk_adventshieldbearer_energyshield", true);
	ShieldedEffect.AddPersistentStatChange(eStat_ShieldHP, 1);
	ShieldedEffect.EffectRemovedVisualizationFn = OnShieldRemoved_BuildVisualization;
	Template.AddTargetEffect(ShieldedEffect);

	Template.bCrossClassEligible = false;

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

static function X2AbilityTemplate NanoweaveBonus()
{
	local X2AbilityTemplate						Template;	
	local X2AbilityTrigger_EventListener		EventListener;
	local RM_X2Effect_DamageControl				DamageControlEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'NanoweaveBonus');
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_damage_control";
	Template.AbilitySourceName = 'eAbilitySource_Item';
	Template.Hostility = eHostility_Neutral;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.AbilityToHitCalc = default.DeadEye;
    Template.AbilityTargetStyle = default.SelfTarget;
	Template.bShowActivation = true;
	Template.bSkipFireAction = true;
	//Template.bIsPassive = true;
	Template.bDisplayInUITooltip = true;
	Template.bDisplayInUITacticalText = true;
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.bDontDisplayInAbilitySummary = true;
	// Trigger on Damage
	EventListener = new class'X2AbilityTrigger_EventListener';
	EventListener.ListenerData.EventID = 'UnitTakeEffectDamage';
	EventListener.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self;
	EventListener.ListenerData.Deferral = ELD_OnStateSubmitted;
	EventListener.ListenerData.Filter = eFilter_Unit;
	Template.AbilityTriggers.AddItem(EventListener);

	DamageControlEffect = new class'RM_X2Effect_DamageControl';
	DamageControlEffect.BuildPersistentEffect(2,false,true,,eGameRule_PlayerTurnBegin);
	DamageControlEffect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
	DamageControlEffect.DuplicateResponse = eDupe_Refresh;
	Template.AddTargetEffect(DamageControlEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	Template.AdditionalAbilities.AddItem('NanoweavePassive');

	return Template;
}

static function X2AbilityTemplate NanoweavePassive()
{
	local X2AbilityTemplate                 Template;	

	Template = PurePassive('NanoweavePassive', "img:///UILibrary_PerkIcons.UIPerk_damage_control", true, 'eAbilitySource_Item');
	Template.bCrossClassEligible = false;
	Template.bDontDisplayInAbilitySummary = true;
	return Template;
}



static function X2AbilityTemplate CodexModuleBonus()
{
	local X2AbilityTemplate						Template;
	local X2Effect_CodexModule					DodgeBonus;
		
	`CREATE_X2ABILITY_TEMPLATE (Template, 'CodexModuleBonus');
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_evasion";
	Template.AbilitySourceName = 'eAbilitySource_Item';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	Template.bIsPassive = true;
	DodgeBonus = new class 'X2Effect_CodexModule';
	DodgeBonus.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
	DodgeBonus.BuildPersistentEffect(1, true);
	Template.AddTargetEffect(DodgeBonus);
	Template.bCrossClassEligible = false;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.bDontDisplayInAbilitySummary = true;
	//  No visualization

	return Template;
}