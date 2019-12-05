class X2Item_MGRBlade extends X2Item config(MGRBlade);

var config bool bHFBladeIsCosmetic;
var config bool bHidePreviousTiers;
var config bool bUseSheaths;

var config WeaponDamageValue HFBLADE_CONVENTIONAL_BASEDAMAGE;
var config int  HFBLADE_CONVENTIONAL_AIM;
var config int  HFBLADE_CONVENTIONAL_CRITCHANCE;
var config int  HFBLADE_CONVENTIONAL_ICLIPSIZE;
var config int  HFBLADE_CONVENTIONAL_ISOUNDRANGE;
var config int  HFBLADE_CONVENTIONAL_IENVIRONMENTDAMAGE;
var config int  HFBLADE_CONVENTIONAL_UPGRADESLOTS;
var config int  HFBLADE_CONVENTIONAL_PANICCHANCE;
var config bool HFBLADE_CONVENTIONAL_BURN;
var config bool HFBLADE_CONVENTIONAL_DISORIENT;
var config int  HFBLADE_CONVENTIONAL_STUNCHANCE;
var config int  HFBLADE_CONVENTIONAL_ROBOTIC_DMGMOD;
var config int	HFBLADE_CONVENTIONAL_ORGANIC_DMGMOD;

var config string HFBLADE_CONVENTIONAL_ARCHETYPE;
var config string HFBLADE_CONVENTIONAL_ICON;
var config array<name> HFBLADE_CONVENTIONAL_ABILITIES;

var config WeaponDamageValue HFBLADE_MAGNETIC_BASEDAMAGE;
var config int  HFBLADE_MAGNETIC_AIM;
var config int  HFBLADE_MAGNETIC_CRITCHANCE;
var config int  HFBLADE_MAGNETIC_ICLIPSIZE;
var config int  HFBLADE_MAGNETIC_ISOUNDRANGE;
var config int  HFBLADE_MAGNETIC_IENVIRONMENTDAMAGE;
var config int  HFBLADE_MAGNETIC_UPGRADESLOTS;
var config int  HFBLADE_MAGNETIC_PANICCHANCE;
var config bool HFBLADE_MAGNETIC_BURN;
var config bool HFBLADE_MAGNETIC_DISORIENT;
var config int  HFBLADE_MAGNETIC_STUNCHANCE;
var config int  HFBLADE_MAGNETIC_ROBOTIC_DMGMOD;
var config int	HFBLADE_MAGNETIC_ORGANIC_DMGMOD;
//var config bool HFBLADE_MAGNETIC_POISON;

var config string HFBLADE_MAGNETIC_ARCHETYPE;
var config string HFBLADE_MAGNETIC_ICON;
var config array<name> HFBLADE_MAGNETIC_ABILITIES;

var config WeaponDamageValue HFBLADE_BEAM_BASEDAMAGE;
var config int  HFBLADE_BEAM_AIM;
var config int  HFBLADE_BEAM_CRITCHANCE;
var config int  HFBLADE_BEAM_ICLIPSIZE;
var config int  HFBLADE_BEAM_ISOUNDRANGE;
var config int  HFBLADE_BEAM_IENVIRONMENTDAMAGE;
var config int  HFBLADE_BEAM_UPGRADESLOTS;
var config int  HFBLADE_BEAM_PANICCHANCE;
var config bool HFBLADE_BEAM_BURN;
var config bool HFBLADE_BEAM_DISORIENT;
var config int  HFBLADE_BEAM_STUNCHANCE;
var config int  HFBLADE_BEAM_ROBOTIC_DMGMOD;
var config int	HFBLADE_BEAM_ORGANIC_DMGMOD;
//var config bool HFBLADE_BEAM_POISON;

var config string HFBLADE_BEAM_ARCHETYPE;
var config string HFBLADE_BEAM_ICON;
var config array<name> HFBLADE_BEAM_ABILITIES;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> ModWeapons;

	ModWeapons.AddItem(CreateTemplate_HFBlade());
	ModWeapons.AddItem(CreateTemplate_HFBlade_MG());
	ModWeapons.AddItem(CreateTemplate_HFBlade_BM());

		return ModWeapons;
}

