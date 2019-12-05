class X2Ability_ItemPerks extends XMBAbility config(GameData_SoldierSkills);

var config int AP_Mod, Shredder_Mod, Tracer_Mod, Impulse_Mod, Flechette_Mod;
var config float AP_Range;
var config int Stiletto_Crit, Stiletto_CritDmg;

var config int Uplinked_Hack, Uplinked_Charges;
var config int SignalBurst_Taunt, SignalBurst_Dodge;
var config int ShieldVest_Shields, ShieldVest_Regen;
var config int Etherweave_Mobility, Etherweave_Defense;
var config float Etherweave_Dmg;

var config int FirstAid_Bonus, RejuvenateHealBonus, RejuvenateWillBonus, SmokeAndMirrors_Bonus, Flashout_Bonus;
var config int RapidDeployment_Cooldown, DangerZone_Radius, HEAT_Shred, HEAT_Pierce, ShockAndAwe_Radius, ShockAndAwe_Shock, ShockAndAwe_Awe;
var config int Pathfinder_Detection, Pathfinder_Sight;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	//Ammo
	Templates.AddItem(APAmmo());
	Templates.AddItem(StilettoAmmo());
	Templates.AddItem(ShredderAmmo());
	Templates.AddItem(IncisionAmmo());
	Templates.AddItem(TracerAmmo());
	Templates.AddItem(SeekerAmmo());
	Templates.AddItem(ImpulseAmmo());
	Templates.AddItem(FlechetteAmmo());
	Templates.AddItem(ReqiuemAmmo());

	//Vests
	Templates.AddItem(UplinkedVest());
	Templates.AddItem(SignalBurst());
	Templates.AddItem(ShieldVest());
	Templates.AddItem(Etherweave());
	Templates.AddItem(EtherweavePassive());

	//Medkits
	Templates.AddItem(FirstAid());
	Templates.AddItem(SecondWind());
	Templates.AddItem(SecondWindTrigger());
	Templates.AddItem(Rejuvenate());

	//Grenades
	Templates.AddItem(RapidDeployment());
	Templates.AddItem(DangerZone());
	Templates.AddItem(FullKit());

	//Explodey Grenades
	Templates.AddItem(HEATGrenades());
	Templates.AddItem(ShockAndAwe());

	//Support Grenades
	Templates.AddItem(SmokeAndMirrors());
	Templates.AddItem(PurePassive('MNT_RestorativeSmoke', "img:///XPerkIconPack.UIPerk_smoke_medkit"));
	Templates.AddItem(Flashout());
	Templates.AddItem(Pathfinder());



	return Templates;
}

// #######################################################################################
// -------------------- AMMO PERKS	------------------------------------------------------
// #######################################################################################

static function X2AbilityTemplate APAmmo()
{
	local X2AbilityTemplate					Template;
	local XMBEffect_ConditionalBonus		Effect;
	local X2Effect_RangeMultiplier			RangeEffect;

	Effect = new class'XMBEffect_ConditionalBonus';
	Effect.AddArmorPiercingModifier(default.AP_Mod);
	
	Template = Passive('APAmmo', "img:///UILibrary_PerkIcons.UIPerk_shotlockdown", false, Effect);

	RangeEffect = new class 'X2Effect_RangeMultiplier';
	RangeEffect.RangeMultiplier = default.AP_Range;
	AddSecondaryEffect(Template, RangeEffect);

	HidePerk(Template);

	return Template;
}

