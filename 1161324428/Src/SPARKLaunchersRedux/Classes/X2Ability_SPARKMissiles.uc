class X2Ability_SPARKMissiles extends X2Ability config(SPARKLaunchers);

var config float MICROMISSILE_DAMAGE_RADIUS;
var config float FLASHRAIN_DAMAGE_RADIUS;
var config float SMOKERAIN_DAMAGE_RADIUS;
var config int LAUNCHER_COOLDOWN;
var config int FLASHRAIN_COOLDOWN;
var config float RAINMAKER_RADIUS;


static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	Templates.AddItem(CreateMicroMissilesM1Ability());
	Templates.AddItem(CreateFlashRainAbility());
	Templates.AddItem(CreateSmokeRainAbility());


	return Templates;
}


static function X2DataTemplate CreateMicroMissilesM1Ability()
{
	local X2AbilityTemplate Template;
	local X2AbilityCost_Ammo AmmoCost;
	local X2AbilityCost_ActionPoints ActionPointCost;
	local X2Effect_ApplyWeaponDamage WeaponEffect;
	local X2AbilityTarget_Cursor CursorTarget;
	local X2AbilityMultiTarget_Radius RadiusMultiTarget;
	local X2AbilityCooldown_LocalAndGlobal Cooldown;
	local X2AbilityToHitCalc_StandardAim    StandardAim;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'RM_SPARKMissiles');
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_fanfire";
	// This action is considered 'hostile' and can be interrupted!
	Template.Hostility = eHostility_Offensive;

	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_AlwaysShow;
	Template.bUseAmmoAsChargesForHUD = true;

	Template.TargetingMethod = class'X2TargetingMethod_MECMicroMissile';
 
	// Cooldown on the ability
	Cooldown = new class'X2AbilityCooldown_LocalAndGlobal';
	Cooldown.iNumTurns = default.LAUNCHER_COOLDOWN;
	Cooldown.NumGlobalTurns = 0;
	Template.AbilityCooldown = Cooldown;

	AmmoCost = new class'X2AbilityCost_Ammo';	
	AmmoCost.iAmmo = 1;
	Template.AbilityCosts.AddItem(AmmoCost);

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);
	
	StandardAim = new class'X2AbilityToHitCalc_StandardAim';
	StandardAim.bGuaranteedHit = true;
	Template.AbilityToHitCalc = StandardAim;
	
	CursorTarget = new class'X2AbilityTarget_Cursor';
	CursorTarget.bRestrictToWeaponRange = true;
	Template.AbilityTargetStyle = CursorTarget;

	RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
	RadiusMultiTarget.fTargetRadius = default.MICROMISSILE_DAMAGE_RADIUS;
	Template.AbilityMultiTargetStyle = RadiusMultiTarget;
	X2AbilityMultiTarget_Radius(Template.AbilityMultiTargetStyle).AddAbilityBonusRadius('Rainmaker', default.RAINMAKER_RADIUS);

	WeaponEffect = new class'X2Effect_ApplyWeaponDamage';
	Template.AddMultiTargetEffect(WeaponEffect);

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.CinescriptCameraType = "MEC_MicroMissiles";

	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.GrenadeLostSpawnIncreasePerUse;

	return Template;
}