static function X2DataTemplate CreateTemplate_HFBlade()
{
	local X2WeaponTemplate Template;
	local name Ability;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'HFBlade_CV');
	Template.WeaponPanelImage = "_Sword";                       // used by the UI. Probably determines iconview of the weapon.

	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'sword';
	Template.WeaponTech = 'conventional';
	//Template.strImage = "img:///UILibrary_Common.ConvSecondaryWeapons.Sword";
	Template.strImage = default.HFBLADE_CONVENTIONAL_ICON;
	Template.EquipSound = "Sword_Equip_Conventional";
	Template.InventorySlot = eInvSlot_SecondaryWeapon;
	Template.StowedLocation = eSlot_RightBack;
	// This all the resources; sounds, animations, models, physics, the works.
	//Template.GameArchetype = "WP_Sword_CV.WP_Sword_CV";
	Template.GameArchetype = default.HFBLADE_CONVENTIONAL_ARCHETYPE;
	Template.AddDefaultAttachment('Sheath', "MGRBlade_Content.Meshes.SM_HFBlade_Sheath", true);
	//if (default.bUseSheaths)
	//{
	//	Template.GameplayInstanceClass = class'XGWeaponTintableSheath';
	//	Template.AddDefaultAttachment('Sheath', "KatanaPkg.Meshes.SM_ConvKatana_Sheath", true);
	//}
	Template.Tier = 0;

	Template.iRadius = 1;
	Template.InfiniteAmmo = true;
	Template.iPhysicsImpulse = 5;

	Template.iRange = 0;

	if(default.bHFBladeIsCosmetic)
	{
		Template.NumUpgradeSlots = 1;
		Template.BaseDamage = class'X2Item_DefaultWeapons'.default.RANGERSWORD_CONVENTIONAL_BASEDAMAGE;
		Template.Aim = class'X2Item_DefaultWeapons'.default.RANGERSWORD_CONVENTIONAL_AIM;
		Template.CritChance = class'X2Item_DefaultWeapons'.default.RANGERSWORD_CONVENTIONAL_CRITCHANCE;
		Template.iSoundRange = class'X2Item_DefaultWeapons'.default.RANGERSWORD_CONVENTIONAL_ISOUNDRANGE;
		Template.iEnvironmentDamage = class'X2Item_DefaultWeapons'.default.RANGERSWORD_CONVENTIONAL_IENVIRONMENTDAMAGE;
	}
	else
	{
		Template.BaseDamage = default.HFBLADE_CONVENTIONAL_BASEDAMAGE;
		Template.NumUpgradeSlots = default.HFBLADE_CONVENTIONAL_UPGRADESLOTS;
		Template.Aim = default.HFBLADE_CONVENTIONAL_AIM;
		Template.CritChance = default.HFBLADE_CONVENTIONAL_CRITCHANCE;
		Template.iSoundRange = default.HFBLADE_CONVENTIONAL_ISOUNDRANGE;
		Template.iEnvironmentDamage = default.HFBLADE_CONVENTIONAL_IENVIRONMENTDAMAGE;
		
		Template.Abilities.AddItem('AsteryBluescreenT1');
		
		foreach default.HFBLADE_CONVENTIONAL_ABILITIES (Ability)
		{
			Template.Abilities.AddItem(Ability);
			if (Ability == 'HFBladeSpeedBonus')
			{
				Template.SetUIStatMarkup(class'XLocalizedData'.default.MobilityLabel, eStat_Mobility, class'X2Ability_ModAbilities'.default.HFBLADE_SPEED_BONUS);
			}
		}

		if(default.HFBLADE_CONVENTIONAL_STUNCHANCE > 0)
		{
			Template.SetUIStatMarkup(class'XLocalizedData'.default.StunChanceLabel, , default.HFBLADE_CONVENTIONAL_STUNCHANCE, , , "%");
			Template.BonusWeaponEffects.AddItem(class'X2StatusEffects'.static.CreateStunnedStatusEffect(2, default.HFBLADE_CONVENTIONAL_STUNCHANCE));
		}
		
		if (default.HFBLADE_CONVENTIONAL_PANICCHANCE > 0)
			{Template.BonusWeaponEffects.AddItem(class'Astery_Status_Effects'.static.CreatePanickedStatusEffectChance(default.HFBLADE_CONVENTIONAL_PANICCHANCE));}
		if (default.HFBLADE_CONVENTIONAL_BURN)
			{Template.BonusWeaponEffects.AddItem(class'X2StatusEffects'.static.CreateBurningStatusEffect(2, 0));}
		if (default.HFBLADE_CONVENTIONAL_DISORIENT)
			{Template.BonusWeaponEffects.AddItem(class'X2StatusEffects'.static.CreateDisorientedStatusEffect());}
	}

	Template.DamageTypeTemplateName = 'Melee';
	Template.BaseDamage.DamageType = 'Melee';

	Template.UpgradeItem = 'HFBlade_MG'; // Which item this can be upgraded to
	Template.StartingItem = true;
	Template.CanBeBuilt = false;
	Template.bInfiniteItem = true;

	if (default.bHidePreviousTiers)
		Template.HideIfPurchased = 'Sword_MG_Schematic';

	return Template;
}


