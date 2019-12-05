class X2StrategyElement_ProvingGroundTechs extends X2StrategyElement_DefaultTechs;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Techs;

	//Ammo Crafting
	Techs.AddItem(IncisionRounds());
	Techs.AddItem(StilettoRounds());
	Techs.AddItem(SeekerRounds());

	//Ammo Crafting
	Techs.AddItem(GrenadeFire());
	Techs.AddItem(GrenadeGas());
	Techs.AddItem(GrenadeAcid());

	//Protocol Crafting
	Techs.AddItem(Gremlin_Aegis());
	Techs.AddItem(Gremlin_Medical());
	Techs.AddItem(Gremlin_Wrath());
	Techs.AddItem(Gremlin_Stealth());
	Techs.AddItem(Gremlin_Overclocker());
	Techs.AddItem(Gremlin_Discharge());
	Techs.AddItem(Gremlin_Nemesis());

	//Module Crafting
	Techs.AddItem(Gremlin_SystemUplink());
	Techs.AddItem(Gremlin_Decompilation());
	Techs.AddItem(Gremlin_Interdiction());
	Techs.AddItem(Gremlin_MegaCapacitors());

	//Faction Techs
	Techs.AddItem(Gremlin_Templar());
	Techs.AddItem(Gremlin_Reaper());
	Techs.AddItem(Gremlin_Skirmisher());

	return Techs;
}

// CRAFTED AMMOs
// #######################################################################################
static function X2DataTemplate IncisionRounds()
{
	local X2TechTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2TechTemplate', Template, 'AmmoCrafting_Incision');
	Template.PointsToComplete = StafferXDays(1, 20);
	Template.strImage = "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_Talon_Rounds";
	Template.ResearchCompletedFn = GiveRandomItemReward;
	Template.bProvingGround = true;
	Template.bRepeatable = true;
	Template.SortingTier = 3;

	// Item Reward
	Template.ItemRewards.AddItem('XCom_IncisionRounds');
	Template.Requirements.RequiredTechs.AddItem('AutopsyAdventCaptain');
	Template.Requirements.RequiredTechs.AddItem('InsightTechSkirmisher');

	// Cost
	Resources.ItemTemplateName = 'CorpseAdventCaptain';
	Resources.Quantity = 2;
	Template.Cost.ResourceCosts.AddItem(Resources);
	
	Resources.ItemTemplateName = 'XCom_ShredderRounds';
	Resources.Quantity = 2;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Resources.ItemTemplateName = 'EleriumCore';
	Resources.Quantity = 2;
	Template.Cost.ResourceCosts.AddItem(Resources);

	return Template;
}

static function X2DataTemplate StilettoRounds()
{
	local X2TechTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2TechTemplate', Template, 'AmmoCrafting_Stiletto');
	Template.PointsToComplete = StafferXDays(1, 10);
	Template.strImage = "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_Stiletto_Rounds";
	Template.ResearchCompletedFn = GiveRandomItemReward;
	Template.bProvingGround = true;
	Template.bRepeatable = true;
	Template.SortingTier = 3;

	// Item Reward
	Template.ItemRewards.AddItem('XCom_StilettoRounds');
	Template.Requirements.RequiredTechs.AddItem('AutopsyAdventTurret');
	Template.Requirements.RequiredTechs.AddItem('InsightTechReaper');

	// Cost
	Resources.ItemTemplateName = 'CorpseAdventTurret';
	Resources.Quantity = 2;
	Template.Cost.ResourceCosts.AddItem(Resources);
	
	Resources.ItemTemplateName = 'XCom_APRounds';
	Resources.Quantity = 2;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Resources.ItemTemplateName = 'EleriumCore';
	Resources.Quantity = 2;
	Template.Cost.ResourceCosts.AddItem(Resources);

	return Template;
}

