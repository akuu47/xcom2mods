class X2Ability_KickAndPunch extends X2Ability config(KickAndPunch);

var config(HUDPriority) int PUNCH_SHOT_HUD_PRIOITY;
var config(HUDPriority) int KICK_SHOT_HUD_PRIOITY;
var config(HUDPriority) int STOCKSTRIKE_SHOT_HUD_PRIOITY;
var config(HUDPriority) int MELEE_SHOT_HUD_PRIOITY;

var config WeaponDamageValue PUNCH_BASEDAMAGE;
var config float PUNCH_BONUS_DAMAGE_PER_RANK;
var config int PUNCH_COOLDOWN;
var config int PUNCH_AIM_PENALTY;
var config int PUNCH_AIM_PENALTY_DURATION_TURNS;
var config int PUNCH_AIM_PENALTY_APPLY_CHANCE;
var config bool PUNCH_IS_CROSS_CLASS_COMPATIBLE;
var config bool ADD_PUNCH_TO_EVERYONE;

var config WeaponDamageValue KICK_BASEDAMAGE;
var config float KICK_BONUS_DAMAGE_PER_RANK;
var config int KICK_COOLDOWN;
var config int KICK_MOBILITY_PENALTY;
var config int KICK_MOBILITY_PENALTY_DURATION_TURNS;
var config int KICK_MOBILITY_PENALTY_APPLY_CHANCE;
var config bool KICK_IS_CROSS_CLASS_COMPATIBLE;
var config bool ADD_KICK_TO_EVERYONE;

var config WeaponDamageValue STOCKSTRIKE_BASEDAMAGE;
var config float STOCKSTRIKE_BONUS_DAMAGE_PER_RANK;
var config int STOCKSTRIKE_COOLDOWN;
var config int STOCKSTRIKE_DISORIENT_APPLY_CHANCE;
var config bool STOCKSTRIKE_IS_CROSS_CLASS_COMPATIBLE;
var config bool ADD_STOCKSTRIKE_TO_EVERYONE;

var config int STOCKSTRIKE_STUN_APPLY_CHANCE;
var config int STOCKSTRIKE_STUN_FOR_ACTIONS;

//	Generic melee ability
var config WeaponDamageValue MELEE_BASEDAMAGE;
var config float MELEE_BONUS_DAMAGE_PER_RANK;
var config int MELEE_COOLDOWN;

var config int MELEE_AIM_PENALTY;
var config int MELEE_AIM_PENALTY_DURATION_TURNS;
var config int MELEE_AIM_PENALTY_APPLY_CHANCE;

var config int MELEE_MOBILITY_PENALTY;
var config int MELEE_MOBILITY_PENALTY_DURATION_TURNS;
var config int MELEE_MOBILITY_PENALTY_APPLY_CHANCE;

var config int MELEE_DISORIENT_APPLY_CHANCE;

var config int MELEE_STUN_APPLY_CHANCE;
var config int MELEE_STUN_FOR_ACTIONS;

var config bool MELEE_IS_CROSS_CLASS_COMPATIBLE;
var config bool ADD_MELEE_TO_EVERYONE;


// Affect all abilities
var config array<name> EXCLUDED_CLASSES;
var config array<name> EXCLUDED_PRIMARY_WEAPON_CATEGORIES;

var config bool MELEE_ATTACKS_WITHIN_ONE_TILE_DONT_END_TURN;
var config int MELEE_BONUS_AIM;
var config int MELEE_BONUS_CRIT;

var config bool USE_CINEMATIC_CAMERA;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	Templates.AddItem(Create_Punch());
	Templates.AddItem(Create_Kick());
	Templates.AddItem(Create_Stockstrike());
	Templates.AddItem(Create_AllInOne());

	//	Adding AnimSets as additional abilities so that these abilities can function when given directly to soldier classes or weapons
	Templates.AddItem(Create_AnimSet_Passive('IRI_AS_IRI_Melee', "IRI_PunchAndKickA.Anims.AS_IRI_Melee"));

	return Templates;
}

