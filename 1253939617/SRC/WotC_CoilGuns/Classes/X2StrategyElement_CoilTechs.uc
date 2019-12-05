//---------------------------------------------------------------------------------------
//  Borrows HEAVILY from 
//  FILE:    X2StrategyElement_LaserTechs.uc
//  AUTHOR:  Amineri / Long War Studios
//---------------------------------------------------------------------------------------
class X2StrategyElement_CoilTechs extends X2StrategyElement config(WotC_CoilGuns);

var config int COILGUN_TECH_SUPPLYCOST;
var config int COILGUN_TECH_ALLOYCOST;
var config int COILGUN_TECH_ELERIUMCOST;
var config int ADVANCED_COILGUN_TECH_SUPPLYCOST;
var config int ADVANCED_COILGUN_TECH_ALLOYCOST;
var config int ADVANCED_COILGUN_TECH_ELERIUMCOST;

//var config bool COIL_TIER_THREE;

var array<name> CoilGunTech_Tier;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Techs;

	// Weapon Techs
	Techs.AddItem(CreateCoilgunsTemplate());
	Techs.AddItem(CreateAdvancedCoilgunsTemplate());

	//UpdateBaseGameTechs();

	return Techs;
}

static function X2DataTemplate CreateCoilGunsTemplate()
{
	local X2TechTemplate Template;
	local ArtifactCost Resources, Artifacts;

	`CREATE_X2TEMPLATE(class'X2TechTemplate', Template, default.CoilGunTech_Tier[0]);
	Template.PointsToComplete = 11000;
	Template.SortingTier = 1;
	Template.strImage = "img:///UILibrary_LW_Coilguns.TECH_CoilWeapons"; 

	// Requirements
	Template.Requirements.RequiredTechs.AddItem('GaussWeapons');
	Template.Requirements.RequiredTechs.AddItem('Tech_Elerium');
	
	// Cost
	// only add if configured value greater than 0
	if (default.COILGUN_TECH_SUPPLYCOST > 0)
	{
		Resources.ItemTemplateName = 'Supplies';
		Resources.Quantity = default.COILGUN_TECH_SUPPLYCOST;
		Template.Cost.ResourceCosts.AddItem(Resources);
	}
	// only add if configured value greater than 0
	if (default.COILGUN_TECH_ALLOYCOST > 0)
	{
		Artifacts.ItemTemplateName = 'AlienAlloy';
		Artifacts.Quantity = default.COILGUN_TECH_ALLOYCOST;
		Template.Cost.ResourceCosts.AddItem(Artifacts);
	}
	// only add if configured value greater than 0
	if (default.COILGUN_TECH_ELERIUMCOST > 0)
	{
		Artifacts.ItemTemplateName = 'EleriumDust';
		Artifacts.Quantity = default.COILGUN_TECH_ELERIUMCOST;
		Template.Cost.ResourceCosts.AddItem(Artifacts);
	}

	return Template;
}

static function X2DataTemplate CreateAdvancedCoilgunsTemplate()
{
	local X2TechTemplate Template;
	local ArtifactCost Resources, Artifacts;

	`CREATE_X2TEMPLATE(class'X2TechTemplate', Template, default.CoilGunTech_Tier[1]);
	Template.PointsToComplete = 11000;
	Template.SortingTier = 1;
	Template.strImage = "img:///UILibrary_LW_Coilguns.TECH_AdvancedCoilWeapons";  

	// Requirements
	Template.Requirements.RequiredTechs.AddItem(class'X2StrategyElement_CoilTechs'.default.CoilGunTech_Tier[0]);

	// Cost
	// only add if configured value greater than 0
	if (default.ADVANCED_COILGUN_TECH_SUPPLYCOST > 0) 
	{
		Resources.ItemTemplateName = 'Supplies';
		Resources.Quantity = default.ADVANCED_COILGUN_TECH_SUPPLYCOST;
		Template.Cost.ResourceCosts.AddItem(Resources);
	}
	// only add if configured value greater than 0
	if (default.ADVANCED_COILGUN_TECH_ALLOYCOST > 0) 
	{
		Artifacts.ItemTemplateName = 'AlienAlloy';
		Artifacts.Quantity = default.ADVANCED_COILGUN_TECH_ALLOYCOST;
		Template.Cost.ResourceCosts.AddItem(Artifacts);
	}
	// only add if configured value greater than 0
	if (default.ADVANCED_COILGUN_TECH_ELERIUMCOST > 0) 
	{
		Artifacts.ItemTemplateName = 'EleriumDust';
		Artifacts.Quantity = default.ADVANCED_COILGUN_TECH_ELERIUMCOST;
		Template.Cost.ResourceCosts.AddItem(Artifacts);
	}

	return Template;
}

defaultProperties
{
	CoilGunTech_Tier[0]="CoilGunTech_LW";
	CoilGunTech_Tier[1]="AdvancedCoilGunTech_LW";
}