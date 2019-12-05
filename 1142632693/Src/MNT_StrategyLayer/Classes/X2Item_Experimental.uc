class X2Item_Experimental extends X2Item config(Mint_StrategyOverhaul);

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Items;

	// ammo
	Items.AddItem(CreateNeedleRounds());
	Items.AddItem(CreateAPRounds());
	Items.AddItem(CreateShredderRounds());

	Items.AddItem(CreateIncendiaryAmmo());
	Items.AddItem(CreateVenomRounds());
	Items.AddItem(CreateTracerRounds());
	Items.AddItem(CreateImpulseRounds());
	Items.AddItem(CreateFlechetteRounds());
	Items.AddItem(CreateReqiuemRounds());

	Items.AddItem(CreateIncisionRounds());
	Items.AddItem(CreateStilettoRounds());
	Items.AddItem(CreateSeekerRounds());
	
	// vests
	Items.AddItem(CreateUplinkedVest());
	Items.AddItem(CreateShieldVest());
	Items.AddItem(CreateEtherweave());


	return Items;
}

// #######################################################################################
// -------------------- AMMUNITION	---------------------------------------------------
// #######################################################################################


// -------------------- STARTING AMMO	--------------------------------------------------
// #######################################################################################

// Needle Rounds - decreases damage by 1, increases clip size by 2. 
static function X2AmmoTemplate CreateNeedleRounds()
{
	local X2AmmoTemplate Template;
	local ArtifactCost Resources;
	local WeaponDamageValue DamageValue;

	`CREATE_X2TEMPLATE(class'X2AmmoTemplate', Template, 'XCom_NeedleRounds');
	Template.strImage = "img:///UILibrary_IconsMint.Ammo_Needle";
	DamageValue.Damage = -1;
	Template.AddAmmoDamageModifier(none, DamageValue);
	Template.CanBeBuilt = true;
	Template.TradingPostValue = 30;
	Template.PointsToComplete = 0;
	Template.ModClipSize = 2;
	Template.Tier = 1;
	Template.EquipSound = "StrategyUI_Ammo_Equip";
	Template.bInfiniteItem = false;

	Template.SetUIStatMarkup(class'XLocalizedData'.default.DamageBonusLabel, , -1);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.ClipSizeLabel, , 2);

	// Cost
	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = 15;
	Template.Cost.ResourceCosts.AddItem(Resources);

	//FX Reference
	Template.GameArchetype = "Ammo_AP.PJ_AP";

	return Template;
}

// AP Rounds - +2 armor penetration, doubles range penalties. Should be very competitive against grenades.
static function X2AmmoTemplate CreateAPRounds()
{
	local X2AmmoTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2AmmoTemplate', Template, 'XCom_APRounds');
	Template.strImage = "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_AP_Rounds";
	Template.CanBeBuilt = true;
	Template.TradingPostValue = 30;
	Template.PointsToComplete = 0;
	Template.Abilities.AddItem('APAmmo');
	Template.Tier = 1;
	Template.EquipSound = "StrategyUI_Ammo_Equip";
	Template.bInfiniteItem = false;

	Template.SetUIStatMarkup(class'XLocalizedData'.default.PierceLabel, eStat_ArmorPiercing, 2);
	
	// Cost
	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = 25;
	Template.Cost.ResourceCosts.AddItem(Resources);

	//FX Reference
	Template.GameArchetype = "Ammo_AP.PJ_AP";
	
	return Template;
}

// Shredder Rounds - Provides shredding! Available very early, off of Troopers. Also very competetive!
static function X2DataTemplate CreateShredderRounds()
{
	local X2AmmoTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2AmmoTemplate', Template, 'XCom_ShredderRounds');
	Template.strImage = "img:///UILibrary_IconsMint.Ammo_Shredder";
	Template.Abilities.AddItem('ShredderAmmo');
	Template.CanBeBuilt = true;
	Template.TradingPostValue = 30;
	Template.PointsToComplete = 0;
	Template.Tier = 1;
	Template.ModClipSize = -1;

	Template.EquipSound = "StrategyUI_Ammo_Equip";

	Template.SetUIStatMarkup(class'XLocalizedData'.default.ShredLabel,, 1);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.ClipSizeLabel, , -1);

	Template.Requirements.RequiredTechs.AddItem('AutopsyAdventTrooper');

	// Cost
	Resources.ItemTemplateName = 'CorpseAdventTrooper';
	Resources.Quantity = 3;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = 25;
	Template.Cost.ResourceCosts.AddItem(Resources);
	//FX Reference
	Template.GameArchetype = "Ammo_Talon.PJ_Talon";
	
	return Template;
}


// -------------------- RESEARCHED AMMO	--------------------------------------------------
// #######################################################################################


// Anti-Melee, inflicts burn and stops regeneration. Increases damage.
static function X2DataTemplate CreateIncendiaryAmmo()
{
	local X2AmmoTemplate Template;
	local ArtifactCost Resources;
	local WeaponDamageValue DamageValue;

	`CREATE_X2TEMPLATE(class'X2AmmoTemplate', Template, 'XCom_IncendiaryRounds');
	Template.strImage = "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_Incendiary_Rounds";
	DamageValue.Damage = 1;
	DamageValue.DamageType = 'Fire';
	Template.AddAmmoDamageModifier(none, DamageValue);
	Template.TargetEffects.AddItem(class'X2StatusEffects'.static.CreateBurningStatusEffect(1, 0));
	Template.CanBeBuilt = true;
	Template.TradingPostValue = 30;
	Template.PointsToComplete = 0;
	Template.Tier = 2;
	Template.EquipSound = "StrategyUI_Ammo_Equip";

	Template.SetUIStatMarkup(class'XLocalizedData'.default.DamageBonusLabel, , 1);

	Template.Requirements.RequiredTechs.AddItem('AutopsyAdventPurifier');

	// Cost
	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = 50;
	Template.Cost.ResourceCosts.AddItem(Resources);
		
	Resources.ItemTemplateName = 'CorpseAdventPurifier';
	Resources.Quantity = 3;
	Template.Cost.ResourceCosts.AddItem(Resources);

	//FX Reference
	Template.GameArchetype = "Ammo_Incendiary.PJ_Incendiary";
	
	return Template;
}