static function X2DataTemplate CreateTemplate_HFBlade_MG()
{
	local X2WeaponTemplate Template;
	local name Ability;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'HFBlade_MG');
	Template.WeaponPanelImage = "_Sword";                       // used by the UI. Probably determines iconview of the weapon.

	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'sword';
	Template.WeaponTech = 'conventional';
	Template.strImage = default.HFBLADE_MAGNETIC_ICON;
	Template.EquipSound = "Sword_Equip_Magnetic";
	Template.InventorySlot = eInvSlot_SecondaryWeapon;
	Template.StowedLocation = eSlot_RightBack;

	Template.CreatorTemplateName = 'Sword_MG_Schematic'; // The schematic which creates this item

	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = default.HFBLADE_MAGNETIC_ARCHETYPE;
	Template.AddDefaultAttachment('Sheath', "MGRBlade_Content.Meshes.SM_HFBlade_Sheath", true);
	Template.Tier =0;

	Template.iRadius = 1;
	Template.InfiniteAmmo = true;
	Template.iPhysicsImpulse = 5;

	Template.iRange = 0;

	if(default.bHFBladeIsCosmetic)
	{
		Template.NumUpgradeSlots = 2;
		Template.BaseDamage = class'X2Item_DefaultWeapons'.default.RANGERSWORD_MAGNETIC_BASEDAMAGE;
		Template.Aim = class'X2Item_DefaultWeapons'.default.RANGERSWORD_MAGNETIC_AIM;
		Template.CritChance = class'X2Item_DefaultWeapons'.default.RANGERSWORD_MAGNETIC_CRITCHANCE;
		Template.iSoundRange = class'X2Item_DefaultWeapons'.default.RANGERSWORD_MAGNETIC_ISOUNDRANGE;
		Template.iEnvironmentDamage = class'X2Item_DefaultWeapons'.default.RANGERSWORD_MAGNETIC_IENVIRONMENTDAMAGE;

		Template.SetUIStatMarkup(class'XLocalizedData'.default.StunChanceLabel, , class'X2Item_DefaultWeapons'.default.RANGERSWORD_MAGNETIC_STUNCHANCE, , , "%");
		Template.BonusWeaponEffects.AddItem(class'X2StatusEffects'.static.CreateStunnedStatusEffect(2, class'X2Item_DefaultWeapons'.default.RANGERSWORD_MAGNETIC_STUNCHANCE, false));
	}
	else
	{
		Template.BaseDamage = default.HFBLADE_MAGNETIC_BASEDAMAGE;
		Template.NumUpgradeSlots = default.HFBLADE_MAGNETIC_UPGRADESLOTS;
		Template.Aim = default.HFBLADE_MAGNETIC_AIM;
		Template.CritChance = default.HFBLADE_MAGNETIC_CRITCHANCE;
		Template.iSoundRange = default.HFBLADE_MAGNETIC_ISOUNDRANGE;
		Template.iEnvironmentDamage = default.HFBLADE_MAGNETIC_IENVIRONMENTDAMAGE;

		Template.Abilities.AddItem('AsteryBluescreenT2');

		foreach default.HFBLADE_MAGNETIC_ABILITIES (Ability)
		{
			Template.Abilities.AddItem(Ability);
			if (Ability == 'HFBladeSpeedBonus')
			{
				Template.SetUIStatMarkup(class'XLocalizedData'.default.MobilityLabel, eStat_Mobility, class'X2Ability_ModAbilities'.default.HFBLADE_SPEED_BONUS);
			}
		}

		if(default.HFBLADE_MAGNETIC_STUNCHANCE > 0)
		{
			Template.SetUIStatMarkup(class'XLocalizedData'.default.StunChanceLabel, , default.HFBLADE_MAGNETIC_STUNCHANCE, , , "%");
			Template.BonusWeaponEffects.AddItem(class'X2StatusEffects'.static.CreateStunnedStatusEffect(2, default.HFBLADE_MAGNETIC_STUNCHANCE));
		}
		
		if (default.HFBLADE_MAGNETIC_PANICCHANCE > 0)
			{Template.BonusWeaponEffects.AddItem(class'Astery_Status_Effects'.static.CreatePanickedStatusEffectChance(default.HFBLADE_MAGNETIC_PANICCHANCE));}
		if (default.HFBLADE_MAGNETIC_BURN)
			{Template.BonusWeaponEffects.AddItem(class'X2StatusEffects'.static.CreateBurningStatusEffect(2, 0));}
		if (default.HFBLADE_MAGNETIC_DISORIENT)
			{Template.BonusWeaponEffects.AddItem(class'X2StatusEffects'.static.CreateDisorientedStatusEffect());}
	}

	Template.DamageTypeTemplateName = 'Melee';
	Template.BaseDamage.DamageType='Melee';

	Template.UpgradeItem = 'HFBlade_BM'; // Which item this can be upgraded to
	Template.BaseItem = 'HFBlade_CV';// Which item this will be upgraded from
	
	Template.StartingItem = false;
	Template.CanBeBuilt = false;
	Template.bInfiniteItem = true;
	
	if (default.bHidePreviousTiers)
		Template.HideIfPurchased = 'Sword_BM_Schematic';

	return Template;
}

