class X2Item_NewLostWeapon extends X2Item config(WWLData);

var config WeaponDamageValue THELOST_NEW_TIER1_MELEEATTACK_BASEDAMAGE;
var config WeaponDamageValue THELOST_NEW_TIER2_MELEEATTACK_BASEDAMAGE;
var config WeaponDamageValue THELOST_NEW_TIER3_MELEEATTACK_BASEDAMAGE;

var config WeaponDamageValue THELOST_HOWLER_NEW_TIER1_MELEEATTACK_BASEDAMAGE;
var config WeaponDamageValue THELOST_HOWLER_NEW_TIER2_MELEEATTACK_BASEDAMAGE;
var config WeaponDamageValue THELOST_HOWLER_NEW_TIER3_MELEEATTACK_BASEDAMAGE;

var config WeaponDamageValue THELOST_BRUTE_NEW_TIER1_MELEEATTACK_BASEDAMAGE;
var config WeaponDamageValue THELOST_BRUTE_NEW_TIER2_MELEEATTACK_BASEDAMAGE;
var config WeaponDamageValue THELOST_BRUTE_NEW_TIER3_MELEEATTACK_BASEDAMAGE;

var config WeaponDamageValue LOST_MELEEATTACK_BASEDAMAGE;
var config WeaponDamageValue LOSTZOMBIE_WPN_BASEDAMAGE;
var config WeaponDamageValue LOSTZOMBIE_MELEEATTACK_BASEDAMAGE;
var config int GENERIC_MELEE_ACCURACY;

var config int ULTRASONICLURE_RANGE;
var config int ULTRASONICLURE_RADIUS;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Weapons;

    Weapons.AddItem(CreateTemplate_TheLost_MeleeAttack('TheLostTier1_MeleeAttack', default.THELOST_NEW_TIER1_MELEEATTACK_BASEDAMAGE));
	Weapons.AddItem(CreateTemplate_TheLost_MeleeAttack('TheLostTier2_MeleeAttack', default.THELOST_NEW_TIER2_MELEEATTACK_BASEDAMAGE));
	Weapons.AddItem(CreateTemplate_TheLost_MeleeAttack('TheLostTier3_MeleeAttack', default.THELOST_NEW_TIER3_MELEEATTACK_BASEDAMAGE));
	Weapons.AddItem(CreateTemplate_TheLost_MeleeAttack('TheLostHowlerTier1_MeleeAttack', default.THELOST_HOWLER_NEW_TIER1_MELEEATTACK_BASEDAMAGE));
	Weapons.AddItem(CreateTemplate_TheLost_MeleeAttack('TheLostHowlerTier2_MeleeAttack', default.THELOST_HOWLER_NEW_TIER2_MELEEATTACK_BASEDAMAGE));
	Weapons.AddItem(CreateTemplate_TheLost_MeleeAttack('TheLostHowlerTier3_MeleeAttack', default.THELOST_HOWLER_NEW_TIER3_MELEEATTACK_BASEDAMAGE));
	Weapons.AddItem(CreateTemplate_TheLost_MeleeAttack('TheLostBruteTier1_MeleeAttack', default.THELOST_BRUTE_NEW_TIER1_MELEEATTACK_BASEDAMAGE));
	Weapons.AddItem(CreateTemplate_TheLost_MeleeAttack('TheLostBruteTier2_MeleeAttack', default.THELOST_BRUTE_NEW_TIER2_MELEEATTACK_BASEDAMAGE));
	Weapons.AddItem(CreateTemplate_TheLost_MeleeAttack('TheLostBruteTier3_MeleeAttack', default.THELOST_BRUTE_NEW_TIER3_MELEEATTACK_BASEDAMAGE));
	Weapons.AddItem(CreateTemplate_LostZombie_MeleeAttack());
	Weapons.AddItem(CreateBrutePoison_WPN());
	Weapons.AddItem(CreateUltrasonicLure());

return Weapons;
}

static function X2DataTemplate CreateTemplate_TheLost_MeleeAttack(name WeaponTemplateName, WeaponDamageValue WeaponBaseDamage)
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, WeaponTemplateName);

	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'melee';
	Template.WeaponTech = 'alien';
	Template.strImage = "img:///UILibrary_PerkIcons.UIPerk_muton_punch";
	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	Template.StowedLocation = eSlot_RightHand;
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "WP_Zombiefist.WP_Zombiefist";
	Template.RemoveTemplateAvailablility(Template.BITFIELD_GAMEAREA_Multiplayer); //invalidates multiplayer availability

	Template.iRange = 2;
	Template.iRadius = 1;
	Template.NumUpgradeSlots = 2;
	Template.InfiniteAmmo = true;
	Template.iPhysicsImpulse = 5;
	Template.iIdealRange = 1;

	Template.BaseDamage = WeaponBaseDamage;
	Template.BaseDamage.DamageType = 'Melee';
	Template.iSoundRange = 2;
	Template.iEnvironmentDamage = 10;

	//Build Data
	Template.StartingItem = false;
	Template.CanBeBuilt = false;

	Template.bDisplayWeaponAndAmmo = false;

	Template.Abilities.AddItem('LostAttack');

	return Template;
}