static function X2AbilityTemplate StilettoAmmo()
{
	local X2AbilityTemplate					Template;
	local XMBEffect_ConditionalBonus		Effect;
	local X2Effect_RangeMultiplier			RangeEffect;

	Effect = new class'XMBEffect_ConditionalBonus';
	Effect.AddArmorPiercingModifier(default.AP_Mod, eHit_Success, 'conventional');
	Effect.AddArmorPiercingModifier(default.AP_Mod * 2, eHit_Success, 'magnetic');
	Effect.AddArmorPiercingModifier(default.AP_Mod * 3, eHit_Success, 'beam');
	Effect.AddToHitModifier(default.Stiletto_Crit, eHit_Crit);
	Effect.AddDamageModifier(default.Stiletto_CritDmg, eHit_Crit);

	Template = Passive('StilettoAmmo', "img:///UILibrary_PerkIcons.UIPerk_shotlockdown", false, Effect);

	RangeEffect = new class 'X2Effect_RangeMultiplier';
	RangeEffect.RangeMultiplier = default.AP_Range;
	AddSecondaryEffect(Template, RangeEffect);

	HidePerk(Template);
	return Template;
}

static function X2AbilityTemplate ShredderAmmo()
{
	local X2AbilityTemplate					Template;
	local XMBEffect_ConditionalBonus		Effect;

	Effect = new class'XMBEffect_ConditionalBonus';
	Effect.AddShredModifier(default.Shredder_Mod, eHit_Success);
	
	Template = Passive('ShredderAmmo', "img:///UILibrary_PerkIcons.UIPerk_shotlockdown", false, Effect);
	HidePerk(Template);

	return Template;
}

static function X2AbilityTemplate IncisionAmmo()
{
	local X2AbilityTemplate					Template;
	local XMBEffect_ConditionalBonus		Effect;

	Effect = new class'XMBEffect_ConditionalBonus';
	Effect.AddShredModifier(default.Shredder_Mod, eHit_Success, 'conventional');
	Effect.AddShredModifier(default.Shredder_Mod * 2, eHit_Success, 'magnetic');
	Effect.AddShredModifier(default.Shredder_Mod * 3, eHit_Success, 'beam');
	
	Template = Passive('IncisionAmmo', "img:///UILibrary_PerkIcons.UIPerk_shotlockdown", false, Effect);
	HidePerk(Template);

	return Template;
}

static function X2AbilityTemplate TracerAmmo()
{
	local X2AbilityTemplate					Template;
	local XMBEffect_ConditionalBonus		Effect;

	Effect = new class'XMBEffect_ConditionalBonus';
	Effect.AddToHitModifier(default.Tracer_Mod);
	
	Template = Passive('TracerAmmo', "img:///UILibrary_PerkIcons.UIPerk_shotlockdown", false, Effect);
	HidePerk(Template);

	return Template;
}

static function X2AbilityTemplate SeekerAmmo()
{
	local X2AbilityTemplate						Template;
	local XMBEffect_ConditionalBonus			Effect;
	local XMBEffect_ChangeHitResultForAttacker	PsiEffect;
	local X2Condition_UnitProperty				TargetCondition;

	Effect = new class'XMBEffect_ConditionalBonus';
	Effect.AddToHitModifier(default.Tracer_Mod, eHit_Success);
	
	Template = Passive('SeekerAmmo', "img:///UILibrary_PerkIcons.UIPerk_shotlockdown", false, Effect);
	
	TargetCondition = new class'X2Condition_UnitProperty';
	TargetCondition.ExcludePsionic = true;

	PsiEffect = new class'XMBEffect_ChangeHitResultForAttacker';
	PsiEffect.AbilityTargetConditions.AddItem(TargetCondition);
	PsiEffect.NewResult = eHit_Success;

	AddSecondaryEffect(Template, PsiEffect);
	HidePerk(Template);

	return Template;
}

static function X2AbilityTemplate FlechetteAmmo()
{
	local X2AbilityTemplate					Template;
	local X2Effect_OrganicBonusDamage		Effect;

	Effect = new class'X2Effect_OrganicBonusDamage';
	Effect.DamageMultiplier = default.Flechette_Mod;
	
	Template = Passive('FlechetteAmmo', "img:///UILibrary_PerkIcons.UIPerk_shotlockdown", false, Effect);
	HidePerk(Template);

	return Template;
}

