class X2StrategyElement_NewAcademyUnlocks extends X2StrategyElement config(Mint_StrategyOverhaul);

var config int Basic_Cost, Intermediate_Cost, Expert_Cost;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	// Basegame
	Templates.AddItem(SwordBasicUnlock());
	Templates.AddItem(SwordIntermediateUnlock());
	Templates.AddItem(SwordExpertUnlock());
	Templates.AddItem(PistolBasicUnlock());
	Templates.AddItem(PistolIntermediateUnlock());
	Templates.AddItem(PistolExpertUnlock());

	// LW 2 SECONDARIES
	Templates.AddItem(PumpActionUnlock());
	Templates.AddItem(CombativesUnlock());
	Templates.AddItem(ArcThrowerBasicUnlock());
	Templates.AddItem(ArcthrowerIntermediateUnlock());
	Templates.AddItem(ArcthrowerExpertUnlock());
	Templates.AddItem(HolotargeterBasicUnlock());
	Templates.AddItem(HolotargeterIntermediateUnlock());
	Templates.AddItem(HolotargeterExpertUnlock());



	return Templates;
}

// #######################################################################################
// -------------------- SWORD	------------------------------------------------------
// #######################################################################################

static function X2SoldierGTSUnlockTemplate SwordBasicUnlock()
{
	local X2SoldierGTSUnlockTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2SoldierGTSUnlockTemplate', Template, 'SwordBasicUnlock');

	Template.AllowedClasses.AddItem('Operative_Mint');
	Template.AbilityName = 'Blademaster';
	Template.InventorySlot = eInvSlot_SecondaryWeapon;
	Template.strImage = "img:///UILibrary_IconsMint.GTS_Sword_Basic";

	// Requirements
	Template.Requirements.RequiredHighestSoldierRank = 3;
	Template.Requirements.bVisibleIfSoldierRankGatesNotMet = true;

	// Cost
	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = default.Basic_Cost;
	Template.Cost.ResourceCosts.AddItem(Resources);

	return Template;
}

static function X2SoldierGTSUnlockTemplate SwordIntermediateUnlock()
{
	local X2SoldierGTSUnlockTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2SoldierGTSUnlockTemplate', Template, 'SwordIntermediateUnlock');

	Template.AllowedClasses.AddItem('Operative_Mint');
	Template.AbilityName = 'MNT_SwordMomentum';
	Template.InventorySlot = eInvSlot_SecondaryWeapon;
	Template.strImage = "img:///UILibrary_IconsMint.GTS_Sword_Intermediate";

	// Requirements
	Template.Requirements.RequiredHighestSoldierRank = 5;
	Template.Requirements.bVisibleIfSoldierRankGatesNotMet = true;

	// Cost
	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = default.Intermediate_Cost;
	Template.Cost.ResourceCosts.AddItem(Resources);

	return Template;
}

static function X2SoldierGTSUnlockTemplate SwordExpertUnlock()
{
	local X2SoldierGTSUnlockTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2SoldierGTSUnlockTemplate', Template, 'SwordExpertUnlock');

	Template.AllowedClasses.AddItem('Operative_Mint');
	Template.AbilityName = 'Bladestorm';
	Template.InventorySlot = eInvSlot_SecondaryWeapon;
	Template.strImage = "img:///UILibrary_IconsMint.GTS_Sword_Expert";

	// Requirements
	Template.Requirements.RequiredHighestSoldierRank = 7;
	Template.Requirements.bVisibleIfSoldierRankGatesNotMet = true;
	Template.Requirements.RequiredTechs.AddItem('InsightTechTemplar');

	// Cost
	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = default.Expert_Cost;
	Template.Cost.ResourceCosts.AddItem(Resources);

	return Template;
}

// #######################################################################################
// -------------------- PISTOL	------------------------------------------------------
// #######################################################################################

static function X2SoldierGTSUnlockTemplate PistolBasicUnlock()
{
	local X2SoldierGTSUnlockTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2SoldierGTSUnlockTemplate', Template, 'PistolBasicUnlock');

	Template.AllowedClasses.AddItem('Operative_Mint');
	Template.AbilityName = 'ReturnFire';
	Template.InventorySlot = eInvSlot_SecondaryWeapon;
	Template.strImage = "img:///UILibrary_IconsMint.GTS_Pistol_Basic";

	// Requirements
	Template.Requirements.RequiredHighestSoldierRank = 3;
	Template.Requirements.bVisibleIfSoldierRankGatesNotMet = true;

	// Cost
	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = default.Basic_Cost;
	Template.Cost.ResourceCosts.AddItem(Resources);

	return Template;
}

