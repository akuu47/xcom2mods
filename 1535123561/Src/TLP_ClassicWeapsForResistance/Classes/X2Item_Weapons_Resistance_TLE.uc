class X2Item_Weapons_Resistance_TLE extends X2Item config(Weapon_MD_TLP_RESISTANCE_BASE);

//E3245: Custom Config Declarations
var config string MD_TLP_RESISTANCE_AR_BALLISTIC_UIIMAGE_T2;
var config string MD_TLP_RESISTANCE_AR_BALLISTIC_WEAPONPANELIMAGE_T2;
var config string MD_TLP_RESISTANCE_AR_BALLISTIC_ARCHETYPEPATH_T2;
var config name MD_TLP_RESISTANCE_AR_BALLISTIC_DAMAGETYPE_T2;
var config string MD_TLP_RESISTANCE_AR_BALLISTIC_EQUIPSOUND_T2;


var config name MD_TLP_RESISTANCE_AR_BALLISTIC_WEAPONCATEGORY_T2;
var config name MD_TLP_RESISTANCE_AR_BALLISTIC_WEAPONTECH_T2;

var config name MD_TLP_RESISTANCE_AR_BALLISTIC_REQUIREDTECH_T2;

var config bool MD_TLP_RESISTANCE_AR_BALLISTIC_STARTINGITEM_T2; //true
var config bool MD_TLP_RESISTANCE_AR_BALLISTIC_CANBEBUILT_T2; //false
var config bool MD_TLP_RESISTANCE_AR_BALLISTIC_INFINITEITEM_T2; //true


var config int MD_TLP_RESISTANCE_AR_BALLISTIC_TIER_T2;
var config int MD_TLP_RESISTANCE_AR_BALLISTIC_PHYSICSIMPULSE_T2;
var config int MD_TLP_RESISTANCE_AR_BALLISTIC_TYPICAL_ACTIONCOST_T2;
var config float MD_TLP_RESISTANCE_AR_BALLISTIC_KNOCKBACKDAMAGE_AMOUNT_T2;
var config float MD_TLP_RESISTANCE_AR_BALLISTIC_KNOCKBACKDAMAGE_RADIUS_T2;

var config array<int> MD_TLP_RESISTANCE_AR_BALLISTIC_RANGE_T2;
var config array<WeaponAbilitiesDefs> Weapon_Abilities_T2;
var config WeaponDamageValue MD_TLP_RESISTANCE_AR_BALLISTIC_BASEDAMAGE_T2;
var config int MD_TLP_RESISTANCE_AR_BALLISTIC_CRITCHANCE_T2;
var config int MD_TLP_RESISTANCE_AR_BALLISTIC_AIM_T2;
var config int MD_TLP_RESISTANCE_AR_BALLISTIC_ICLIPSIZE_T2;
var config int MD_TLP_RESISTANCE_AR_BALLISTIC_ISOUNDRANGE_T2;
var config int MD_TLP_RESISTANCE_AR_BALLISTIC_IENVIRONMENTDAMAGE_T2;
var config int MD_TLP_RESISTANCE_AR_BALLISTIC_IUPGRADESLOTS_T2;

//E3245: Custom Config Declarations
var config string MD_TLP_RESISTANCE_AR_LASER_UIIMAGE_T3;
var config string MD_TLP_RESISTANCE_AR_LASER_WEAPONPANELIMAGE_T3;
var config string MD_TLP_RESISTANCE_AR_LASER_ARCHETYPEPATH_T3;
var config name MD_TLP_RESISTANCE_AR_LASER_DAMAGETYPE_T3;
var config string MD_TLP_RESISTANCE_AR_LASER_EQUIPSOUND_T3;


var config name MD_TLP_RESISTANCE_AR_LASER_WEAPONCATEGORY_T3;
var config name MD_TLP_RESISTANCE_AR_LASER_WEAPONTECH_T3;

var config name MD_TLP_RESISTANCE_AR_LASER_REQUIREDTECH_T3;

var config bool MD_TLP_RESISTANCE_AR_LASER_STARTINGITEM_T3; //true
var config bool MD_TLP_RESISTANCE_AR_LASER_CANBEBUILT_T3; //false
var config bool MD_TLP_RESISTANCE_AR_LASER_INFINITEITEM_T3; //true


var config int MD_TLP_RESISTANCE_AR_LASER_TIER_T3;
var config int MD_TLP_RESISTANCE_AR_LASER_PHYSICSIMPULSE_T3;
var config int MD_TLP_RESISTANCE_AR_LASER_TYPICAL_ACTIONCOST_T3;
var config float MD_TLP_RESISTANCE_AR_LASER_KNOCKBACKDAMAGE_AMOUNT_T3;
var config float MD_TLP_RESISTANCE_AR_LASER_KNOCKBACKDAMAGE_RADIUS_T3;

