class X2Item_InvisPsi extends X2Item config(GameData_WeaponData);

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Weapons;

	Weapons.AddItem(CreateTemplate_InvisPsi_Conventional());

	return Weapons;
}

// **************************************************************************
// ***                       Psi Amps                                     ***
// **************************************************************************

static function X2DataTemplate CreateTemplate_InvisPsi_Conventional()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'InvisiblePsiWeapon');
	Template.WeaponPanelImage = "_PsiAmp";                  

	Template.ItemCat = 'weapon';
	Template.DamageTypeTemplateName = 'Psi';
	Template.WeaponCat = 'psiamp';
	Template.WeaponTech = 'conventional';
	Template.strImage = "img:///UILibrary_Common.ConvSecondaryWeapons.PsiAmp";
	Template.EquipSound = "Psi_Amp_Equip";
	Template.InventorySlot = eInvSlot_Utility;
	Template.StowedLocation = eSlot_RightBack;
	Template.Tier = 0;
	// This all the resources; sounds, animations, models, physics, the works.
	
	Template.GameArchetype = "WP_PsiAmp_CV.WP_PsiAmp_CV";
	Template.ExtraDamage = class'X2Item_DefaultWeapons'.default.PSIAMPT1_ABILITYDAMAGE;
	Template.CanBeBuilt = false;
	Template.HideIfResearched = 'Psionics';

	return Template;
}