static function X2DataTemplate CreateFlashRainAbility()
{
	local X2AbilityTemplate Template;
	local X2AbilityCost_Ammo AmmoCost;
	local X2AbilityCost_ActionPoints ActionPointCost;
	local X2Effect_ApplyWeaponDamage WeaponEffect;
	local X2AbilityTarget_Cursor CursorTarget;
	local X2AbilityMultiTarget_Radius RadiusMultiTarget;
	local X2AbilityCooldown Cooldown;
	local X2AbilityToHitCalc_StandardAim    StandardAim;
	
	`CREATE_X2ABILITY_TEMPLATE(Template, 'RM_FlashRain');
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_fanfire";
	// This action is considered 'hostile' and can be interrupted!
	Template.Hostility = eHostility_Neutral;

	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_AlwaysShow;
	Template.bUseAmmoAsChargesForHUD = true;

	Template.TargetingMethod = class'X2TargetingMethod_MECMicroMissile';
 
	// Cooldown on the ability
	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.FLASHRAIN_COOLDOWN;
	Template.AbilityCooldown = Cooldown;

	AmmoCost = new class'X2AbilityCost_Ammo';	
	AmmoCost.iAmmo = 1;
	Template.AbilityCosts.AddItem(AmmoCost);

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);
	
	StandardAim = new class'X2AbilityToHitCalc_StandardAim';
	StandardAim.bGuaranteedHit = true;
	Template.AbilityToHitCalc = StandardAim;
	
	CursorTarget = new class'X2AbilityTarget_Cursor';
	CursorTarget.bRestrictToWeaponRange = true;
	Template.AbilityTargetStyle = CursorTarget;

	RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
	RadiusMultiTarget.fTargetRadius = default.FLASHRAIN_DAMAGE_RADIUS;
	Template.AbilityMultiTargetStyle = RadiusMultiTarget;
	X2AbilityMultiTarget_Radius(Template.AbilityMultiTargetStyle).AddAbilityBonusRadius('Rainmaker', default.RAINMAKER_RADIUS);

	WeaponEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponEffect.bExplosiveDamage = true;
	Template.AddMultiTargetEffect(WeaponEffect);

	Template.AddMultiTargetEffect(class'X2StatusEffects'.static.CreateDisorientedStatusEffect(, , false));
	
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	Template.bShowPostActivation = true;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.CinescriptCameraType = "MEC_MicroMissiles";

	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.GrenadeLostSpawnIncreasePerUse;

	return Template;
}


static function X2DataTemplate CreateSmokeRainAbility()
{
	local X2AbilityTemplate Template;
	local X2AbilityCost_Ammo AmmoCost;
	local X2AbilityCost_ActionPoints ActionPointCost;
	local X2Effect_ApplySmokeGrenadeToWorld WeaponEffect;
	local X2AbilityMultiTarget_Radius RadiusMultiTarget;
	local X2AbilityCooldown Cooldown;
	local X2AbilityTarget_Cursor CursorTarget;
	local X2AbilityToHitCalc_StandardAim    StandardAim;
	
	`CREATE_X2ABILITY_TEMPLATE(Template, 'RM_SmokeRain');
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_fanfire";
	// This action is considered 'hostile' and can be interrupted!
	Template.Hostility = eHostility_Neutral;

	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_AlwaysShow;
	Template.bUseAmmoAsChargesForHUD = true;

	Template.TargetingMethod = class'X2TargetingMethod_MECMicroMissile';
	 
	// Cooldown on the ability
	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.LAUNCHER_COOLDOWN;
	Template.AbilityCooldown = Cooldown;

	AmmoCost = new class'X2AbilityCost_Ammo';	
	AmmoCost.iAmmo = 1;
	Template.AbilityCosts.AddItem(AmmoCost);

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = false;
	Template.AbilityCosts.AddItem(ActionPointCost);
	
	StandardAim = new class'X2AbilityToHitCalc_StandardAim';
	StandardAim.bGuaranteedHit = true;
	Template.AbilityToHitCalc = StandardAim;
	
	CursorTarget = new class'X2AbilityTarget_Cursor';
	CursorTarget.bRestrictToWeaponRange = true;
	Template.AbilityTargetStyle = CursorTarget;

	RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
	RadiusMultiTarget.fTargetRadius = default.SMOKERAIN_DAMAGE_RADIUS;
	Template.AbilityMultiTargetStyle = RadiusMultiTarget;
	X2AbilityMultiTarget_Radius(Template.AbilityMultiTargetStyle).AddAbilityBonusRadius('Rainmaker', default.RAINMAKER_RADIUS);

	WeaponEffect = new class'X2Effect_ApplySmokeGrenadeToWorld';	
	Template.AddMultiTargetEffect(WeaponEffect);
	Template.AddMultiTargetEffect(SmokeRainEffect());
	
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	Template.bShowPostActivation = true;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.CinescriptCameraType = "MEC_MicroMissiles";

	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.GrenadeLostSpawnIncreasePerUse;

	return Template;
}

//copy of the X2Effect SmokegrenadeEffect, in case i want to change it for the MEC
static function X2Effect SmokeRainEffect()
{
	local X2Effect_SmokeGrenade Effect;

	Effect = new class'X2Effect_SmokeGrenade';
	//Must be at least as long as the duration of the smoke effect on the tiles. Will get "cut short" when the tile stops smoking or the unit moves. -btopp 2015-08-05
	Effect.BuildPersistentEffect(class'X2Effect_ApplySmokeGrenadeToWorld'.default.Duration + 1, false, false, false, eGameRule_PlayerTurnBegin);
	Effect.SetDisplayInfo(ePerkBuff_Bonus, class'X2Item_DefaultGrenades'.default.SmokeGrenadeEffectDisplayName, class'X2Item_DefaultGrenades'.default.SmokeGrenadeEffectDisplayDesc, "img:///UILibrary_PerkIcons.UIPerk_grenade_smoke");
	Effect.HitMod = class'X2Item_DefaultGrenades'.default.SMOKEGRENADE_HITMOD;
	Effect.DuplicateResponse = eDupe_Refresh;
	return Effect;
}

