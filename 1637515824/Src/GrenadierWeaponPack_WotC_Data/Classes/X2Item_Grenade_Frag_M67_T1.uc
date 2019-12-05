class X2Item_Grenade_Frag_M67_T1 extends X2Item_Master_Data config(Item_MD_WOTC_MWR_GND_FRAG_M67_STD_T1);

//E3245: Custom Config DeclarationsW
var config string UIImage;
var config string EquipSound;
var config name WeaponCategory;
var config name ItemCategory;
var config array<GrenadeAbilitiesDefs> ItemAbilities;
var config name ItemDamageType;
var config int ItemTier;
var config int PhysicsImpulse;
var config name ItemHideIfResearched;
var config name ItemVoiceBarkEvent;
var config name ItemBaseItem;
var config name ItemCreatorTemplateName;

var config EngineeringBuildDefs BuildIteminEngineering;

var config bool ItemStartingItem; //true
var config bool ItemCanBeBuilt; //false
var config bool ItemInfiniteItem; //true

//Standard Declarations
var config WeaponDamageValue ItemBaseDamage;
var config int ItemSoundRange;
var config int ItemEnvironmentDamage;
var config int ItemClipSize;
var config int ItemRange;
var config int ItemRadius;

static function X2DataTemplate CreateM67FragGrenade()
{
	local X2GrenadeTemplate Template;
	local X2Effect_ApplyWeaponDamage WeaponDamageEffect;
	local X2Effect_Knockback KnockbackEffect;
	local ArtifactCost Resources;
	local int i;
	
	`CREATE_X2TEMPLATE(class'X2GrenadeTemplate', Template, 'MD_WOTC_MWR_GND_FRAG_M67_STD_T1'); //TC_WOTC_GRENADE_FRAG_MWR_M67

	Template.strImage = default.UIImage;
	Template.WeaponCat = default.WeaponCategory;
	Template.ItemCat = default.ItemCategory;
	Template.EquipSound = default.EquipSound;
	Template.iRange = default.ItemRange;
	Template.iRadius = default.ItemRadius;

	Template.BaseDamage = default.ItemBaseDamage;
	Template.iSoundRange = default.ItemSoundRange;
	Template.iEnvironmentDamage = default.ItemEnvironmentDamage;
	Template.iClipSize = default.ItemClipSize;
	Template.DamageTypeTemplateName = default.ItemDamageType;
	Template.Tier = default.ItemTier;

	//Check if the array of structs exists
	if (default.ItemAbilities.Length > 0)
	{
		//Loop until the end of the length of the array
		for (i = 0; i < default.ItemAbilities.Length; i++)
		{
			//Add the ability name at index [i]
			Template.Abilities.AddItem(default.ItemAbilities[i].AbilityName);
			//Check if the name at index [i] also has a IconOverrideName string. 
			//It doesn't check if the string is valid though
			if (Len(default.ItemAbilities[i].IconOverrideName) > 0)
			{
				//Special case. If the Abilty 'ThrowGrenade' is defined in the config file
				if (default.ItemAbilities[i].AbilityName == 'ThrowGrenade')
				{
					//Add Ability Icon Overrides for both ThrowGrenade and it's child ability, LaunchGrenade
					Template.AddAbilityIconOverride(default.ItemAbilities[i].AbilityName, default.ItemAbilities[i].IconOverrideName);
					Template.AddAbilityIconOverride('LaunchGrenade', default.ItemAbilities[i].IconOverrideName);
				}
				else
				{
					//Otherwise add the icon override
					Template.AddAbilityIconOverride(default.ItemAbilities[i].AbilityName, default.ItemAbilities[i].IconOverrideName);
				}
			}
		}
	}
	else
	{
		//Add the default abilities
		Template.Abilities.AddItem('ThrowGrenade');
		Template.Abilities.AddItem('GrenadeFuse');
	}

	Template.OnThrowBarkSoundCue = default.ItemVoiceBarkEvent; //'ThrowGrenade'

	Template.GameArchetype = "XZ_ResOrd_Data.Archetypes.WP_Grenade_Frag_M67";

	Template.iPhysicsImpulse = default.PhysicsImpulse;

	Template.StartingItem = default.ItemStartingItem; //true
	Template.bInfiniteItem = default.ItemInfiniteItem; //true

	Template.CanBeBuilt = default.ItemCanBeBuilt; //false

	//If this is set to true
	if (default.ItemCanBeBuilt == true)
	{

		if(default.BuildIteminEngineering.RequiredEngineeringScore > 0)
		Template.Requirements.RequiredEngineeringScore = default.BuildIteminEngineering.RequiredEngineeringScore;
		
		if(default.BuildIteminEngineering.PointsToComplete > 0)
		Template.PointsToComplete = default.BuildIteminEngineering.PointsToComplete;

		Template.Requirements.bVisibleifPersonnelGatesNotMet = true;

		if (default.BuildIteminEngineering.RequiredTech1 != '' || default.BuildIteminEngineering.RequiredTech1 != 'none')
		{
			Template.Requirements.RequiredTechs.AddItem(default.BuildIteminEngineering.RequiredTech1);
		}
		if (default.BuildIteminEngineering.RequiredTech2 != '' || default.BuildIteminEngineering.RequiredTech2 != 'none')
		{
			Template.Requirements.RequiredTechs.AddItem(default.BuildIteminEngineering.RequiredTech2);
		}

		Template.Cost.ResourceCosts.AddItem(Resources);

		if (default.BuildIteminEngineering.SupplyCost > 0)
		{
			Resources.ItemTemplateName = 'Supplies';
			Resources.Quantity = default.BuildIteminEngineering.SupplyCost;
			Template.Cost.ResourceCosts.AddItem(Resources);
		}
		if (default.BuildIteminEngineering.AlloyCost > 0)
		{
			Resources.ItemTemplateName = 'AlienAlloy';
			Resources.Quantity = default.BuildIteminEngineering.AlloyCost;
			Template.Cost.ResourceCosts.AddItem(Resources);
		}
		if (default.BuildIteminEngineering.CrystalCost > 0)
		{
			Resources.ItemTemplateName = 'EleriumDust';
			Resources.Quantity = default.BuildIteminEngineering.CrystalCost;
			Template.Cost.ResourceCosts.AddItem(Resources);
		}
		if (default.BuildIteminEngineering.CoreCost > 0)
		{
			Resources.ItemTemplateName = 'EleriumCore';
			Resources.Quantity = default.BuildIteminEngineering.CoreCost;
			Template.Cost.ResourceCosts.AddItem(Resources);
		}
		if (default.BuildIteminEngineering.SpecialItemTemplateName != '' && default.BuildIteminEngineering.SpecialItemCost > 0)
		{
			Resources.ItemTemplateName = default.BuildIteminEngineering.SpecialItemTemplateName;
			Resources.Quantity = default.BuildIteminEngineering.SpecialItemCost;
			Template.Cost.ArtifactCosts.AddItem(Resources);
		}
	}

	Template.HideIfResearched = default.ItemHideIfResearched; //'PlasmaGrenade'
	Template.BaseItem = default.ItemBaseItem;
	Template.CreatorTemplateName = default.ItemCreatorTemplateName;


	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.bExplosiveDamage = true;
	Template.ThrownGrenadeEffects.AddItem(WeaponDamageEffect);
	Template.LaunchedGrenadeEffects.AddItem(WeaponDamageEffect);

	//Don't export this
	KnockbackEffect = new class'X2Effect_Knockback';
	KnockbackEffect.KnockbackDistance = 2;
	Template.ThrownGrenadeEffects.AddItem(KnockbackEffect);
	Template.LaunchedGrenadeEffects.AddItem(KnockbackEffect);

	Template.SetUIStatMarkup(class'XLocalizedData'.default.RangeLabel, , default.ItemRange);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.RadiusLabel, , default.ItemRadius);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.ShredLabel, , default.ItemBaseDamage.Shred);

	return Template;
}

defaultproperties
{
	bShouldCreateDifficultyVariants = true
}