var config array<int> MD_TLP_RESISTANCE_AR_LASER_RANGE_T3;
var config array<WeaponAbilitiesDefs> Weapon_Abilities_T3;
var config WeaponDamageValue MD_TLP_RESISTANCE_AR_LASER_BASEDAMAGE_T3;
var config int MD_TLP_RESISTANCE_AR_LASER_CRITCHANCE_T3;
var config int MD_TLP_RESISTANCE_AR_LASER_AIM_T3;
var config int MD_TLP_RESISTANCE_AR_LASER_ICLIPSIZE_T3;
var config int MD_TLP_RESISTANCE_AR_LASER_ISOUNDRANGE_T3;
var config int MD_TLP_RESISTANCE_AR_LASER_IENVIRONMENTDAMAGE_T3;
var config int MD_TLP_RESISTANCE_AR_LASER_IUPGRADESLOTS_T3;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Weapons;

	Weapons.AddItem( CreateWeaponResistanceTLE_BallisticAR() );
	Weapons.AddItem( CreateWeaponResistanceTLE_LaserAR() );

	return Weapons;
}


static function X2DataTemplate CreateWeaponResistanceTLE_BallisticAR()
{
	local X2WeaponTemplate Template;
	local int i;

	// Main Properties of the weapon template
	//=====================================================================
	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'MD_TLP_RESISTANCE_AR_BALLISTIC_T2');
	Template.WeaponPanelImage = default.MD_TLP_RESISTANCE_AR_BALLISTIC_WEAPONPANELIMAGE_T2;                       // used by the UI. Probably determines iconview of the weapon.
	Template.EquipSound = default.MD_TLP_RESISTANCE_AR_BALLISTIC_EQUIPSOUND_T2;

	Template.ItemCat = 'weapon';
	Template.WeaponCat = default.MD_TLP_RESISTANCE_AR_BALLISTIC_WEAPONCATEGORY_T2;
	Template.WeaponTech = default.MD_TLP_RESISTANCE_AR_BALLISTIC_WEAPONTECH_T2;
	Template.strImage = default.MD_TLP_RESISTANCE_AR_BALLISTIC_UIIMAGE_T2;
	Template.Tier = default.MD_TLP_RESISTANCE_AR_BALLISTIC_TIER_T2;

	Template.RangeAccuracy = default.MD_TLP_RESISTANCE_AR_BALLISTIC_RANGE_T2;
	Template.BaseDamage = default.MD_TLP_RESISTANCE_AR_BALLISTIC_BASEDAMAGE_T2;
	Template.Aim = default.MD_TLP_RESISTANCE_AR_BALLISTIC_AIM_T2;
	Template.CritChance = default.MD_TLP_RESISTANCE_AR_BALLISTIC_CRITCHANCE_T2;
	Template.iClipSize = default.MD_TLP_RESISTANCE_AR_BALLISTIC_ICLIPSIZE_T2;
	Template.iSoundRange = default.MD_TLP_RESISTANCE_AR_BALLISTIC_ISOUNDRANGE_T2;
	Template.iEnvironmentDamage = default.MD_TLP_RESISTANCE_AR_BALLISTIC_IENVIRONMENTDAMAGE_T2;
	Template.NumUpgradeSlots = default.MD_TLP_RESISTANCE_AR_BALLISTIC_IUPGRADESLOTS_T2;

	Template.InventorySlot = eInvSlot_PrimaryWeapon;

	//Abilities Loop
	if (default.Weapon_Abilities_T2.Length > 0)
	{
		//Loop until the end of the length of the array
		for (i = 0; i < default.Weapon_Abilities_T2.Length; i++)
		{
			//Add the ability name at index [i]
			Template.Abilities.AddItem(default.Weapon_Abilities_T2[i].AbilityName);
			//Check if the name at index [i] also has a IconOverrideName string. 
			//It doesn't check if the string is valid though
			if (Len(default.Weapon_Abilities_T2[i].IconOverrideName) > 0)
			{
				Template.AddAbilityIconOverride(default.Weapon_Abilities_T2[i].AbilityName, default.Weapon_Abilities_T2[i].IconOverrideName);
			}
		}
	}
	else
	{
		//Add the default abilities
		Template.Abilities.AddItem('StandardShot');
		Template.Abilities.AddItem('Overwatch');
		Template.Abilities.AddItem('OverwatchShot');
		Template.Abilities.AddItem('Reload');
		Template.Abilities.AddItem('HotLoadAmmo');
	}

	Template.iPhysicsImpulse = default.MD_TLP_RESISTANCE_AR_BALLISTIC_PHYSICSIMPULSE_T2;
	Template.fKnockbackDamageAmount = default.MD_TLP_RESISTANCE_AR_BALLISTIC_KNOCKBACKDAMAGE_AMOUNT_T2;
	Template.fKnockbackDamageRadius = default.MD_TLP_RESISTANCE_AR_BALLISTIC_KNOCKBACKDAMAGE_RADIUS_T2;

	Template.StartingItem = default.MD_TLP_RESISTANCE_AR_BALLISTIC_STARTINGITEM_T2;
	Template.CanBeBuilt = false;
	Template.bInfiniteItem = default.MD_TLP_RESISTANCE_AR_BALLISTIC_INFINITEITEM_T2;

	Template.UIArmoryCameraPointTag = 'UIPawnLocation_WeaponUpgrade_AssaultRifle';
	Template.DamageTypeTemplateName = default.MD_TLP_RESISTANCE_AR_BALLISTIC_DAMAGETYPE_T2;	
	Template.GameArchetype = "TLE2AssaultRifle.WP_TLE2AssaultRifle"; 
	

	return Template;
}

