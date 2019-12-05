class X2Ability_SoldierPerks extends XMBAbility config(GameData_SoldierSkills);

var config array<name> PERKS_TO_LOAD;

var config int Num_StatBoost;
var config int Aggression_Crit, Tactical_Defense, HardTarget_Dodge, AtO_Aim, BEO_Damage, Stalwart_Mod;
var config int Aggression_Scale, Tactical_Scale, HardTarget_Scale, AtO_Scale, BEO_Scale, Stalwart_Scale;
var config int Grit_Duration;
var config int Prevail_Critical, Prevail_Block;
var config int HoldTheLine_Chance, HoldTheLine_Armor, HoldTheLine_Radius, HoldTheLine_Cooldown;
var config int Resilience_Crit, Resilience_Dodge;
var config int ComeAtMe_Cooldown;
var config int CoverMe_Cooldown, GuardianAngel_Charges;
var config int BulwarkDefense_Acc, BulwarkDefense_Crit;
var config int Sprint_Cooldown, SlamFire_Cooldown, BulletTime_Charges, Blitz_Cooldown;
var config int BulletTime_Actions, BulletTime_Aim, BulletTime_Crit, BulletTime_Defense, BulletTime_Dmg, Blitz_Armor;
var config int Executioner_Crit, Executioner_Dmg;
var config int Snipe_Aim, Snipe_Crit;
var config float Snipe_Range;
var config int Blindside_CV, Blindside_MG, Blindside_BM;
var config int AimForTheHead_Dmg, PiercingShot_AimMod;
var config int ReflexShot_Charges, PiercingShot_Cooldown;
var config float DangerousGame_Mod;
var config int Stalker_Mobility, Ambuscade_Aim, Ambuscade_Defense;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;
	local int idx;

	//STATUPS
	for(idx = 0; idx < default.Num_StatBoost; ++idx)
	{
		Templates.AddItem(MobUp(idx+1));
		Templates.AddItem(HPUp(idx+1));
		Templates.AddItem(AimUp(idx+1));
		Templates.AddItem(DefUp(idx+1));
		Templates.AddItem(HackUp(idx+1));
		Templates.AddItem(WillUp(idx+1));
	}

	//INITIAL/PerkLoader
	Templates.AddItem(JackOfAllTrades());

	//LOS
	Templates.AddItem(Aggression());
	Templates.AddItem(TacticalSense());
	Templates.AddItem(HardTarget());
	Templates.AddItem(AgainstTheOdds());
	Templates.AddItem(BringEmOn());

	//COVER
	Templates.AddItem(LowProfile());
	Templates.AddItem(Precision());

	//DAMAGE TAKING
	Templates.AddItem(Grit());
	Templates.AddItem(Stalwart());
	Templates.AddItem(HoldTheLine());
	Templates.AddItem(Resilience());
	Templates.AddItem(ComeAtMe());

	//OVERWATCH
	Templates.AddItem(CoverMe());
	Templates.AddItem(GuardianAngel());
	Templates.AddItem(Vigilance());
	Templates.AddItem(VigilanceFlyover());
	Templates.AddItem(Bulwark());

	//ACTION POINTS
	Templates.AddItem(PurePassive('MNT_LightEmUp', "img:///UILibrary_PerkIcons.UIPerk_Sectopod_hailofbullets", true, 'eAbilitySource_Perk'));
	Templates.AddItem(PurePassive('MNT_Bracing', "img:///XPerkIconPack.UIPerk_move_shot", true, 'eAbilitySource_Perk'));
	Templates.AddItem(PurePassive('MNT_Fastdraw', "img:///UILibrary_PerkIcons.UIPerk_returnfire", true, 'eAbilitySource_Perk'));
	Templates.AddItem(Sprint());
	Templates.AddItem(BulletTime());
	Templates.AddItem(Blitz());
	Templates.AddItem(HitAndRun());
	Templates.AddItem(SlamFire());
	Templates.AddItem(PurePassive('MNT_Unburdened', "img:///UILibrary_PerkIcons.UIPerk_beserk", true, 'eAbilitySource_Perk'));

	//CONDITIONAL DAMAGE
	Templates.AddItem(Executioner());	
	Templates.AddItem(Blindside());
	Templates.AddItem(Decryption());
	Templates.AddItem(FastFire());
	Templates.AddItem(RedscreenRound());
	Templates.AddItem(DangerousGame());
	Templates.AddItem(PiercingShot());
	Templates.AddItem(PiercingShotBonuses());

	//STEALTH
	Templates.AddItem(Fade());
	Templates.AddItem(Stalker());	
	Templates.AddItem(Ambuscade());	

	return Templates;
}

// Jack of All Trades - hidden perk loader
static function X2AbilityTemplate JackOfAllTrades()
{
	local X2AbilityTemplate Template;
	local X2Effect_LoadPerks LoadPerks;

	LoadPerks = new class'X2Effect_LoadPerks';
	LoadPerks.AbilitiesToLoad = default.PERKS_TO_LOAD;
	
	Template = Passive('JackOfAllTrades', "img:///XPerkIconPack.UIPerk_star_x2", true, LoadPerks);

	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.bDisplayInUITacticalText = false;
	HidePerk(Template);
	
	return Template;
}

// #######################################################################################
// -------------------- STATUPS	------------------------------------------------------
// #######################################################################################

static function X2AbilityTemplate MobUp(int Amount)
{
	local X2AbilityTemplate Template;
	local X2Effect_PersistentStatChange		Effect;
	local string InternalName;

	Effect = new class'X2Effect_PersistentStatChange';
	Effect.AddPersistentStatChange(eStat_Mobility, Amount);

	InternalName = "MNT_MobUp_" $ Amount;

	Template = Passive(name(InternalName), "img:///XPerkIconPack.UIPerk_move_box", true, Effect);

	Template.LocFriendlyName="<font color='#53b45e'>Mobility Up</font>";
	Template.LocLongDescription="Increase mobility by" @ string(Amount);
	Template.LocHelpText="+Mobility.";
	Template.LocPromotionPopupText="Increases soldier mobility.";

	Template.SetUIStatMarkUp(class'XLocalizedData'.default.MobilityLabel, eStat_Mobility, Amount);

	HidePerkIcon(Template);

	return Template;
}