// Anti-Shooties, inflicts poison and stops adrenaline. Increases damage.
static function X2DataTemplate CreateVenomRounds()
{
	local X2AmmoTemplate Template;
	local ArtifactCost Resources;
	local WeaponDamageValue DamageValue;

	`CREATE_X2TEMPLATE(class'X2AmmoTemplate', Template, 'XCom_VenomRounds');
	Template.strImage = "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_Venom_Rounds";
	DamageValue.Damage = 1;
	DamageValue.DamageType = 'Poison';
	Template.AddAmmoDamageModifier(none, DamageValue);
	Template.TargetEffects.AddItem(class'X2StatusEffects'.static.CreatePoisonedStatusEffect());
	Template.CanBeBuilt = true;
	Template.TradingPostValue = 30;
	Template.PointsToComplete = 0;
	Template.Tier = 2;
	Template.EquipSound = "StrategyUI_Ammo_Equip";

	Template.SetUIStatMarkup(class'XLocalizedData'.default.DamageBonusLabel, , 1);

	Template.Requirements.RequiredTechs.AddItem('AutopsyViper');

	// Cost
	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = 50;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Resources.ItemTemplateName = 'CorpseViper';
	Resources.Quantity = 3;
	Template.Cost.ResourceCosts.AddItem(Resources);

	//FX Reference
	Template.GameArchetype = "Ammo_Venom.PJ_Venom";

	return Template;
}

// Anti-Psi - +20 aim, -40 critchance, bypasses shields
static function X2AmmoTemplate CreateTracerRounds()
{
	local X2AmmoTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2AmmoTemplate', Template, 'XCom_TracerRounds');
	Template.strImage = "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_Tracer_Rounds";
	Template.Abilities.AddItem('TracerAmmo');
	Template.bBypassShields = true;
	Template.CanBeBuilt = true;
	Template.TradingPostValue = 30;
	Template.PointsToComplete = 0;
	Template.Tier = 2;
	Template.EquipSound = "StrategyUI_Ammo_Equip";

	Template.SetUIStatMarkup(class'XLocalizedData'.default.AimLabel, eStat_Offense, 20);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.CriticalChanceBonusLabel, eStat_CritChance, -40);

	Template.Requirements.RequiredTechs.AddItem('AutopsySectoid');

	// Cost
	Resources.ItemTemplateName = 'CorpseSectoid';
	Resources.Quantity = 3;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = 50;
	Template.Cost.ResourceCosts.AddItem(Resources);
		
	//FX Reference
	Template.GameArchetype = "Ammo_Tracer.PJ_Tracer";
	
	return Template;
}

// Impulse Rounds - Deals massive shield damage, but won't help otherwise
static function X2DataTemplate CreateImpulseRounds()
{
	local X2AmmoTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2AmmoTemplate', Template, 'XCom_ImpulseRounds');
	Template.strImage = "img:///UILibrary_IconsMint.Ammo_Impulse";
	Template.Abilities.AddItem('ImpulseAmmo');
	Template.CanBeBuilt = true;
	Template.TradingPostValue = 30;
	Template.PointsToComplete = 0;
	Template.Tier = 2;

	Template.EquipSound = "StrategyUI_Ammo_Equip";

	Template.Requirements.RequiredTechs.AddItem('AutopsyAdventShieldbearer');

	// Cost
	Resources.ItemTemplateName = 'EleriumDust';
	Resources.Quantity = 10;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Resources.ItemTemplateName = 'AlienAlloy';
	Resources.Quantity = 25;
	Template.Cost.ResourceCosts.AddItem(Resources);
	//FX Reference
	Template.GameArchetype = "Ammo_Talon.PJ_Talon";
	
	return Template;
}

// Flechette Rounds - The strongest anti-biological ammo against UNARMORED, UNSHIELDED enemies.
static function X2DataTemplate CreateFlechetteRounds()
{
	local X2AmmoTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2AmmoTemplate', Template, 'XCom_FlechetteRounds');
	Template.strImage = "img:///UILibrary_IconsMint.Ammo_Flechette";
	Template.Abilities.AddItem('FlechetteAmmo');
	Template.CanBeBuilt = true;
	Template.TradingPostValue = 30;
	Template.PointsToComplete = 0;
	Template.Tier = 2;
	Template.EquipSound = "StrategyUI_Ammo_Equip";

	Template.Requirements.RequiredTechs.AddItem('AutopsyMuton');

	// Cost
	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = 100;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Resources.ItemTemplateName = 'AlienAlloy';
	Resources.Quantity = 25;
	Template.Cost.ResourceCosts.AddItem(Resources);

	//FX Reference
	Template.GameArchetype = "Ammo_Venom.PJ_Venom";

	return Template;
}

// Reqiuem Rounds - Anti zombie rounds. Very good on Lost missions!
static function X2DataTemplate CreateReqiuemRounds()
{
	local X2AmmoTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2AmmoTemplate', Template, 'XCom_ReqiuemRounds');
	Template.strImage = "img:///UILibrary_IconsMint.Ammo_Reqiuem";
	Template.Abilities.AddItem('ReqiuemAmmo');
	Template.CanBeBuilt = true;
	Template.TradingPostValue = 30;
	Template.PointsToComplete = 0;
	Template.Tier = 2;

	Template.EquipSound = "StrategyUI_Ammo_Equip";

	Template.Requirements.RequiredTechs.AddItem('AutopsyTheLost');

	// Cost
	Resources.ItemTemplateName = 'CorpseTheLost';
	Resources.Quantity = 5;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Resources.ItemTemplateName = 'EleriumDust';
	Resources.Quantity = 10;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = 50;
	Template.Cost.ResourceCosts.AddItem(Resources);
	//FX Reference
	Template.GameArchetype = "Ammo_Talon.PJ_Talon";
	
	return Template;
}

// -------------------- FACTION AMMO (PG) ------------------------------------------------
// #######################################################################################

// Incision Rounds - Upgraded Shredder Ammo. Skirmisher
static function X2DataTemplate CreateIncisionRounds()
{
	local X2AmmoTemplate Template;
	local WeaponDamageValue DamageValue;
	
	`CREATE_X2TEMPLATE(class'X2AmmoTemplate', Template, 'XCom_IncisionRounds');
	Template.strImage = "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_Talon_Rounds";
	DamageValue.Damage = 2;
	DamageValue.Rupture = 1;
	Template.AddAmmoDamageModifier(none, DamageValue);
	Template.Abilities.AddItem('IncisionAmmo');
	Template.CanBeBuilt = false;
	Template.TradingPostValue = 30;
	Template.PointsToComplete = 0;
	Template.Tier = 3;
	Template.ModClipSize = -1;

	Template.EquipSound = "StrategyUI_Ammo_Equip";

	Template.SetUIStatMarkup(class'XLocalizedData'.default.ShredLabel,, 1);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.ClipSizeLabel, , -1);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.DamageBonusLabel, , 2);

	//FX Reference
	Template.GameArchetype = "Ammo_Talon.PJ_Talon";
	
	return Template;
}

