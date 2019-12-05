class X2Item_Weapon_GL_MGL140_Standard_XCOM extends X2Item_Master_Data config(Item_MD_WOTC_GL_MGL140_STD);

//E3245: Custom Config Declarations
var config string UIImage_T1;
var config string EquipSound_T1;
var config name WeaponCategory_T1;
var config name ItemCategory_T1;
var config name ItemDamageType_T1;
var config int ItemTier_T1;
var config int PhysicsImpulse_T1;
var config name ItemHideIfResearched_T1;
var config name ItemBaseItem_T1;
var config name ItemCreatorTemplateName_T1;

var config EngineeringBuildDefs BuildIteminEngineering_T1;

var config bool ItemStartingItem_T1; //true
var config bool ItemCanBeBuilt_T1; //false
var config bool ItemInfiniteItem_T1; //true

//Standard Declarations
var config WeaponDamageValue ItemBaseDamage_T1;
var config int ItemSoundRange_T1;
var config int ItemEnvironmentDamage_T1;
var config int ItemClipSize_T1;
var config int ItemRangeBonus_T1;
var config int ItemRadiusBonus_T1;


var config string UIImage_T2;
var config string EquipSound_T2;
var config name WeaponCategory_T2;
var config name ItemCategory_T2;
var config name ItemDamageType_T2;
var config int ItemTier_T2;
var config int PhysicsImpulse_T2;
var config name ItemHideIfResearched_T2;
var config name ItemBaseItem_T2;
var config name ItemCreatorTemplateName_T2;

var config EngineeringBuildDefs BuildIteminEngineering_T2;

var config bool ItemStartingItem_T2; //true
var config bool ItemCanBeBuilt_T2; //false
var config bool ItemInfiniteItem_T2; //true

//Standard Declarations
var config WeaponDamageValue ItemBaseDamage_T2;
var config int ItemSoundRange_T2;
var config int ItemEnvironmentDamage_T2;
var config int ItemClipSize_T2;
var config int ItemRangeBonus_T2;
var config int ItemRadiusBonus_T2;