static function X2AbilityTemplate HPUp(int Amount)
{
	local X2AbilityTemplate Template;
	local X2Effect_PersistentStatChange		Effect;
	local string InternalName;

	Effect = new class'X2Effect_PersistentStatChange';
	Effect.AddPersistentStatChange(eStat_HP, Amount);

	InternalName = "MNT_HPUp_" $ Amount;

	Template = Passive(name(InternalName), "img:///XPerkIconPack.UIPerk_stim_box", true, Effect);

	Template.LocFriendlyName="<font color='#53b45e'>HP Up</font>";
	Template.LocLongDescription="Increase HP by" @ string(Amount);
	Template.LocHelpText="+HP.";
	Template.LocPromotionPopupText="Increases soldier HP.";

	Template.SetUIStatMarkUp(class'XLocalizedData'.default.HealthLabel, eStat_HP, Amount);


	HidePerkIcon(Template);

	return Template;
}

static function X2AbilityTemplate AimUp(int Amount)
{
	local X2AbilityTemplate Template;
	local X2Effect_PersistentStatChange		Effect;
	local string InternalName;

	Effect = new class'X2Effect_PersistentStatChange';
	Effect.AddPersistentStatChange(eStat_Offense, Amount * 3);

	InternalName = "MNT_AimUp_" $ Amount;

	Template = Passive(name(InternalName), "img:///XPerkIconPack.UIPerk_sniper_box", true, Effect);

	Template.LocFriendlyName="<font color='#53b45e'>Aim Up</font>";
	Template.LocLongDescription="Increase aim by" @ string(Amount*3);
	Template.LocHelpText="+Aim.";
	Template.LocPromotionPopupText="Increases soldier aim.";

	Template.SetUIStatMarkUp(class'XLocalizedData'.default.AimLabel, eStat_Offense, Amount*3);

	HidePerkIcon(Template);

	return Template;
}

static function X2AbilityTemplate DefUp(int Amount)
{
	local X2AbilityTemplate Template;
	local X2Effect_PersistentStatChange		Effect;
	local string InternalName;

	Effect = new class'X2Effect_PersistentStatChange';
	Effect.AddPersistentStatChange(eStat_Defense, Amount * 3);

	InternalName =  "MNT_DefUp_" $ Amount;

	Template = Passive(name(InternalName), "img:///XPerkIconPack.UIPerk_defense_box", true, Effect);
	
	Template.LocFriendlyName="<font color='#53b45e'>Defense Up</font>";
	Template.LocLongDescription="Increase defense by" @ string(Amount*3);
	Template.LocHelpText="+Defense.";
	Template.LocPromotionPopupText="Increases soldier defense.";

	HidePerkIcon(Template);
	
	Template.SetUIStatMarkUp(class'XLocalizedData'.default.DefenseLabel, eStat_Defense, Amount*3);


	return Template;
}

static function X2AbilityTemplate HackUp(int Amount)
{
	local X2AbilityTemplate Template;
	local X2Effect_PersistentStatChange		Effect;
	local string InternalName;

	Effect = new class'X2Effect_PersistentStatChange';
	Effect.AddPersistentStatChange(eStat_Hacking, Amount * 5);

	InternalName = "MNT_HackUp_" $ Amount;

	Template = Passive(name(InternalName), "img:///XPerkIconPack.UIPerk_hack_box", true, Effect);

	Template.LocFriendlyName="<font color='#53b45e'>Hack Up</font>";
	Template.LocLongDescription="Increase hack by" @ string(Amount*5);
	Template.LocHelpText="+Hack.";
	Template.LocPromotionPopupText="Increases soldier hack.";
	
	Template.SetUIStatMarkUp(class'XLocalizedData'.default.TechLabel, eStat_Hacking, Amount*5);

	HidePerkIcon(Template);

	return Template;
}

static function X2AbilityTemplate WillUp(int Amount)
{
	local X2AbilityTemplate Template;
	local X2Effect_PersistentStatChange		Effect;
	local string							InternalName;

	Effect = new class'X2Effect_PersistentStatChange';
	Effect.AddPersistentStatChange(eStat_Will, Amount * 5);

	InternalName = 'MNT_WillUp_' $ Amount;

	Template = Passive(name(InternalName), "img:///XPerkIconPack.UIPerk_mind_box", true, Effect);

	Template.LocFriendlyName="<font color='#53b45e'>Will Up</font>";
	Template.LocLongDescription="Increase will by" @ string(Amount*5);
	Template.LocHelpText="+Will.";
	Template.LocPromotionPopupText="Increases soldier will.";

	Template.SetUIStatMarkUp(class'XLocalizedData'.default.WillLabel, eStat_Will, Amount*5);

	HidePerkIcon(Template);

	return Template;
}

// #######################################################################################
// -------------------- LOS	------------------------------------------------------
// #######################################################################################

// NUMBER OF ENEMIES IN SIGHT PASSIVE
static function X2AbilityTemplate Aggression()
{
	local XMBEffect_ConditionalBonus Effect;
	local XMBValue_Visibility Value;
	 
	Value = new class'XMBValue_Visibility';
	Value.bCountEnemies = true;

	Effect = new class'XMBEffect_ConditionalBonus';
	Effect.AddToHitModifier(default.Aggression_Crit, eHit_Crit);
	Effect.ScaleValue = Value;
	Effect.ScaleMax = default.Aggression_Scale;

	return Passive('MNT_Aggression', "img:///UILibrary_PerkIcons.UIPerk_Aggression", true, Effect);
}