static function X2DataTemplate SeekerRounds()
{
	local X2TechTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2TechTemplate', Template, 'AmmoCrafting_Seeker');
	Template.PointsToComplete = StafferXDays(1, 10);
	Template.strImage = "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_Flechette_Rounds";
	Template.ResearchCompletedFn = GiveRandomItemReward;
	Template.bProvingGround = true;
	Template.bRepeatable = true;
	Template.SortingTier = 3;

	// Item Reward
	Template.ItemRewards.AddItem('XCom_SeekerRounds');
	Template.Requirements.RequiredTechs.AddItem('AutopsyCodex');
	Template.Requirements.RequiredTechs.AddItem('InsightTechTemplar');

	// Cost
	Resources.ItemTemplateName = 'CorpseCyberus';
	Resources.Quantity = 2;
	Template.Cost.ResourceCosts.AddItem(Resources);
	
	Resources.ItemTemplateName = 'XCom_TracerRounds';
	Resources.Quantity = 2;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Resources.ItemTemplateName = 'EleriumCore';
	Resources.Quantity = 2;
	Template.Cost.ResourceCosts.AddItem(Resources);

	return Template;
}

// CRAFTED GRENADES
// #######################################################################################
static function X2DataTemplate GrenadeFire()
{
	local X2TechTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2TechTemplate', Template, 'GrenadeCrafting_Fire');
	Template.PointsToComplete = StafferXDays(1, 10);
	Template.strImage = "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_firebomb";
	Template.ResearchCompletedFn = GiveRandomItemReward;
	Template.bProvingGround = true;
	Template.bRepeatable = true;
	Template.SortingTier = 3;

	// Item Reward
	Template.ItemRewards.AddItem('Firebomb');
	Template.Requirements.RequiredTechs.AddItem('AutopsyAdventPurifier');

	// Cost
	Resources.ItemTemplateName = 'CorpseAdventPurifier';
	Resources.Quantity = 3;
	Template.Cost.ResourceCosts.AddItem(Resources);
	
	Resources.ItemTemplateName = 'EleriumCore';
	Resources.Quantity = 1;
	Template.Cost.ResourceCosts.AddItem(Resources);

	return Template;
}

static function X2DataTemplate GrenadeGas()
{
	local X2TechTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2TechTemplate', Template, 'GrenadeCrafting_Gas');
	Template.PointsToComplete = StafferXDays(1, 10);
	Template.strImage = "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_gas_grenade";
	Template.ResearchCompletedFn = GiveRandomItemReward;
	Template.bProvingGround = true;
	Template.bRepeatable = true;
	Template.SortingTier = 3;

	// Item Reward
	Template.ItemRewards.AddItem('GasGrenade');
	Template.Requirements.RequiredTechs.AddItem('AutopsyViper');

	// Cost
	Resources.ItemTemplateName = 'CorpseViper';
	Resources.Quantity = 3;
	Template.Cost.ResourceCosts.AddItem(Resources);
	
	Resources.ItemTemplateName = 'EleriumCore';
	Resources.Quantity = 1;
	Template.Cost.ResourceCosts.AddItem(Resources);

	return Template;
}

static function X2DataTemplate GrenadeAcid()
{
	local X2TechTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2TechTemplate', Template, 'GrenadeCrafting_Acid');
	Template.PointsToComplete = StafferXDays(1, 10);
	Template.strImage = "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_acid_grenade";
	Template.ResearchCompletedFn = GiveRandomItemReward;
	Template.bProvingGround = true;
	Template.bRepeatable = true;
	Template.SortingTier = 3;

	// Item Reward
	Template.ItemRewards.AddItem('AcidGrenade');
	Template.Requirements.RequiredTechs.AddItem('AutopsyAndromedon');

	// Cost
	Resources.ItemTemplateName = 'CorpseAndromedon';
	Resources.Quantity = 2;
	Template.Cost.ResourceCosts.AddItem(Resources);
	
	Resources.ItemTemplateName = 'EleriumCore';
	Resources.Quantity = 1;
	Template.Cost.ResourceCosts.AddItem(Resources);

	return Template;
}

// PROTOCOL SUITES
// #######################################################################################