static function X2AbilityTemplate ImpulseAmmo()
{
	local X2AbilityTemplate					Template;
	local X2Effect_ShieldBonusDamage		Effect;

	Effect = new class'X2Effect_ShieldBonusDamage';
	Effect.BreakMultiplier = default.Impulse_Mod;
	
	Template = Passive('ImpulseAmmo', "img:///UILibrary_PerkIcons.UIPerk_shotlockdown", false, Effect);
	HidePerk(Template);

	return Template;
}


static function X2AbilityTemplate ReqiuemAmmo()
{
	local X2AbilityTemplate						Template;
	local XMBEffect_ChangeHitResultForAttacker	Effect;
	local X2Condition_UnitType					TargetCondition;

	TargetCondition = new class'X2Condition_UnitType';
	TargetCondition.IncludeTypes.AddItem('TheLost');
	TargetCondition.IncludeTypes.AddItem('PsiZombie');

	Effect = new class'XMBEffect_ChangeHitResultForAttacker';
	Effect.AbilityTargetConditions.AddItem(TargetCondition);
	Effect.NewResult = eHit_Crit;
	
	Template = Passive('ReqiuemAmmo', "img:///UILibrary_PerkIcons.UIPerk_shotlockdown", false, Effect);
	HidePerk(Template);

	return Template;
}

// #######################################################################################
// -------------------- VEST PERKS	------------------------------------------------------
// #######################################################################################

//Grants +20 hacking and +1 Skulljack charge if equipped
static function X2AbilityTemplate UplinkedVest()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityTrigger					Trigger;
	local X2AbilityTarget_Self				TargetStyle;
	local X2Effect_PersistentStatChange		PersistentStatChangeEffect;
	local XMBEffect_AddItemCharges			Effect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'UplinkedVest_Passive');

	Template.AbilitySourceName = 'eAbilitySource_Item';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.bDisplayInUITacticalText = false;
	Template.AbilityToHitCalc = default.DeadEye;
	TargetStyle = new class'X2AbilityTarget_Self';
	Template.AbilityTargetStyle = TargetStyle;
	Trigger = new class'X2AbilityTrigger_UnitPostBeginPlay';
	Template.AbilityTriggers.AddItem(Trigger);
		
	PersistentStatChangeEffect = new class'X2Effect_PersistentStatChange';
	PersistentStatChangeEffect.BuildPersistentEffect(1, true, false, false);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_Hacking, default.Uplinked_Hack);
	
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	Effect = new class'XMBEffect_AddItemCharges';
	Effect.ApplyToNames.AddItem('skulljack');
	Effect.PerItemBonus = default.Uplinked_Charges;

	AddSecondaryEffect(Template, Effect);
	HidePerk(Template);

	return Template;	
}

// Taunts robotic enemies as a free action
static function X2AbilityTemplate SignalBurst()
{
	local X2AbilityTemplate                 Template;
	local X2Effect_SignalBurst Effect;

	Effect = new class'X2Effect_SignalBurst';
	Effect.TauntBoost = default.SignalBurst_Taunt;
	Effect.DodgeBoost = default.SignalBurst_Dodge;
	Effect.BuildPersistentEffect (1, false, true, false, eGameRule_PlayerTurnBegin);

	Template = SelfTargetActivated('SignalBurst', "img:///UILibrary_PerkIcons.UIPerk_shock_armor", false, Effect,,eCost_Free);
	AddCooldown(Template, 4);

	return Template;
}

// Shield Vest - +3 regenerating shields
static function X2AbilityTemplate ShieldVest()
{
	local X2Effect_ShieldVest Effect;

	Effect = new class'X2Effect_ShieldVest';
	Effect.ShieldAmount = default.ShieldVest_Shields;
	Effect.ShieldRegen = default.ShieldVest_Regen;

	return Passive('ShieldVest_Passive', "img:///UILibrary_PerkIcons.UIPerk_absorptionfields", true, Effect);
}