// NUMBER OF ENEMIES IN SIGHT PASSIVE
static function X2AbilityTemplate TacticalSense()
{
	local XMBEffect_ConditionalBonus Effect;
	local XMBValue_Visibility Value;
	 
	Value = new class'XMBValue_Visibility';
	Value.bCountEnemies = true;

	Effect = new class'XMBEffect_ConditionalBonus';
	Effect.AddToHitAsTargetModifier(-default.Tactical_Defense, eHit_Success);
	Effect.ScaleValue = Value;
	Effect.ScaleMax = default.Tactical_Scale;

	return Passive('MNT_TacticalSense', "img:///UILibrary_PerkIcons.UIPerk_TacticalSense", true, Effect);
}

// NUMBER OF ENEMIES IN SIGHT PASSIVE
static function X2AbilityTemplate AgainstTheOdds()
{
	local XMBEffect_ConditionalBonus Effect;
	local XMBValue_Visibility Value;
	 
	Value = new class'XMBValue_Visibility';
	Value.bCountEnemies = true;

	Effect = new class'XMBEffect_ConditionalBonus';
	Effect.AddToHitModifier(default.AtO_Aim, eHit_Success);
	Effect.ScaleValue = Value;
	Effect.ScaleMax = default.AtO_Scale;

	return Passive('MNT_AgainstTheOdds', "img:///XPerkIconPack.UIPerk_sniper_bullet_x2", true, Effect);
}

// NUMBER OF ENEMIES IN SIGHT PASSIVE
static function X2AbilityTemplate HardTarget()
{
	local XMBEffect_ConditionalBonus Effect;
	local XMBValue_Visibility Value;
	 
	Value = new class'XMBValue_Visibility';
	Value.bCountEnemies = true;

	Effect = new class'XMBEffect_ConditionalBonus';
	Effect.AddToHitAsTargetModifier(default.HardTarget_Dodge, eHit_Graze);
	Effect.ScaleValue = Value;
	Effect.ScaleMax = default.HardTarget_Scale;

	return Passive('MNT_HardTarget', "img:///UILibrary_PerkIcons.UIPerk_evasion", true, Effect);
}

// NUMBER OF ENEMIES IN SIGHT PASSIVE
static function X2AbilityTemplate BringEmOn()
{
	local X2Effect_BringEmOn		            DamageEffect;

	DamageEffect = new class'X2Effect_BringEmOn';
	DamageEffect.PerEnemyBoost = default.BEO_Damage;
	DamageEffect.DamageCap = default.BEO_Scale;

	return Passive('MNT_BringEmOn', "img:///UILibrary_PerkIcons.UIPerk_BringEmOn", true, DamageEffect);

}


// Stalwart - Lots of small passive bonuses based on enemies in sight
static function X2AbilityTemplate Stalwart()
{
	local XMBEffect_ConditionalBonus Effect;
	local XMBValue_Visibility Value;
	 
	Value = new class'XMBValue_Visibility';
	Value.bCountEnemies = true;

	Effect = new class'XMBEffect_ConditionalBonus';
	Effect.AddToHitModifier(default.Stalwart_Mod, eHit_Crit);
	Effect.AddToHitModifier(default.Stalwart_Mod, eHit_Success);
	Effect.AddToHitAsTargetModifier(-default.Stalwart_Mod, eHit_Success);
	Effect.AddToHitAsTargetModifier(default.Stalwart_Mod, eHit_Graze);
	Effect.ScaleValue = Value;
	Effect.ScaleMax = default.Stalwart_Scale;

	return Passive('MNT_Stalwart', "img:///UILibrary_PerkIcons.UIPerk_willtosurvive", true, Effect);
}

// #######################################################################################
// -------------------- COVER	------------------------------------------------------
// #######################################################################################

// Low Profile - Low cover counts as high cover
static function X2AbilityTemplate LowProfile()
{
	local X2Effect_LowProfile_LW			DefModifier;

	DefModifier = new class 'X2Effect_LowProfile_LW';
	
	return Passive('MNT_LowestProfile', "img:///UILibrary_PerkIcons.UIPerk_LowProfile", true, DefModifier);

}

// Precision - Treats enemy high cover as low cover and low cover as almost no cover 
static function X2AbilityTemplate Precision()
{
	local X2AbilityTemplate					Template;
	local XMBEffect_ConditionalBonus Effect, LowEffect;

	Effect = new class'XMBEffect_ConditionalBonus';
	Effect.AbilityTargetConditions.AddItem(default.FullCoverCondition);
	Effect.AddToHitModifier(class'X2AbilityToHitCalc_StandardAim'.default.HIGH_COVER_BONUS - class'X2AbilityToHitCalc_StandardAim'.default.LOW_COVER_BONUS);

	Template = Passive('MNT_Precision', "img:///UILibrary_PerkIcons.UIPerk_throughthewall", true, Effect);

	LowEffect = new class'XMBEffect_ConditionalBonus';
	LowEffect.AbilityTargetConditions.AddItem(default.HalfCoverCondition);
	LowEffect.AddToHitModifier(class'X2AbilityToHitCalc_StandardAim'.default.LOW_COVER_BONUS/2);

	AddSecondaryEffect(Template, LowEffect);

	return Template;
}

// #######################################################################################
// -------------------- OVERWATCH	------------------------------------------------------
// #######################################################################################

