class UtilitySlotSidearms_WOTC extends X2Item config(UtilitySlotSidearms_WOTC);

var config array<name> PistolCategories, MeleeCategories, GremlinCategories, PsiAmpCategories, GrenadeLauncherCategories, ClaymoreCategories, RipjackCategories, ShardGauntletCategories, GenericCategories;
var config array<name> PistolAbilities, MeleeAbilities, GremlinAbilities, PsiAmpAbilities, GrenadeLauncherAbilities, ClaymoreAbilities, RipjackAbilities, ShardGauntletAbilities;
var config bool bEnablePistols, bEnableSwords, bEnableGremlins, bEnablePsiAmps, bEnableGrenadeLaunchers, bEnableClaymores, bEnableRipjacks, bEnableShardGauntlets, bEnableGenerics;

static function GrimyCreateTemplates() {
	local X2AbilityTemplateManager	AbilityManager;
	local X2AbilityTemplate			AbilityTemplate, NewAbility;
	local X2ItemTemplateManager		ItemManager;
	local array<X2WeaponTemplate>	AllTemplates;
	local X2WeaponTemplate			BaseTemplate;
	local array<X2DataTemplate>		DifficultyVariants;
	local X2DataTemplate			ItemTemplate;

	// Copy Ripjack secondary hit ability to work with Ripjacks in the septenary slot
	AbilityManager = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();
	AbilityTemplate = AbilityManager.FindAbilityTemplate('SkirmisherPostAbilityMelee');
	NewAbility = new class'X2AbilityTemplate'(AbilityTemplate);
	NewAbility.SetTemplateName(name("Utility" $ AbilityTemplate.DataName));
	NewAbility.DefaultSourceItemSlot = eInvSlot_SeptenaryWeapon;
	AbilityManager.AddAbilityTemplate(NewAbility,True);

	ItemManager = class'X2ItemTemplateManager'.static.GetItemTemplateManager();
	AllTemplates = ItemManager.GetAllWeaponTemplates();

	if (default.bEnablePistols) {
		foreach AllTemplates(BaseTemplate) {
			if ( IsPistolWeaponTemplate(BaseTemplate) ) {
				ItemManager.FindDataTemplateAllDifficulties(BaseTemplate.DataName, DifficultyVariants);
				foreach DifficultyVariants(ItemTemplate) {
					ItemManager.AddItemTemplate(CreateUtilityWeaponTemplateClone(ItemTemplate),True);
					ItemManager.AddItemTemplate(CreateWeaponSetTemplate(ItemTemplate),True);
				}
			}
		}
	}
	if (default.bEnableSwords) {
		foreach AllTemplates(BaseTemplate) {
			if ( IsMeleeWeaponTemplate(BaseTemplate) ) {
				ItemManager.FindDataTemplateAllDifficulties(BaseTemplate.DataName, DifficultyVariants);
				foreach DifficultyVariants(ItemTemplate) {
					ItemManager.AddItemTemplate(CreateUtilityWeaponTemplateClone(ItemTemplate),True);
					if ( InStr(string(BaseTemplate.DataName), "AlienHunterAxe") == INDEX_NONE || // Create X2WeaponSetTemplate for non-hunter-axes
						X2PairedWeaponTemplate(ItemTemplate) != none )							 // and for the X2PairedWeaponTemplate hunter axe
					{
						ItemManager.AddItemTemplate(CreateWeaponSetTemplate(ItemTemplate),True);
					}
				}
			}
		}
	}
	if (default.bEnableGremlins) {
		foreach AllTemplates(BaseTemplate) {
			if ( IsGremlinTemplate(BaseTemplate) ) {
				ItemManager.FindDataTemplateAllDifficulties(BaseTemplate.DataName, DifficultyVariants);
				foreach DifficultyVariants(ItemTemplate) {
					ItemManager.AddItemTemplate(CreateUtilityWeaponTemplateClone(ItemTemplate),True);
					ItemManager.AddItemTemplate(CreateWeaponSetTemplate(ItemTemplate),True);
				}
			}
		}
	}
	if (default.bEnablePsiAmps) {
		foreach AllTemplates(BaseTemplate) {
			if ( IsPsiAmpTemplate(BaseTemplate) ) {
				ItemManager.FindDataTemplateAllDifficulties(BaseTemplate.DataName, DifficultyVariants);
				foreach DifficultyVariants(ItemTemplate) {
					ItemManager.AddItemTemplate(CreateUtilityWeaponTemplateClone(ItemTemplate),True);
					ItemManager.AddItemTemplate(CreateWeaponSetTemplate(ItemTemplate),True);
				}
			}
		}
	}
	if (default.bEnableGrenadeLaunchers) {
		foreach AllTemplates(BaseTemplate) {
			if ( IsGrenadeLauncherTemplate(BaseTemplate) ) {
				ItemManager.FindDataTemplateAllDifficulties(BaseTemplate.DataName, DifficultyVariants);
				foreach DifficultyVariants(ItemTemplate) {
					ItemManager.AddItemTemplate(CreateUtilityWeaponTemplateClone(ItemTemplate),True);
					ItemManager.AddItemTemplate(CreateWeaponSetTemplate(ItemTemplate),True);
				}
			}
		}
	}
	if (default.bEnableClaymores) {
		foreach AllTemplates(BaseTemplate) {
			if ( IsClaymoreWeaponTemplate(BaseTemplate) ) {
				ItemManager.FindDataTemplateAllDifficulties(BaseTemplate.DataName, DifficultyVariants);
				foreach DifficultyVariants(ItemTemplate) {
					ItemManager.AddItemTemplate(CreateUtilityWeaponTemplateClone(ItemTemplate),True);
					ItemManager.AddItemTemplate(CreateWeaponSetTemplate(ItemTemplate),True);
				}
			}
		}
	}
	if (default.bEnableRipjacks) {
		foreach AllTemplates(BaseTemplate) {
			if ( IsRipjackWeaponTemplate(BaseTemplate) ) {
				ItemManager.FindDataTemplateAllDifficulties(BaseTemplate.DataName, DifficultyVariants);
				foreach DifficultyVariants(ItemTemplate) {
					ItemManager.AddItemTemplate(CreateUtilityWeaponTemplateClone(ItemTemplate),True);
					if ( X2PairedWeaponTemplate(ItemTemplate) != none ) // Create X2WeaponSetTemplate only for X2PairedWeaponTemplate ripjack
					{
						ItemManager.AddItemTemplate(CreateWeaponSetTemplate(ItemTemplate),True);
					}
				}
			}
		}
	}
	if (default.bEnableShardGauntlets) {
		foreach AllTemplates(BaseTemplate) {
			if ( IsShardGauntletWeaponTemplate(BaseTemplate) ) {
				ItemManager.FindDataTemplateAllDifficulties(BaseTemplate.DataName, DifficultyVariants);
				foreach DifficultyVariants(ItemTemplate) {
					ItemManager.AddItemTemplate(CreateUtilityWeaponTemplateClone(ItemTemplate),True);
					if ( X2PairedWeaponTemplate(ItemTemplate) != none ) // Create X2WeaponSetTemplate only for X2PairedWeaponTemplate gauntlet
					{
						ItemManager.AddItemTemplate(CreateWeaponSetTemplate(ItemTemplate),True);
					}
				}
			}
		}
	}
	if (default.bEnableGenerics) {
		foreach AllTemplates(BaseTemplate) {
			if ( IsGenericWeaponTemplate(BaseTemplate) ) {
				ItemManager.FindDataTemplateAllDifficulties(BaseTemplate.DataName, DifficultyVariants);
				foreach DifficultyVariants(ItemTemplate) {
					ItemManager.AddItemTemplate(CreateUtilityWeaponTemplateClone(ItemTemplate),True);
					ItemManager.AddItemTemplate(CreateWeaponSetTemplate(ItemTemplate),True);
				}
			}
		}
	}
}