// Stiletto Rounds - Upgraded AP Rounds. Reaper
static function X2AmmoTemplate CreateStilettoRounds()
{
	local X2AmmoTemplate Template;
	
	`CREATE_X2TEMPLATE(class'X2AmmoTemplate', Template, 'XCom_StilettoRounds');
	Template.strImage = "img:///UILibrary_IconsMint.Ammo_Stiletto";
	Template.CanBeBuilt = false;
	Template.TradingPostValue = 30;
	Template.PointsToComplete = 0;
	Template.Abilities.AddItem('StilettoAmmo');
	Template.Tier = 3;
	Template.EquipSound = "StrategyUI_Ammo_Equip";

	Template.SetUIStatMarkup(class'XLocalizedData'.default.PierceLabel, eStat_ArmorPiercing, 2);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.CriticalChanceBonusLabel, eStat_CritChance, 20);
			
	//FX Reference
	Template.GameArchetype = "Ammo_AP.PJ_AP";
	
	return Template;
}

//Seeker Rounds - Upgraded Tracer Rounds. Templar
static function X2AmmoTemplate CreateSeekerRounds()
{
	local X2AmmoTemplate Template;

	`CREATE_X2TEMPLATE(class'X2AmmoTemplate', Template, 'XCom_SeekerRounds');
	Template.strImage = "img:///UILibrary_IconsMint.Ammo_Seeker";
	Template.Abilities.AddItem('SeekerAmmo');
	Template.bBypassShields = true;
	Template.CanBeBuilt = false;
	Template.TradingPostValue = 30;
	Template.PointsToComplete = 0;
	Template.Tier = 3;
	Template.EquipSound = "StrategyUI_Ammo_Equip";

	Template.SetUIStatMarkup(class'XLocalizedData'.default.AimLabel, eStat_Offense, 20);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.CriticalChanceBonusLabel, eStat_CritChance, -20);
	
	//FX Reference
	Template.GameArchetype = "Ammo_Tracer.PJ_Tracer";
	
	return Template;
}