static function X2DataTemplate Gremlin_Aegis()
{
	local X2TechTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2TechTemplate', Template, 'GremlinModuleCrafting_Aegis');
	Template.PointsToComplete = StafferXDays(1, 10);
	Template.strImage = "img:///UILibrary_IconsMint.Fusion_Matrix_G";
	Template.ResearchCompletedFn = GiveRandomItemReward;
	Template.bProvingGround = true;
	Template.bRepeatable = true;
	Template.SortingTier = 3;

	// Item Reward
	Template.ItemRewards.AddItem('AegisSuite_Gremlin');

	Template.Requirements.RequiredTechs.AddItem('AutopsyAdventTurret');
	Template.Requirements.RequiredTechs.AddItem('AutopsyAdventMEC');
	Template.Requirements.RequiredTechs.AddItem('AutopsyAdventShieldbearer');
	Template.Requirements.RequiredTechs.AddItem('AutopsyCodex');

	// Cost
	Resources.ItemTemplateName = 'CorpseAdventShieldbearer';
	Resources.Quantity = 3;
	Template.Cost.ResourceCosts.AddItem(Resources);
	
	Resources.ItemTemplateName = 'CorpseCyberus';
	Resources.Quantity = 2;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Resources.ItemTemplateName = 'EleriumCore';
	Resources.Quantity = 1;
	Template.Cost.ResourceCosts.AddItem(Resources);

	return Template;
}

static function X2DataTemplate Gremlin_Medical()
{
	local X2TechTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2TechTemplate', Template, 'GremlinModuleCrafting_Medical');
	Template.PointsToComplete = StafferXDays(1, 10);
	Template.strImage = "img:///UILibrary_IconsMint.Fusion_Matrix_W";
	Template.ResearchCompletedFn = GiveRandomItemReward;
	Template.bProvingGround = true;
	Template.bRepeatable = true;
	Template.SortingTier = 3;

	// Item Reward
	Template.ItemRewards.AddItem('MedicalSuite_Gremlin');

	Template.Requirements.RequiredTechs.AddItem('AutopsyAdventTurret');
	Template.Requirements.RequiredTechs.AddItem('AutopsyAdventMEC');
	Template.Requirements.RequiredTechs.AddItem('AutopsyViper');
	Template.Requirements.RequiredTechs.AddItem('BattlefieldMedicine');

	// Cost
	Resources.ItemTemplateName = 'CorpseViper';
	Resources.Quantity = 1;
	Template.Cost.ResourceCosts.AddItem(Resources);
	
	Resources.ItemTemplateName = 'Nanomedikit';
	Resources.Quantity = 1;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Resources.ItemTemplateName = 'EleriumCore';
	Resources.Quantity = 1;
	Template.Cost.ResourceCosts.AddItem(Resources);

	return Template;
}

static function X2DataTemplate Gremlin_Overclocker()
{
	local X2TechTemplate Template;
	local ArtifactCost EleriumCore;

	`CREATE_X2TEMPLATE(class'X2TechTemplate', Template, 'GremlinModuleCrafting_Overclocker');
	Template.PointsToComplete = StafferXDays(1, 10);
	Template.strImage = "img:///UILibrary_IconsMint.Fusion_Matrix_V";
	Template.ResearchCompletedFn = GiveRandomItemReward;
	Template.bProvingGround = true;
	Template.bRepeatable = true;
	Template.SortingTier = 3;

	Template.ItemRewards.AddItem('OverclockerSuite_Gremlin');
	
	Template.Requirements.RequiredTechs.AddItem('AutopsyAdventTurret');
	Template.Requirements.RequiredTechs.AddItem('AutopsyAdventMEC');

// Cost
	EleriumCore.ItemTemplateName = 'EleriumCore';
 	EleriumCore.Quantity = 2;
 	Template.Cost.ResourceCosts.AddItem(EleriumCore);

	return Template;
}

static function X2DataTemplate Gremlin_Wrath()
{
	local X2TechTemplate Template;
	local ArtifactCost Resources;
	local ArtifactCost EleriumCore;

	`CREATE_X2TEMPLATE(class'X2TechTemplate', Template, 'GremlinModuleCrafting_Wrath');
	Template.PointsToComplete = StafferXDays(1, 10);
	Template.strImage = "img:///UILibrary_IconsMint.Fusion_Matrix_R";
	Template.ResearchCompletedFn = GiveRandomItemReward;
	Template.bProvingGround = true;
	Template.bRepeatable = true;
	Template.SortingTier = 3;

	Template.ItemRewards.AddItem('WrathSuite_Gremlin');
	
	Template.Requirements.RequiredTechs.AddItem('AutopsyAdventTurret');
	Template.Requirements.RequiredTechs.AddItem('AutopsyAdventMEC');
	Template.Requirements.RequiredTechs.AddItem('AutopsyAdventPurifier');
	Template.Requirements.RequiredTechs.AddItem('AutopsyBerserker');

	// Cost
 	Resources.ItemTemplateName = 'CorpseBerserker';
 	Resources.Quantity = 1;
 	Template.Cost.ResourceCosts.AddItem(Resources);

	Resources.ItemTemplateName = 'CorpseAdventPurifier';
 	Resources.Quantity = 1;
 	Template.Cost.ResourceCosts.AddItem(Resources);

	Resources.ItemTemplateName = 'CombatStims';
 	Resources.Quantity = 1;
 	Template.Cost.ResourceCosts.AddItem(Resources);

	EleriumCore.ItemTemplateName = 'EleriumCore';
 	EleriumCore.Quantity = 1;
 	Template.Cost.ResourceCosts.AddItem(EleriumCore);

	return Template;
}