// Etherweave - Grants Low Profile, +1 mobility, and 10 defense, IF at full hp...
static function X2AbilityTemplate Etherweave()
{
	local X2AbilityTemplate                 Template;
	local X2Effect_LowProfile_LW			Effect;
	local X2Effect_PersistentStatChange		PersistentStatChangeEffect;
	local X2Condition_UnitStatCheck			Condition;

	Effect = new class'X2Effect_LowProfile_LW';

	Template = Passive('Etherweave_Passive', "img:///XPerkIconPack.UIPerk_medkit_plus", true, Effect);
	
	PersistentStatChangeEffect = new class'X2Effect_PersistentStatChange';
	PersistentStatChangeEffect.BuildPersistentEffect(1, true, false, false);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_Mobility, default.Etherweave_Mobility);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_Defense, default.Etherweave_Defense);

	AddSecondaryEffect(Template, PersistentStatChangeEffect);
	
	Condition = new class'X2Condition_UnitStatCheck';
	Condition.AddCheckStat(eStat_HP, 100, eCheck_Exact,,, true);

	Template.AbilityShooterConditions.AddItem(Condition);

	return Template;
}

//But take +20% damage in general. Wao.
static function X2AbilityTemplate EtherweavePassive()
{
	local X2AbilityTemplate Template;
	local X2Effect_DefendingDamage	Effect;

	Effect = new class'X2Effect_DefendingDamage';
	Effect.PercentDamage = true;
	Effect.PercentDamageMod = default.Etherweave_Dmg;

	Template = Passive('Etherweave_Damage', "img:///UILibrary_PerkIcons.UIPerk_stickandmove", true, Effect);
	HidePerk(Template);

	return Template;
}


// #######################################################################################
// -------------------- MEDKIT PERKS ----------------------------------------------------
// #######################################################################################

// First Aid - free medkit
static function X2AbilityTemplate FirstAid()
{
	local XMBEffect_AddUtilityItem Effect;

	Effect = new class'XMBEffect_AddUtilityItem';
	Effect.DataName = 'medikit';
	Effect.BaseCharges = default.FirstAid_Bonus;
	Effect.BonusCharges = default.FirstAid_Bonus;

	return Passive('MNT_FirstAid', "img:///XPerkIconPack.UIPerk_medkit_plus", true, Effect);
}


// Second Wind - healing with a medkit grants a bonus action. [SHADOW_OPS]
static function X2AbilityTemplate SecondWind()
{
	local X2AbilityTemplate Template;

	Template = PurePassive('MNT_SecondWind', "img:///XPerkIconPack.UIPerk_medkit_move", false);
	Template.AdditionalAbilities.AddItem('MNT_SecondWindTrigger');

	return Template;
}


static function X2AbilityTemplate SecondWindTrigger()
{
	local X2AbilityTemplate					Template;
	local X2Effect_GrantActionPoints		Effect;
	local XMBCondition_AbilityName			Condition;
	local XMBAbilityTrigger_EventListener	EventListener;

	Effect = new class'X2Effect_GrantActionPoints';
	Effect.NumActionPoints = 1;
	Effect.PointType = class'X2CharacterTemplateManager'.default.StandardActionPoint;

	Template = TargetedBuff('MNT_SecondWindTrigger', "img:///XPerkIconPack.UIPerk_medkit_move", false, Effect,, eCost_None);
	Template.AbilityTriggers.Length = 0;
	Template.AbilityTargetConditions.Length = 0;
	Template.AbilityShooterConditions.Length = 0;
	Template.AbilityTargetStyle = default.SingleTargetWithSelf;
	
	EventListener = new class'XMBAbilityTrigger_EventListener';
	EventListener.ListenerData.Deferral = ELD_OnStateSubmitted;
	EventListener.ListenerData.EventID = 'AbilityActivated';
	EventListener.ListenerData.Filter = eFilter_Unit;
	EventListener.bSelfTarget = false;
	Template.AbilityTriggers.AddItem(EventListener);

	Condition = new class'XMBCondition_AbilityName';
	Condition.IncludeAbilityNames.AddItem('MedikitHeal');
	Condition.IncludeAbilityNames.AddItem('NanoMedikitHeal');
	Condition.IncludeAbilityNames.AddItem('MedikitStabilize');
	AddTriggerTargetCondition(Template, Condition);

	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.bSkipFireAction = true;

	HidePerk(Template);

	return Template;
}