static function X2AbilityTemplate Create_Punch()
{
	local X2AbilityTemplate				Template;
	local X2Effect_Knockback			KnockbackEffect;
	local X2Effect_ApplyScalingDamage   DamageEffect;

	Template = class'X2Ability_RangerAbilitySet'.static.AddSwordSliceAbility('IRI_Punch_Ability');

	Template.ShotHUDPriority = default.PUNCH_SHOT_HUD_PRIOITY;

	Template.AbilityTriggers.Length = 0;	//	removing end of move trigger
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	//	Remove ability effects (weapon damage)
	Template.AbilityTargetEffects.Length = 0;

	Template.IconImage = "img:///IRI_PunchAndKickA.UI.perk_Punch";
	Template.bDontDisplayInAbilitySummary = true;

	AddCooldown(Template, default.PUNCH_COOLDOWN);
	SetToHitCalc(Template);
	AddPenalty(Template, 'IRI_Punch_Aim_Penalty_Effect', eStat_Offense, default.PUNCH_AIM_PENALTY_APPLY_CHANCE, default.PUNCH_AIM_PENALTY, default.PUNCH_AIM_PENALTY_DURATION_TURNS);
	
	KnockbackEffect = new class'X2Effect_Knockback';
	KnockbackEffect.KnockbackDistance = 1;
	Template.AddTargetEffect(KnockbackEffect);

	DamageEffect = new class'X2Effect_ApplyScalingDamage';
	DamageEffect.BonusDamagePerRank = default.PUNCH_BONUS_DAMAGE_PER_RANK;
	DamageEffect.EffectDamageValue = default.PUNCH_BASEDAMAGE;
	Template.AddTargetEffect(DamageEffect);

	Template.CustomFireAnim = 'FF_Melee_Punch';
	Template.CustomFireKillAnim = 'FF_Melee_Punch';

	if (default.USE_CINEMATIC_CAMERA) Template.CinescriptCameraType = "Iridar_KAP_Uppercut";

	Template.bCrossClassEligible = default.PUNCH_IS_CROSS_CLASS_COMPATIBLE;

	//	Makes the soldier play Stop Move animation, fixes awkward sliding punch visualization
	Template.bSkipMoveStop = false;

	//	Allows knockback to do its thing
	Template.bOverrideMeleeDeath = true;

	Template.AdditionalAbilities.AddItem('IRI_AS_IRI_Melee');

	return Template;
}

static function X2AbilityTemplate Create_Kick()
{
	local X2AbilityTemplate				Template;
	local X2Effect_Knockback			KnockbackEffect;
	local X2Effect_ApplyScalingDamage   DamageEffect;

	Template = class'X2Ability_RangerAbilitySet'.static.AddSwordSliceAbility('IRI_Kick_Ability');

	Template.AbilityTriggers.Length = 0;	//	removing end of move trigger
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	Template.ShotHUDPriority = default.KICK_SHOT_HUD_PRIOITY;

	//	Remove ability effects (weapon damage)
	Template.AbilityTargetEffects.Length = 0;

	Template.IconImage = "img:///IRI_PunchAndKickA.UI.perk_Kick_alt";
	Template.bDontDisplayInAbilitySummary = true;

	AddCooldown(Template, default.KICK_COOLDOWN);
	SetToHitCalc(Template);
	AddPenalty(Template, 'IRI_Kick_Mobility_Penalty_Effect', eStat_Mobility, default.KICK_MOBILITY_PENALTY_APPLY_CHANCE, default.KICK_MOBILITY_PENALTY, default.KICK_MOBILITY_PENALTY_DURATION_TURNS);

	KnockbackEffect = new class'X2Effect_Knockback';
	KnockbackEffect.KnockbackDistance = 1;
	Template.AddTargetEffect(KnockbackEffect);

	DamageEffect = new class'X2Effect_ApplyScalingDamage';
	DamageEffect.BonusDamagePerRank = default.KICK_BONUS_DAMAGE_PER_RANK;
	DamageEffect.EffectDamageValue = default.KICK_BASEDAMAGE;
	Template.AddTargetEffect(DamageEffect);

	Template.CustomFireAnim = 'FF_Melee_Kick';
	Template.CustomFireKillAnim = 'FF_Melee_Kick';

	if (default.USE_CINEMATIC_CAMERA) Template.CinescriptCameraType = "Iridar_KAP_Uppercut";

	Template.bCrossClassEligible = default.KICK_IS_CROSS_CLASS_COMPATIBLE;

	//	Allows knockback to do its thing
	Template.bOverrideMeleeDeath = true;

	Template.AdditionalAbilities.AddItem('IRI_AS_IRI_Melee');

	return Template;
}