// Cover Me - grants boosted overwatch to target ally. [SHADOW_OPS]
static function X2AbilityTemplate CoverMe()
{
	local X2AbilityTemplate Template;
	local XMBEffect_AddAbility CoolUnderPressureEffect;
	local XMBEffect_GrantReserveActionPoint ActionPointEffect;

	CoolUnderPressureEffect = new class'XMBEffect_AddAbility';
	CoolUnderPressureEffect.AbilityName = 'CoolUnderPressure';
	CoolUnderPressureEffect.BuildPersistentEffect(1, false, false, false, eGameRule_PlayerTurnBegin);
	CoolUnderPressureEffect.VisualizationFn = EffectFlyOver_Visualization;

	Template = TargetedBuff('MNT_CoverMe', "img:///XPerkIconPack.UIPerk_overwatch_sniper", true, CoolUnderPressureEffect,, eCost_SingleConsumeAll);

	ActionPointEffect = new class'XMBEffect_GrantReserveActionPoint';
	ActionPointEffect.ImmediateActionPoint = class'X2CharacterTemplateManager'.default.OverwatchReserveActionPoint;
	Template.AddTargetEffect(ActionPointEffect);

	AddCooldown(Template, default.CoverMe_Cooldown);

	return Template;
}

// Guardian Angel - free action, grant squadsight covering fire
static function X2AbilityTemplate GuardianAngel()
{
	local X2AbilityTemplate						Template;
	local XMBEffect_AddAbility					CoolUnderPressureEffect;
	local X2Effect_Squadsight					SquadsightEffect;
	local XMBEffect_GrantReserveActionPoint		ActionPointEffect;

	CoolUnderPressureEffect = new class'XMBEffect_AddAbility';
	CoolUnderPressureEffect.AbilityName = 'CoolUnderPressure';
	CoolUnderPressureEffect.BuildPersistentEffect(1, false, false, false, eGameRule_PlayerTurnBegin);
	CoolUnderPressureEffect.VisualizationFn = EffectFlyOver_Visualization;

	Template = TargetedBuff('MNT_GuardianAngel', "img:///XPerkIconPack.UIPerk_overwatch_move", true, CoolUnderPressureEffect,, eCost_Free);

	ActionPointEffect = new class'XMBEffect_GrantReserveActionPoint';
	ActionPointEffect.ImmediateActionPoint = class'X2CharacterTemplateManager'.default.OverwatchReserveActionPoint;
	Template.AddTargetEffect(ActionPointEffect);

	SquadsightEffect = new class'X2Effect_Squadsight';
	SquadsightEffect.BuildPersistentEffect(1, false, false, false, eGameRule_PlayerTurnBegin);
	Template.AddTargetEffect(SquadsightEffect);

	Template.AbilityTargetConditions.AddItem(default.HeightAdvantageCondition);
	AddCharges(Template, default.GuardianAngel_Charges);

	return Template;
}

// Vigilance - Firing will put this soldier into overwatch. [LW]
static function X2DataTemplate Vigilance()
{
	local X2AbilityTemplate							Template;
	local X2Effect_Vigilance					ActionPointEffect;

	`CREATE_X2ABILITY_TEMPLATE (Template, 'MNT_Vigilance');

	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_BurstFire";

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.Hostility = eHostility_Neutral;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.AbilityToHitCalc = default.DeadEye;
    Template.AbilityTargetStyle = default.SelfTarget;
	Template.bShowActivation = false;
	Template.bIsPassive = true;
	Template.bDisplayInUITooltip = true;
	Template.bDisplayInUITacticalText = true;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	ActionPointEffect = new class'X2Effect_Vigilance';
	ActionPointEffect.BuildPersistentEffect (1, true, false);
	ActionPointEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage,,, Template.AbilitySourceName);
	Template.AddTargetEffect(ActionPointEffect);

	Template.AdditionalAbilities.AddItem('MNT_VigilanceFlyover');

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;


	return Template;
}

static function X2DataTemplate VigilanceFlyover()
{
	local X2AbilityTemplate					Template;
	local X2AbilityTrigger_EventListener	EventListener;

	`CREATE_X2ABILITY_TEMPLATE (Template, 'MNT_VigilanceFlyover');

	Template.Hostility = eHostility_Neutral;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.bShowActivation = true;
	Template.bSkipFireAction = true;
	Template.bDontDisplayInAbilitySummary = true;

	EventListener = new class'X2AbilityTrigger_EventListener';
	EventListener.ListenerData.EventID = 'VigilanceTriggered';
	EventListener.ListenerData.Deferral = ELD_OnStateSubmitted;
	EventListener.ListenerData.Filter = eFilter_Unit;
	EventListener.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self;
	Template.AbilityTriggers.AddItem(EventListener);

	Template.CinescriptCameraType = "Overwatch";

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	return Template;
}

// Bulwark - When overwatching, grants bonus defense and crit defense to nearby squadmates
static function X2AbilityTemplate Bulwark()
{
	local XMBEffect_ConditionalBonus Effect;
	local X2AbilityTemplate Template;
	local X2AbilityMultiTarget_Radius RadiusMultiTarget;

	// Create a persistent stat change effect
	Effect = new class'XMBEffect_ConditionalBonus';
	Effect.EffectName = 'MNT_Bulwark';
	Effect.DuplicateResponse = eDupe_Refresh;
	Effect.AddToHitAsTargetModifier(default.BulwarkDefense_Acc);
	Effect.AddToHitAsTargetModifier(default.BulwarkDefense_Crit, eHit_Crit);
	Effect.BuildPersistentEffect(1, false, true,, eGameRule_PlayerTurnBegin);
	Effect.VisualizationFn = EffectFlyOver_Visualization;
	Effect.TargetConditions.AddItem(default.LivingFriendlyTargetProperty);

	Template = SelfTargetTrigger('MNT_Bulwark', "img:///UILibrary_XPACK_Common.UIPerk_bond_standbyme", true, Effect, 'OverwatchUsed');

	AddIconPassive(Template);
	RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';

	RadiusMultiTarget.fTargetRadius = 12;
	RadiusMultiTarget.bIgnoreBlockingCover = true;
	Template.AbilityMultiTargetStyle = RadiusMultiTarget;
	Template.AddMultiTargetEffect(Effect);

	Template.bShowActivation = true;
	Template.bSkipFireAction = true;

	return Template;
}