// Rejuvenate - MNT version of Savior
static function X2AbilityTemplate Rejuvenate()
{
	local X2Effect_Rejuvenate Effect;

	Effect = new class'X2Effect_Rejuvenate';
	Effect.RejuvenateBonusHealAmount=default.RejuvenateHealBonus;
	Effect.RejuvenateBonusWillAmount=default.RejuvenateWillBonus;
	Effect.BuildPersistentEffect (1, true, false);

	return Passive('MNT_Rejuvenate', "img:///XPerkIconPack.UIPerk_medkit_plus", true, Effect);
}

// #######################################################################################
// -------------------- GRENADES	------------------------------------------------------
// #######################################################################################

//Rapid Deployment - grants a free action grenade launch
static function X2AbilityTemplate RapidDeployment()
{
	local X2AbilityTemplate Template;
	local XMBEffect_AbilityCostRefund Effect;
	local XMBCondition_AbilityName NameCondition;

	Effect = new class'XMBEffect_AbilityCostRefund';
	Effect.TriggeredEvent = 'RapidDeployment';
	Effect.bShowFlyOver = true;
	Effect.CountValueName = 'RapidDeploymentUses';
	Effect.MaxRefundsPerTurn = 1;
	Effect.bFreeCost = true;
	Effect.BuildPersistentEffect(1, false, true, false, eGameRule_PlayerTurnEnd);

	NameCondition = new class'XMBCondition_AbilityName';
	NameCondition.IncludeAbilityNames.AddItem('ThrowGrenade');
	NameCondition.IncludeAbilityNames.AddItem('LaunchGrenade');
	Effect.AbilityTargetConditions.AddItem(NameCondition);

	Template = SelfTargetActivated('MNT_RapidDeployment', "img:///UILibrary_PerkIcons.UIPerk_bankshot", true, Effect,, eCost_Free);
	AddCooldown(Template, default.RapidDeployment_Cooldown);

	return Template;
}

//Increase blast radius of grenades
static function X2AbilityTemplate DangerZone()
{
	local XMBEffect_BonusRadius Effect;

	Effect = new class'XMBEffect_BonusRadius';
	Effect.EffectName = 'DangerZone';

	// Add 2m (1.33 tiles) to the radius of all grenades
	Effect.fBonusRadius = default.DangerZone_Radius;

	return Passive('MNT_DangerZone', "img:///XPerkIconPack.UIPerk_grenade_blaze", true, Effect);
}

//Full Kit - adds charges to utility slot
static function X2AbilityTemplate FullKit()
{
	local XMBEffect_AddItemCharges Effect;

	Effect = new class'XMBEffect_AddItemCharges';
	Effect.ApplyToSlots.AddItem(eInvSlot_Utility);

	return Passive('MNT_FullKit', "img:///XPerkIconPack.UIPerk_grenade_plus", false, Effect);
}

// #######################################################################################
// -------------------- GRENADES (DMG)----------------------------------------------------
// #######################################################################################

//HEAT Warheads - this ability grants armor piercing to all damage-causing grenades
static function X2AbilityTemplate HEATGrenades()
{
	local X2Effect_HEATGrenades			HEATEffect;

	HEATEffect = new class 'X2Effect_HEATGrenades';
	HEATEffect.ShredMod = default.HEAT_Shred;
	HEATEffect.PierceMod = default.HEAT_Pierce;

	return Passive('MNT_HEATGrenades', "img:///XPerkIconPack.UIPerk_grenade_crit", true, HEATEffect);

}