static function X2AbilityTemplate Create_Stockstrike()
{
	local X2AbilityTemplate				Template;
	local X2Effect_Knockback			KnockbackEffect;
	local X2Effect_ApplyScalingDamage   DamageEffect;
	local X2Effect_PersistentStatChange DisorientEffect;
	local X2Effect_Stunned				StunEffect;

	Template = class'X2Ability_RangerAbilitySet'.static.AddSwordSliceAbility('IRI_Stockstrike_Ability');

	Template.AbilityTriggers.Length = 0;	//	removing end of move trigger
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	Template.ShotHUDPriority = default.STOCKSTRIKE_SHOT_HUD_PRIOITY;

	Template.IconImage = "img:///IRI_PunchAndKickA.UI.perk_Stockstrike";
	Template.bDontDisplayInAbilitySummary = true;

	AddCooldown(Template, default.STOCKSTRIKE_COOLDOWN);
	SetToHitCalc(Template);
	//	Remove ability effects (weapon damage)
	Template.AbilityTargetEffects.Length = 0;
	
	KnockbackEffect = new class'X2Effect_Knockback';
	KnockbackEffect.KnockbackDistance = 1;
	Template.AddTargetEffect(KnockbackEffect);

	DamageEffect = new class'X2Effect_ApplyScalingDamage';
	DamageEffect.BonusDamagePerRank = default.STOCKSTRIKE_BONUS_DAMAGE_PER_RANK;
	DamageEffect.EffectDamageValue = default.STOCKSTRIKE_BASEDAMAGE;
	Template.AddTargetEffect(DamageEffect);

	DisorientEffect = class'X2StatusEffects'.static.CreateDisorientedStatusEffect(, , true);
	DisorientEffect.ApplyChance = default.STOCKSTRIKE_DISORIENT_APPLY_CHANCE;
	Template.AddTargetEffect(DisorientEffect);

	if (default.STOCKSTRIKE_STUN_APPLY_CHANCE > 0)
	{
		StunEffect = class'X2StatusEffects'.static.CreateStunnedStatusEffect(default.STOCKSTRIKE_STUN_FOR_ACTIONS, default.STOCKSTRIKE_STUN_APPLY_CHANCE); // # ACTIONS, % chance
		StunEffect.bRemoveWhenSourceDies = false;
		Template.AddTargetEffect(StunEffect);
	}
	Template.CustomFireAnim = 'FF_Melee_Stock';
	Template.CustomFireKillAnim = 'FF_Melee_Stock';

	if (default.USE_CINEMATIC_CAMERA) Template.CinescriptCameraType = "Iridar_KAP_Uppercut";
	Template.bCrossClassEligible = default.STOCKSTRIKE_IS_CROSS_CLASS_COMPATIBLE;

	//	Allows knockback to do its thing
	Template.bOverrideMeleeDeath = true;

	Template.bSkipMoveStop = false;

	Template.AdditionalAbilities.AddItem('IRI_AS_IRI_Melee');

	return Template;
}

static function X2AbilityTemplate Create_AllInOne()
{
	local X2AbilityTemplate				Template;
	local X2Effect_Knockback			KnockbackEffect;
	local X2Effect_ApplyScalingDamage   DamageEffect;
	local X2Effect_PersistentStatChange DisorientEffect;
	local X2Effect_Stunned				StunEffect;

	Template = class'X2Ability_RangerAbilitySet'.static.AddSwordSliceAbility('IRI_Melee_Ability');

	Template.AbilityTriggers.Length = 0;	//	removing end of move trigger
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	Template.ShotHUDPriority = default.MELEE_SHOT_HUD_PRIOITY;

	//	Remove ability effects (weapon damage)
	Template.AbilityTargetEffects.Length = 0;

	Template.IconImage = "img:///IRI_PunchAndKickA.UI.perk_Stockstrike";
	Template.bDontDisplayInAbilitySummary = true;

	AddCooldown(Template, default.MELEE_COOLDOWN);
	SetToHitCalc(Template);

	AddPenalty(Template, 'IRI_Melee_Mobility_Penalty_Effect', eStat_Mobility, default.MELEE_MOBILITY_PENALTY_APPLY_CHANCE, default.MELEE_MOBILITY_PENALTY, default.MELEE_MOBILITY_PENALTY_DURATION_TURNS);
	AddPenalty(Template, 'IRI_Melee_Aim_Penalty_Effect', eStat_Offense, default.MELEE_AIM_PENALTY_APPLY_CHANCE, default.MELEE_AIM_PENALTY, default.MELEE_AIM_PENALTY_DURATION_TURNS);

	if (default.MELEE_STUN_APPLY_CHANCE > 0)	//	yes, it's necessary
	{
		StunEffect = class'X2StatusEffects'.static.CreateStunnedStatusEffect(default.MELEE_STUN_FOR_ACTIONS, default.MELEE_STUN_APPLY_CHANCE); // # ACTIONS, % chance
		StunEffect.bRemoveWhenSourceDies = false;
		Template.AddTargetEffect(StunEffect);
	}

	DisorientEffect = class'X2StatusEffects'.static.CreateDisorientedStatusEffect(, , true);
	DisorientEffect.ApplyChance = default.MELEE_DISORIENT_APPLY_CHANCE;
	Template.AddTargetEffect(DisorientEffect);
	
	KnockbackEffect = new class'X2Effect_Knockback';
	KnockbackEffect.KnockbackDistance = 1;
	Template.AddTargetEffect(KnockbackEffect);

	DamageEffect = new class'X2Effect_ApplyScalingDamage';
	DamageEffect.BonusDamagePerRank = default.MELEE_BONUS_DAMAGE_PER_RANK;
	DamageEffect.EffectDamageValue = default.MELEE_BASEDAMAGE;
	Template.AddTargetEffect(DamageEffect);

	Template.CustomFireAnim = 'FF_AMeleeAttack';
	Template.CustomFireKillAnim = 'FF_AMeleeAttack';

	if (default.USE_CINEMATIC_CAMERA) Template.CinescriptCameraType = "Iridar_KAP_Uppercut";
	Template.bCrossClassEligible = default.MELEE_IS_CROSS_CLASS_COMPATIBLE;

	//	Allows knockback to do its thing
	Template.bOverrideMeleeDeath = true;

	Template.bSkipMoveStop = false;

	Template.AdditionalAbilities.AddItem('IRI_AS_IRI_Melee');

	return Template;
}