static function X2DataTemplate CreateWeaponResistanceTLE_LaserAR()
{
	local X2WeaponTemplate Template;
	local int i;

	// Main Properties of the weapon template
	//=====================================================================
	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'MD_TLP_RESISTANCE_AR_LASER_T3');
	Template.WeaponPanelImage = default.MD_TLP_RESISTANCE_AR_LASER_WEAPONPANELIMAGE_T3;                       // used by the UI. Probably determines iconview of the weapon.
	Template.EquipSound = default.MD_TLP_RESISTANCE_AR_LASER_EQUIPSOUND_T3;

	Template.ItemCat = 'weapon';
	Template.WeaponCat = default.MD_TLP_RESISTANCE_AR_LASER_WEAPONCATEGORY_T3;
	Template.WeaponTech = default.MD_TLP_RESISTANCE_AR_LASER_WEAPONTECH_T3;
	Template.strImage = default.MD_TLP_RESISTANCE_AR_LASER_UIIMAGE_T3;
	Template.Tier = default.MD_TLP_RESISTANCE_AR_LASER_TIER_T3;

	Template.RangeAccuracy = default.MD_TLP_RESISTANCE_AR_LASER_RANGE_T3;
	Template.BaseDamage = default.MD_TLP_RESISTANCE_AR_LASER_BASEDAMAGE_T3;
	Template.Aim = default.MD_TLP_RESISTANCE_AR_LASER_AIM_T3;
	Template.CritChance = default.MD_TLP_RESISTANCE_AR_LASER_CRITCHANCE_T3;
	Template.iClipSize = default.MD_TLP_RESISTANCE_AR_LASER_ICLIPSIZE_T3;
	Template.iSoundRange = default.MD_TLP_RESISTANCE_AR_LASER_ISOUNDRANGE_T3;
	Template.iEnvironmentDamage = default.MD_TLP_RESISTANCE_AR_LASER_IENVIRONMENTDAMAGE_T3;
	Template.NumUpgradeSlots = default.MD_TLP_RESISTANCE_AR_LASER_IUPGRADESLOTS_T3;

	Template.InventorySlot = eInvSlot_PrimaryWeapon;

	//Abilities Loop
	if (default.Weapon_Abilities_T3.Length > 0)
	{
		//Loop until the end of the length of the array
		for (i = 0; i < default.Weapon_Abilities_T3.Length; i++)
		{
			//Add the ability name at index [i]
			Template.Abilities.AddItem(default.Weapon_Abilities_T3[i].AbilityName);
			//Check if the name at index [i] also has a IconOverrideName string. 
			//It doesn't check if the string is valid though
			if (Len(default.Weapon_Abilities_T3[i].IconOverrideName) > 0)
			{
				Template.AddAbilityIconOverride(default.Weapon_Abilities_T3[i].AbilityName, default.Weapon_Abilities_T3[i].IconOverrideName);
			}
		}
	}
	else
	{
		//Add the default abilities
		Template.Abilities.AddItem('StandardShot');
		Template.Abilities.AddItem('Overwatch');
		Template.Abilities.AddItem('OverwatchShot');
		Template.Abilities.AddItem('Reload');
		Template.Abilities.AddItem('HotLoadAmmo');
	}

	Template.iPhysicsImpulse = default.MD_TLP_RESISTANCE_AR_LASER_PHYSICSIMPULSE_T3;
	Template.fKnockbackDamageAmount = default.MD_TLP_RESISTANCE_AR_LASER_KNOCKBACKDAMAGE_AMOUNT_T3;
	Template.fKnockbackDamageRadius = default.MD_TLP_RESISTANCE_AR_LASER_KNOCKBACKDAMAGE_RADIUS_T3;

	Template.StartingItem = default.MD_TLP_RESISTANCE_AR_LASER_STARTINGITEM_T3;
	Template.CanBeBuilt = false;
	Template.bInfiniteItem = default.MD_TLP_RESISTANCE_AR_LASER_INFINITEITEM_T3;

	Template.UIArmoryCameraPointTag = 'UIPawnLocation_WeaponUpgrade_AssaultRifle';
	Template.DamageTypeTemplateName = default.MD_TLP_RESISTANCE_AR_LASER_DAMAGETYPE_T3;	
	Template.GameArchetype = "TLE2AssaultRifle.WP_TLE2AssaultRifle"; 
	

	return Template;
}