static function X2DataTemplate CreateTemplate_HFBlade_BM()
{
	local X2WeaponTemplate Template;
	local name Ability;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'HFBlade_BM');
	Template.WeaponPanelImage = "_Sword";                       // used by the UI. Probably determines iconview of the weapon.

	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'sword';
	Template.WeaponTech = 'conventional';
	Template.strImage = default.HFBLADE_BEAM_ICON;
	Template.EquipSound = "Sword_Equip_Beam";
	Template.InventorySlot = eInvSlot_SecondaryWeapon;
	Template.StowedLocation = eSlot_RightBack;

	Template.CreatorTemplateName = 'Sword_BM_Schematic'; // The schematic which creates this item

	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = default.HFBLADE_BEAM_ARCHETYPE;
	Template.AddDefaultAttachment('Sheath', "MGRBlade_Content.Meshes.SM_HFBlade_Sheath", true);
	Template.Tier = 0;

	Template.iRadius = 1;
	Template.InfiniteAmmo = true;
	Template.iPhysicsImpulse = 5;

	Template.iRange = 0;

	if(default.bHFBladeIsCosmetic)
	{
		Template.NumUpgradeSlots = 2;
		Template.BaseDamage = class'X2Item_DefaultWeapons'.default.RANGERSWORD_BEAM_BASEDAMAGE;
		Template.Aim = class'X2Item_DefaultWeapons'.default.RANGERSWORD_BEAM_AIM;
		Template.CritChance = class'X2Item_DefaultWeapons'.default.RANGERSWORD_BEAM_CRITCHANCE;
		Template.iSoundRange = class'X2Item_DefaultWeapons'.default.RANGERSWORD_BEAM_ISOUNDRANGE;
		Template.iEnvironmentDamage = class'X2Item_DefaultWeapons'.default.RANGERSWORD_BEAM_IENVIRONMENTDAMAGE;

		Template.BonusWeaponEffects.AddItem(class'X2StatusEffects'.static.CreateBurningStatusEffect(2, 0));
	}
	else
	{
		Template.BaseDamage = default.HFBLADE_BEAM_BASEDAMAGE;
		Template.NumUpgradeSlots = default.HFBLADE_BEAM_UPGRADESLOTS;
		Template.Aim = default.HFBLADE_BEAM_AIM;
		Template.CritChance = default.HFBLADE_BEAM_CRITCHANCE;
		Template.iSoundRange = default.HFBLADE_BEAM_ISOUNDRANGE;
		Template.iEnvironmentDamage = default.HFBLADE_BEAM_IENVIRONMENTDAMAGE;

		Template.Abilities.AddItem('AsteryBluescreenT3');

		foreach default.HFBLADE_BEAM_ABILITIES (Ability)
		{
			Template.Abilities.AddItem(Ability);
			if (Ability == 'HFBladeSpeedBonus')
			{
				Template.SetUIStatMarkup(class'XLocalizedData'.default.MobilityLabel, eStat_Mobility, class'X2Ability_ModAbilities'.default.HFBLADE_SPEED_BONUS);
			}
		}

		if(default.HFBLADE_BEAM_STUNCHANCE > 0)
		{
			Template.SetUIStatMarkup(class'XLocalizedData'.default.StunChanceLabel, , default.HFBLADE_BEAM_STUNCHANCE, , , "%");
			Template.BonusWeaponEffects.AddItem(class'X2StatusEffects'.static.CreateStunnedStatusEffect(2, default.HFBLADE_BEAM_STUNCHANCE, false));
		}
		if (default.HFBLADE_BEAM_PANICCHANCE > 0)
			{Template.BonusWeaponEffects.AddItem(class'Astery_Status_Effects'.static.CreatePanickedStatusEffectChance(default.HFBLADE_BEAM_PANICCHANCE));}
		if (default.HFBLADE_BEAM_BURN)
			{Template.BonusWeaponEffects.AddItem(class'X2StatusEffects'.static.CreateBurningStatusEffect(2, 0));}
		if (default.HFBLADE_BEAM_DISORIENT)
			{Template.BonusWeaponEffects.AddItem(class'X2StatusEffects'.static.CreateDisorientedStatusEffect());}
	}

	Template.BaseDamage.DamageType = 'Melee';
	Template.DamageTypeTemplateName = 'Melee';

	Template.BaseItem = 'HFBlade_MG'; // Which item this will be upgraded from

	Template.StartingItem = false;
	Template.CanBeBuilt = false;
	Template.bInfiniteItem = true;
	
	return Template;
}