static function X2GrenadeLauncherTemplate CreateItem_T1()
{
	local X2GrenadeLauncherTemplate Template;
	local ArtifactCost Resources;
	
	`CREATE_X2TEMPLATE(class'X2GrenadeLauncherTemplate', Template, 'MD_WOTC_GL_MGL140_STD_T1'); //TC_WOTC_GRENADE_FRAG_MWR_M67

	Template.strImage = default.UIImage_T1;
	Template.WeaponCat = default.WeaponCategory_T1;
	Template.ItemCat = default.ItemCategory_T1;
	Template.EquipSound = default.EquipSound_T1;
	Template.Tier = default.ItemTier_T1;

//	Template.BaseDamage = default.ItemBaseDamage_T1;
	Template.iSoundRange = default.ItemSoundRange_T1;
	Template.iEnvironmentDamage = default.ItemEnvironmentDamage_T1;
	Template.iClipSize = default.ItemClipSize_T1;
	Template.DamageTypeTemplateName = default.ItemDamageType_T1;

	Template.IncreaseGrenadeRange = default.ItemRangeBonus_T1;
	Template.IncreaseGrenadeRadius = default.ItemRadiusBonus_T1;

	Template.GameArchetype = "XZ_ResOrd_Data.Archetypes.WP_Weapon_MGL-140";

	Template.StartingItem = default.ItemStartingItem_T1; //true
	Template.bInfiniteItem = default.ItemInfiniteItem_T1; //true

	Template.CanBeBuilt = default.ItemCanBeBuilt_T1; //false

	//If this is set to true
	if (default.ItemCanBeBuilt_T1 == true)
	{
		if(default.BuildIteminEngineering_T1.RequiredEngineeringScore > 0)
		Template.Requirements.RequiredEngineeringScore = default.BuildIteminEngineering_T1.RequiredEngineeringScore;

		if(default.BuildIteminEngineering_T1.PointsToComplete > 0)
		Template.PointsToComplete = default.BuildIteminEngineering_T1.PointsToComplete;

		Template.Requirements.bVisibleifPersonnelGatesNotMet = true;

		if (default.BuildIteminEngineering_T1.RequiredTech1 != '')
		{
			Template.Requirements.RequiredTechs.AddItem(default.BuildIteminEngineering_T1.RequiredTech1);
		}
		if (default.BuildIteminEngineering_T1.RequiredTech2 != '')
		{
			Template.Requirements.RequiredTechs.AddItem(default.BuildIteminEngineering_T1.RequiredTech2);
		}

		Template.Cost.ResourceCosts.AddItem(Resources);

		if (default.BuildIteminEngineering_T1.SupplyCost > 0)
		{
			Resources.ItemTemplateName = 'Supplies';
			Resources.Quantity = default.BuildIteminEngineering_T1.SupplyCost;
			Template.Cost.ResourceCosts.AddItem(Resources);
		}
		if (default.BuildIteminEngineering_T1.AlloyCost > 0)
		{
			Resources.ItemTemplateName = 'AlienAlloy';
			Resources.Quantity = default.BuildIteminEngineering_T1.AlloyCost;
			Template.Cost.ResourceCosts.AddItem(Resources);
		}
		if (default.BuildIteminEngineering_T1.CrystalCost > 0)
		{
			Resources.ItemTemplateName = 'EleriumDust';
			Resources.Quantity = default.BuildIteminEngineering_T1.CrystalCost;
			Template.Cost.ResourceCosts.AddItem(Resources);
		}
		if (default.BuildIteminEngineering_T1.CoreCost > 0)
		{
			Resources.ItemTemplateName = 'EleriumCore';
			Resources.Quantity = default.BuildIteminEngineering_T1.CoreCost;
			Template.Cost.ResourceCosts.AddItem(Resources);
		}
		if (default.BuildIteminEngineering_T1.SpecialItemTemplateName != '' && default.BuildIteminEngineering_T1.SpecialItemCost > 0)
		{
			Resources.ItemTemplateName = default.BuildIteminEngineering_T1.SpecialItemTemplateName;
			Resources.Quantity = default.BuildIteminEngineering_T1.SpecialItemCost;
			Template.Cost.ArtifactCosts.AddItem(Resources);
		}
	}

	Template.HideIfResearched = default.ItemHideIfResearched_T1; //'PlasmaGrenade'
	Template.BaseItem = default.ItemBaseItem_T1;
	Template.CreatorTemplateName = default.ItemCreatorTemplateName_T1;

	Template.SetUIStatMarkup(class'XLocalizedData'.default.GrenadeRangeBonusLabel, , default.ItemRangeBonus_T1);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.GrenadeRadiusBonusLabel, , default.ItemRadiusBonus_T1);

	return Template;
}

static function X2GrenadeLauncherTemplate CreateItem_T2()
{
	local X2GrenadeLauncherTemplate Template;
	local ArtifactCost Resources;
	
	`CREATE_X2TEMPLATE(class'X2GrenadeLauncherTemplate', Template, 'MD_WOTC_GL_MGL140_STD_T2'); //TC_WOTC_GRENADE_FRAG_MWR_M67

	Template.strImage = default.UIImage_T2;
	Template.WeaponCat = default.WeaponCategory_T2;
	Template.ItemCat = default.ItemCategory_T2;
	Template.EquipSound = default.EquipSound_T2;
	Template.Tier = default.ItemTier_T2;

//	Template.BaseDamage = default.ItemBaseDamage_T2;
	Template.iSoundRange = default.ItemSoundRange_T2;
	Template.iEnvironmentDamage = default.ItemEnvironmentDamage_T2;
	Template.iClipSize = default.ItemClipSize_T2;
	Template.DamageTypeTemplateName = default.ItemDamageType_T2;

	Template.IncreaseGrenadeRange	= default.ItemRangeBonus_T2;
	Template.IncreaseGrenadeRadius	= default.ItemRadiusBonus_T2;

	Template.GameArchetype = "XZ_ResOrd_Data.Archetypes.WP_Weapon_MGL-140";

	Template.StartingItem = default.ItemStartingItem_T2; //true
	Template.bInfiniteItem = default.ItemInfiniteItem_T2; //true

	Template.CanBeBuilt = default.ItemCanBeBuilt_T2; //false

	//If this is set to true
	if (default.ItemCanBeBuilt_T2 == true)
	{
		if(default.BuildIteminEngineering_T2.RequiredEngineeringScore > 0)
		Template.Requirements.RequiredEngineeringScore = default.BuildIteminEngineering_T2.RequiredEngineeringScore;

		if(default.BuildIteminEngineering_T2.PointsToComplete > 0)
		Template.PointsToComplete = default.BuildIteminEngineering_T2.PointsToComplete;

		Template.Requirements.bVisibleifPersonnelGatesNotMet = true;

		if (default.BuildIteminEngineering_T2.RequiredTech1 != '')
		{
			Template.Requirements.RequiredTechs.AddItem(default.BuildIteminEngineering_T2.RequiredTech1);
		}
		if (default.BuildIteminEngineering_T2.RequiredTech2 != '')
		{
			Template.Requirements.RequiredTechs.AddItem(default.BuildIteminEngineering_T2.RequiredTech2);
		}

		Template.Cost.ResourceCosts.AddItem(Resources);

		if (default.BuildIteminEngineering_T2.SupplyCost > 0)
		{
			Resources.ItemTemplateName = 'Supplies';
			Resources.Quantity = default.BuildIteminEngineering_T2.SupplyCost;
			Template.Cost.ResourceCosts.AddItem(Resources);
		}
		if (default.BuildIteminEngineering_T2.AlloyCost > 0)
		{
			Resources.ItemTemplateName = 'AlienAlloy';
			Resources.Quantity = default.BuildIteminEngineering_T2.AlloyCost;
			Template.Cost.ResourceCosts.AddItem(Resources);
		}
		if (default.BuildIteminEngineering_T2.CrystalCost > 0)
		{
			Resources.ItemTemplateName = 'EleriumDust';
			Resources.Quantity = default.BuildIteminEngineering_T2.CrystalCost;
			Template.Cost.ResourceCosts.AddItem(Resources);
		}
		if (default.BuildIteminEngineering_T2.CoreCost > 0)
		{
			Resources.ItemTemplateName = 'EleriumCore';
			Resources.Quantity = default.BuildIteminEngineering_T2.CoreCost;
			Template.Cost.ResourceCosts.AddItem(Resources);
		}
		if (default.BuildIteminEngineering_T2.SpecialItemTemplateName != '' && default.BuildIteminEngineering_T2.SpecialItemCost > 0)
		{
			Resources.ItemTemplateName = default.BuildIteminEngineering_T2.SpecialItemTemplateName;
			Resources.Quantity = default.BuildIteminEngineering_T2.SpecialItemCost;
			Template.Cost.ArtifactCosts.AddItem(Resources);
		}
	}

	Template.HideIfResearched = default.ItemHideIfResearched_T2; //'PlasmaGrenade'
	Template.BaseItem = default.ItemBaseItem_T2;
	Template.CreatorTemplateName = default.ItemCreatorTemplateName_T2;

	Template.SetUIStatMarkup(class'XLocalizedData'.default.GrenadeRangeBonusLabel, , default.ItemRangeBonus_T2);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.GrenadeRadiusBonusLabel, , default.ItemRadiusBonus_T2);

	return Template;
}