// #######################################################################################
// -------------------- ACTIONS	------------------------------------------------------
// #######################################################################################

// Sprint - Free bonus move action. [XMB]
static function X2AbilityTemplate Sprint()
{
	local X2Effect_GrantActionPoints Effect;
	local X2AbilityTemplate Template;

	Effect = new class'X2Effect_GrantActionPoints';
	Effect.NumActionPoints = 1;
	Effect.PointType = class'X2CharacterTemplateManager'.default.MoveActionPoint;

	Template = SelfTargetActivated('MNT_Sprint', "img:///XPerkIconPack.UIPerk_move_x2", true, Effect, class'UIUtilities_Tactical'.const.CLASS_LIEUTENANT_PRIORITY, eCost_Free);

	AddCooldown(Template, default.Sprint_Cooldown);

	return Template;
}

// Slam Fire - Crits refund action points [XMB]
static function X2AbilityTemplate SlamFire()
{
	local X2AbilityTemplate Template;
	local XMBEffect_AbilityCostRefund SlamFireEffect;

	// Create an effect that refunds the action point cost of abilities
	SlamFireEffect = new class'XMBEffect_AbilityCostRefund';
	SlamFireEffect.EffectName = 'SlamFire';
	SlamFireEffect.TriggeredEvent = 'SlamFire';

	SlamFireEffect.AbilityTargetConditions.AddItem(default.MatchingWeaponCondition);
	SlamFireEffect.AbilityTargetConditions.AddItem(default.CritCondition);
	SlamFireEffect.BuildPersistentEffect(1, false, true, false, eGameRule_PlayerTurnEnd);

	Template = SelfTargetActivated('MNT_SlamFire', "img:///XPerkIconPack.UIPerk_crit_plus", true, SlamFireEffect, class'UIUtilities_Tactical'.const.CLASS_COLONEL_PRIORITY, eCost_Free);

	AddCooldown(Template, default.SlamFire_Cooldown);
	class'X2Ability_RangerAbilitySet'.static.SuperKillRestrictions(Template, 'Serial_SuperKillCheck');

	return Template;
}

// Hit And Run - Gain movement after any action that didn't end turn
static function X2AbilityTemplate HitAndRun()
{
	local X2Effect_GrantActionPoints Effect;
	local X2AbilityTemplate Template;
	local XMBCondition_AbilityCost CostCondition;
	local XMBCondition_AbilityName NameCondition;

	// Add a single movement-only action point to the unit
	Effect = new class'X2Effect_GrantActionPoints';
	Effect.NumActionPoints = 1;
	Effect.PointType = class'X2CharacterTemplateManager'.default.MoveActionPoint;

	// Create a triggered ability that will activate whenever the unit uses an ability that meets the condition
	Template = SelfTargetTrigger('MNT_HitAndRun', "img:///XPerkIconPack.UIPerk_move_rifle", false, Effect, 'AbilityActivated');

	// Trigger abilities don't appear as passives. Add a passive ability icon.
	AddIconPassive(Template);

	// Require that the activated ability costs 1 action point, but actually spent at least 2
	CostCondition = new class'XMBCondition_AbilityCost';
	CostCondition.bRequireMaximumCost = true;
	CostCondition.MaximumCost = 1;
	CostCondition.bRequireMinimumPointsSpent = true;
	CostCondition.MinimumPointsSpent = 2;
	AddTriggerTargetCondition(Template, CostCondition);

	// Exclude Hunker Down
	NameCondition = new class'XMBCondition_AbilityName';
	NameCondition.ExcludeAbilityNames.AddItem('HunkerDown');
	AddTriggerTargetCondition(Template, NameCondition);

	// Show a flyover when Hit and Run is activated
	Template.bShowActivation = true;
		
	return Template;
}

// Bullet Time - Gain 4 non-movement action points, 50 aim and 50 crit. Your attacks don't end the turn, but deal 80% less damage this turn.
static function X2AbilityTemplate BulletTime()
{
	local X2Effect_GrantActionPoints	Effect;
	local X2AbilityTemplate				Template;
	local XMBEffect_ConditionalBonus	ModEffect;

	Effect = new class'X2Effect_GrantActionPoints';
	Effect.NumActionPoints = default.BulletTime_Actions;
	Effect.PointType = class'X2CharacterTemplateManager'.default.RunAndGunActionPoint;

	Template = SelfTargetActivated('MNT_BulletTime', "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_Volley", true, Effect, class'UIUtilities_Tactical'.const.CLASS_COLONEL_PRIORITY, eCost_Free);

	ModEffect = new class'XMBEffect_ConditionalBonus';
	ModEffect.EffectName = 'MNT_BulletTime';
	ModEffect.AddToHitModifier(default.BulletTime_Aim, eHit_Success);
	ModEffect.AddToHitModifier(default.BulletTime_Crit, eHit_Crit);
	ModEffect.AddToHitAsTargetModifier(-default.BulletTime_Defense, eHit_Success);
	ModEffect.AddPercentDamageModifier(default.BulletTime_Dmg);
	ModEffect.BuildPersistentEffect (1, false, true, false, eGameRule_PlayerTurnBegin);

	Template.AddTargetEffect(ModEffect);

	AddCharges(Template, default.BulletTime_Charges);

	return Template;
}

