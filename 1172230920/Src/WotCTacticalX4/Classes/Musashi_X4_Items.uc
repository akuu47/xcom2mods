class Musashi_X4_Items extends X2Item config(X4);

var config WeaponDamageValue C4_BASEDAMAGE;
var config int C4_ISOUNDRANGE;
var config int C4_IENVIRONMENTDAMAGE;
var config int C4_ISUPPLIES;
var config int C4_TRADINGPOSTVALUE;
var config int C4_IPOINTS;
var config int C4_ICLIPSIZE;
var config int C4_RANGE;
var config int C4_RADIUS;

var config WeaponDamageValue X4_BASEDAMAGE;
var config int X4_ISOUNDRANGE;
var config int X4_IENVIRONMENTDAMAGE;
var config int X4_ISUPPLIES;
var config int X4_TRADINGPOSTVALUE;
var config int X4_IPOINTS;
var config int X4_ICLIPSIZE;
var config int X4_RANGE;
var config int X4_RADIUS;

var config WeaponDamageValue E4_BASEDAMAGE;
var config int E4_ISOUNDRANGE;
var config int E4_IENVIRONMENTDAMAGE;
var config int E4_ISUPPLIES;
var config int E4_TRADINGPOSTVALUE;
var config int E4_IPOINTS;
var config int E4_ICLIPSIZE;
var config int E4_RANGE;
var config int E4_RADIUS;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Grenades;

	Grenades.AddItem(C4());
	Grenades.AddItem(X4());
	Grenades.AddItem(EleriumX4());
	
	return Grenades;
}

static function X2GrenadeTemplate C4()
{
	local X2GrenadeTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2GrenadeTemplate', Template, 'TacticalC4');

	Template.strImage = "img:///Texture2D'X4Mod.UILIB.Inv_C4'";
	Template.EquipSound = "StrategyUI_Grenade_Equip";
	Template.iRange = default.C4_RANGE;
	Template.iRadius = default.C4_RADIUS;
	Template.iClipSize = default.C4_ICLIPSIZE;
	Template.BaseDamage = default.C4_BASEDAMAGE;
	Template.iSoundRange = default.C4_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.C4_IENVIRONMENTDAMAGE;
	Template.DamageTypeTemplateName = 'Explosion';
	Template.Tier = -1;

	Template.Abilities.AddItem(class'Musashi_X4_AbilitySet'.default.PlantC4AbilityName);
	Template.Abilities.AddItem(class'Musashi_X4_AbilitySet'.default.TriggerC4AbilityName);
	Template.Abilities.AddItem(class'Musashi_X4_AbilitySet'.default.ExplodeC4AbilityName);

	Template.bOverrideConcealmentRule = true;               //  override the normal behavior for the throw or launch grenade ability
	Template.OverrideConcealmentRule = eConceal_Always;     //  always stay concealed when planting x4
	Template.bSoundOriginatesFromOwnerLocation = false;

	Template.GameArchetype = "XComWeapon'X4Mod.Archetypes.WP_C4'";

	Template.iPhysicsImpulse = 10;

	Template.bMergeAmmo = true;
	Template.bInfiniteItem = true;
	Template.CanBeBuilt = false;
	Template.StartingItem = true;	
	Template.PointsToComplete = 0;
	Template.TradingPostValue = default.C4_TRADINGPOSTVALUE;
	
	Resources.ItemTemplateName = 'Supplies';
 	Resources.Quantity = default.C4_ISUPPLIES;
 	Template.Cost.ResourceCosts.AddItem(Resources);

	Template.SetUIStatMarkup(class'XLocalizedData'.default.RangeLabel, , default.C4_RANGE);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.RadiusLabel, , default.C4_RADIUS);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.ShredLabel, , default.C4_BASEDAMAGE.Shred);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.PierceLabel, , default.C4_BASEDAMAGE.Pierce);
	
	Template.SetAnimationNameForAbility(class'Musashi_X4_AbilitySet'.default.PlantC4AbilityName, 'PlantBomb_insert_Shot03_Soldier1');

	return Template;
}