static function X2DataTemplate Gremlin_Stealth()
{
	local X2TechTemplate Template;
	local ArtifactCost Resources;
	local ArtifactCost EleriumCore;

	`CREATE_X2TEMPLATE(class'X2TechTemplate', Template, 'GremlinModuleCrafting_Stealth');
	Template.PointsToComplete = StafferXDays(1, 10);
	Template.strImage = "img:///UILibrary_IconsMint.Fusion_Matrix_P";
	Template.ResearchCompletedFn = GiveRandomItemReward;
	Template.bProvingGround = true;
	Template.bRepeatable = true;
	Template.SortingTier = 3;

	Template.ItemRewards.AddItem('StealthSuite_Gremlin');
	
	Template.Requirements.RequiredTechs.AddItem('AutopsyAdventTurret');
	Template.Requirements.RequiredTechs.AddItem('AutopsyAdventMEC');
	Template.Requirements.RequiredTechs.AddItem('AutopsyFaceless');
	Template.Requirements.RequiredTechs.AddItem('AutopsySpectre');

	// Cost
 	Resources.ItemTemplateName = 'CorpseFaceless';
 	Resources.Quantity = 1;
 	Template.Cost.ResourceCosts.AddItem(Resources);

	Resources.ItemTemplateName = 'CorpseSpectre';
 	Resources.Quantity = 1;
 	Template.Cost.ResourceCosts.AddItem(Resources);

	Resources.ItemTemplateName = 'MimicBeacon';
 	Resources.Quantity = 1;
 	Template.Cost.ResourceCosts.AddItem(Resources);

	EleriumCore.ItemTemplateName = 'EleriumCore';
 	EleriumCore.Quantity = 1;
 	Template.Cost.ResourceCosts.AddItem(EleriumCore);

	return Template;
}

static function X2DataTemplate Gremlin_Discharge()
{
	local X2TechTemplate Template;
	local ArtifactCost Resources;
	local ArtifactCost EleriumCore;

	`CREATE_X2TEMPLATE(class'X2TechTemplate', Template, 'GremlinModuleCrafting_Discharge');
	Template.PointsToComplete = StafferXDays(1, 10);
	Template.strImage = "img:///UILibrary_IconsMint.Fusion_Matrix_O";
	Template.ResearchCompletedFn = GiveRandomItemReward;
	Template.bProvingGround = true;
	Template.bRepeatable = true;
	Template.SortingTier = 3;

	Template.ItemRewards.AddItem('DischargeSuite_Gremlin');
	
	Template.Requirements.RequiredTechs.AddItem('AutopsyAdventTurret');
	Template.Requirements.RequiredTechs.AddItem('AutopsyAdventMEC');
	Template.Requirements.RequiredTechs.AddItem('Tech_Elerium');
	Template.Requirements.RequiredTechs.AddItem('AutopsySectopod');

// Cost
 	Resources.ItemTemplateName = 'CorpseSectopod';
 	Resources.Quantity = 1;
 	Template.Cost.ResourceCosts.AddItem(Resources);

	EleriumCore.ItemTemplateName = 'EleriumCore';
 	EleriumCore.Quantity = 2;
 	Template.Cost.ResourceCosts.AddItem(EleriumCore);

	return Template;
}