// Blitz - Charge the foe, before dealing a point-blank shot. Gain some armor until the next turn. Does not end turn, only a single action!
static function X2AbilityTemplate Blitz()
{
	local X2AbilityTemplate					Template;
	local X2Effect_ApplyWeaponDamage		DamageEffect;
	local X2Effect_PersistentStatChange		Effect;
	local X2AbilityToHitCalc_StandardMelee	ToHitCalc;
	local X2AbilityCost_Ammo				AmmoCost;

	DamageEffect = new class'X2Effect_ApplyWeaponDamage';

	Template = MeleeAttack('MNT_Blitz', "img:///UILibrary_PerkIcons.UIPerk_voidadept", true, DamageEffect, class'UIUtilities_Tactical'.const.CLASS_COLONEL_PRIORITY, eCost_Single);
	
	Effect = new class'X2Effect_PersistentStatChange';
	Effect.DuplicateResponse = eDupe_Refresh;
	Effect.AddPersistentStatChange(eStat_ArmorMitigation, default.Blitz_Armor);
	Effect.BuildPersistentEffect (1, false, true, false, eGameRule_PlayerTurnBegin);

	AddCooldown(Template, default.Blitz_Cooldown);

	AmmoCost = new class'X2AbilityCost_Ammo';
	AmmoCost.iAmmo = 1;
	Template.AbilityCosts.AddItem(AmmoCost);

	ToHitCalc = new class'X2AbilityToHitCalc_StandardMelee';
	Template.AbilityToHitCalc = ToHitCalc;

	return Template;
}


// #######################################################################################
// -------------------- DEFENSE	------------------------------------------------------
// #######################################################################################

// Grit - Gain armor upon being hit
static function X2AbilityTemplate Grit()
{
	local X2AbilityTemplate						Template;	
	local X2Effect_Grit 						GritEffect;

	GritEffect = new class'X2Effect_Grit';
	GritEffect.BuildPersistentEffect(default.Grit_Duration,false,true,,eGameRule_PlayerTurnBegin);
	GritEffect.DuplicateResponse = eDupe_Refresh;

	Template = SelfTargetTrigger('MNT_Grit', "img:///XPerkIconPack.UIPerk_defense_plus", false, GritEffect, 'UnitTakeEffectDamage');

	AddIconPassive(Template);
	
	return Template;
}

//Hold the Line - Grant 50% of bonus armor this turn
static function X2AbilityTemplate HoldTheLine()
{
	local X2Effect_PersistentStatChange Effect;
	local X2AbilityTemplate Template;
	local X2AbilityMultiTarget_Radius RadiusMultiTarget;

	Effect = new class'X2Effect_PersistentStatChange';
	Effect.EffectName = 'HoldTheLine';

	Effect.DuplicateResponse = eDupe_Refresh;
	Effect.AddPersistentStatChange(eStat_ArmorChance, default.HoldTheLine_Chance);
	Effect.AddPersistentStatChange(eStat_ArmorMitigation, default.HoldTheLine_Armor);
	Effect.TargetConditions.AddItem(default.LivingFriendlyTargetProperty);
	Effect.VisualizationFn = EffectFlyOver_Visualization;
	Effect.BuildPersistentEffect (1, false, true, false, eGameRule_PlayerTurnBegin);

	Template = SelfTargetActivated('MNT_HoldTheLine', "img:///UILibrary_PerkIcons.UIPerk_HoldTheLine", true, Effect, class'UIUtilities_Tactical'.const.CLASS_CAPTAIN_PRIORITY, eCost_Single);

	AddIconPassive(Template);

	RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
	RadiusMultiTarget.fTargetRadius = default.HoldTheLine_Radius;
	RadiusMultiTarget.bIgnoreBlockingCover = true;
	Template.AbilityMultiTargetStyle = RadiusMultiTarget;
	Template.AddMultiTargetEffect(Effect);

	AddCooldown(Template, default.HoldTheLine_Cooldown);

	return Template;
}

//Resilience - Dodge bonus + can't be crit
static function X2AbilityTemplate Resilience()
{
	local XMBEffect_ConditionalBonus Effect;

	Effect = new class'XMBEffect_ConditionalBonus';
	Effect.AddToHitAsTargetModifier(default.Resilience_Crit, eHit_Crit);
	Effect.AddToHitAsTargetModifier(default.Resilience_Dodge, eHit_Graze);

	return Passive('MNT_Resilience', "img:///UILibrary_PerkIcons.UIPerk_Resilience", true, Effect);
}

// Come at Me! - can't evade attacks, but all attacks turned into dodges.
static function X2AbilityTemplate ComeAtMe()
{
	local X2AbilityTemplate				Template;
	local XMBEffect_ConditionalBonus	ModEffect;

	ModEffect = new class'XMBEffect_ConditionalBonus';
	ModEffect.EffectName = 'MNT_BulletTime';
	ModEffect.AddToHitAsTargetModifier(50, eHit_Success);
	ModEffect.AddToHitAsTargetModifier(500, eHit_Graze);
	ModEffect.BuildPersistentEffect (1, false, true, false, eGameRule_PlayerTurnBegin);

	Template = SelfTargetActivated('MNT_ComeAtMe', "img:///UILibrary_PerkIcons.UIPerk_Beserker_Rage", true, ModEffect, class'UIUtilities_Tactical'.const.CLASS_COLONEL_PRIORITY, eCost_Free);
	AddCooldown(Template, default.ComeAtMe_Cooldown);

	return Template;
}


// #######################################################################################
// -------------------- +DAMAGE	------------------------------------------------------
// #######################################################################################


// Blindside - grants bonus damage on flank crits
static function X2AbilityTemplate Blindside()
{
	local XMBEffect_ConditionalBonus Effect;

	Effect = new class'XMBEffect_ConditionalBonus';
	Effect.AddDamageModifier(default.Blindside_CV, eHit_Crit, 'conventional');
	Effect.AddDamageModifier(default.Blindside_MG, eHit_Crit, 'magnetic');
	Effect.AddDamageModifier(default.Blindside_BM, eHit_Crit, 'beam');
	Effect.AbilityTargetConditions.AddItem(default.FlankedCondition);

	// Create the template using a helper function
	return Passive('MNT_Blindside', "img:///XPerkIconPack.UIPerk_move_sniper", false, Effect);
}