static function X2GrenadeTemplate X4()
{
	local X2GrenadeTemplate Template;
	local ArtifactCost Artifacts;
	local ArtifactCost Resources;
	
	`CREATE_X2TEMPLATE(class'X2GrenadeTemplate', Template, 'TacticalX4');

	Template.strImage = "img:///Texture2D'X4Mod.UILIB.Inv_X4'";
	Template.EquipSound = "StrategyUI_Grenade_Equip";
	Template.iRange = default.X4_RANGE;
	Template.iRadius = default.X4_RADIUS;
	Template.iClipSize = default.X4_ICLIPSIZE;
	Template.BaseDamage = default.X4_BASEDAMAGE;
	Template.iSoundRange = default.X4_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.X4_IENVIRONMENTDAMAGE;
	Template.DamageTypeTemplateName = 'Explosion';
	Template.Tier = -1;

	Template.Abilities.AddItem(class'Musashi_X4_AbilitySet'.default.PlantX4AbilityName);
	Template.Abilities.AddItem(class'Musashi_X4_AbilitySet'.default.TriggerX4AbilityName);
	Template.Abilities.AddItem(class'Musashi_X4_AbilitySet'.default.ExplodeX4AbilityName);

	Template.bOverrideConcealmentRule = true;               //  override the normal behavior for the throw or launch grenade ability
	Template.OverrideConcealmentRule = eConceal_Always;     //  always stay concealed when planting x4
	Template.bSoundOriginatesFromOwnerLocation = false;

	Template.GameArchetype = "XComWeapon'X4Mod.Archetypes.WP_X4'";

	Template.iPhysicsImpulse = 10;

	Template.bMergeAmmo = true;
	Template.bInfiniteItem = false;
	Template.CanBeBuilt = true;	
	Template.PointsToComplete = 0;
	Template.TradingPostValue = default.X4_TRADINGPOSTVALUE;
		
	Template.Requirements.RequiredTechs.AddItem('AutopsyMuton');

	Resources.ItemTemplateName = 'Supplies';
 	Resources.Quantity = default.X4_ISUPPLIES;
 	Template.Cost.ResourceCosts.AddItem(Resources);
	
	Resources.ItemTemplateName = 'AlienAlloy';
	Resources.Quantity = 5;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Template.SetUIStatMarkup(class'XLocalizedData'.default.RangeLabel, , default.X4_RANGE);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.RadiusLabel, , default.X4_RADIUS);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.ShredLabel, , default.X4_BASEDAMAGE.Shred);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.PierceLabel, , default.X4_BASEDAMAGE.Pierce);
	
	return Template;
}

static function X2GrenadeTemplate EleriumX4()
{
	local X2GrenadeTemplate Template;
	local ArtifactCost Artifacts;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2GrenadeTemplate', Template, 'TacticalE4');

	Template.strImage = "img:///Texture2D'X4Mod.UILIB.Inv_E4'";
	Template.EquipSound = "StrategyUI_Grenade_Equip";
	Template.iRange = default.E4_RANGE;
	Template.iRadius = default.E4_RADIUS;
	Template.iClipSize = default.E4_ICLIPSIZE;
	Template.BaseDamage = default.E4_BASEDAMAGE;
	Template.iSoundRange = default.E4_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.E4_IENVIRONMENTDAMAGE;
	Template.DamageTypeTemplateName = 'Explosion';
	Template.Tier = -1;

	Template.Abilities.AddItem(class'Musashi_X4_AbilitySet'.default.PlantE4AbilityName);
	Template.Abilities.AddItem(class'Musashi_X4_AbilitySet'.default.TriggerE4AbilityName);
	Template.Abilities.AddItem(class'Musashi_X4_AbilitySet'.default.ExplodeE4AbilityName);

	Template.bOverrideConcealmentRule = true;               //  override the normal behavior for the throw or launch grenade ability
	Template.OverrideConcealmentRule = eConceal_Always;     //  always stay concealed when planting x4
	Template.bSoundOriginatesFromOwnerLocation = false;

	Template.GameArchetype = "XComWeapon'X4Mod.Archetypes.WP_E4'";

	Template.iPhysicsImpulse = 10;

	Template.bMergeAmmo = true;
	Template.bInfiniteItem = false;
	Template.CanBeBuilt = true;	
	Template.PointsToComplete = 0;
	Template.TradingPostValue = default.E4_TRADINGPOSTVALUE;
	
	Template.Requirements.RequiredTechs.AddItem('AutopsyAndromedon');

	Resources.ItemTemplateName = 'Supplies';
 	Resources.Quantity = default.E4_ISUPPLIES;
 	Template.Cost.ResourceCosts.AddItem(Resources);

	Artifacts.ItemTemplateName = 'EleriumCore';
	Artifacts.Quantity = 1;
	Template.Cost.ArtifactCosts.AddItem(Artifacts);
	
	Resources.ItemTemplateName = 'EleriumDust';
	Resources.Quantity = 10;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Template.SetUIStatMarkup(class'XLocalizedData'.default.RangeLabel, , default.E4_RANGE);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.RadiusLabel, , default.E4_RADIUS);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.ShredLabel, , default.E4_BASEDAMAGE.Shred);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.PierceLabel, , default.E4_BASEDAMAGE.Pierce);

	return Template;
}

defaultproperties
{
	bShouldCreateDifficultyVariants = true
}