//HAHA.
static function X2DataTemplate Gremlin_Nemesis()
{
	local X2TechTemplate Template;
	local ArtifactCost EleriumCore;

	`CREATE_X2TEMPLATE(class'X2TechTemplate', Template, 'GremlinModuleCrafting_Nemesis');
	Template.PointsToComplete = StafferXDays(1, 20);
	Template.strImage = "img:///UILibrary_IconsMint.Fusion_Matrix_B";
	Template.ResearchCompletedFn = GiveRandomItemReward;
	Template.bProvingGround = true;
	Template.bRepeatable = false;
	Template.SortingTier = 1;

	Template.ItemRewards.AddItem('NemesisSuite_Gremlin');

	Template.Requirements.RequiredTechs.AddItem('ChosenAssassinWeapons');
	Template.Requirements.RequiredTechs.AddItem('ChosenHunterWeapons');
	Template.Requirements.RequiredTechs.AddItem('ChosenWarlockWeapons');
	Template.Requirements.RequiredTechs.AddItem('InsightTechTemplar');
	Template.Requirements.RequiredTechs.AddItem('InsightTechReapar');
	Template.Requirements.RequiredTechs.AddItem('InsightTechSkirmisher');

// Cost
	EleriumCore.ItemTemplateName = 'EleriumCore';
 	EleriumCore.Quantity = 3;
 	Template.Cost.ResourceCosts.AddItem(EleriumCore);

	return Template;
}

// ENHANCEMENT MODULES
// #######################################################################################
static function X2DataTemplate Gremlin_Decompilation()
{
	local X2TechTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2TechTemplate', Template, 'GremlinModuleCrafting_Decompilation');
	Template.PointsToComplete = StafferXDays(1, 10);
	Template.strImage = "img:///UILibrary_IconsMint.Schematic_Module";
	Template.ResearchCompletedFn = GiveRandomItemReward;
	Template.bProvingGround = true;
	Template.bRepeatable = true;
	Template.SortingTier = 3;

	// Item Reward
	Template.ItemRewards.AddItem('Decompilation_Gremlin');

	Template.Requirements.RequiredTechs.AddItem('AutopsyAdventTurret');

	// Cost
	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = 50;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Resources.ItemTemplateName = 'EleriumCore';
	Resources.Quantity = 1;
	Template.Cost.ResourceCosts.AddItem(Resources);

	return Template;
}

static function X2DataTemplate Gremlin_SystemUplink()
{
	local X2TechTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2TechTemplate', Template, 'GremlinModuleCrafting_SystemUplink');
	Template.PointsToComplete = StafferXDays(1, 10);
	Template.strImage = "img:///UILibrary_IconsMint.Schematic_Module";
	Template.ResearchCompletedFn = GiveRandomItemReward;
	Template.bProvingGround = true;
	Template.bRepeatable = true;
	Template.SortingTier = 3;

	// Item Reward
	Template.ItemRewards.AddItem('SystemUplink_Gremlin');

	Template.Requirements.RequiredTechs.AddItem('AutopsyAdventTurret');
	Template.Requirements.RequiredTechs.AddItem('AutopsyAdventMEC');
	Template.Requirements.RequiredTechs.AddItem('AutopsyAdventCaptain');

	// Cost
	Resources.ItemTemplateName = 'CorpseAdventMEC';
	Resources.Quantity = 2;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Resources.ItemTemplateName = 'CorpseAdventTurret';
	Resources.Quantity = 2;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Resources.ItemTemplateName = 'CorpseAdventOfficer';
	Resources.Quantity = 2;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Resources.ItemTemplateName = 'EleriumCore';
	Resources.Quantity = 2;
	Template.Cost.ResourceCosts.AddItem(Resources);

	return Template;
}

static function X2DataTemplate Gremlin_Interdiction()
{
	local X2TechTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2TechTemplate', Template, 'GremlinModuleCrafting_Interdiction');
	Template.PointsToComplete = StafferXDays(1, 10);
	Template.strImage = "img:///UILibrary_IconsMint.Schematic_Module";
	Template.ResearchCompletedFn = GiveRandomItemReward;
	Template.bProvingGround = true;
	Template.bRepeatable = true;
	Template.SortingTier = 3;

	// Item Reward
	Template.ItemRewards.AddItem('Interdiction_Gremlin');

	Template.Requirements.RequiredTechs.AddItem('AutopsyAdventTurret');
	Template.Requirements.RequiredTechs.AddItem('AutopsyAdventMEC');
	Template.Requirements.RequiredTechs.AddItem('AutopsyMuton');

	// Cost
	Resources.ItemTemplateName = 'CorpseAdventTurret';
	Resources.Quantity = 4;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Resources.ItemTemplateName = 'CorpseMuton';
	Resources.Quantity = 4;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Resources.ItemTemplateName = 'EleriumCore';
	Resources.Quantity = 2;
	Template.Cost.ResourceCosts.AddItem(Resources);

	return Template;
}

static function X2DataTemplate Gremlin_MegaCapacitors()
{
	local X2TechTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2TechTemplate', Template, 'GremlinModuleCrafting_MegaCapacitors');
	Template.PointsToComplete = StafferXDays(1, 10);
	Template.ResearchCompletedFn = GiveRandomItemReward;
	Template.strImage = "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_Fusion_Matrix";
	Template.bProvingGround = true;
	Template.bRepeatable = true;
	Template.SortingTier = 3;

	// Item Reward
	Template.ItemRewards.AddItem('MegaCapacitor_Gremlin');

	Template.Requirements.RequiredTechs.AddItem('AutopsyAdventTurret');

	// Cost
	Resources.ItemTemplateName = 'CorpseAdventTurret';
	Resources.Quantity = 3;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Resources.ItemTemplateName = 'EleriumCore';
	Resources.Quantity = 1;
	Template.Cost.ResourceCosts.AddItem(Resources);

	return Template;
}



// FACTION TECH
// #######################################################################################

static function X2DataTemplate Gremlin_Templar()
{
	local X2TechTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2TechTemplate', Template, 'InsightTechTemplar');
	Template.PointsToComplete = StafferXDays(1, 20);
	Template.strImage = "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_Intel";
	Template.bProvingGround = true;
	Template.bRepeatable = false;
	Template.SortingTier = 1;

	Template.Requirements.RequiredHighestSoldierRank = 5;
	Template.Requirements.RequiredSoldierClass = 'Templar';
	Template.Requirements.RequiredSoldierRankClassCombo = true;
	Template.Requirements.bVisibleIfSoldierRankGatesNotMet = true;

	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = 25;
	Template.Cost.ResourceCosts.AddItem(Resources);

	return Template;
}

static function X2DataTemplate Gremlin_Reaper()
{
	local X2TechTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2TechTemplate', Template, 'InsightTechReaper');
	Template.PointsToComplete = StafferXDays(1, 20);
	Template.strImage = "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_Intel";
	Template.bProvingGround = true;
	Template.bRepeatable = false;
	Template.SortingTier = 1;

	Template.Requirements.RequiredHighestSoldierRank = 5;
	Template.Requirements.RequiredSoldierClass = 'Reaper';
	Template.Requirements.RequiredSoldierRankClassCombo = true;
	Template.Requirements.bVisibleIfSoldierRankGatesNotMet = true;

	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = 25;
	Template.Cost.ResourceCosts.AddItem(Resources);

	return Template;
}

static function X2DataTemplate Gremlin_Skirmisher()
{
	local X2TechTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2TechTemplate', Template, 'InsightTechSkirmisher');
	Template.PointsToComplete = StafferXDays(1, 20);
	Template.strImage = "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_Intel";
	Template.bProvingGround = true;
	Template.bRepeatable = false;
	Template.SortingTier = 1;

	Template.Requirements.RequiredHighestSoldierRank = 5;
	Template.Requirements.RequiredSoldierClass = 'Skirmisher';
	Template.Requirements.RequiredSoldierRankClassCombo = true;
	Template.Requirements.bVisibleIfSoldierRankGatesNotMet = true;

	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = 25;
	Template.Cost.ResourceCosts.AddItem(Resources);

	return Template;
}