// Executioner - Grants +50 crit and +25% crit damage against biological foes that are impaired.
static function X2AbilityTemplate Executioner()
{
	local XMBEffect_ConditionalBonus			Effect;
	local X2Condition_UnitProperty				TargetProperty;

	// Create a conditional bonus
	Effect = new class'XMBEffect_ConditionalBonus';
	Effect.AddToHitModifier(default.Executioner_Crit, eHit_Crit);
	Effect.AddPercentDamageModifier(default.Executioner_Dmg, eHit_Crit);

	TargetProperty = new class 'X2Condition_UnitProperty';
	TargetProperty.ExcludeRobotic = true;
	TargetProperty.IsImpaired = true;

	Effect.AbilityTargetConditions.AddItem(TargetProperty);

	return Passive('MNT_Executioner', "img:///UILibrary_PerkIcons.UIPerk_executioner", true, Effect);
}

// Flush out - your second attack on enemies behind cover will always hit.
static function X2AbilityTemplate FlushOut()
{
	local XMBEffect_ChangeHitResultForAttacker Effect;
	local X2Condition_UnitValue ValueCondition;
	local XMBCondition_CoverType InCover;

	// Create a condition that checks a unit value. Unit values are just a way of storing a number
	// on a unit that we can change to track whatever we need.
	ValueCondition = new class'X2Condition_UnitValue';
	ValueCondition.AddCheckValue('AttacksThisTurn', 0, eCheck_GreaterThan);
	
	// Create an effect that will change attack hit results
	Effect = new class'XMBEffect_ChangeHitResultForAttacker';
	Effect.EffectName = 'FlushOut';

	InCover = new class 'XMBCondition_CoverType';
	InCover.AllowedCoverTypes.AddItem(CT_MidLevel);
	InCover.AllowedCoverTypes.AddItem(CT_Standing);

	// The effect only affects shots on covered foes
	Effect.AbilityTargetConditions.AddItem(InCover);

	// The effect only works on shots past the first made this turn
	Effect.AbilityShooterConditions.AddItem(ValueCondition);

	// Could have hit anyways, but it doesn't matter.
	Effect.bRequireMiss = false;

	// Change the hit result to a hit
	Effect.NewResult = eHit_Success;

	// Create the template using a helper function
	return Passive('Flushout', "img:///UILibrary_PerkIcons.UIPerk_advent_marktarget", true, Effect);
}


// AI Decryption - Guarantees hits on robotic enemies
static function X2AbilityTemplate Decryption()
{
	local XMBEffect_ChangeHitResultForAttacker Effect;
	local X2Condition_UnitProperty TargetProperty;

	Effect = new class'XMBEffect_ChangeHitResultForAttacker';
	Effect.EffectName = 'FlushOut';

	TargetProperty = new class 'X2Condition_UnitProperty';
	TargetProperty.ExcludeOrganic = true;

	// The effect only affects robotics
	Effect.AbilityTargetConditions.AddItem(TargetProperty);

	return Passive('MNT_Decrypted', "img:///UILibrary_PerkIcons.UIPerk_hackdrone", true, Effect);
}



// DangerousGame - Increases crit damage dealt and taken when flanking and flanked by your target
static function X2AbilityTemplate DangerousGame()
{
	local X2Effect_DangerousGame Effect;

	Effect = new class'X2Effect_DangerousGame';
	Effect.EffectName = 'MNT_DangerousGame';
	Effect.RequireCrit = true;
	Effect.DamageMod = default.DangerousGame_Mod;

	// Create the template using a helper function
	return Passive('MNT_DangerousGame', "img:///XPerkIconPack.UIPerk_enemy_shot_crit", true, Effect);
}

// Fast Fire - one charge of a free standard shot.
static function X2AbilityTemplate FastFire()
{
	local X2AbilityTemplate Template;

	// Create a standard attack that doesn't cost an action.
	Template = Attack('MNT_FastFire', "img:///UILibrary_PerkIcons.UIPerk_ammo_ap", false, none, class'UIUtilities_Tactical'.const.CLASS_SERGEANT_PRIORITY, eCost_Free, 1);

	AddCharges(Template, default.ReflexShot_Charges);

	return Template;
}

// Redscreen Round - Fires a shot that permanently reduces hack defense
static function X2AbilityTemplate RedScreenRound()
{
	local X2AbilityTemplate Template;
	local XMBEffect_PermanentStatChange HackEffect;
	local X2Condition_UnitProperty UnitPropertyCondition;

	// Create a standard attack that doesn't cost an action.
	Template = Attack('MNT_RedscreenRound', "img:///XPerkIconPack.UIPerk_hack_defense2", false, none, class'UIUtilities_Tactical'.const.CLASS_SERGEANT_PRIORITY, eCost_WeaponConsumeAll, 2);

	AddCharges(Template, 1);

	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeRobotic = false;
	UnitPropertyCondition.ExcludeOrganic = true;
		
	HackEffect = new class'XMBEffect_PermanentStatChange';
	HackEffect.AddStatChange(eStat_HackDefense, -20);
	HackEffect.TargetConditions.AddItem(UnitPropertyCondition);

	return Template;
}

// Piercing Shot - fire a shot that pierces all armor.
static function X2AbilityTemplate PiercingShot()
{
	local X2AbilityTemplate Template;

	// Create a standard attack that doesn't cost an action.
	Template = Attack('MNT_PiercingShot', "img:///UILibrary_PerkIcons.UIPerk_threadtheneedle", false, none, class'UIUtilities_Tactical'.const.CLASS_SERGEANT_PRIORITY, eCost_WeaponConsumeAll, 1);

	AddCooldown(Template, default.PiercingShot_Cooldown);

	AddSecondaryAbility(Template, PiercingShotBonuses());
	return Template;
}