static function X2ItemTemplate CreateUtilityWeaponTemplateClone(X2DataTemplate BaseTemplate)
{
	local X2WeaponTemplate Template, BaseAsWeaponTemplate;
	local name AbilityName;

	BaseAsWeaponTemplate = X2WeaponTemplate(BaseTemplate);
	
	//`Log("Generating copy of" @ BaseAsWeaponTemplate.DataName,, 'UtilitySlotSidearms_WOTC');

	if (X2PairedWeaponTemplate(BaseAsWeaponTemplate) != none)
	{
		Template = new class'X2PairedWeaponTemplate'(BaseAsWeaponTemplate);
		X2PairedWeaponTemplate(Template).OnEquippedFn = none;
		X2PairedWeaponTemplate(Template).OnUnEquippedFn = none;
		X2PairedWeaponTemplate(Template).PairedSlot = eInvSlot_Unknown;
		X2PairedWeaponTemplate(Template).PairedTemplateName = 'None';
	}
	else if (X2GremlinTemplate(BaseAsWeaponTemplate) != none)
	{
		Template = new class'X2GremlinTemplate'(X2GremlinTemplate(BaseAsWeaponTemplate));
	}
	else if (X2GrenadeLauncherTemplate(BaseAsWeaponTemplate) != none)
	{
		Template = new class'X2GrenadeLauncherTemplate'(X2GrenadeLauncherTemplate(BaseAsWeaponTemplate));
	}
	else
	{
		Template = new class'X2WeaponTemplate'(BaseAsWeaponTemplate);
	}
	
	Template.SetTemplateName(name("Utility" $ BaseAsWeaponTemplate.DataName));
	class'UtilitySlotSidearms_ItemHelper'.static.CopyLocalization(BaseAsWeaponTemplate, Template);
	
	switch (Template.WeaponCat)
	{
		case 'pistol':
			Template.SetAnimationNameForAbility('FanFire', BaseAsWeaponTemplate.GetAnimationNameFromAbilityName('FF_FireMultiShotConvA'));
			Template.InventorySlot = eInvSlot_QuaternaryWeapon;

			foreach default.PistolAbilities(AbilityName) {
				if (Template.Abilities.Find(AbilityName) == INDEX_NONE)
					Template.Abilities.AddItem(AbilityName);
			}
			break;
		case 'sword': // thrown hunter axe is now 'sword_thrown' so we don't have to ignore it
			Template.InventorySlot = eInvSlot_QuinaryWeapon;

			foreach default.MeleeAbilities(AbilityName) {
				if (Template.Abilities.Find(AbilityName) == INDEX_NONE)
					Template.Abilities.AddItem(AbilityName);
			}
			break;
		case 'gremlin':
			Template.InventorySlot = eInvSlot_QuinaryWeapon;

			foreach default.GremlinAbilities(AbilityName) {
				if (Template.Abilities.Find(AbilityName) == INDEX_NONE)
					Template.Abilities.AddItem(AbilityName);
			}
			break;
		case 'psiamp':
			Template.InventorySlot = eInvSlot_QuinaryWeapon;

			foreach default.PsiAmpAbilities(AbilityName) {
				if (Template.Abilities.Find(AbilityName) == INDEX_NONE)
					Template.Abilities.AddItem(AbilityName);
			}
			break;
		case 'grenade_launcher':
			Template.InventorySlot = eInvSlot_QuinaryWeapon;

			foreach default.GrenadeLauncherAbilities(AbilityName) {
				if (Template.Abilities.Find(AbilityName) == INDEX_NONE)
					Template.Abilities.AddItem(AbilityName);
			}
			break;
		case 'claymore':
			Template.InventorySlot = eInvSlot_SeptenaryWeapon;

			foreach default.ClaymoreAbilities(AbilityName) {
				if (Template.Abilities.Find(AbilityName) == INDEX_NONE)
					Template.Abilities.AddItem(AbilityName);
			}
			break;
		case 'wristblade': // left jack is now 'wristblade_left' so we don't have to ignore it
			Template.InventorySlot = eInvSlot_SeptenaryWeapon;

			foreach default.RipjackAbilities(AbilityName) {
				if (Template.Abilities.Find(AbilityName) == INDEX_NONE)
					Template.Abilities.AddItem(AbilityName);
			}
			break;
		case 'gauntlet': // left gauntlet is now 'gauntlet_left' so we don't have to ignore it
			Template.InventorySlot = eInvSlot_SeptenaryWeapon;

			foreach default.ShardGauntletAbilities(AbilityName) {
				if (Template.Abilities.Find(AbilityName) == INDEX_NONE)
					Template.Abilities.AddItem(AbilityName);
			}
			break;
		default:
			Template.InventorySlot = eInvSlot_QuinaryWeapon; // we're going to assume any new mod items will be stowed eSlot_RightBack as it's the most popular slot
	}

	if (Template.WeaponCat != 'sword')
		Template.UIArmoryCameraPointTag = 'UIPawnLocation_WeaponUpgrade_Shotgun';
	
	if (BaseAsWeaponTemplate.BaseItem != '' )
		Template.BaseItem = name("Utility" $ BaseAsWeaponTemplate.BaseItem); // Which item this will be upgraded from
	
	if (Template != none)
		`Log("Generating Template" @ Template.DataName,, 'UtilitySlotSidearms_WOTC');
	
	return Template;
}

static function X2ItemTemplate CreateWeaponSetTemplate(X2DataTemplate BaseTemplate)
{
	local X2WeaponSetTemplate Template;
	local X2WeaponTemplate BaseAsWeaponTemplate;
	local X2ItemTemplateManager ItemMgr;
	local name TertiaryTemplateName;
	local int i;
	
	BaseAsWeaponTemplate = X2WeaponTemplate(BaseTemplate);
	ItemMgr = class'X2ItemTemplateManager'.static.GetItemTemplateManager();

	`CREATE_X2TEMPLATE(class'X2WeaponSetTemplate', Template, name("Paired" $ BaseAsWeaponTemplate.DataName));
	class'UtilitySlotSidearms_ItemHelper'.static.CopyLocalization(BaseAsWeaponTemplate, Template);

	//Template.PairedSlots.AddItem(eInvSlot_QuaternaryWeapon);
	Template.PairedSlots.AddItem(X2WeaponTemplate(ItemMgr.FindItemTemplate(name("Utility" $ BaseAsWeaponTemplate.DataName))).InventorySlot);
	Template.PairedTemplateNames.AddItem(name("Utility" $ BaseAsWeaponTemplate.DataName));

	// All X2ItemTemplate properties start - adding them all to reduce risks of different-from-original-item behavior happening
	Template.iItemSize = BaseAsWeaponTemplate.iItemSize;
	Template.MaxQuantity = BaseAsWeaponTemplate.MaxQuantity;
	Template.LeavesExplosiveRemains = BaseAsWeaponTemplate.LeavesExplosiveRemains;
	Template.ExplosiveRemains = BaseAsWeaponTemplate.ExplosiveRemains;
	
	Template.HideInInventory = BaseAsWeaponTemplate.HideInInventory;
	Template.HideInLootRecovered = BaseAsWeaponTemplate.HideInLootRecovered;
	Template.StartingItem = BaseAsWeaponTemplate.StartingItem;
	Template.bInfiniteItem = BaseAsWeaponTemplate.bInfiniteItem;
	Template.bAlwaysUnique = BaseAsWeaponTemplate.bAlwaysUnique;
	Template.bPriority = BaseAsWeaponTemplate.bPriority;
	Template.bAlwaysRecovered = BaseAsWeaponTemplate.bAlwaysRecovered;
	Template.bOkayToConcealAsObjective = BaseAsWeaponTemplate.bOkayToConcealAsObjective;

	//Trading Post stuff would go here, but USS items shouldn't be sellable so I'm not gonna
	
	Template.OnAcquiredFn = BaseAsWeaponTemplate.OnAcquiredFn;
	Template.OnBuiltFn = BaseAsWeaponTemplate.OnBuiltFn;
	//Template.OnEquippedFn = BaseAsWeaponTemplate.OnEquippedFn; // WeaponSets have their own OnEquippedFn
	//Template.OnUnequippedFn = BaseAsWeaponTemplate.OnUnequippedFn; // WeaponSets have their own OnUnequippedFn
	Template.IsObjectiveItemFn = BaseAsWeaponTemplate.IsObjectiveItemFn;
	
	Template.PointsToComplete = BaseAsWeaponTemplate.PointsToComplete;
	Template.CanBeBuilt = BaseAsWeaponTemplate.CanBeBuilt;
	Template.bOneTimeBuild = BaseAsWeaponTemplate.bOneTimeBuild;
	//Template.bBlocked = BaseAsWeaponTemplate.bBlocked; // This would require re-tooling the unblocking functions, and that's outside of scope

	Template.CreatorTemplateName = BaseAsWeaponTemplate.CreatorTemplateName;
	if ( BaseAsWeaponTemplate.UpgradeItem != '' )
		Template.UpgradeItem = name("Paired" $ BaseAsWeaponTemplate.UpgradeItem);
	if ( BaseAsWeaponTemplate.BaseItem != '' )
		Template.BaseItem = name("Paired" $ BaseAsWeaponTemplate.BaseItem);
	Template.HideIfResearched = BaseAsWeaponTemplate.HideIfResearched;
	Template.HideIfPurchased = BaseAsWeaponTemplate.HideIfPurchased;

	// Resource reward stuff would go here, but USS items are all weapons and so don't reward resources on acquisition

	Template.Tier = BaseAsWeaponTemplate.Tier - 5;

	// Reward decks would go here, but USS weapons are rewarded by schematics of their corresponding item

	Template.Requirements = BaseAsWeaponTemplate.Requirements;
	Template.AlternateRequirements = BaseAsWeaponTemplate.AlternateRequirements;
	Template.Cost = BaseAsWeaponTemplate.Cost;
	Template.ArmoryDisplayRequirements = BaseAsWeaponTemplate.ArmoryDisplayRequirements;
	//Template.ArmoryDisplayRequirements.RequiredTechs = BaseAsWeaponTemplate.ArmoryDisplayRequirements.RequiredTechs; // Copying the broader display requirements instead

	// Sounds would go here, but those are triggered by loot recovery and USS doesn't do loot

	Template.ItemCat = BaseAsWeaponTemplate.ItemCat;
	Template.strImage = BaseAsWeaponTemplate.strImage;
	Template.strInventoryImage = BaseAsWeaponTemplate.strInventoryImage;
	Template.strBackpackIcon = BaseAsWeaponTemplate.strBackpackIcon;
	// Loot meshes and particles would go here, but USS doesn't do loot
	// All X2ItemTemplate properties end

	// All X2EquipmentTemplate properties start - adding them all to reduce risks of different-from-original-item behavior happening
	//Template.GameArchetype = BaseAsWeaponTemplate.GameArchetype; // WeaponSets don't have archetypes
	//Template.AltGameArchetype = BaseAsWeaponTemplate.AltGameArchetype; // WeaponSets don't have archetypes
	//Template.CosmeticUnitTemplate = BaseAsWeaponTemplate.CosmeticUnitTemplate; // WeaponSets don't have cosmetics
	//Template.Abilities = BaseAsWeaponTemplate.Abilities; // Don't copy abilities - we don't want to utilize this weapon
	Template.InventorySlot = eInvSlot_Utility; // Set utility slot because otherwise wtf are we doing?
	Template.StatBoostPowerLevel = BaseAsWeaponTemplate.StatBoostPowerLevel;
	Template.StatsToBoost = BaseAsWeaponTemplate.StatsToBoost;
	Template.bUseBoostIncrement = BaseAsWeaponTemplate.bUseBoostIncrement;
	//Template.EquipNarrative = BaseAsWeaponTemplate.EquipNarrative; // Tygan, Bradford, and Shen talk enough
	Template.UIStatMarkups = BaseAsWeaponTemplate.UIStatMarkups;
	Template.EquipSound = BaseAsWeaponTemplate.EquipSound;

	//Template.AltGameArchetypeArray = BaseAsWeaponTemplate.AltGameArchetypeArray; // WeaponSets don't have archetypes
	// All X2EquipmentTemplate properties end

	// All X2WeaponTemplate properties start - adding them all to reduce risks of different-from-original-item behavior happening
	Template.WeaponCat = BaseAsWeaponTemplate.WeaponCat;
	Template.WeaponTech = BaseAsWeaponTemplate.WeaponTech;
	Template.UIArmoryCameraPointTag = BaseAsWeaponTemplate.UIArmoryCameraPointTag;
	Template.StowedLocation = BaseAsWeaponTemplate.StowedLocation;
	Template.WeaponPanelImage = BaseAsWeaponTemplate.WeaponPanelImage;
	Template.bMergeAmmo = BaseAsWeaponTemplate.bMergeAmmo;
	Template.ArmorTechCatForAltArchetype = BaseAsWeaponTemplate.ArmorTechCatForAltArchetype;
	Template.GenderForAltArchetype = BaseAsWeaponTemplate.GenderForAltArchetype;

	// Combat stuff would go here, but the WeaponSet items aren't the ones used in combat, so we don't need it
	Template.DamageTypeTemplateName = BaseAsWeaponTemplate.DamageTypeTemplateName; // Why did Grimy copy this to the weapon that's never used?
	Template.BaseDamage = BaseAsWeaponTemplate.BaseDamage; // Hopefully this doesn't come back to bite me, but this should fix the UIStatMarkups not appearing right
	Template.ExtraDamage = BaseAsWeaponTemplate.ExtraDamage; // ^
	
	Template.NumUpgradeSlots = -1; // Upgrading a utility slot weapon is useless - don't need to handle ResOrder that gives +1, because it happens to >0

	// More combat stuff
	
	Template.DefaultAttachments = BaseAsWeaponTemplate.DefaultAttachments;
	// All X2WeaponTemplate properties end

	switch (BaseAsWeaponTemplate.DataName)
	{
		case 'AlienHunterAxe_CV':
		case 'AlienHunterAxe_MG':
		case 'AlienHunterAxe_BM':
			TertiaryTemplateName = name("Utility" $ Repl(string(BaseAsWeaponTemplate.DataName), "Axe", "AxeThrown", true));
			break;
		case 'WristBlade_CV':
		case 'WristBlade_MG':
		case 'WristBlade_BM':
			TertiaryTemplateName = name("Utility" $ Repl(string(BaseAsWeaponTemplate.DataName), "Blade", "BladeLeft", true));
			break;
		case 'ShardGauntletLeft_CV':
		case 'ShardGauntletLeft_MG':
		case 'ShardGauntletLeft_BM':
			TertiaryTemplateName = name("Utility" $ Repl(string(BaseAsWeaponTemplate.DataName), "Gauntlet", "GauntletLeft", true));
			break;
	}

	if (TertiaryTemplateName != '')
	{
		Template.PairedSlots.AddItem(eInvSlot_TertiaryWeapon);
		Template.PairedTemplateNames.AddItem(TertiaryTemplateName);
	}
	
	if (Template != none)
	{
		`Log("Generating Template" @ Template.DataName,, 'UtilitySlotSidearms_WOTC');
		for (i = 0; i < Template.PairedTemplateNames.Length; i++)
		{
			`Log("- PairedTemplateNames[" $ i $ "]" @ Template.PairedTemplateNames[i],, 'UtilitySlotSidearms_WOTC');
			`Log("- - PairedSlots[" $ i $ "]" @ Template.PairedSlots[i],, 'UtilitySlotSidearms_WOTC');
		}
	}

	return Template;
}

static function bool IsPistolWeaponTemplate(X2WeaponTemplate WeaponTemplate)
{
	return WeaponTemplate != none &&
		WeaponTemplate.InventorySlot == eInvSlot_SecondaryWeapon &&
		//X2PairedWeaponTemplate(WeaponTemplate) == none &&
		default.PistolCategories.Find(WeaponTemplate.WeaponCat) != INDEX_NONE &&
		InStr(WeaponTemplate.DataName, "_TMP_") == INDEX_NONE; // Filter RF Templar Weapons
}

static function bool IsMeleeWeaponTemplate(X2WeaponTemplate WeaponTemplate)
{
	return WeaponTemplate != none && WeaponTemplate.InventorySlot == eInvSlot_SecondaryWeapon && default.MeleeCategories.Find(WeaponTemplate.WeaponCat) != INDEX_NONE;
}

static function bool IsGremlinTemplate(X2WeaponTemplate WeaponTemplate)
{
	return WeaponTemplate != none && WeaponTemplate.InventorySlot == eInvSlot_SecondaryWeapon && default.GremlinCategories.Find(WeaponTemplate.WeaponCat) != INDEX_NONE;
}

static function bool IsPsiAmpTemplate(X2WeaponTemplate WeaponTemplate)
{
	return WeaponTemplate != none && WeaponTemplate.InventorySlot == eInvSlot_SecondaryWeapon && default.PsiAmpCategories.Find(WeaponTemplate.WeaponCat) != INDEX_NONE;
}

static function bool IsGrenadeLauncherTemplate(X2WeaponTemplate WeaponTemplate)
{
	return WeaponTemplate != none && WeaponTemplate.InventorySlot == eInvSlot_SecondaryWeapon && default.GrenadeLauncherCategories.Find(WeaponTemplate.WeaponCat) != INDEX_NONE;
}

static function bool IsClaymoreWeaponTemplate(X2WeaponTemplate WeaponTemplate)
{
	return WeaponTemplate != none && WeaponTemplate.InventorySlot == eInvSlot_SecondaryWeapon && default.ClaymoreCategories.Find(WeaponTemplate.WeaponCat) != INDEX_NONE;
}

static function bool IsRipjackWeaponTemplate(X2WeaponTemplate WeaponTemplate)
{
	return WeaponTemplate != none && WeaponTemplate.InventorySlot == eInvSlot_SecondaryWeapon && default.RipjackCategories.Find(WeaponTemplate.WeaponCat) != INDEX_NONE;
}

static function bool IsShardGauntletWeaponTemplate(X2WeaponTemplate WeaponTemplate)
{
	return WeaponTemplate != none && default.ShardGauntletCategories.Find(WeaponTemplate.WeaponCat) != INDEX_NONE; // Don't check for eInvSlot_SecondaryWeapon because these are primaries :upsidedownface:
}

static function bool IsGenericWeaponTemplate(X2WeaponTemplate WeaponTemplate)
{
	return WeaponTemplate != none && WeaponTemplate.InventorySlot == eInvSlot_SecondaryWeapon && default.GenericCategories.Find(WeaponTemplate.WeaponCat) != INDEX_NONE;
}