static function X2SoldierGTSUnlockTemplate PistolIntermediateUnlock()
{
	local X2SoldierGTSUnlockTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2SoldierGTSUnlockTemplate', Template, 'PistolIntermediateUnlock');

	Template.AllowedClasses.AddItem('Operative_Mint');
	Template.AbilityName = 'LightningHands';
	Template.InventorySlot = eInvSlot_SecondaryWeapon;
	Template.strImage = "img:///UILibrary_IconsMint.GTS_Pistol_Intermediate";

	// Requirements
	Template.Requirements.RequiredHighestSoldierRank = 5;
	Template.Requirements.bVisibleIfSoldierRankGatesNotMet = true;

	// Cost
	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = default.Intermediate_Cost;
	Template.Cost.ResourceCosts.AddItem(Resources);

	return Template;
}

static function X2SoldierGTSUnlockTemplate PistolExpertUnlock()
{
	local X2SoldierGTSUnlockTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2SoldierGTSUnlockTemplate', Template, 'PistolExpertUnlock');

	Template.AllowedClasses.AddItem('Operative_Mint');
	Template.AbilityName = 'Faceoff';
	Template.InventorySlot = eInvSlot_SecondaryWeapon;
	Template.strImage = "img:///UILibrary_IconsMint.GTS_Pistol_Expert";

	// Requirements
	Template.Requirements.RequiredHighestSoldierRank = 7;
	Template.Requirements.bVisibleIfSoldierRankGatesNotMet = true;
	Template.Requirements.RequiredTechs.AddItem('InsightTechTemplar');

	// Cost
	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = default.Expert_Cost;
	Template.Cost.ResourceCosts.AddItem(Resources);

	return Template;
}

// #######################################################################################
// -------------------- LW2	------------------------------------------------------
// #######################################################################################

static function X2SoldierGTSUnlockTemplate PumpActionUnlock()
{
	local X2SoldierGTSUnlockTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2SoldierGTSUnlockTemplate', Template, 'PumpActionUnlock');

	 Template.AllowedClasses.AddItem('Operative_Mint');
	Template.AbilityName = 'PumpAction';
	Template.InventorySlot = eInvSlot_SecondaryWeapon;
	Template.strImage = "img:///UILibrary_IconsMint.GTS_SawedOff_Upgrade";

	// Requirements
	Template.Requirements.RequiredHighestSoldierRank = 3;
	Template.Requirements.bVisibleIfSoldierRankGatesNotMet = true;

	// Cost
	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = default.Basic_Cost;
	Template.Cost.ResourceCosts.AddItem(Resources);

	return Template;
}

static function X2SoldierGTSUnlockTemplate CombativesUnlock()
{
	local X2SoldierGTSUnlockTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2SoldierGTSUnlockTemplate', Template, 'CombativesUnlock');

	 Template.AllowedClasses.AddItem('Operative_Mint');
	Template.AbilityName = 'Combatives';
	Template.InventorySlot = eInvSlot_SecondaryWeapon;
	Template.strImage = "img:///UILibrary_IconsMint.GTS_Knife_Upgrade";

	// Requirements
	Template.Requirements.RequiredHighestSoldierRank = 3;
	Template.Requirements.bVisibleIfSoldierRankGatesNotMet = true;

	// Cost
	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = default.Basic_Cost;
	Template.Cost.ResourceCosts.AddItem(Resources);

	return Template;
}

static function X2SoldierGTSUnlockTemplate ArcThrowerBasicUnlock()
{
	local X2SoldierGTSUnlockTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2SoldierGTSUnlockTemplate', Template, 'ArcThrowerBasicUnlock');

	 Template.AllowedClasses.AddItem('Operative_Mint');
	Template.AbilityName = 'EMPulsar';
	Template.InventorySlot = eInvSlot_SecondaryWeapon;
	Template.strImage = "img:///UILibrary_IconsMint.GTS_ArcThrower_Basic";

	// Requirements
	Template.Requirements.RequiredHighestSoldierRank = 3;
	Template.Requirements.bVisibleIfSoldierRankGatesNotMet = true;

	// Cost
	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = default.Basic_Cost;
	Template.Cost.ResourceCosts.AddItem(Resources);

	return Template;
}