static function X2AbilityTemplate PiercingShotBonuses()
{
	local X2AbilityTemplate				Template;
	local XMBEffect_ConditionalBonus	Effect;
	local XMBCondition_AbilityName		Condition;

	Effect = new class'XMBEffect_ConditionalBonus';
	Effect.EffectName = 'PiercingShotBonuses';

	Effect.AddToHitModifier(default.PiercingShot_AimMod, eHit_Success);
	Effect.AddArmorPiercingModifier(5);

	Condition = new class'XMBCondition_AbilityName';
	Condition.IncludeAbilityNames.AddItem('MNT_PiercingShot');
	Effect.AbilityTargetConditions.AddItem(Condition);

	Template = Passive('MNT_PiercingShotBonuses', "img:///UILibrary_PerkIcons.UIPerk_command", false, Effect);
	HidePerkIcon(Template);

	return Template;
}

static function X2AbilityTemplate Snipe()
{
	local X2Effect_Infighter Effect;
	 
	Effect = new class'X2Effect_Infighter';
	Effect.HitMod = default.Snipe_Aim;
	Effect.CritMod = default.Snipe_Crit;
	Effect.TileRange = default.Snipe_Range;
	Effect.bWithin = false;

	return Passive('MNT_Snipe', "img:///UILibrary_PerkIcons.UIPerk_precisionshot", true, Effect);
}

//Armor Penetrate - bonus for swords that pierces all armor
static function X2AbilityTemplate ArmorPenetrate()
{
	local X2AbilityTemplate				Template;
	local XMBEffect_ConditionalBonus	Effect;
	local XMBCondition_AbilityName		Condition;

	Effect = new class'XMBEffect_ConditionalBonus';
	Effect.EffectName = 'MNT_ArmorPenetrate';
	Effect.AddArmorPiercingModifier(99);

	Condition = new class'XMBCondition_AbilityName';
	Condition.IncludeAbilityNames.AddItem('BladestormAttack');
	Condition.IncludeAbilityNames.AddItem('KnifeFighter');
	Condition.IncludeAbilityNames.AddItem('SwordSlice');
	Effect.AbilityTargetConditions.AddItem(Condition);

	Template = Passive('MNT_ArmorPenetrate', "img:///UILibrary_PerkIcons.UIPerk_archon_beatdown", false, Effect);

	return Template;
}

// #######################################################################################
// -------------------- STEALTH	------------------------------------------------------
// #######################################################################################

// Fade - After killing a unit, gain stealth if no enemies in sight
static function X2AbilityTemplate Fade()
{
	local X2AbilityTemplate			Template;
	local X2Effect_RangerStealth	StealthEffect;
	local X2Condition_Fade			IsVisibleToEnemy;

	// Create a standard stealth effect
	StealthEffect = new class'X2Effect_RangerStealth';
	StealthEffect.BuildPersistentEffect(1, true, true, false, eGameRule_PlayerTurnEnd);
	StealthEffect.bRemoveWhenTargetConcealmentBroken = true;

	Template = SelfTargetTrigger('MNT_Fade', "img:///XPerkIconPack.UIPerk_stealth_crit2", false, StealthEffect, 'AbilityActivated');

	AddIconPassive(Template);
	// Require that the target of the ability is now dead
	AddTriggerTargetCondition(Template, default.DeadCondition);
	// Require that the unit be able to enter stealth
	Template.AbilityShooterConditions.AddItem(new class'X2Condition_Stealth');
	// Require no visible enemy in sight
	IsVisibleToEnemy = new class 'X2Condition_Fade';
	Template.AbilityShooterConditions.AddItem(IsVisibleToEnemy);
	// Add an additional effect that causes the AI to forget where the unit was
	AddSecondaryEffect(Template, class'X2Effect_Spotted'.static.CreateUnspottedEffect());

	// Have the unit say it's entering concealment
	Template.ActivationSpeech = 'ActivateConcealment';

	return Template;
}

// Stalker - Grants increased mobility in stealth
static function X2AbilityTemplate Stalker()
{
	local XMBEffect_ConditionalStatChange Effect;

	Effect = new class'XMBEffect_ConditionalStatChange';
	Effect.AddPersistentStatChange(eStat_Mobility, default.Stalker_Mobility);
	Effect.Conditions.AddItem(new class'XMBCondition_Concealed');

	return Passive('MNT_Stalker', "img:///XPerkIconPack.UIPerk_move_stealth", true, Effect);
}

// Ambuscade - gain a standard action point on concealment break, +10 aim and defense for one turn.
static function X2AbilityTemplate Ambuscade()
{
	local X2Effect_GrantActionPoints	ActEffect;
	local X2Effect_PersistentStatChange	Effect;
	local X2AbilityTemplate				Template;

	ActEffect = new class'X2Effect_GrantActionPoints';
	ActEffect.NumActionPoints = 1;
	ActEffect.PointType = class'X2CharacterTemplateManager'.default.StandardActionPoint;

	Template = SelfTargetTrigger('MNT_Ambuscade', "img:///UILibrary_PerkIcons.UIPerk_ambush", false, ActEffect, 'EffectBreakUnitConcealment');

	Effect = new class'X2Effect_PersistentStatChange';
	Effect.DuplicateResponse = eDupe_Refresh;
	Effect.AddPersistentStatChange(eStat_Offense, default.Ambuscade_Aim);
	Effect.AddPersistentStatChange(eStat_Defense, default.Ambuscade_Defense);
	Effect.BuildPersistentEffect (1, false, true, false, eGameRule_PlayerTurnBegin);

	return Template;
}