// #######################################################################################
// -------------------- VESTS ------------------------------------------------------------
// #######################################################################################

// -------------------- RESEARCHED VESTS -------------------------------------------------
// #######################################################################################

static function X2DataTemplate CreateUplinkedVest()
{
	local X2EquipmentTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2EquipmentTemplate', Template, 'UplinkedVest');
	Template.ItemCat = 'defense';
	Template.InventorySlot = eInvSlot_Utility;
	Template.strImage = "img:///UILibrary_IconsMint.Vest_Uplinked";
	Template.EquipSound = "StrategyUI_Vest_Equip";

	Template.Abilities.AddItem('UplinkedVest_Passive');
	Template.Abilities.AddItem('SignalBurst');

	Template.CanBeBuilt = true;
	Template.TradingPostValue = 15;
	Template.PointsToComplete = 0;
	Template.Tier = 2;

	Template.SetUIStatMarkup(class'XLocalizedData'.default.TechLabel, eStat_Hacking, 20);

	// Requirements
	Template.Requirements.RequiredTechs.AddItem('AutopsyAdventShieldbearer');
	Template.Requirements.RequiredTechs.AddItem('AutopsyAdventMEC');
	Template.Requirements.RequiredTechs.AddItem('AutopsyAdventTurret');

	// Cost
	Resources.ItemTemplateName = 'Battlescanner';
	Resources.Quantity = 1;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Resources.ItemTemplateName = 'NanofiberVest';
	Resources.Quantity = 1;
	Template.Cost.ResourceCosts.AddItem(Resources);

	return Template;
}

static function X2DataTemplate CreateShieldVest()
{
	local X2EquipmentTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2EquipmentTemplate', Template, 'ShieldVest');
	Template.ItemCat = 'defense';
	Template.InventorySlot = eInvSlot_Utility;
	Template.strImage = "img:///UILibrary_IconsMint.Vest_Shield";
	Template.EquipSound = "StrategyUI_Vest_Equip";

	Template.Abilities.AddItem('ShieldVest_Passive');

	Template.CanBeBuilt = true;
	Template.TradingPostValue = 15;
	Template.PointsToComplete = 0;
	Template.Tier = 2;
	
	Template.SetUIStatMarkup("Shields", eStat_ShieldHP, 3);

	// Requirements
	Template.Requirements.RequiredTechs.AddItem('AutopsyAdventShieldbearer');

	// Cost
	Resources.ItemTemplateName = 'CorpseAdventShieldbearer';
	Resources.Quantity = 4;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Resources.ItemTemplateName = 'NanofiberVest';
	Resources.Quantity = 2;
	Template.Cost.ResourceCosts.AddItem(Resources);

	return Template;
}

static function X2DataTemplate CreateEtherweave()
{
	local X2EquipmentTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2EquipmentTemplate', Template, 'Etherweave');
	Template.ItemCat = 'defense';
	Template.InventorySlot = eInvSlot_Utility;
	Template.strImage = "img:///UILibrary_IconsMint.Vest_Ether";
	Template.EquipSound = "StrategyUI_Vest_Equip";

	Template.Abilities.AddItem('Etherweave_Passive');
	Template.Abilities.AddItem('Etherweave_Damage');

	Template.CanBeBuilt = true;
	Template.TradingPostValue = 15;
	Template.PointsToComplete = 0;
	Template.Tier = 2;

	Template.SetUIStatMarkup(class'XLocalizedData'.default.MobilityLabel, eStat_Mobility, 1);

	// Requirements
	Template.Requirements.RequiredTechs.AddItem('AutopsyArchon');

	// Cost
	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = 200;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Resources.ItemTemplateName = 'CorpseArchon';
	Resources.Quantity = 5;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Resources.ItemTemplateName = 'NanofiberVest';
	Resources.Quantity = 2;
	Template.Cost.ResourceCosts.AddItem(Resources);

	return Template;
}