//	========================================
//				COMMON CODE
//	========================================

static function AddCooldown(out X2AbilityTemplate Template, int Cooldown)
{
	local X2AbilityCooldown AbilityCooldown;

	if (Cooldown > 0)
	{
		AbilityCooldown = new class'X2AbilityCooldown';
		AbilityCooldown.iNumTurns = Cooldown;
		Template.AbilityCooldown = AbilityCooldown;
	}
}

static function AddPenalty(out X2AbilityTemplate Template, name EffectName, ECharStatType Stat, int ApplyChance, int Penalty, int Duration)
{
	local X2Effect_PersistentStatChange	StatEffect;

	StatEffect = new class'X2Effect_PersistentStatChange';
	StatEffect.BuildPersistentEffect(Duration, false, false, false, eGameRule_PlayerTurnBegin);
	StatEffect.SetDisplayInfo(ePerkBuff_Penalty, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage);
	StatEffect.AddPersistentStatChange(Stat, Penalty);
	StatEffect.DuplicateResponse = eDupe_Allow;
	StatEffect.EffectName = EffectName;
	StatEffect.ApplyChance = ApplyChance;
	Template.AddTargetEffect(StatEffect);
}

static function SetToHitCalc(out X2AbilityTemplate Template)
{
	local X2AbilityToHitCalc_Bayonet	ToHitCalc;

	ToHitCalc = new class'X2AbilityToHitCalc_Bayonet';
	ToHitCalc.bAllowCrit = true;
	ToHitCalc.BuiltInHitMod = default.MELEE_BONUS_AIM;
	ToHitCalc.BuiltInCritMod = default.MELEE_BONUS_CRIT;

	Template.AbilityToHitCalc = ToHitCalc;
}

static function X2AbilityTemplate Create_AnimSet_Passive(name TemplateName, string AnimSetPath)
{
	local X2AbilityTemplate                 Template;
	local X2Effect_AdditionalAnimSets		AnimSetEffect;
	local X2Effect_MeleeAbilityCost			CostEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);

	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.bDisplayInUITooltip = false;
	Template.bDisplayInUITacticalText = false;
	Template.bDontDisplayInAbilitySummary = true;
	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	
	AnimSetEffect = new class'X2Effect_AdditionalAnimSets';
	AnimSetEffect.AddAnimSetWithPath(AnimSetPath);
	AnimSetEffect.BuildPersistentEffect(1, true, false, false);
	Template.AddTargetEffect(AnimSetEffect);

	if (default.MELEE_ATTACKS_WITHIN_ONE_TILE_DONT_END_TURN)
	{
		CostEffect = new class'X2Effect_MeleeAbilityCost';
		CostEffect.BuildPersistentEffect(1, true, false, false);
		Template.AddTargetEffect(CostEffect);
	}

	Template.bUniqueSource = true;

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}