//Shock and Awe - Increases will of allies whenever you throw/launch a grenade. 20% to stun things with said grenade.
static function X2AbilityTemplate ShockAndAwe()
{
	local X2Effect_PersistentStatChange			Effect;
	local X2AbilityTemplate						Template;
	local X2AbilityMultiTarget_Radius			RadiusMultiTarget;
	local XMBCondition_AbilityName				NameCondition;

	// Create a persistent stat change effect
	Effect = new class'X2Effect_PersistentStatChange';
	Effect.EffectName = 'MNT_ShockAndAwe';

	// The effect lasts 5 turns and refreshes
	Effect.BuildPersistentEffect(5, false, false, false, eGameRule_PlayerTurnEnd);
	Effect.DuplicateResponse = eDupe_Refresh;

	Effect.AddPersistentStatChange(eStat_Will, default.ShockAndAwe_Awe);
	Effect.TargetConditions.AddItem(default.LivingFriendlyTargetProperty);
	Effect.VisualizationFn = EffectFlyOver_Visualization;
	Template = SelfTargetTrigger('MNT_ShockAndAwe', "img:///XPerkIconPack.UIPerk_grenade_blossom", true, Effect, 'AbilityActivation');

	// Trigger abilities don't appear as passives. Add a passive ability icon.
	AddIconPassive(Template);
	RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
	RadiusMultiTarget.fTargetRadius = default.ShockAndAwe_Radius;
	RadiusMultiTarget.bIgnoreBlockingCover = true;
	Template.AbilityMultiTargetStyle = RadiusMultiTarget;
	Template.AddMultiTargetEffect(Effect);

	//Applies whenever we launch a grenade
	NameCondition = new class 'XMBCondition_AbilityName';
	NameCondition.IncludeAbilityNames.AddItem('LaunchGrenade');
	NameCondition.IncludeAbilityNames.AddItem('ThrowGrenade');

	AddTriggerTargetCondition(Template, NameCondition);

	return Template;
}

// #######################################################################################
// -------------------- GRENADES (UTL)----------------------------------------------------
// #######################################################################################

// Smoke and Mirrors - Smokes can be fired wihout ending turn, grants additional smokes
static function X2AbilityTemplate SmokeAndMirrors()
{
	local XMBEffect_AddItemCharges			BonusItemEffect;

	BonusItemEffect = new class'XMBEffect_AddItemCharges';
	BonusItemEffect.PerItemBonus = default.SmokeAndMirrors_Bonus;
	BonusItemEffect.ApplyToNames.AddItem('SmokeGrenade');
	BonusItemEffect.ApplyToNames.AddItem('SmokeGrenadeMk2');
	
	return Passive('MNT_SmokeAndMirrors', "img:///XPerkIconPack.UIPerk_smoke_circle", false, BonusItemEffect);
}

// Flashout - grants bonus flashbangs and grants additional flashes
static function X2AbilityTemplate Flashout()
{
	local XMBEffect_AddItemCharges			BonusItemEffect;

	BonusItemEffect = new class'XMBEffect_AddItemCharges';
	BonusItemEffect.PerItemBonus = default.Flashout_Bonus;
	BonusItemEffect.ApplyToNames.AddItem('FlashbangGrenade');
	
	return Passive('MNT_Flashout', "img:///XPerkIconPack.UIPerk_grenade_circle", false, BonusItemEffect);
}

// Battlescanner + vision + detection down
static function X2AbilityTemplate Pathfinder()
{
	local X2AbilityTemplate Template;
	local XMBEffect_AddUtilityItem			Effect;
	local X2Effect_PersistentStatChange		PersistentStatChangeEffect;

	Effect = new class'XMBEffect_AddUtilityItem';
	Effect.DataName = 'BattleScanner';

	Template = Passive('MNT_Pathfinder', "img:///UILibrary_PerkIcons.UIPerk_battlescanner", true, Effect);

	PersistentStatChangeEffect = new class'X2Effect_PersistentStatChange';
	PersistentStatChangeEffect.BuildPersistentEffect(1, true, false, false);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_DetectionModifier, default.Pathfinder_Detection);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_SightRadius, default.Pathfinder_Sight);
	Template.AddTargetEffect(PersistentStatChangeEffect);
	
	
	return Template;
}