static function X2SoldierGTSUnlockTemplate ArcThrowerIntermediateUnlock()
{
	local X2SoldierGTSUnlockTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2SoldierGTSUnlockTemplate', Template, 'ArcThrowerIntermediateUnlock');

	 Template.AllowedClasses.AddItem('Operative_Mint');
	Template.AbilityName = 'StunGunner';
	Template.InventorySlot = eInvSlot_SecondaryWeapon;
	Template.strImage = "img:///UILibrary_IconsMint.GTS_ArcThrower_Intermediate";

	// Requirements
	Template.Requirements.RequiredHighestSoldierRank = 5;
	Template.Requirements.bVisibleIfSoldierRankGatesNotMet = true;

	// Cost
	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = default.Intermediate_Cost;
	Template.Cost.ResourceCosts.AddItem(Resources);

	return Template;
}

static function X2SoldierGTSUnlockTemplate ArcThrowerExpertUnlock()
{
	local X2SoldierGTSUnlockTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2SoldierGTSUnlockTemplate', Template, 'ArcThrowerExpertUnlock');

	 Template.AllowedClasses.AddItem('Operative_Mint');
	Template.AbilityName = 'ChainLightning';
	Template.InventorySlot = eInvSlot_SecondaryWeapon;
	Template.strImage = "img:///UILibrary_IconsMint.GTS_ArcThrower_Expert";

	// Requirements
	Template.Requirements.RequiredHighestSoldierRank = 7;
	Template.Requirements.bVisibleIfSoldierRankGatesNotMet = true;
	Template.Requirements.RequiredTechs.AddItem('InsightTechSkirmisher');

	// Cost
	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = default.Expert_Cost;
	Template.Cost.ResourceCosts.AddItem(Resources);

	return Template;
}

static function X2SoldierGTSUnlockTemplate HolotargeterBasicUnlock()
{
	local X2SoldierGTSUnlockTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2SoldierGTSUnlockTemplate', Template, 'HolotargeterBasicUnlock');

	 Template.AllowedClasses.AddItem('Operative_Mint');
	Template.AbilityName = 'HDHolo';
	Template.InventorySlot = eInvSlot_SecondaryWeapon;
	Template.strImage = "img:///UILibrary_IconsMint.GTS_Holotargeter_Basic";

	// Requirements
	Template.Requirements.RequiredHighestSoldierRank = 3;
	Template.Requirements.bVisibleIfSoldierRankGatesNotMet = true;

	// Cost
	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = default.Basic_Cost;
	Template.Cost.ResourceCosts.AddItem(Resources);

	return Template;
}

static function X2SoldierGTSUnlockTemplate HolotargeterIntermediateUnlock()
{
	local X2SoldierGTSUnlockTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2SoldierGTSUnlockTemplate', Template, 'HolotargeterIntermediateUnlock');

	 Template.AllowedClasses.AddItem('Operative_Mint');
	Template.AbilityName = 'VitalPointTargeting';
	Template.InventorySlot = eInvSlot_SecondaryWeapon;
	Template.strImage = "img:///UILibrary_IconsMint.GTS_Holotargeter_Intermediate";

	// Requirements
	Template.Requirements.RequiredHighestSoldierRank = 5;
	Template.Requirements.bVisibleIfSoldierRankGatesNotMet = true;

	// Cost
	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = default.Intermediate_Cost;
	Template.Cost.ResourceCosts.AddItem(Resources);

	return Template;
}

static function X2SoldierGTSUnlockTemplate HolotargeterExpertUnlock()
{
	local X2SoldierGTSUnlockTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2SoldierGTSUnlockTemplate', Template, 'HolotargeterExpertUnlock');

	 Template.AllowedClasses.AddItem('Operative_Mint');
	Template.AbilityName = 'MultiTargeting';
	Template.InventorySlot = eInvSlot_SecondaryWeapon;
	Template.strImage = "img:///UILibrary_IconsMint.GTS_Holotargeter_Expert";

	// Requirements
	Template.Requirements.RequiredHighestSoldierRank = 7;
	Template.Requirements.bVisibleIfSoldierRankGatesNotMet = true;
	Template.Requirements.RequiredTechs.AddItem('InsightTechReaper');

	// Cost
	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = default.Expert_Cost;
	Template.Cost.ResourceCosts.AddItem(Resources);


	return Template;
}