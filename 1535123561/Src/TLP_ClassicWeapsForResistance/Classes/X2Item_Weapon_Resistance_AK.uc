//  
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class X2Item_Weapon_Resistance_AK extends X2Item config(Weapon_MD_TLP_RESISTANCE_STOY79_AK); 


//Weapon Definitons
struct WeaponAbilitiesDefs
{
	var name AbilityName;
	var string IconOverrideName;

	structdefaultproperties
	{
		AbilityName = none;
		IconOverrideName = "";
	}
};

//Template classes are searched for by the game when it starts. Any derived classes have their CreateTemplates function called
//on the class default object. The game expects CreateTemplates to return a list of templates that it will add to the manager
//reponsible for those types of templates. Later, these templates will be automatically picked up by the game mechanics and systems.
//=======================================================================================
// Weapon Values (_T1) -- CONVENTIONAL
//=======================================================================================

//E3245: Custom Config Declarations
var config string MD_TLP_RESISTANCE_STOY79_AK_UIIMAGE_T1;
var config string MD_TLP_RESISTANCE_STOY79_AK_WEAPONPANELIMAGE_T1;
var config string MD_TLP_RESISTANCE_STOY79_AK_ARCHETYPEPATH_T1;
var config name MD_TLP_RESISTANCE_STOY79_AK_DAMAGETYPE_T1;
var config string MD_TLP_RESISTANCE_STOY79_AK_EQUIPSOUND_T1;


var config name MD_TLP_RESISTANCE_STOY79_AK_WEAPONCATEGORY_T1;
var config name MD_TLP_RESISTANCE_STOY79_AK_WEAPONTECH_T1;

var config name MD_TLP_RESISTANCE_STOY79_AK_REQUIREDTECH_T1;

var config bool MD_TLP_RESISTANCE_STOY79_AK_STARTINGITEM_T1; //true
var config bool MD_TLP_RESISTANCE_STOY79_AK_CANBEBUILT_T1; //false
var config bool MD_TLP_RESISTANCE_STOY79_AK_INFINITEITEM_T1; //true


var config int MD_TLP_RESISTANCE_STOY79_AK_TIER_T1;
var config int MD_TLP_RESISTANCE_STOY79_AK_PHYSICSIMPULSE_T1;
var config int MD_TLP_RESISTANCE_STOY79_AK_TYPICAL_ACTIONCOST_T1;
var config float MD_TLP_RESISTANCE_STOY79_AK_KNOCKBACKDAMAGE_AMOUNT_T1;
var config float MD_TLP_RESISTANCE_STOY79_AK_KNOCKBACKDAMAGE_RADIUS_T1;

var config array<int> MD_TLP_RESISTANCE_STOY79_AK_RANGE_T1;
var config array<WeaponAbilitiesDefs> Weapon_Abilities_T1;
var config WeaponDamageValue MD_TLP_RESISTANCE_STOY79_AK_BASEDAMAGE_T1;
var config int MD_TLP_RESISTANCE_STOY79_AK_CRITCHANCE_T1;
var config int MD_TLP_RESISTANCE_STOY79_AK_AIM_T1;
var config int MD_TLP_RESISTANCE_STOY79_AK_ICLIPSIZE_T1;
var config int MD_TLP_RESISTANCE_STOY79_AK_ISOUNDRANGE_T1;
var config int MD_TLP_RESISTANCE_STOY79_AK_IENVIRONMENTDAMAGE_T1;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> ModWeapons;

	ModWeapons.AddItem(CreateTemplate_MD_TLP_RESISTANCE_STOY79_AK());

	return ModWeapons;
}