static function X2DataTemplate CreateTemplate_LostZombie_MeleeAttack()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'LostZombie_MeleeAttack');
	
	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'melee';
	Template.WeaponTech = 'alien';
	Template.strImage = "img:///UILibrary_PerkIcons.UIPerk_muton_punch";
	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	Template.StowedLocation = eSlot_RightHand;
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "WP_Zombiefist.WP_Zombiefist";
	Template.Aim = class'X2Item_DefaultWeapons'.default.GENERIC_MELEE_ACCURACY;
	Template.RemoveTemplateAvailablility(Template.BITFIELD_GAMEAREA_Multiplayer); //invalidates multiplayer availability

	Template.iRange = 2;
	Template.iRadius = 1;
	Template.NumUpgradeSlots = 2;
	Template.InfiniteAmmo = true;
	Template.iPhysicsImpulse = 5;
	Template.iIdealRange = 1;

	Template.BaseDamage = default.LOSTZOMBIE_MELEEATTACK_BASEDAMAGE;
	Template.BaseDamage.DamageType='Melee';
	Template.iSoundRange = 2;
	Template.iEnvironmentDamage = 10;

	//Build Data
	Template.StartingItem = false;
	Template.CanBeBuilt = false;

	Template.bDisplayWeaponAndAmmo = false;

	Template.Abilities.AddItem('LostAttack');

	return Template;
}

static function X2DataTemplate CreateBrutePoison_WPN()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'BrutePoison_WPN');

	Template.ItemCat = 'defense';
	Template.WeaponCat = 'utility';
	Template.strImage = "img:///UILibrary_StrategyImages.InventoryIcons.Inv_SmokeGrenade";
	Template.EquipSound = "StrategyUI_Grenade_Equip";
	Template.GameArchetype = "WP_Grenade_Gas.WP_Grenade_Gas";
	Template.CanBeBuilt = false;	

	//Template.iRange = 14;
	Template.iRadius = 3;
	Template.iClipSize = 1;
	Template.InfiniteAmmo = true;

	Template.iSoundRange = 6;
	Template.bSoundOriginatesFromOwnerLocation = true;

	Template.BaseDamage.DamageType = 'Poison';

	Template.InventorySlot = eInvSlot_Utility;
	Template.StowedLocation = eSlot_None;
	Template.Abilities.AddItem('BrutePoison');

	return Template;
}

static function X2WeaponTemplate CreateUltrasonicLure()
{
	local X2GrenadeTemplate Template;
	local ArtifactCost Resources;
	local X2Condition_UnitType UnitTypeCondition;
	local X2Effect_Persistent LureEffect;
	local X2Effect_AlertTheLost LostActivateEffect;

	`CREATE_X2TEMPLATE(class'X2GrenadeTemplate', Template, 'UltrasonicLure');

	Template.strImage = "img:///UILibrary_XPACK_StrategyImages.Inv_UltrasonicLure";
	Template.EquipSound = "StrategyUI_Grenade_Equip";
	Template.AddAbilityIconOverride('ThrowGrenade', "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_ultrasoniclure");
	Template.AddAbilityIconOverride('LaunchGrenade', "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_ultrasoniclure");
	Template.GameArchetype = "WP_Ultrasonic_Lure.WP_Ultrasonic_Lure";

	Template.Abilities.AddItem('ThrowGrenade');
	Template.Abilities.AddItem('GrenadeFuse');

	Template.ItemCat = 'tech';
	Template.WeaponCat = 'utility';
	Template.WeaponTech = 'conventional';
	Template.InventorySlot = eInvSlot_Utility;
	Template.StowedLocation = eSlot_BeltHolster;
	Template.bMergeAmmo = true;
	Template.iClipSize = 2;
	Template.Tier = 1;

	Template.bShouldCreateDifficultyVariants = true;

	Template.iRadius = default.ULTRASONICLURE_RADIUS;
	Template.iRange = default.ULTRASONICLURE_RANGE;
	Template.bIgnoreRadialBlockingCover = true;

	Template.CanBeBuilt = true;
	Template.PointsToComplete = 0;
	Template.TradingPostValue = 6;

	Template.SetUIStatMarkup(class'XLocalizedData'.default.RangeLabel, , default.ULTRASONICLURE_RANGE);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.RadiusLabel, , default.ULTRASONICLURE_RADIUS);

	// Requirements
	Template.Requirements.RequiredTechs.AddItem('AutopsyTheLost');

	// Cost
	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = 30;
	Template.Cost.ResourceCosts.AddItem(Resources);

	// Apply an effect on all non-lost units in the grenade range, to paint as targets.
	UnitTypeCondition = new class'X2Condition_UnitType';
	UnitTypeCondition.ExcludeTypes.AddItem('TheLost');
	UnitTypeCondition.ExcludeTypes.AddItem('TheLostBrute');
	LureEffect = class'X2StatusEffects'.static.CreateUltrasonicLureTargetStatusEffect();
	LureEffect.TargetConditions.AddItem(UnitTypeCondition);
	Template.ThrownGrenadeEffects.AddItem(LureEffect);

	// Apply an effect on all lost units within sight range, to activate inactive lost groups.
	LostActivateEffect = new class'X2Effect_AlertTheLost';
	Template.ThrownGrenadeEffects.AddItem(LostActivateEffect);
	Template.LaunchedGrenadeEffects = Template.ThrownGrenadeEffects;

	Template.bFriendlyFireWarning = false;

	return Template;
}