//=======================================================================================
// Secondary Weapon Template (_T1)
//=======================================================================================
static function X2DataTemplate CreateTemplate_MD_TLP_RESISTANCE_STOY79_AK()
{
	local X2WeaponTemplate Template;
	local int i;

	// Main Properties of the weapon template
	//=====================================================================
	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'MD_TLP_RESISTANCE_STOY79_AK_T1');
	Template.WeaponPanelImage = default.MD_TLP_RESISTANCE_STOY79_AK_WEAPONPANELIMAGE_T1;                       // used by the UI. Probably determines iconview of the weapon.
	Template.EquipSound = default.MD_TLP_RESISTANCE_STOY79_AK_EQUIPSOUND_T1;

	Template.ItemCat = 'weapon';
	Template.WeaponCat = default.MD_TLP_RESISTANCE_STOY79_AK_WEAPONCATEGORY_T1;
	Template.WeaponTech = default.MD_TLP_RESISTANCE_STOY79_AK_WEAPONTECH_T1;
	Template.strImage = default.MD_TLP_RESISTANCE_STOY79_AK_UIIMAGE_T1;
	Template.Tier = default.MD_TLP_RESISTANCE_STOY79_AK_TIER_T1;

	Template.RangeAccuracy = default.MD_TLP_RESISTANCE_STOY79_AK_RANGE_T1;
	Template.BaseDamage = default.MD_TLP_RESISTANCE_STOY79_AK_BASEDAMAGE_T1;
	Template.Aim = default.MD_TLP_RESISTANCE_STOY79_AK_AIM_T1;
	Template.CritChance = default.MD_TLP_RESISTANCE_STOY79_AK_CRITCHANCE_T1;
	Template.iClipSize = default.MD_TLP_RESISTANCE_STOY79_AK_ICLIPSIZE_T1;
	Template.iSoundRange = default.MD_TLP_RESISTANCE_STOY79_AK_ISOUNDRANGE_T1;
	Template.iEnvironmentDamage = default.MD_TLP_RESISTANCE_STOY79_AK_IENVIRONMENTDAMAGE_T1;
	Template.NumUpgradeSlots = 0;

	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	Template.AddDefaultAttachment('Mag', "Stoy79_AK47_Stripped_10918.Meshes.AK_762x39mm_Standard_Magazine", , "");
	Template.AddDefaultAttachment('Stock', "Stoy79_AK47_Stripped_10918.Meshes.XCOMAK47_DefaultStock", , "");
	Template.AddDefaultAttachment('Suppressor', "Stoy79_AK47_Stripped_10918.Meshes.XCOMAK47_Compensator", , "");

	//Abilities Loop
	if (default.Weapon_Abilities_T1.Length > 0)
	{
		//Loop until the end of the length of the array
		for (i = 0; i < default.Weapon_Abilities_T1.Length; i++)
		{
			//Add the ability name at index [i]
			Template.Abilities.AddItem(default.Weapon_Abilities_T1[i].AbilityName);
			//Check if the name at index [i] also has a IconOverrideName string. 
			//It doesn't check if the string is valid though
			if (Len(default.Weapon_Abilities_T1[i].IconOverrideName) > 0)
			{
				Template.AddAbilityIconOverride(default.Weapon_Abilities_T1[i].AbilityName, default.Weapon_Abilities_T1[i].IconOverrideName);
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

	Template.iPhysicsImpulse = default.MD_TLP_RESISTANCE_STOY79_AK_PHYSICSIMPULSE_T1;
	Template.fKnockbackDamageAmount = default.MD_TLP_RESISTANCE_STOY79_AK_KNOCKBACKDAMAGE_AMOUNT_T1;
	Template.fKnockbackDamageRadius = default.MD_TLP_RESISTANCE_STOY79_AK_KNOCKBACKDAMAGE_RADIUS_T1;

	Template.StartingItem = default.MD_TLP_RESISTANCE_STOY79_AK_STARTINGITEM_T1;
	Template.CanBeBuilt = false;
	Template.bInfiniteItem = default.MD_TLP_RESISTANCE_STOY79_AK_INFINITEITEM_T1;

	Template.UIArmoryCameraPointTag = 'UIPawnLocation_WeaponUpgrade_AssaultRifle';
	Template.DamageTypeTemplateName = default.MD_TLP_RESISTANCE_STOY79_AK_DAMAGETYPE_T1;	
	Template.GameArchetype = "Stoy79_AK47_Stripped_10918.Archetypes.WP_AK47"; 
	
	return Template;
}