//  FILE:   X2Item_CVWPWeaponTemplate.uc
//  AUTHOR: Krakah

class X2Item_CVWPWeaponTemplate extends X2Item dependson(X2CVWPDataStructures);



//##############################################################################################################
//########################################## Weapon Template function ##########################################
//##############################################################################################################

static function X2DataTemplate CVWPdataWeaponTemplateFN(				// Parameter:
	name nTemplateName,  												// 			 1
	int iNumUpgradeSlots, 												// 			 2
	int iNumOfAbilities,												//			 3
	array<name> nAbilities,												//			 4
	int iNumOfAttachments_Default,										//			 5
	array<CVWP_DefaultWepAttachment> DefaultAttach,						//			 6
	array<WeaponDamageValue> WepBasedmg,								//			 7
	int iNumOfResources,												//			 8
	array<CVWP_ResourceTypeCost> ResourceTypeCost,						//			 9
	bool bCanBeBuilt,													//			10
	bool bStartingItem,													//			11
	bool bIsLargeWeapon,												//			12
	bool bInfiniteItem,													//			13
	int iPointsToCompleteStaff,											//			14
	int iPointsToCompleteDays,											//			15
	int iTradingPostValue,												//			16
	int iNumOfRequiredTechs,											//			17
	array<name> nRequiredTechs,											//			18
	string strWeaponPanelImage,											//			19
	string strEquipSound,												//			20
	name nItemCat,														//			21
	name nWeaponCat,													//			22
	name nWeaponTech,													//			23
	string strImage,													//			24
	int iTier,															//			25
	int iAim,															//			26
	int iCritChance,													//			27
	int iClipSize,														//			28
	int iSoundRange,													//			29
	int iEnvironmentDamage,												//			30
	int iTypicalActionCost,												//			31
	string GameArchetype,												//			32
	name nUIArmoryCameraPointTag,										//			33
	int iPhysicsImpulse,												//			34
	float fKnockbackDamageAmount,										//			35
	float fKnockbackDamageRadius,										//			36
	name nDamageTypeTemplateName,										//			37
	name nCreatorTemplateName,											//			38
	name nBaseItem,														//			39
	name WeaponSlotSelect,												//			40
	array<CVWP_HideIfResearched> HideIfResearched,						//			41
	array<CVWP_HideIfPurchased> HideIfPurchased,						//			42
	name StatSelectMode,												//			43
	name RangeTableSelect,												//			44
	name StatSelectMobilityDetectionRadius,								//			45
			
	//3.21.17: Adding New Features			
	optional bool bInfiniteAmmo,										//			46
	optional bool bOverwatchActionPoint,								//			47
	optional bool bHideClipSizeStat,									//			48
	optional int iNumOfAnimationOverrides_Config,							//		49
	optional array<CVWP_SetAnimationNameForAbility> SetAnimationNameForAbility	 // 50
	)

	{

	local X2WeaponTemplate Template;
	local int iNumFcAbilities, iNumFcAttachments, iNumFcResources, iNumFcReqTech, iNumFcAnimationOverrides, i;
	local ArtifactCost Resources;

	iNumFcAbilities = 0;
	iNumFcAttachments = 0;
	iNumFcAnimationOverrides = 0;
	iNumFcResources = 0;
	iNumFcReqTech = 0;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, nTemplateName);

		if (class'X2DownloadableContentInfo_RFData_WotC'.default.ENABLE_DEBUG_LOGGING == true)
		{
			`LOG("==============================" @nTemplateName@ "==============================");
		}
	
	Template.WeaponPanelImage = strWeaponPanelImage;
	Template.EquipSound = strEquipSound;
	Template.ItemCat = nItemCat;
	Template.WeaponCat = nWeaponCat;
	Template.WeaponTech = nWeaponTech;
	Template.strImage = strImage;
	Template.Tier = iTier;

	Template.iTypicalActionCost = iTypicalActionCost;

	Template.iPhysicsImpulse = iPhysicsImpulse;
	Template.fKnockbackDamageAmount = fKnockbackDamageAmount;
	Template.fKnockbackDamageRadius = fKnockbackDamageRadius;
	Template.DamageTypeTemplateName = nDamageTypeTemplateName;

	Template.StartingItem = bStartingItem;
	Template.CanBeBuilt = bCanBeBuilt;
	Template.bIsLargeWeapon = bIsLargeWeapon;
	Template.bInfiniteItem = bInfiniteItem;


	// Weapon slot select.
	switch(WeaponSlotSelect) 
	{
		case('Primary'):
			Template.InventorySlot = eInvSlot_PrimaryWeapon;
			break;
		case('Secondary'):
			Template.InventorySlot = eInvSlot_SecondaryWeapon;
//			Template.OverwatchActionPoint = class'X2CharacterTemplateManager'.default.PistolOverwatchReserveActionPoint;
			break;
		case('Utility'):
			Template.InventorySlot = eInvSlot_Utility;
			break;
		default:
			`Log(nTemplateName$ ": Weapon Slot" @WeaponSlotSelect@ "invalid!");
			break;
	}
	
	
	// Weapon Abilities.
	while(iNumFcAbilities < iNumOfAbilities)
	{
		Template.Abilities.AddItem(nAbilities[iNumFcAbilities]);
		
		if (class'X2DownloadableContentInfo_RFData_WotC'.default.ENABLE_DEBUG_LOGGING == true)
		{
			`Log(nTemplateName$ ": Abilities =" @nAbilities[iNumFcAbilities]);
		}
		
		iNumFcAbilities++;
	}
		//Separators
		if (class'X2DownloadableContentInfo_RFData_WotC'.default.ENABLE_DEBUG_LOGGING == true)
		{
			`LOG("-------------------------------------------------------------------------------");
		}

	// Schematic trigger settings if bStartingItem=false.
	if (bStartingItem == false && bCanBeBuilt == false) 
	{
		Template.CreatorTemplateName = nCreatorTemplateName; // The schematic which creates this item.
		Template.BaseItem = nBaseItem; // Which item this will be upgraded from.
	} 


	// Model archtype reference, and UIcamera.
	Template.GameArchetype = GameArchetype;
	Template.UIArmoryCameraPointTag = nUIArmoryCameraPointTag;


	// Set the number of fields for Default attachments.
	while (iNumFcAttachments < iNumOfAttachments_Default)
	{
		Template.AddDefaultAttachment(DefaultAttach[iNumFcAttachments].AttachSocket, DefaultAttach[iNumFcAttachments].MeshName, ,DefaultAttach[iNumFcAttachments].IconName);

		if (class'X2DownloadableContentInfo_RFData_WotC'.default.ENABLE_DEBUG_LOGGING == true)
		{
			`Log(nTemplateName$ ": Attachments =" @DefaultAttach[iNumFcAttachments].AttachSocket$ ":" @DefaultAttach[iNumFcAttachments].MeshName$ "," @DefaultAttach[iNumFcAttachments].IconName);
		}

		iNumFcAttachments++;
	}


	//5.4.17: SetAnimationNameForAbility Support
	while (iNumFcAnimationOverrides < iNumOfAnimationOverrides_Config)
	{
		Template.SetAnimationNameForAbility(SetAnimationNameForAbility[iNumFcAnimationOverrides].AbilityName, SetAnimationNameForAbility[iNumFcAnimationOverrides].AnimSequenceName);
		
		if (class'X2DownloadableContentInfo_RFData_WotC'.default.ENABLE_DEBUG_LOGGING == true)
		{
			`LOG(nTemplateName$": SetAnimationNameForAbility =" @SetAnimationNameForAbility[iNumFcAnimationOverrides].AbilityName$ "," @SetAnimationNameForAbility[iNumFcAnimationOverrides].AnimSequenceName); 
		}
		
		iNumFcAnimationOverrides++;
	}

		//Separators
		if (class'X2DownloadableContentInfo_RFData_WotC'.default.ENABLE_DEBUG_LOGGING == true)
		{
			`LOG("-------------------------------------------------------------------------------");
		}

	// CanBeBuilt options active when true.
	if(bCanBeBuilt == true)
	{
		Template.PointsToComplete = class'X2StrategyElement_DefaultTechs'.static.StafferXDays(iPointsToCompleteStaff, iPointsToCompleteDays);
		Template.TradingPostValue = iTradingPostValue;
	
	
		// Set the number of fields for Required tech.
		while(iNumFcReqTech < iNumOfRequiredTechs)
		{

		Template.Requirements.RequiredTechs.AddItem(nRequiredTechs[iNumFcReqTech]);

			if (class'X2DownloadableContentInfo_RFData_WotC'.default.ENABLE_DEBUG_LOGGING == true)
			{
				`Log(nTemplateName$ ": RequiredTechs =" @nRequiredTechs[iNumFcReqTech]);
			}

		iNumFcReqTech++;
		}


		// Set the number of fields for resource type and cost.
		while(iNumFcResources < iNumOfResources)
		{
			Resources.ItemTemplateName = ResourceTypeCost[iNumFcResources].ResourceName;
			Resources.Quantity = ResourceTypeCost[iNumFcResources].ResourceQuantity;

			if (class'X2DownloadableContentInfo_RFData_WotC'.default.ENABLE_DEBUG_LOGGING == true)
			{
				`Log(nTemplateName$ ": ResourceTypeCost =" @ResourceTypeCost[iNumFcResources].ResourceName$ "," @ResourceTypeCost[iNumFcResources].ResourceQuantity);
			}

			Template.Cost.ResourceCosts.AddItem(Resources);
			iNumFcResources++;
		}
	}


	// Hide this weapon template when tech is researched.
	if(HideIfResearched[0].bOnOffToggle == true) 
	{
		Template.HideIfResearched = HideIfResearched[0].HideIfResearched;

		if (class'X2DownloadableContentInfo_RFData_WotC'.default.ENABLE_DEBUG_LOGGING == true)
		{
			`LOG(nTemplateName$ ": HideIfResearched =" @HideIfResearched[0].HideIfResearched); 
		}

	}
	else if(HideIfResearched[0].bOnOffToggle == false) 
	{
		if (class'X2DownloadableContentInfo_RFData_WotC'.default.ENABLE_DEBUG_LOGGING == true)
		{
			`LOG(nTemplateName$ ": HideIfResearched is Disabled");
		}
	}
	

	// Hide this weapon template when next tier schematic is purchased.
	if(HideIfPurchased[0].bOnOffToggle == true) 
	{
		Template.HideIfPurchased = HideIfPurchased[0].HideIfPurchased;
		if (class'X2DownloadableContentInfo_RFData_WotC'.default.ENABLE_DEBUG_LOGGING == true)
		{
			`LOG(nTemplateName$ ": HideIfPurchased =" @HideIfPurchased[0].HideIfPurchased); 
		}
	}	
	else if(HideIfPurchased[0].bOnOffToggle == false)	
	{
		if (class'X2DownloadableContentInfo_RFData_WotC'.default.ENABLE_DEBUG_LOGGING == true)
		{
			`LOG(nTemplateName$ ": HideIfPurchased is Disabled"); 
		}
	}
			//Separators
		if (class'X2DownloadableContentInfo_RFData_WotC'.default.ENABLE_DEBUG_LOGGING == true)
		{
			`LOG("-------------------------------------------------------------------------------");
		}


	// Mobility Bonus
	switch(StatSelectMobilityDetectionRadius)
	{
		case('Global_All_1_Bonus'):
			Template.Abilities.AddItem(class'X2Ability_Global_AbilityBonus'.default.CVWPdata_1_Bonus.AbilityTemplate);
			Template.SetUIStatMarkup(class'XLocalizedData'.default.MobilityLabel, eStat_Mobility, class'X2Ability_Global_AbilityBonus'.default.CVWPdata_1_Bonus.MobilityBonus);
			break;
		case('Global_All_2_Bonus'):
			Template.Abilities.AddItem(class'X2Ability_Global_AbilityBonus'.default.CVWPdata_2_Bonus.AbilityTemplate);
			Template.SetUIStatMarkup(class'XLocalizedData'.default.MobilityLabel, eStat_Mobility, class'X2Ability_Global_AbilityBonus'.default.CVWPdata_2_Bonus.MobilityBonus);
			break;
		case('Global_All_3_Bonus'):
			Template.Abilities.AddItem(class'X2Ability_Global_AbilityBonus'.default.CVWPdata_3_Bonus.AbilityTemplate);
			Template.SetUIStatMarkup(class'XLocalizedData'.default.MobilityLabel, eStat_Mobility, class'X2Ability_Global_AbilityBonus'.default.CVWPdata_3_Bonus.MobilityBonus);
			break;

		case('Global_Assault_1_Bonus'):
			Template.Abilities.AddItem(class'X2Ability_Global_AbilityBonus'.default.CVWPdata_Assault_1_Bonus.AbilityTemplate);
			Template.SetUIStatMarkup(class'XLocalizedData'.default.MobilityLabel, eStat_Mobility, class'X2Ability_Global_AbilityBonus'.default.CVWPdata_Assault_1_Bonus.MobilityBonus);
			break;
		case('Global_Assault_2_Bonus'):
			Template.Abilities.AddItem(class'X2Ability_Global_AbilityBonus'.default.CVWPdata_Assault_2_Bonus.AbilityTemplate);
			Template.SetUIStatMarkup(class'XLocalizedData'.default.MobilityLabel, eStat_Mobility, class'X2Ability_Global_AbilityBonus'.default.CVWPdata_Assault_2_Bonus.MobilityBonus);
			break;
		case('Global_Assault_3_Bonus'):
			Template.Abilities.AddItem(class'X2Ability_Global_AbilityBonus'.default.CVWPdata_Assault_3_Bonus.AbilityTemplate);
			Template.SetUIStatMarkup(class'XLocalizedData'.default.MobilityLabel, eStat_Mobility, class'X2Ability_Global_AbilityBonus'.default.CVWPdata_Assault_3_Bonus.MobilityBonus);
			break;

		case('Global_Shotgun_1_Bonus'):
			Template.Abilities.AddItem(class'X2Ability_Global_AbilityBonus'.default.CVWPdata_Shotgun_1_Bonus.AbilityTemplate);
			Template.SetUIStatMarkup(class'XLocalizedData'.default.MobilityLabel, eStat_Mobility, class'X2Ability_Global_AbilityBonus'.default.CVWPdata_Shotgun_1_Bonus.MobilityBonus);
			break;
		case('Global_Shotgun_2_Bonus'):
			Template.Abilities.AddItem(class'X2Ability_Global_AbilityBonus'.default.CVWPdata_Shotgun_2_Bonus.AbilityTemplate);
			Template.SetUIStatMarkup(class'XLocalizedData'.default.MobilityLabel, eStat_Mobility, class'X2Ability_Global_AbilityBonus'.default.CVWPdata_Shotgun_2_Bonus.MobilityBonus);
			break;
		case('Global_Shotgun_3_Bonus'):
			Template.Abilities.AddItem(class'X2Ability_Global_AbilityBonus'.default.CVWPdata_Shotgun_3_Bonus.AbilityTemplate);
			Template.SetUIStatMarkup(class'XLocalizedData'.default.MobilityLabel, eStat_Mobility, class'X2Ability_Global_AbilityBonus'.default.CVWPdata_Shotgun_3_Bonus.MobilityBonus);
			break;

		case('Global_Sniper_1_Bonus'):
			Template.Abilities.AddItem(class'X2Ability_Global_AbilityBonus'.default.CVWPdata_Sniper_1_Bonus.AbilityTemplate);
			Template.SetUIStatMarkup(class'XLocalizedData'.default.MobilityLabel, eStat_Mobility, class'X2Ability_Global_AbilityBonus'.default.CVWPdata_Sniper_1_Bonus.MobilityBonus);
			break;
		case('Global_Sniper_2_Bonus'):
			Template.Abilities.AddItem(class'X2Ability_Global_AbilityBonus'.default.CVWPdata_Sniper_2_Bonus.AbilityTemplate);
			Template.SetUIStatMarkup(class'XLocalizedData'.default.MobilityLabel, eStat_Mobility, class'X2Ability_Global_AbilityBonus'.default.CVWPdata_Sniper_2_Bonus.MobilityBonus);
			break;
		case('Global_Sniper_3_Bonus'):
			Template.Abilities.AddItem(class'X2Ability_Global_AbilityBonus'.default.CVWPdata_Sniper_3_Bonus.AbilityTemplate);
			Template.SetUIStatMarkup(class'XLocalizedData'.default.MobilityLabel, eStat_Mobility, class'X2Ability_Global_AbilityBonus'.default.CVWPdata_Sniper_3_Bonus.MobilityBonus);
			break;

		case('Global_Cannon_1_Bonus'):
			Template.Abilities.AddItem(class'X2Ability_Global_AbilityBonus'.default.CVWPdata_Cannon_1_Bonus.AbilityTemplate);
			Template.SetUIStatMarkup(class'XLocalizedData'.default.MobilityLabel, eStat_Mobility, class'X2Ability_Global_AbilityBonus'.default.CVWPdata_Cannon_1_Bonus.MobilityBonus);
			break;
		case('Global_Cannon_2_Bonus'):
			Template.Abilities.AddItem(class'X2Ability_Global_AbilityBonus'.default.CVWPdata_Cannon_2_Bonus.AbilityTemplate);
			Template.SetUIStatMarkup(class'XLocalizedData'.default.MobilityLabel, eStat_Mobility, class'X2Ability_Global_AbilityBonus'.default.CVWPdata_Cannon_2_Bonus.MobilityBonus);
			break;
		case('Global_Cannon_3_Bonus'):
			Template.Abilities.AddItem(class'X2Ability_Global_AbilityBonus'.default.CVWPdata_Cannon_3_Bonus.AbilityTemplate);
			Template.SetUIStatMarkup(class'XLocalizedData'.default.MobilityLabel, eStat_Mobility, class'X2Ability_Global_AbilityBonus'.default.CVWPdata_Cannon_3_Bonus.MobilityBonus);
			break;
		case('Global_Pistol_1_Bonus'):
			Template.Abilities.AddItem(class'X2Ability_Global_AbilityBonus'.default.CVWPdata_Pistol_1_Bonus.AbilityTemplate);
			Template.SetUIStatMarkup(class'XLocalizedData'.default.MobilityLabel, eStat_Mobility, class'X2Ability_Global_AbilityBonus'.default.CVWPdata_Pistol_1_Bonus.MobilityBonus);
			break;
		case('Global_Pistol_2_Bonus'):
			Template.Abilities.AddItem(class'X2Ability_Global_AbilityBonus'.default.CVWPdata_Pistol_2_Bonus.AbilityTemplate);
			Template.SetUIStatMarkup(class'XLocalizedData'.default.MobilityLabel, eStat_Mobility, class'X2Ability_Global_AbilityBonus'.default.CVWPdata_Pistol_2_Bonus.MobilityBonus);
			break;
		case('Global_Pistol_3_Bonus'):
			Template.Abilities.AddItem(class'X2Ability_Global_AbilityBonus'.default.CVWPdata_Pistol_3_Bonus.AbilityTemplate);
			Template.SetUIStatMarkup(class'XLocalizedData'.default.MobilityLabel, eStat_Mobility, class'X2Ability_Global_AbilityBonus'.default.CVWPdata_Pistol_3_Bonus.MobilityBonus);
			break;
		default:
			`Log("Stat Select Mode, Mobility bonus disabled  for" @nTemplateName);
			break;
	}		



	// Stat Select Mode.
	switch(StatSelectMode) 
	{
		//Vanilla weapon seeded stats.
		case('Shotgun_CV'): 
			Template.RangeAccuracy = class'X2Item_DefaultWeapons'.default.SHORT_CONVENTIONAL_RANGE;
			Template.BaseDamage = class'X2Item_DefaultWeapons'.default.SHOTGUN_CONVENTIONAL_BASEDAMAGE;
			Template.Aim = class'X2Item_DefaultWeapons'.default.SHOTGUN_CONVENTIONAL_AIM;
			Template.CritChance = class'X2Item_DefaultWeapons'.default.SHOTGUN_CONVENTIONAL_CRITCHANCE;
			Template.iClipSize = class'X2Item_DefaultWeapons'.default.SHOTGUN_CONVENTIONAL_ICLIPSIZE;
			Template.iSoundRange = class'X2Item_DefaultWeapons'.default.SHOTGUN_CONVENTIONAL_ISOUNDRANGE;
			Template.iEnvironmentDamage = class'X2Item_DefaultWeapons'.default.SHOTGUN_CONVENTIONAL_IENVIRONMENTDAMAGE;
			Template.NumUpgradeSlots = 1;
			break;
		case('Shotgun_MG'):	
			Template.RangeAccuracy = class'X2Item_DefaultWeapons'.default.SHORT_CONVENTIONAL_RANGE;
			Template.BaseDamage = class'X2Item_DefaultWeapons'.default.SHOTGUN_MAGNETIC_BASEDAMAGE;
			Template.Aim = class'X2Item_DefaultWeapons'.default.SHOTGUN_MAGNETIC_AIM;
			Template.CritChance = class'X2Item_DefaultWeapons'.default.SHOTGUN_MAGNETIC_CRITCHANCE;
			Template.iClipSize = class'X2Item_DefaultWeapons'.default.SHOTGUN_MAGNETIC_ICLIPSIZE;
			Template.iSoundRange = class'X2Item_DefaultWeapons'.default.SHOTGUN_MAGNETIC_ISOUNDRANGE;
			Template.iEnvironmentDamage = class'X2Item_DefaultWeapons'.default.SHOTGUN_MAGNETIC_IENVIRONMENTDAMAGE;
			Template.NumUpgradeSlots = 2;
			break;
		case('Shotgun_BM'):
			Template.RangeAccuracy = class'X2Item_DefaultWeapons'.default.SHORT_CONVENTIONAL_RANGE;
			Template.BaseDamage = class'X2Item_DefaultWeapons'.default.SHOTGUN_BEAM_BASEDAMAGE;
			Template.Aim = class'X2Item_DefaultWeapons'.default.SHOTGUN_BEAM_AIM;
			Template.CritChance = class'X2Item_DefaultWeapons'.default.SHOTGUN_BEAM_CRITCHANCE;
			Template.iClipSize = class'X2Item_DefaultWeapons'.default.SHOTGUN_BEAM_ICLIPSIZE;
			Template.iSoundRange = class'X2Item_DefaultWeapons'.default.SHOTGUN_BEAM_ISOUNDRANGE;
			Template.iEnvironmentDamage = class'X2Item_DefaultWeapons'.default.SHOTGUN_BEAM_IENVIRONMENTDAMAGE;
			Template.NumUpgradeSlots = 2;
			break;
		case('AssaultRifle_CV'): 
			Template.RangeAccuracy = class'X2Item_DefaultWeapons'.default.MEDIUM_CONVENTIONAL_RANGE;
			Template.BaseDamage = class'X2Item_DefaultWeapons'.default.ASSAULTRIFLE_CONVENTIONAL_BASEDAMAGE;
			Template.Aim = class'X2Item_DefaultWeapons'.default.ASSAULTRIFLE_CONVENTIONAL_AIM;
			Template.CritChance = class'X2Item_DefaultWeapons'.default.ASSAULTRIFLE_CONVENTIONAL_CRITCHANCE;
			Template.iClipSize = class'X2Item_DefaultWeapons'.default.ASSAULTRIFLE_CONVENTIONAL_ICLIPSIZE;
			Template.iSoundRange = class'X2Item_DefaultWeapons'.default.ASSAULTRIFLE_CONVENTIONAL_ISOUNDRANGE;
			Template.iEnvironmentDamage = class'X2Item_DefaultWeapons'.default.ASSAULTRIFLE_CONVENTIONAL_IENVIRONMENTDAMAGE;
			Template.NumUpgradeSlots = 1;
			break;
		case('AssaultRifle_MG'):
			Template.RangeAccuracy = class'X2Item_DefaultWeapons'.default.MEDIUM_MAGNETIC_RANGE;
			Template.BaseDamage = class'X2Item_DefaultWeapons'.default.ASSAULTRIFLE_MAGNETIC_BASEDAMAGE;
			Template.Aim = class'X2Item_DefaultWeapons'.default.ASSAULTRIFLE_MAGNETIC_AIM;
			Template.CritChance = class'X2Item_DefaultWeapons'.default.ASSAULTRIFLE_MAGNETIC_CRITCHANCE;
			Template.iClipSize = class'X2Item_DefaultWeapons'.default.ASSAULTRIFLE_MAGNETIC_ICLIPSIZE;
			Template.iSoundRange = class'X2Item_DefaultWeapons'.default.ASSAULTRIFLE_MAGNETIC_ISOUNDRANGE;
			Template.iEnvironmentDamage = class'X2Item_DefaultWeapons'.default.ASSAULTRIFLE_MAGNETIC_IENVIRONMENTDAMAGE;
			Template.NumUpgradeSlots = 2;
			break;
		case('AssaultRifle_BM'): 
			Template.RangeAccuracy = class'X2Item_DefaultWeapons'.default.MEDIUM_BEAM_RANGE;
			Template.BaseDamage = class'X2Item_DefaultWeapons'.default.ASSAULTRIFLE_BEAM_BASEDAMAGE;
			Template.Aim = class'X2Item_DefaultWeapons'.default.ASSAULTRIFLE_BEAM_AIM;
			Template.CritChance = class'X2Item_DefaultWeapons'.default.ASSAULTRIFLE_BEAM_CRITCHANCE;
			Template.iClipSize = class'X2Item_DefaultWeapons'.default.ASSAULTRIFLE_BEAM_ICLIPSIZE;
			Template.iSoundRange = class'X2Item_DefaultWeapons'.default.ASSAULTRIFLE_BEAM_ISOUNDRANGE;
			Template.iEnvironmentDamage = class'X2Item_DefaultWeapons'.default.ASSAULTRIFLE_BEAM_IENVIRONMENTDAMAGE;
			Template.NumUpgradeSlots = 2;
			break;
		case('SniperRifle_CV'):
			Template.RangeAccuracy = class'X2Item_DefaultWeapons'.default.LONG_CONVENTIONAL_RANGE;
			Template.BaseDamage = class'X2Item_DefaultWeapons'.default.SNIPERRIFLE_CONVENTIONAL_BASEDAMAGE;
			Template.Aim = class'X2Item_DefaultWeapons'.default.SNIPERRIFLE_CONVENTIONAL_AIM;
			Template.CritChance = class'X2Item_DefaultWeapons'.default.SNIPERRIFLE_CONVENTIONAL_CRITCHANCE;
			Template.iClipSize = class'X2Item_DefaultWeapons'.default.SNIPERRIFLE_CONVENTIONAL_ICLIPSIZE;
			Template.iSoundRange = class'X2Item_DefaultWeapons'.default.SNIPERRIFLE_CONVENTIONAL_ISOUNDRANGE;
			Template.iEnvironmentDamage = class'X2Item_DefaultWeapons'.default.SNIPERRIFLE_CONVENTIONAL_IENVIRONMENTDAMAGE;
			Template.NumUpgradeSlots = 1;
			break;
		case('SniperRifle_MG'):
			Template.RangeAccuracy = class'X2Item_DefaultWeapons'.default.LONG_MAGNETIC_RANGE;
			Template.BaseDamage = class'X2Item_DefaultWeapons'.default.SNIPERRIFLE_MAGNETIC_BASEDAMAGE;
			Template.Aim = class'X2Item_DefaultWeapons'.default.SNIPERRIFLE_MAGNETIC_AIM;
			Template.CritChance = class'X2Item_DefaultWeapons'.default.SNIPERRIFLE_MAGNETIC_CRITCHANCE;
			Template.iClipSize = class'X2Item_DefaultWeapons'.default.SNIPERRIFLE_MAGNETIC_ICLIPSIZE;
			Template.iSoundRange = class'X2Item_DefaultWeapons'.default.SNIPERRIFLE_MAGNETIC_ISOUNDRANGE;
			Template.iEnvironmentDamage = class'X2Item_DefaultWeapons'.default.SNIPERRIFLE_MAGNETIC_IENVIRONMENTDAMAGE;
			Template.NumUpgradeSlots = 2;
			break;
		case('SniperRifle_BM'):
			Template.RangeAccuracy = class'X2Item_DefaultWeapons'.default.LONG_BEAM_RANGE;
			Template.BaseDamage = class'X2Item_DefaultWeapons'.default.SNIPERRIFLE_BEAM_BASEDAMAGE;
			Template.Aim = class'X2Item_DefaultWeapons'.default.SNIPERRIFLE_BEAM_AIM;
			Template.CritChance = class'X2Item_DefaultWeapons'.default.SNIPERRIFLE_BEAM_CRITCHANCE;
			Template.iClipSize = class'X2Item_DefaultWeapons'.default.SNIPERRIFLE_BEAM_ICLIPSIZE;
			Template.iSoundRange = class'X2Item_DefaultWeapons'.default.SNIPERRIFLE_BEAM_ISOUNDRANGE;
			Template.iEnvironmentDamage = class'X2Item_DefaultWeapons'.default.SNIPERRIFLE_BEAM_IENVIRONMENTDAMAGE;
			Template.NumUpgradeSlots = 2;
			break;
		case('Cannon_CV'):
			Template.RangeAccuracy = class'X2Item_DefaultWeapons'.default.MEDIUM_CONVENTIONAL_RANGE;
			Template.BaseDamage = class'X2Item_DefaultWeapons'.default.LMG_CONVENTIONAL_BASEDAMAGE;
			Template.Aim = class'X2Item_DefaultWeapons'.default.LMG_CONVENTIONAL_AIM;
			Template.CritChance = class'X2Item_DefaultWeapons'.default.LMG_CONVENTIONAL_CRITCHANCE;
			Template.iClipSize = class'X2Item_DefaultWeapons'.default.LMG_CONVENTIONAL_ICLIPSIZE;
			Template.iSoundRange = class'X2Item_DefaultWeapons'.default.LMG_CONVENTIONAL_ISOUNDRANGE;
			Template.iEnvironmentDamage = class'X2Item_DefaultWeapons'.default.LMG_CONVENTIONAL_IENVIRONMENTDAMAGE;
			Template.NumUpgradeSlots = 1;
			break;
		case('Cannon_MG'):
			Template.RangeAccuracy = class'X2Item_DefaultWeapons'.default.MEDIUM_MAGNETIC_RANGE;
			Template.BaseDamage = class'X2Item_DefaultWeapons'.default.LMG_MAGNETIC_BASEDAMAGE;
			Template.Aim = class'X2Item_DefaultWeapons'.default.LMG_MAGNETIC_AIM;
			Template.CritChance = class'X2Item_DefaultWeapons'.default.LMG_MAGNETIC_CRITCHANCE;
			Template.iClipSize = class'X2Item_DefaultWeapons'.default.LMG_MAGNETIC_ICLIPSIZE;
			Template.iSoundRange = class'X2Item_DefaultWeapons'.default.LMG_MAGNETIC_ISOUNDRANGE;
			Template.iEnvironmentDamage = class'X2Item_DefaultWeapons'.default.LMG_MAGNETIC_IENVIRONMENTDAMAGE;
			Template.NumUpgradeSlots = 2;
			break;
		case('Cannon_BM'):
			Template.RangeAccuracy = class'X2Item_DefaultWeapons'.default.MEDIUM_BEAM_RANGE;
			Template.BaseDamage = class'X2Item_DefaultWeapons'.default.LMG_BEAM_BASEDAMAGE;
			Template.Aim = class'X2Item_DefaultWeapons'.default.LMG_BEAM_AIM;
			Template.CritChance = class'X2Item_DefaultWeapons'.default.LMG_BEAM_CRITCHANCE;
			Template.iClipSize = class'X2Item_DefaultWeapons'.default.LMG_BEAM_ICLIPSIZE;
			Template.iSoundRange = class'X2Item_DefaultWeapons'.default.LMG_BEAM_ISOUNDRANGE;
			Template.iEnvironmentDamage = class'X2Item_DefaultWeapons'.default.LMG_BEAM_IENVIRONMENTDAMAGE;
			Template.NumUpgradeSlots = 2;
			break;
		case('Pistol_CV'): 
			Template.RangeAccuracy = class'X2Item_DefaultWeapons'.default.SHORT_CONVENTIONAL_RANGE;
			Template.BaseDamage = class'X2Item_DefaultWeapons'.default.PISTOL_CONVENTIONAL_BASEDAMAGE;
			Template.Aim = class'X2Item_DefaultWeapons'.default.PISTOL_CONVENTIONAL_AIM;
			Template.CritChance = class'X2Item_DefaultWeapons'.default.PISTOL_CONVENTIONAL_CRITCHANCE;
			Template.iClipSize = class'X2Item_DefaultWeapons'.default.PISTOL_CONVENTIONAL_ICLIPSIZE;
			Template.iSoundRange = class'X2Item_DefaultWeapons'.default.PISTOL_CONVENTIONAL_ISOUNDRANGE;
			Template.iEnvironmentDamage = class'X2Item_DefaultWeapons'.default.PISTOL_CONVENTIONAL_IENVIRONMENTDAMAGE;
			Template.NumUpgradeSlots = 1;
			break;
		case('Pistol_MG'):
			Template.RangeAccuracy = class'X2Item_DefaultWeapons'.default.SHORT_CONVENTIONAL_RANGE;
			Template.BaseDamage = class'X2Item_DefaultWeapons'.default.PISTOL_MAGNETIC_BASEDAMAGE;
			Template.Aim = class'X2Item_DefaultWeapons'.default.PISTOL_MAGNETIC_AIM;
			Template.CritChance = class'X2Item_DefaultWeapons'.default.PISTOL_MAGNETIC_CRITCHANCE;
			Template.iClipSize = class'X2Item_DefaultWeapons'.default.PISTOL_MAGNETIC_ICLIPSIZE;
			Template.iSoundRange = class'X2Item_DefaultWeapons'.default.PISTOL_MAGNETIC_ISOUNDRANGE;
			Template.iEnvironmentDamage = class'X2Item_DefaultWeapons'.default.PISTOL_MAGNETIC_IENVIRONMENTDAMAGE;
			Template.NumUpgradeSlots = 2;
			break;
		case('Pistol_BM'): 
			Template.RangeAccuracy = class'X2Item_DefaultWeapons'.default.SHORT_CONVENTIONAL_RANGE;
			Template.BaseDamage = class'X2Item_DefaultWeapons'.default.PISTOL_BEAM_BASEDAMAGE;
			Template.Aim = class'X2Item_DefaultWeapons'.default.PISTOL_BEAM_AIM;
			Template.CritChance = class'X2Item_DefaultWeapons'.default.PISTOL_BEAM_CRITCHANCE;
			Template.iClipSize = class'X2Item_DefaultWeapons'.default.PISTOL_BEAM_ICLIPSIZE;
			Template.iSoundRange = class'X2Item_DefaultWeapons'.default.PISTOL_BEAM_ISOUNDRANGE;
			Template.iEnvironmentDamage = class'X2Item_DefaultWeapons'.default.PISTOL_BEAM_IENVIRONMENTDAMAGE;
			Template.NumUpgradeSlots = 2;
			break;

		case('VektorRifle_CV'): 
			Template.RangeAccuracy = class'X2Item_XpackWeapons'.default.VEKTOR_CONVENTIONAL_RANGE;
			Template.BaseDamage = class'X2Item_XpackWeapons'.default.VEKTORRIFLE_CONVENTIONAL_BASEDAMAGE;
			Template.Aim = class'X2Item_XpackWeapons'.default.VEKTORRIFLE_CONVENTIONAL_AIM;
			Template.CritChance = class'X2Item_XpackWeapons'.default.VEKTORRIFLE_CONVENTIONAL_CRITCHANCE;
			Template.iClipSize = class'X2Item_XpackWeapons'.default.VEKTORRIFLE_CONVENTIONAL_ICLIPSIZE;
			Template.iSoundRange = class'X2Item_XpackWeapons'.default.VEKTORRIFLE_CONVENTIONAL_ISOUNDRANGE;
			Template.iEnvironmentDamage = class'X2Item_XpackWeapons'.default.VEKTORRIFLE_CONVENTIONAL_IENVIRONMENTDAMAGE;
			Template.NumUpgradeSlots = 1;
			break;
		case('VektorRifle_MG'):
			Template.RangeAccuracy = class'X2Item_XpackWeapons'.default.VEKTOR_MAGNETIC_RANGE;
			Template.BaseDamage = class'X2Item_XpackWeapons'.default.VEKTORRIFLE_MAGNETIC_BASEDAMAGE;
			Template.Aim = class'X2Item_XpackWeapons'.default.VEKTORRIFLE_MAGNETIC_AIM;
			Template.CritChance = class'X2Item_XpackWeapons'.default.VEKTORRIFLE_MAGNETIC_CRITCHANCE;
			Template.iClipSize = class'X2Item_XpackWeapons'.default.VEKTORRIFLE_MAGNETIC_ICLIPSIZE;
			Template.iSoundRange = class'X2Item_XpackWeapons'.default.VEKTORRIFLE_MAGNETIC_ISOUNDRANGE;
			Template.iEnvironmentDamage = class'X2Item_XpackWeapons'.default.VEKTORRIFLE_MAGNETIC_IENVIRONMENTDAMAGE;
			Template.NumUpgradeSlots = 2;
			break;
		case('VektorRifle_BM'): 
			Template.RangeAccuracy = class'X2Item_XpackWeapons'.default.VEKTOR_BEAM_RANGE;
			Template.BaseDamage = class'X2Item_XpackWeapons'.default.VEKTORRIFLE_BEAM_BASEDAMAGE;
			Template.Aim = class'X2Item_XpackWeapons'.default.VEKTORRIFLE_BEAM_AIM;
			Template.CritChance = class'X2Item_XpackWeapons'.default.VEKTORRIFLE_BEAM_CRITCHANCE;
			Template.iClipSize = class'X2Item_XpackWeapons'.default.VEKTORRIFLE_BEAM_ICLIPSIZE;
			Template.iSoundRange = class'X2Item_XpackWeapons'.default.VEKTORRIFLE_BEAM_ISOUNDRANGE;
			Template.iEnvironmentDamage = class'X2Item_XpackWeapons'.default.VEKTORRIFLE_BEAM_IENVIRONMENTDAMAGE;
			Template.NumUpgradeSlots = 2;
			break;
		case('Bullpup_CV'):
			Template.RangeAccuracy = class'X2Item_DefaultWeapons'.default.SHORT_CONVENTIONAL_RANGE;
			Template.BaseDamage = class'X2Item_XpackWeapons'.default.BULLPUP_CONVENTIONAL_BASEDAMAGE;
			Template.Aim = class'X2Item_XpackWeapons'.default.BULLPUP_CONVENTIONAL_AIM;
			Template.CritChance = class'X2Item_XpackWeapons'.default.BULLPUP_CONVENTIONAL_CRITCHANCE;
			Template.iClipSize = class'X2Item_XpackWeapons'.default.BULLPUP_CONVENTIONAL_ICLIPSIZE;
			Template.iSoundRange = class'X2Item_XpackWeapons'.default.BULLPUP_CONVENTIONAL_ISOUNDRANGE;
			Template.iEnvironmentDamage = class'X2Item_XpackWeapons'.default.BULLPUP_CONVENTIONAL_IENVIRONMENTDAMAGE;
			Template.NumUpgradeSlots = 1;
			break;
		case('Bullpup_MG'):
			Template.RangeAccuracy = class'X2Item_DefaultWeapons'.default.SHORT_MAGNETIC_RANGE;
			Template.BaseDamage = class'X2Item_XpackWeapons'.default.BULLPUP_MAGNETIC_BASEDAMAGE;
			Template.Aim = class'X2Item_XpackWeapons'.default.BULLPUP_MAGNETIC_AIM;
			Template.CritChance = class'X2Item_XpackWeapons'.default.BULLPUP_MAGNETIC_CRITCHANCE;
			Template.iClipSize = class'X2Item_XpackWeapons'.default.BULLPUP_MAGNETIC_ICLIPSIZE;
			Template.iSoundRange = class'X2Item_XpackWeapons'.default.BULLPUP_MAGNETIC_ISOUNDRANGE;
			Template.iEnvironmentDamage = class'X2Item_XpackWeapons'.default.BULLPUP_MAGNETIC_IENVIRONMENTDAMAGE;
			Template.NumUpgradeSlots = 2;
			break;
		case('Bullpup_BM'):
			Template.RangeAccuracy = class'X2Item_DefaultWeapons'.default.SHORT_BEAM_RANGE;
			Template.BaseDamage = class'X2Item_XpackWeapons'.default.BULLPUP_BEAM_BASEDAMAGE;
			Template.Aim = class'X2Item_XpackWeapons'.default.BULLPUP_BEAM_AIM;
			Template.CritChance = class'X2Item_XpackWeapons'.default.BULLPUP_BEAM_CRITCHANCE;
			Template.iClipSize = class'X2Item_XpackWeapons'.default.BULLPUP_BEAM_ICLIPSIZE;
			Template.iSoundRange = class'X2Item_XpackWeapons'.default.BULLPUP_BEAM_ISOUNDRANGE;
			Template.iEnvironmentDamage = class'X2Item_XpackWeapons'.default.BULLPUP_BEAM_IENVIRONMENTDAMAGE;
			Template.NumUpgradeSlots = 2;
			break;
		case('Sidearm_CV'):
			Template.RangeAccuracy = class'X2Item_DefaultWeapons'.default.SHORT_CONVENTIONAL_RANGE;
			Template.BaseDamage = class'X2Item_XpackWeapons'.default.SIDEARM_CONVENTIONAL_BASEDAMAGE;
			Template.Aim = class'X2Item_XpackWeapons'.default.SIDEARM_CONVENTIONAL_AIM;
			Template.CritChance = class'X2Item_XpackWeapons'.default.SIDEARM_CONVENTIONAL_CRITCHANCE;
			Template.iClipSize = class'X2Item_XpackWeapons'.default.SIDEARM_CONVENTIONAL_ICLIPSIZE;
			Template.iSoundRange = class'X2Item_XpackWeapons'.default.SIDEARM_CONVENTIONAL_ISOUNDRANGE;
			Template.iEnvironmentDamage = class'X2Item_XpackWeapons'.default.SIDEARM_CONVENTIONAL_IENVIRONMENTDAMAGE;
			Template.NumUpgradeSlots = 1;
			break;
		case('Sidearm_MG'):
			Template.RangeAccuracy = class'X2Item_DefaultWeapons'.default.SHORT_MAGNETIC_RANGE;
			Template.BaseDamage = class'X2Item_XpackWeapons'.default.SIDEARM_MAGNETIC_BASEDAMAGE;
			Template.Aim = class'X2Item_XpackWeapons'.default.SIDEARM_MAGNETIC_AIM;
			Template.CritChance = class'X2Item_XpackWeapons'.default.SIDEARM_MAGNETIC_CRITCHANCE;
			Template.iClipSize = class'X2Item_XpackWeapons'.default.SIDEARM_MAGNETIC_ICLIPSIZE;
			Template.iSoundRange = class'X2Item_XpackWeapons'.default.SIDEARM_MAGNETIC_ISOUNDRANGE;
			Template.iEnvironmentDamage = class'X2Item_XpackWeapons'.default.SIDEARM_MAGNETIC_IENVIRONMENTDAMAGE;
			Template.NumUpgradeSlots = 2;
			break;
		case('Sidearm_BM'):
			Template.RangeAccuracy = class'X2Item_DefaultWeapons'.default.SHORT_BEAM_RANGE;
			Template.BaseDamage = class'X2Item_XpackWeapons'.default.SIDEARM_BEAM_BASEDAMAGE;
			Template.Aim = class'X2Item_XpackWeapons'.default.SIDEARM_BEAM_AIM;
			Template.CritChance = class'X2Item_XpackWeapons'.default.SIDEARM_BEAM_CRITCHANCE;
			Template.iClipSize = class'X2Item_XpackWeapons'.default.SIDEARM_BEAM_ICLIPSIZE;
			Template.iSoundRange = class'X2Item_XpackWeapons'.default.SIDEARM_BEAM_ISOUNDRANGE;
			Template.iEnvironmentDamage = class'X2Item_XpackWeapons'.default.SIDEARM_BEAM_IENVIRONMENTDAMAGE;
			Template.NumUpgradeSlots = 2;
			break;

		//GLOBAL MOD STATS
		case('WOTC_STATS_SBS_T1'): 
			Template.RangeAccuracy = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SHORT_BARREL_SHOTGUN_T1_RANGE;
			Template.BaseDamage = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SHORT_BARREL_SHOTGUN_T1_BASEDAMAGE;
			Template.Aim = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SHORT_BARREL_SHOTGUN_T1_AIM;
			Template.CritChance = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SHORT_BARREL_SHOTGUN_T1_CRITCHANCE;
			Template.iClipSize = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SHORT_BARREL_SHOTGUN_T1_ICLIPSIZE;
			Template.iSoundRange = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SHORT_BARREL_SHOTGUN_T1_ISOUNDRANGE;
			Template.iEnvironmentDamage = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SHORT_BARREL_SHOTGUN_T1_IENVIRONMENTDAMAGE;
			Template.NumUpgradeSlots = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SHORT_BARREL_SHOTGUN_T1_UPGRADESLOTS;
			break;
		case('WOTC_STATS_SBS_T2'):	
			Template.RangeAccuracy = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SHORT_BARREL_SHOTGUN_T2_RANGE;
			Template.BaseDamage = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SHORT_BARREL_SHOTGUN_T2_BASEDAMAGE;
			Template.Aim = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SHORT_BARREL_SHOTGUN_T2_AIM;
			Template.CritChance = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SHORT_BARREL_SHOTGUN_T2_CRITCHANCE;
			Template.iClipSize = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SHORT_BARREL_SHOTGUN_T2_ICLIPSIZE;
			Template.iSoundRange = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SHORT_BARREL_SHOTGUN_T2_ISOUNDRANGE;
			Template.iEnvironmentDamage = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SHORT_BARREL_SHOTGUN_T2_IENVIRONMENTDAMAGE;
			Template.NumUpgradeSlots = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SHORT_BARREL_SHOTGUN_T2_UPGRADESLOTS;
			break;
		case('WOTC_STATS_SBS_T3'):
			Template.RangeAccuracy = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SHORT_BARREL_SHOTGUN_T3_RANGE;
			Template.BaseDamage = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SHORT_BARREL_SHOTGUN_T3_BASEDAMAGE;
			Template.Aim = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SHORT_BARREL_SHOTGUN_T3_AIM;
			Template.CritChance = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SHORT_BARREL_SHOTGUN_T3_CRITCHANCE;
			Template.iClipSize = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SHORT_BARREL_SHOTGUN_T3_ICLIPSIZE;
			Template.iSoundRange = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SHORT_BARREL_SHOTGUN_T3_ISOUNDRANGE;
			Template.iEnvironmentDamage = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SHORT_BARREL_SHOTGUN_T3_IENVIRONMENTDAMAGE;
			Template.NumUpgradeSlots = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SHORT_BARREL_SHOTGUN_T3_UPGRADESLOTS;
			break;
		case('WOTC_STATS_SHOTGUN_T1'): 
			Template.RangeAccuracy = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SHOTGUN_T1_RANGE;
			Template.BaseDamage = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SHOTGUN_T1_BASEDAMAGE;
			Template.Aim = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SHOTGUN_T1_AIM;
			Template.CritChance = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SHOTGUN_T1_CRITCHANCE;
			Template.iClipSize = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SHOTGUN_T1_ICLIPSIZE;
			Template.iSoundRange = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SHOTGUN_T1_ISOUNDRANGE;
			Template.iEnvironmentDamage = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SHOTGUN_T1_IENVIRONMENTDAMAGE;
			Template.NumUpgradeSlots = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SHOTGUN_T1_UPGRADESLOTS;
			break;
		case('WOTC_STATS_SHOTGUN_T2'):	
			Template.RangeAccuracy = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SHOTGUN_T2_RANGE;
			Template.BaseDamage = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SHOTGUN_T2_BASEDAMAGE;
			Template.Aim = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SHOTGUN_T2_AIM;
			Template.CritChance = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SHOTGUN_T2_CRITCHANCE;
			Template.iClipSize = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SHOTGUN_T2_ICLIPSIZE;
			Template.iSoundRange = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SHOTGUN_T2_ISOUNDRANGE;
			Template.iEnvironmentDamage = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SHOTGUN_T2_IENVIRONMENTDAMAGE;
			Template.NumUpgradeSlots = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SHOTGUN_T2_UPGRADESLOTS;
			break;
		case('WOTC_STATS_SHOTGUN_T3'):
			Template.RangeAccuracy = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SHOTGUN_T3_RANGE;
			Template.BaseDamage = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SHOTGUN_T3_BASEDAMAGE;
			Template.Aim = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SHOTGUN_T3_AIM;
			Template.CritChance = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SHOTGUN_T3_CRITCHANCE;
			Template.iClipSize = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SHOTGUN_T3_ICLIPSIZE;
			Template.iSoundRange = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SHOTGUN_T3_ISOUNDRANGE;
			Template.iEnvironmentDamage = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SHOTGUN_T3_IENVIRONMENTDAMAGE;
			Template.NumUpgradeSlots = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SHOTGUN_T3_UPGRADESLOTS;
			break;
		case('WOTC_STATS_ASSAULT_RIFLE_T1'): 
			Template.RangeAccuracy = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_ASSAULT_RIFLE_T1_RANGE;
			Template.BaseDamage = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_ASSAULT_RIFLE_T1_BASEDAMAGE;
			Template.Aim = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_ASSAULT_RIFLE_T1_AIM;
			Template.CritChance = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_ASSAULT_RIFLE_T1_CRITCHANCE;
			Template.iClipSize = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_ASSAULT_RIFLE_T1_ICLIPSIZE;
			Template.iSoundRange = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_ASSAULT_RIFLE_T1_ISOUNDRANGE;
			Template.iEnvironmentDamage = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_ASSAULT_RIFLE_T1_IENVIRONMENTDAMAGE;
			Template.NumUpgradeSlots = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_ASSAULT_RIFLE_T1_UPGRADESLOTS;
			break;
		case('WOTC_STATS_ASSAULT_RIFLE_T2'): 
			Template.RangeAccuracy = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_ASSAULT_RIFLE_T2_RANGE;
			Template.BaseDamage = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_ASSAULT_RIFLE_T2_BASEDAMAGE;
			Template.Aim = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_ASSAULT_RIFLE_T2_AIM;
			Template.CritChance = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_ASSAULT_RIFLE_T2_CRITCHANCE;
			Template.iClipSize = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_ASSAULT_RIFLE_T2_ICLIPSIZE;
			Template.iSoundRange = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_ASSAULT_RIFLE_T2_ISOUNDRANGE;
			Template.iEnvironmentDamage = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_ASSAULT_RIFLE_T2_IENVIRONMENTDAMAGE;
			Template.NumUpgradeSlots = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_ASSAULT_RIFLE_T2_UPGRADESLOTS;
			break;
		case('WOTC_STATS_ASSAULT_RIFLE_T3'): 
			Template.RangeAccuracy = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_ASSAULT_RIFLE_T3_RANGE;
			Template.BaseDamage = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_ASSAULT_RIFLE_T3_BASEDAMAGE;
			Template.Aim = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_ASSAULT_RIFLE_T3_AIM;
			Template.CritChance = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_ASSAULT_RIFLE_T3_CRITCHANCE;
			Template.iClipSize = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_ASSAULT_RIFLE_T3_ICLIPSIZE;
			Template.iSoundRange = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_ASSAULT_RIFLE_T3_ISOUNDRANGE;
			Template.iEnvironmentDamage = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_ASSAULT_RIFLE_T3_IENVIRONMENTDAMAGE;
			Template.NumUpgradeSlots = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_ASSAULT_RIFLE_T3_UPGRADESLOTS;
			break;
		case('WOTC_STATS_BATTLE_RIFLE_T1'): 
			Template.RangeAccuracy = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_BATTLE_RIFLE_T1_RANGE;
			Template.BaseDamage = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_BATTLE_RIFLE_T1_BASEDAMAGE;
			Template.Aim = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_BATTLE_RIFLE_T1_AIM;
			Template.CritChance = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_BATTLE_RIFLE_T1_CRITCHANCE;
			Template.iClipSize = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_BATTLE_RIFLE_T1_ICLIPSIZE;
			Template.iSoundRange = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_BATTLE_RIFLE_T1_ISOUNDRANGE;
			Template.iEnvironmentDamage = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_BATTLE_RIFLE_T1_IENVIRONMENTDAMAGE;
			Template.NumUpgradeSlots = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_BATTLE_RIFLE_T1_UPGRADESLOTS;
			break;
		case('WOTC_STATS_BATTLE_RIFLE_T2'): 
			Template.RangeAccuracy = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_BATTLE_RIFLE_T2_RANGE;
			Template.BaseDamage = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_BATTLE_RIFLE_T2_BASEDAMAGE;
			Template.Aim = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_BATTLE_RIFLE_T2_AIM;
			Template.CritChance = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_BATTLE_RIFLE_T2_CRITCHANCE;
			Template.iClipSize = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_BATTLE_RIFLE_T2_ICLIPSIZE;
			Template.iSoundRange = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_BATTLE_RIFLE_T2_ISOUNDRANGE;
			Template.iEnvironmentDamage = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_BATTLE_RIFLE_T2_IENVIRONMENTDAMAGE;
			Template.NumUpgradeSlots = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_BATTLE_RIFLE_T2_UPGRADESLOTS;
			break;
		case('WOTC_STATS_BATTLE_RIFLE_T3'): 
			Template.RangeAccuracy = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_BATTLE_RIFLE_T3_RANGE;
			Template.BaseDamage = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_BATTLE_RIFLE_T3_BASEDAMAGE;
			Template.Aim = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_BATTLE_RIFLE_T3_AIM;
			Template.CritChance = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_BATTLE_RIFLE_T3_CRITCHANCE;
			Template.iClipSize = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_BATTLE_RIFLE_T3_ICLIPSIZE;
			Template.iSoundRange = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_BATTLE_RIFLE_T3_ISOUNDRANGE;
			Template.iEnvironmentDamage = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_BATTLE_RIFLE_T3_IENVIRONMENTDAMAGE;
			Template.NumUpgradeSlots = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_BATTLE_RIFLE_T3_UPGRADESLOTS;
			break;
		case('WOTC_STATS_ASSAULT_CARBINE_T1'): 
			Template.RangeAccuracy = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_ASSAULT_CARBINE_T1_RANGE;
			Template.BaseDamage = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_ASSAULT_CARBINE_T1_BASEDAMAGE;
			Template.Aim = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_ASSAULT_CARBINE_T1_AIM;
			Template.CritChance = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_ASSAULT_CARBINE_T1_CRITCHANCE;
			Template.iClipSize = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_ASSAULT_CARBINE_T1_ICLIPSIZE;
			Template.iSoundRange = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_ASSAULT_CARBINE_T1_ISOUNDRANGE;
			Template.iEnvironmentDamage = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_ASSAULT_CARBINE_T1_IENVIRONMENTDAMAGE;
			Template.NumUpgradeSlots = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_ASSAULT_CARBINE_T1_UPGRADESLOTS;
			break;
		case('WOTC_STATS_ASSAULT_CARBINE_T2'): 
			Template.RangeAccuracy = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_ASSAULT_CARBINE_T2_RANGE;
			Template.BaseDamage = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_ASSAULT_CARBINE_T2_BASEDAMAGE;
			Template.Aim = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_ASSAULT_CARBINE_T2_AIM;
			Template.CritChance = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_ASSAULT_CARBINE_T2_CRITCHANCE;
			Template.iClipSize = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_ASSAULT_CARBINE_T2_ICLIPSIZE;
			Template.iSoundRange = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_ASSAULT_CARBINE_T2_ISOUNDRANGE;
			Template.iEnvironmentDamage = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_ASSAULT_CARBINE_T2_IENVIRONMENTDAMAGE;
			Template.NumUpgradeSlots = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_ASSAULT_CARBINE_T2_UPGRADESLOTS;
			break;
		case('WOTC_STATS_ASSAULT_CARBINE_T3'): 
			Template.RangeAccuracy = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_ASSAULT_CARBINE_T3_RANGE;
			Template.BaseDamage = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_ASSAULT_CARBINE_T3_BASEDAMAGE;
			Template.Aim = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_ASSAULT_CARBINE_T3_AIM;
			Template.CritChance = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_ASSAULT_CARBINE_T3_CRITCHANCE;
			Template.iClipSize = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_ASSAULT_CARBINE_T3_ICLIPSIZE;
			Template.iSoundRange = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_ASSAULT_CARBINE_T3_ISOUNDRANGE;
			Template.iEnvironmentDamage = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_ASSAULT_CARBINE_T3_IENVIRONMENTDAMAGE;
			Template.NumUpgradeSlots = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_ASSAULT_CARBINE_T3_UPGRADESLOTS;
			break;
		case('WOTC_STATS_SMG_T1'): 
			Template.RangeAccuracy = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SMG_T1_RANGE;
			Template.BaseDamage = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SMG_T1_BASEDAMAGE;
			Template.Aim = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SMG_T1_AIM;
			Template.CritChance = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SMG_T1_CRITCHANCE;
			Template.iClipSize = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SMG_T1_ICLIPSIZE;
			Template.iSoundRange = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SMG_T1_ISOUNDRANGE;
			Template.iEnvironmentDamage = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SMG_T1_IENVIRONMENTDAMAGE;
			Template.NumUpgradeSlots = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SMG_T1_UPGRADESLOTS;
			break;
		case('WOTC_STATS_SMG_T2'): 
			Template.RangeAccuracy = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SMG_T2_RANGE;
			Template.BaseDamage = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SMG_T2_BASEDAMAGE;
			Template.Aim = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SMG_T2_AIM;
			Template.CritChance = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SMG_T2_CRITCHANCE;
			Template.iClipSize = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SMG_T2_ICLIPSIZE;
			Template.iSoundRange = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SMG_T2_ISOUNDRANGE;
			Template.iEnvironmentDamage = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SMG_T2_IENVIRONMENTDAMAGE;
			Template.NumUpgradeSlots = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SMG_T2_UPGRADESLOTS;
			break;
		case('WOTC_STATS_SMG_T3'): 
			Template.RangeAccuracy = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SMG_T3_RANGE;
			Template.BaseDamage = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SMG_T3_BASEDAMAGE;
			Template.Aim = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SMG_T3_AIM;
			Template.CritChance = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SMG_T3_CRITCHANCE;
			Template.iClipSize = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SMG_T3_ICLIPSIZE;
			Template.iSoundRange = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SMG_T3_ISOUNDRANGE;
			Template.iEnvironmentDamage = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SMG_T3_IENVIRONMENTDAMAGE;
			Template.NumUpgradeSlots = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SMG_T3_UPGRADESLOTS;
			break;
		case('WOTC_STATS_SNIPER_RIFLE_T1'): 
			Template.RangeAccuracy = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SNIPER_RIFLE_T1_RANGE;
			Template.BaseDamage = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SNIPER_RIFLE_T1_BASEDAMAGE;
			Template.Aim = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SNIPER_RIFLE_T1_AIM;
			Template.CritChance = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SNIPER_RIFLE_T1_CRITCHANCE;
			Template.iClipSize = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SNIPER_RIFLE_T1_ICLIPSIZE;
			Template.iSoundRange = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SNIPER_RIFLE_T1_ISOUNDRANGE;
			Template.iEnvironmentDamage = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SNIPER_RIFLE_T1_IENVIRONMENTDAMAGE;
			Template.NumUpgradeSlots = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SNIPER_RIFLE_T1_UPGRADESLOTS;
			break;
		case('WOTC_STATS_SNIPER_RIFLE_T2'): 
			Template.RangeAccuracy = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SNIPER_RIFLE_T2_RANGE;
			Template.BaseDamage = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SNIPER_RIFLE_T2_BASEDAMAGE;
			Template.Aim = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SNIPER_RIFLE_T2_AIM;
			Template.CritChance = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SNIPER_RIFLE_T2_CRITCHANCE;
			Template.iClipSize = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SNIPER_RIFLE_T2_ICLIPSIZE;
			Template.iSoundRange = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SNIPER_RIFLE_T2_ISOUNDRANGE;
			Template.iEnvironmentDamage = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SNIPER_RIFLE_T2_IENVIRONMENTDAMAGE;
			Template.NumUpgradeSlots = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SNIPER_RIFLE_T2_UPGRADESLOTS;
			break;
		case('WOTC_STATS_SNIPER_RIFLE_T3'): 
			Template.RangeAccuracy = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SNIPER_RIFLE_T3_RANGE;
			Template.BaseDamage = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SNIPER_RIFLE_T3_BASEDAMAGE;
			Template.Aim = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SNIPER_RIFLE_T3_AIM;
			Template.CritChance = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SNIPER_RIFLE_T3_CRITCHANCE;
			Template.iClipSize = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SNIPER_RIFLE_T3_ICLIPSIZE;
			Template.iSoundRange = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SNIPER_RIFLE_T3_ISOUNDRANGE;
			Template.iEnvironmentDamage = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SNIPER_RIFLE_T3_IENVIRONMENTDAMAGE;
			Template.NumUpgradeSlots = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SNIPER_RIFLE_T3_UPGRADESLOTS;
			break;
		case('WOTC_STATS_MARKSMAN_RIFLE_T1'): 
			Template.RangeAccuracy = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_MARKSMAN_RIFLE_T1_RANGE;
			Template.BaseDamage = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_MARKSMAN_RIFLE_T1_BASEDAMAGE;
			Template.Aim = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_MARKSMAN_RIFLE_T1_AIM;
			Template.CritChance = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_MARKSMAN_RIFLE_T1_CRITCHANCE;
			Template.iClipSize = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_MARKSMAN_RIFLE_T1_ICLIPSIZE;
			Template.iSoundRange = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_MARKSMAN_RIFLE_T1_ISOUNDRANGE;
			Template.iEnvironmentDamage = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_MARKSMAN_RIFLE_T1_IENVIRONMENTDAMAGE;
			Template.NumUpgradeSlots = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_MARKSMAN_RIFLE_T1_UPGRADESLOTS;
			break;
		case('WOTC_STATS_MARKSMAN_RIFLE_T2'): 
			Template.RangeAccuracy = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_MARKSMAN_RIFLE_T2_RANGE;
			Template.BaseDamage = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_MARKSMAN_RIFLE_T2_BASEDAMAGE;
			Template.Aim = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_MARKSMAN_RIFLE_T2_AIM;
			Template.CritChance = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_MARKSMAN_RIFLE_T2_CRITCHANCE;
			Template.iClipSize = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_MARKSMAN_RIFLE_T2_ICLIPSIZE;
			Template.iSoundRange = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_MARKSMAN_RIFLE_T2_ISOUNDRANGE;
			Template.iEnvironmentDamage = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_MARKSMAN_RIFLE_T2_IENVIRONMENTDAMAGE;
			Template.NumUpgradeSlots = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_MARKSMAN_RIFLE_T2_UPGRADESLOTS;
			break;
		case('WOTC_STATS_MARKSMAN_RIFLE_T3'): 
			Template.RangeAccuracy = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_MARKSMAN_RIFLE_T3_RANGE;
			Template.BaseDamage = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_MARKSMAN_RIFLE_T3_BASEDAMAGE;
			Template.Aim = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_MARKSMAN_RIFLE_T3_AIM;
			Template.CritChance = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_MARKSMAN_RIFLE_T3_CRITCHANCE;
			Template.iClipSize = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_MARKSMAN_RIFLE_T3_ICLIPSIZE;
			Template.iSoundRange = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_MARKSMAN_RIFLE_T3_ISOUNDRANGE;
			Template.iEnvironmentDamage = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_MARKSMAN_RIFLE_T3_IENVIRONMENTDAMAGE;
			Template.NumUpgradeSlots = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_MARKSMAN_RIFLE_T3_UPGRADESLOTS;
			break;
		case('WOTC_STATS_LMG_T1'): 
			Template.RangeAccuracy = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_LMG_T1_RANGE;
			Template.BaseDamage = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_LMG_T1_BASEDAMAGE;
			Template.Aim = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_LMG_T1_AIM;
			Template.CritChance = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_LMG_T1_CRITCHANCE;
			Template.iClipSize = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_LMG_T1_ICLIPSIZE;
			Template.iSoundRange = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_LMG_T1_ISOUNDRANGE;
			Template.iEnvironmentDamage = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_LMG_T1_IENVIRONMENTDAMAGE;
			Template.NumUpgradeSlots = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_LMG_T1_UPGRADESLOTS;
			break;
		case('WOTC_STATS_LMG_T2'): 
			Template.RangeAccuracy = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_LMG_T2_RANGE;
			Template.BaseDamage = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_LMG_T2_BASEDAMAGE;
			Template.Aim = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_LMG_T2_AIM;
			Template.CritChance = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_LMG_T2_CRITCHANCE;
			Template.iClipSize = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_LMG_T2_ICLIPSIZE;
			Template.iSoundRange = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_LMG_T2_ISOUNDRANGE;
			Template.iEnvironmentDamage = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_LMG_T2_IENVIRONMENTDAMAGE;
			Template.NumUpgradeSlots = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_LMG_T2_UPGRADESLOTS;
			break;
		case('WOTC_STATS_LMG_T3'): 
			Template.RangeAccuracy = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_LMG_T3_RANGE;
			Template.BaseDamage = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_LMG_T3_BASEDAMAGE;
			Template.Aim = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_LMG_T3_AIM;
			Template.CritChance = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_LMG_T3_CRITCHANCE;
			Template.iClipSize = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_LMG_T3_ICLIPSIZE;
			Template.iSoundRange = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_LMG_T3_ISOUNDRANGE;
			Template.iEnvironmentDamage = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_LMG_T3_IENVIRONMENTDAMAGE;
			Template.NumUpgradeSlots = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_LMG_T3_UPGRADESLOTS;
			break;
		case('WOTC_STATS_CANNON_T1'): 
			Template.RangeAccuracy = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_CANNON_T1_RANGE;
			Template.BaseDamage = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_CANNON_T1_BASEDAMAGE;
			Template.Aim = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_CANNON_T1_AIM;
			Template.CritChance = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_CANNON_T1_CRITCHANCE;
			Template.iClipSize = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_CANNON_T1_ICLIPSIZE;
			Template.iSoundRange = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_CANNON_T1_ISOUNDRANGE;
			Template.iEnvironmentDamage = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_CANNON_T1_IENVIRONMENTDAMAGE;
			Template.NumUpgradeSlots = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_CANNON_T1_UPGRADESLOTS;
			break;
		case('WOTC_STATS_CANNON_T2'): 
			Template.RangeAccuracy = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_CANNON_T2_RANGE;
			Template.BaseDamage = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_CANNON_T2_BASEDAMAGE;
			Template.Aim = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_CANNON_T2_AIM;
			Template.CritChance = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_CANNON_T2_CRITCHANCE;
			Template.iClipSize = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_CANNON_T2_ICLIPSIZE;
			Template.iSoundRange = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_CANNON_T2_ISOUNDRANGE;
			Template.iEnvironmentDamage = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_CANNON_T2_IENVIRONMENTDAMAGE;
			Template.NumUpgradeSlots = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_CANNON_T2_UPGRADESLOTS;
			break;
		case('WOTC_STATS_CANNON_T3'): 
			Template.RangeAccuracy = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_CANNON_T3_RANGE;
			Template.BaseDamage = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_CANNON_T3_BASEDAMAGE;
			Template.Aim = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_CANNON_T3_AIM;
			Template.CritChance = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_CANNON_T3_CRITCHANCE;
			Template.iClipSize = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_CANNON_T3_ICLIPSIZE;
			Template.iSoundRange = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_CANNON_T3_ISOUNDRANGE;
			Template.iEnvironmentDamage = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_CANNON_T3_IENVIRONMENTDAMAGE;
			Template.NumUpgradeSlots = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_CANNON_T3_UPGRADESLOTS;
			break;
		case('WOTC_STATS_PISTOL_T1'): 
			Template.RangeAccuracy = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_PISTOL_T1_RANGE;
			Template.BaseDamage = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_PISTOL_T1_BASEDAMAGE;
			Template.Aim = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_PISTOL_T1_AIM;
			Template.CritChance = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_PISTOL_T1_CRITCHANCE;
			Template.iClipSize = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_PISTOL_T1_ICLIPSIZE;
			Template.iSoundRange = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_PISTOL_T1_ISOUNDRANGE;
			Template.iEnvironmentDamage = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_PISTOL_T1_IENVIRONMENTDAMAGE;
			Template.NumUpgradeSlots = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_PISTOL_T1_UPGRADESLOTS;
			break;
		case('WOTC_STATS_PISTOL_T2'): 
			Template.RangeAccuracy = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_PISTOL_T2_RANGE;
			Template.BaseDamage = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_PISTOL_T2_BASEDAMAGE;
			Template.Aim = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_PISTOL_T2_AIM;
			Template.CritChance = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_PISTOL_T2_CRITCHANCE;
			Template.iClipSize = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_PISTOL_T2_ICLIPSIZE;
			Template.iSoundRange = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_PISTOL_T2_ISOUNDRANGE;
			Template.iEnvironmentDamage = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_PISTOL_T2_IENVIRONMENTDAMAGE;
			Template.NumUpgradeSlots = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_PISTOL_T2_UPGRADESLOTS;
			break;
		case('WOTC_STATS_PISTOL_T3'): 
			Template.RangeAccuracy = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_PISTOL_T3_RANGE;
			Template.BaseDamage = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_PISTOL_T3_BASEDAMAGE;
			Template.Aim = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_PISTOL_T3_AIM;
			Template.CritChance = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_PISTOL_T3_CRITCHANCE;
			Template.iClipSize = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_PISTOL_T3_ICLIPSIZE;
			Template.iSoundRange = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_PISTOL_T3_ISOUNDRANGE;
			Template.iEnvironmentDamage = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_PISTOL_T3_IENVIRONMENTDAMAGE;
			Template.NumUpgradeSlots = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_PISTOL_T3_UPGRADESLOTS;
			break;
		case('WOTC_STATS_MACHINE_PISTOL_T1'): 
			Template.RangeAccuracy = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_MACHINE_PISTOL_T1_RANGE;
			Template.BaseDamage = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_MACHINE_PISTOL_T1_BASEDAMAGE;
			Template.Aim = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_MACHINE_PISTOL_T1_AIM;
			Template.CritChance = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_MACHINE_PISTOL_T1_CRITCHANCE;
			Template.iClipSize = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_MACHINE_PISTOL_T1_ICLIPSIZE;
			Template.iSoundRange = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_MACHINE_PISTOL_T1_ISOUNDRANGE;
			Template.iEnvironmentDamage = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_MACHINE_PISTOL_T1_IENVIRONMENTDAMAGE;
			Template.NumUpgradeSlots = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_MACHINE_PISTOL_T1_UPGRADESLOTS;
			break;
		case('WOTC_STATS_MACHINE_PISTOL_T2'): 
			Template.RangeAccuracy = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_MACHINE_PISTOL_T2_RANGE;
			Template.BaseDamage = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_MACHINE_PISTOL_T2_BASEDAMAGE;
			Template.Aim = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_MACHINE_PISTOL_T2_AIM;
			Template.CritChance = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_MACHINE_PISTOL_T2_CRITCHANCE;
			Template.iClipSize = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_MACHINE_PISTOL_T2_ICLIPSIZE;
			Template.iSoundRange = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_MACHINE_PISTOL_T2_ISOUNDRANGE;
			Template.iEnvironmentDamage = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_MACHINE_PISTOL_T2_IENVIRONMENTDAMAGE;
			Template.NumUpgradeSlots = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_MACHINE_PISTOL_T2_UPGRADESLOTS;
			break;
		case('WOTC_STATS_MACHINE_PISTOL_T3'):
			Template.RangeAccuracy = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_MACHINE_PISTOL_T3_RANGE;
			Template.BaseDamage = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_MACHINE_PISTOL_T3_BASEDAMAGE;
			Template.Aim = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_MACHINE_PISTOL_T3_AIM;
			Template.CritChance = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_MACHINE_PISTOL_T3_CRITCHANCE;
			Template.iClipSize = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_MACHINE_PISTOL_T3_ICLIPSIZE;
			Template.iSoundRange = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_MACHINE_PISTOL_T3_ISOUNDRANGE;
			Template.iEnvironmentDamage = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_MACHINE_PISTOL_T3_IENVIRONMENTDAMAGE;
			Template.NumUpgradeSlots = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_MACHINE_PISTOL_T3_UPGRADESLOTS;
			break;
//
//	War of the Chosen faction weapons
//
//	Reaper Vektor rifle, split into two separate files
		case('WOTC_STATS_RPR_VEKTOR_SNIPER_RIFLE_T1'): 
			Template.RangeAccuracy = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_RPR_VEKTOR_SNIPER_RIFLE_T1_RANGE;
			Template.BaseDamage = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_RPR_VEKTOR_SNIPER_RIFLE_T1_BASEDAMAGE;
			Template.Aim = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_RPR_VEKTOR_SNIPER_RIFLE_T1_AIM;
			Template.CritChance = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_RPR_VEKTOR_SNIPER_RIFLE_T1_CRITCHANCE;
			Template.iClipSize = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_RPR_VEKTOR_SNIPER_RIFLE_T1_ICLIPSIZE;
			Template.iSoundRange = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_RPR_VEKTOR_SNIPER_RIFLE_T1_ISOUNDRANGE;
			Template.iEnvironmentDamage = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_RPR_VEKTOR_SNIPER_RIFLE_T1_IENVIRONMENTDAMAGE;
			Template.NumUpgradeSlots = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_RPR_VEKTOR_SNIPER_RIFLE_T1_UPGRADESLOTS;
			break;
		case('WOTC_STATS_RPR_VEKTOR_SNIPER_RIFLE_T2'): 
			Template.RangeAccuracy = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_RPR_VEKTOR_SNIPER_RIFLE_T2_RANGE;
			Template.BaseDamage = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_RPR_VEKTOR_SNIPER_RIFLE_T2_BASEDAMAGE;
			Template.Aim = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_RPR_VEKTOR_SNIPER_RIFLE_T2_AIM;
			Template.CritChance = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_RPR_VEKTOR_SNIPER_RIFLE_T2_CRITCHANCE;
			Template.iClipSize = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_RPR_VEKTOR_SNIPER_RIFLE_T2_ICLIPSIZE;
			Template.iSoundRange = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_RPR_VEKTOR_SNIPER_RIFLE_T2_ISOUNDRANGE;
			Template.iEnvironmentDamage = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_RPR_VEKTOR_SNIPER_RIFLE_T2_IENVIRONMENTDAMAGE;
			Template.NumUpgradeSlots = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_RPR_VEKTOR_SNIPER_RIFLE_T2_UPGRADESLOTS;
			break;
		case('WOTC_STATS_RPR_VEKTOR_SNIPER_RIFLE_T3'):
			Template.RangeAccuracy = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_RPR_VEKTOR_SNIPER_RIFLE_T3_RANGE;
			Template.BaseDamage = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_RPR_VEKTOR_SNIPER_RIFLE_T3_BASEDAMAGE;
			Template.Aim = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_RPR_VEKTOR_SNIPER_RIFLE_T3_AIM;
			Template.CritChance = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_RPR_VEKTOR_SNIPER_RIFLE_T3_CRITCHANCE;
			Template.iClipSize = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_RPR_VEKTOR_SNIPER_RIFLE_T3_ICLIPSIZE;
			Template.iSoundRange = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_RPR_VEKTOR_SNIPER_RIFLE_T3_ISOUNDRANGE;
			Template.iEnvironmentDamage = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_RPR_VEKTOR_SNIPER_RIFLE_T3_IENVIRONMENTDAMAGE;
			Template.NumUpgradeSlots = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_RPR_VEKTOR_SNIPER_RIFLE_T3_UPGRADESLOTS;
			break;

		case('WOTC_STATS_RPR_VEKTOR_BATTLE_RIFLE_T1'): 
			Template.RangeAccuracy = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_RPR_VEKTOR_BATTLE_RIFLE_T1_RANGE;
			Template.BaseDamage = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_RPR_VEKTOR_BATTLE_RIFLE_T1_BASEDAMAGE;
			Template.Aim = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_RPR_VEKTOR_BATTLE_RIFLE_T1_AIM;
			Template.CritChance = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_RPR_VEKTOR_BATTLE_RIFLE_T1_CRITCHANCE;
			Template.iClipSize = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_RPR_VEKTOR_BATTLE_RIFLE_T1_ICLIPSIZE;
			Template.iSoundRange = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_RPR_VEKTOR_BATTLE_RIFLE_T1_ISOUNDRANGE;
			Template.iEnvironmentDamage = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_RPR_VEKTOR_BATTLE_RIFLE_T1_IENVIRONMENTDAMAGE;
			Template.NumUpgradeSlots = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_RPR_VEKTOR_BATTLE_RIFLE_T1_UPGRADESLOTS;
			break;
		case('WOTC_STATS_RPR_VEKTOR_BATTLE_RIFLE_T2'): 
			Template.RangeAccuracy = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_RPR_VEKTOR_BATTLE_RIFLE_T2_RANGE;
			Template.BaseDamage = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_RPR_VEKTOR_BATTLE_RIFLE_T2_BASEDAMAGE;
			Template.Aim = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_RPR_VEKTOR_BATTLE_RIFLE_T2_AIM;
			Template.CritChance = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_RPR_VEKTOR_BATTLE_RIFLE_T2_CRITCHANCE;
			Template.iClipSize = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_RPR_VEKTOR_BATTLE_RIFLE_T2_ICLIPSIZE;
			Template.iSoundRange = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_RPR_VEKTOR_BATTLE_RIFLE_T2_ISOUNDRANGE;
			Template.iEnvironmentDamage = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_RPR_VEKTOR_BATTLE_RIFLE_T2_IENVIRONMENTDAMAGE;
			Template.NumUpgradeSlots = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_RPR_VEKTOR_BATTLE_RIFLE_T2_UPGRADESLOTS;
			break;
		case('WOTC_STATS_RPR_VEKTOR_BATTLE_RIFLE_T3'):
			Template.RangeAccuracy = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_RPR_VEKTOR_BATTLE_RIFLE_T3_RANGE;
			Template.BaseDamage = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_RPR_VEKTOR_BATTLE_RIFLE_T3_BASEDAMAGE;
			Template.Aim = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_RPR_VEKTOR_BATTLE_RIFLE_T3_AIM;
			Template.CritChance = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_RPR_VEKTOR_BATTLE_RIFLE_T3_CRITCHANCE;
			Template.iClipSize = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_RPR_VEKTOR_BATTLE_RIFLE_T3_ICLIPSIZE;
			Template.iSoundRange = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_RPR_VEKTOR_BATTLE_RIFLE_T3_ISOUNDRANGE;
			Template.iEnvironmentDamage = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_RPR_VEKTOR_BATTLE_RIFLE_T3_IENVIRONMENTDAMAGE;
			Template.NumUpgradeSlots = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_RPR_VEKTOR_BATTLE_RIFLE_T3_UPGRADESLOTS;
			break;

//	Skirmisher Bullpup rifle, split into three separate files
		case('WOTC_STATS_SKR_BULLPUP_ASSAULT_RIFLE_T1'): 
			Template.RangeAccuracy = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SKR_BULLPUP_ASSAULT_RIFLE_T1_RANGE;
			Template.BaseDamage = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SKR_BULLPUP_ASSAULT_RIFLE_T1_BASEDAMAGE;
			Template.Aim = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SKR_BULLPUP_ASSAULT_RIFLE_T1_AIM;
			Template.CritChance = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SKR_BULLPUP_ASSAULT_RIFLE_T1_CRITCHANCE;
			Template.iClipSize = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SKR_BULLPUP_ASSAULT_RIFLE_T1_ICLIPSIZE;
			Template.iSoundRange = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SKR_BULLPUP_ASSAULT_RIFLE_T1_ISOUNDRANGE;
			Template.iEnvironmentDamage = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SKR_BULLPUP_ASSAULT_RIFLE_T1_IENVIRONMENTDAMAGE;
			Template.NumUpgradeSlots = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SKR_BULLPUP_ASSAULT_RIFLE_T1_UPGRADESLOTS;
			break;
		case('WOTC_STATS_SKR_BULLPUP_ASSAULT_RIFLE_T2'): 
			Template.RangeAccuracy = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SKR_BULLPUP_ASSAULT_RIFLE_T2_RANGE;
			Template.BaseDamage = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SKR_BULLPUP_ASSAULT_RIFLE_T2_BASEDAMAGE;
			Template.Aim = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SKR_BULLPUP_ASSAULT_RIFLE_T2_AIM;
			Template.CritChance = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SKR_BULLPUP_ASSAULT_RIFLE_T2_CRITCHANCE;
			Template.iClipSize = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SKR_BULLPUP_ASSAULT_RIFLE_T2_ICLIPSIZE;
			Template.iSoundRange = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SKR_BULLPUP_ASSAULT_RIFLE_T2_ISOUNDRANGE;
			Template.iEnvironmentDamage = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SKR_BULLPUP_ASSAULT_RIFLE_T2_IENVIRONMENTDAMAGE;
			Template.NumUpgradeSlots = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SKR_BULLPUP_ASSAULT_RIFLE_T2_UPGRADESLOTS;
			break;
		case('WOTC_STATS_SKR_BULLPUP_ASSAULT_RIFLE_T3'):
			Template.RangeAccuracy = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SKR_BULLPUP_ASSAULT_RIFLE_T3_RANGE;
			Template.BaseDamage = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SKR_BULLPUP_ASSAULT_RIFLE_T3_BASEDAMAGE;
			Template.Aim = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SKR_BULLPUP_ASSAULT_RIFLE_T3_AIM;
			Template.CritChance = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SKR_BULLPUP_ASSAULT_RIFLE_T3_CRITCHANCE;
			Template.iClipSize = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SKR_BULLPUP_ASSAULT_RIFLE_T3_ICLIPSIZE;
			Template.iSoundRange = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SKR_BULLPUP_ASSAULT_RIFLE_T3_ISOUNDRANGE;
			Template.iEnvironmentDamage = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SKR_BULLPUP_ASSAULT_RIFLE_T3_IENVIRONMENTDAMAGE;
			Template.NumUpgradeSlots = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SKR_BULLPUP_ASSAULT_RIFLE_T3_UPGRADESLOTS;
			break;
		case('WOTC_STATS_SKR_BULLPUP_ASSAULT_CARBINE_T1'): 
			Template.RangeAccuracy = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SKR_BULLPUP_ASSAULT_CARBINE_T1_RANGE;
			Template.BaseDamage = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SKR_BULLPUP_ASSAULT_CARBINE_T1_BASEDAMAGE;
			Template.Aim = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SKR_BULLPUP_ASSAULT_CARBINE_T1_AIM;
			Template.CritChance = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SKR_BULLPUP_ASSAULT_CARBINE_T1_CRITCHANCE;
			Template.iClipSize = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SKR_BULLPUP_ASSAULT_CARBINE_T1_ICLIPSIZE;
			Template.iSoundRange = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SKR_BULLPUP_ASSAULT_CARBINE_T1_ISOUNDRANGE;
			Template.iEnvironmentDamage = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SKR_BULLPUP_ASSAULT_CARBINE_T1_IENVIRONMENTDAMAGE;
			Template.NumUpgradeSlots = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SKR_BULLPUP_ASSAULT_CARBINE_T1_UPGRADESLOTS;
			break;
		case('WOTC_STATS_SKR_BULLPUP_ASSAULT_CARBINE_T2'): 
			Template.RangeAccuracy = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SKR_BULLPUP_ASSAULT_CARBINE_T2_RANGE;
			Template.BaseDamage = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SKR_BULLPUP_ASSAULT_CARBINE_T2_BASEDAMAGE;
			Template.Aim = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SKR_BULLPUP_ASSAULT_CARBINE_T2_AIM;
			Template.CritChance = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SKR_BULLPUP_ASSAULT_CARBINE_T2_CRITCHANCE;
			Template.iClipSize = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SKR_BULLPUP_ASSAULT_CARBINE_T2_ICLIPSIZE;
			Template.iSoundRange = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SKR_BULLPUP_ASSAULT_CARBINE_T2_ISOUNDRANGE;
			Template.iEnvironmentDamage = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SKR_BULLPUP_ASSAULT_CARBINE_T2_IENVIRONMENTDAMAGE;
			Template.NumUpgradeSlots = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SKR_BULLPUP_ASSAULT_CARBINE_T2_UPGRADESLOTS;
			break;
		case('WOTC_STATS_SKR_BULLPUP_ASSAULT_CARBINE_T3'):
			Template.RangeAccuracy = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SKR_BULLPUP_ASSAULT_CARBINE_T3_RANGE;
			Template.BaseDamage = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SKR_BULLPUP_ASSAULT_CARBINE_T3_BASEDAMAGE;
			Template.Aim = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SKR_BULLPUP_ASSAULT_CARBINE_T3_AIM;
			Template.CritChance = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SKR_BULLPUP_ASSAULT_CARBINE_T3_CRITCHANCE;
			Template.iClipSize = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SKR_BULLPUP_ASSAULT_CARBINE_T3_ICLIPSIZE;
			Template.iSoundRange = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SKR_BULLPUP_ASSAULT_CARBINE_T3_ISOUNDRANGE;
			Template.iEnvironmentDamage = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SKR_BULLPUP_ASSAULT_CARBINE_T3_IENVIRONMENTDAMAGE;
			Template.NumUpgradeSlots = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SKR_BULLPUP_ASSAULT_CARBINE_T3_UPGRADESLOTS;
			break;
		case('WOTC_STATS_SKR_BULLPUP_BATTLE_RIFLE_T1'): 
			Template.RangeAccuracy = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SKR_BULLPUP_BATTLE_RIFLE_T1_RANGE;
			Template.BaseDamage = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SKR_BULLPUP_BATTLE_RIFLE_T1_BASEDAMAGE;
			Template.Aim = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SKR_BULLPUP_BATTLE_RIFLE_T1_AIM;
			Template.CritChance = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SKR_BULLPUP_BATTLE_RIFLE_T1_CRITCHANCE;
			Template.iClipSize = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SKR_BULLPUP_BATTLE_RIFLE_T1_ICLIPSIZE;
			Template.iSoundRange = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SKR_BULLPUP_BATTLE_RIFLE_T1_ISOUNDRANGE;
			Template.iEnvironmentDamage = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SKR_BULLPUP_BATTLE_RIFLE_T1_IENVIRONMENTDAMAGE;
			Template.NumUpgradeSlots = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SKR_BULLPUP_BATTLE_RIFLE_T1_UPGRADESLOTS;
			break;
		case('WOTC_STATS_SKR_BULLPUP_BATTLE_RIFLE_T2'): 
			Template.RangeAccuracy = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SKR_BULLPUP_BATTLE_RIFLE_T2_RANGE;
			Template.BaseDamage = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SKR_BULLPUP_BATTLE_RIFLE_T2_BASEDAMAGE;
			Template.Aim = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SKR_BULLPUP_BATTLE_RIFLE_T2_AIM;
			Template.CritChance = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SKR_BULLPUP_BATTLE_RIFLE_T2_CRITCHANCE;
			Template.iClipSize = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SKR_BULLPUP_BATTLE_RIFLE_T2_ICLIPSIZE;
			Template.iSoundRange = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SKR_BULLPUP_BATTLE_RIFLE_T2_ISOUNDRANGE;
			Template.iEnvironmentDamage = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SKR_BULLPUP_BATTLE_RIFLE_T2_IENVIRONMENTDAMAGE;
			Template.NumUpgradeSlots = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SKR_BULLPUP_BATTLE_RIFLE_T2_UPGRADESLOTS;
			break;
		case('WOTC_STATS_SKR_BULLPUP_BATTLE_RIFLE_T3'):
			Template.RangeAccuracy = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SKR_BULLPUP_BATTLE_RIFLE_T3_RANGE;
			Template.BaseDamage = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SKR_BULLPUP_BATTLE_RIFLE_T3_BASEDAMAGE;
			Template.Aim = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SKR_BULLPUP_BATTLE_RIFLE_T3_AIM;
			Template.CritChance = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SKR_BULLPUP_BATTLE_RIFLE_T3_CRITCHANCE;
			Template.iClipSize = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SKR_BULLPUP_BATTLE_RIFLE_T3_ICLIPSIZE;
			Template.iSoundRange = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SKR_BULLPUP_BATTLE_RIFLE_T3_ISOUNDRANGE;
			Template.iEnvironmentDamage = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SKR_BULLPUP_BATTLE_RIFLE_T3_IENVIRONMENTDAMAGE;
			Template.NumUpgradeSlots = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SKR_BULLPUP_BATTLE_RIFLE_T3_UPGRADESLOTS;
			break;
		case('WOTC_STATS_SKR_BULLPUP_SMG_T1'): 
			Template.RangeAccuracy = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SKR_BULLPUP_SMG_T1_RANGE;
			Template.BaseDamage = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SKR_BULLPUP_SMG_T1_BASEDAMAGE;
			Template.Aim = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SKR_BULLPUP_SMG_T1_AIM;
			Template.CritChance = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SKR_BULLPUP_SMG_T1_CRITCHANCE;
			Template.iClipSize = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SKR_BULLPUP_SMG_T1_ICLIPSIZE;
			Template.iSoundRange = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SKR_BULLPUP_SMG_T1_ISOUNDRANGE;
			Template.iEnvironmentDamage = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SKR_BULLPUP_SMG_T1_IENVIRONMENTDAMAGE;
			Template.NumUpgradeSlots = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SKR_BULLPUP_SMG_T1_UPGRADESLOTS;
			break;
		case('WOTC_STATS_SKR_BULLPUP_SMG_T2'): 
			Template.RangeAccuracy = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SKR_BULLPUP_SMG_T2_RANGE;
			Template.BaseDamage = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SKR_BULLPUP_SMG_T2_BASEDAMAGE;
			Template.Aim = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SKR_BULLPUP_SMG_T2_AIM;
			Template.CritChance = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SKR_BULLPUP_SMG_T2_CRITCHANCE;
			Template.iClipSize = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SKR_BULLPUP_SMG_T2_ICLIPSIZE;
			Template.iSoundRange = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SKR_BULLPUP_SMG_T2_ISOUNDRANGE;
			Template.iEnvironmentDamage = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SKR_BULLPUP_SMG_T2_IENVIRONMENTDAMAGE;
			Template.NumUpgradeSlots = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SKR_BULLPUP_SMG_T2_UPGRADESLOTS;
			break;
		case('WOTC_STATS_SKR_BULLPUP_SMG_T3'):
			Template.RangeAccuracy = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SKR_BULLPUP_SMG_T3_RANGE;
			Template.BaseDamage = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SKR_BULLPUP_SMG_T3_BASEDAMAGE;
			Template.Aim = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SKR_BULLPUP_SMG_T3_AIM;
			Template.CritChance = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SKR_BULLPUP_SMG_T3_CRITCHANCE;
			Template.iClipSize = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SKR_BULLPUP_SMG_T3_ICLIPSIZE;
			Template.iSoundRange = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SKR_BULLPUP_SMG_T3_ISOUNDRANGE;
			Template.iEnvironmentDamage = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SKR_BULLPUP_SMG_T3_IENVIRONMENTDAMAGE;
			Template.NumUpgradeSlots = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_SKR_BULLPUP_SMG_T3_UPGRADESLOTS;
			break;
//	Templar Sidearm pistol, split into two separate values
		case('WOTC_STATS_TMP_SIDEARM_PISTOL_T1'): 
			Template.RangeAccuracy = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_TMP_SIDEARM_PISTOL_T1_RANGE;
			Template.BaseDamage = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_TMP_SIDEARM_PISTOL_T1_BASEDAMAGE;
			Template.Aim = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_TMP_SIDEARM_PISTOL_T1_AIM;
			Template.CritChance = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_TMP_SIDEARM_PISTOL_T1_CRITCHANCE;
			Template.iClipSize = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_TMP_SIDEARM_PISTOL_T1_ICLIPSIZE;
			Template.iSoundRange = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_TMP_SIDEARM_PISTOL_T1_ISOUNDRANGE;
			Template.iEnvironmentDamage = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_TMP_SIDEARM_PISTOL_T1_IENVIRONMENTDAMAGE;
			Template.NumUpgradeSlots = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_TMP_SIDEARM_PISTOL_T1_UPGRADESLOTS;
			break;
		case('WOTC_STATS_TMP_SIDEARM_PISTOL_T2'): 
			Template.RangeAccuracy = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_TMP_SIDEARM_PISTOL_T2_RANGE;
			Template.BaseDamage = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_TMP_SIDEARM_PISTOL_T2_BASEDAMAGE;
			Template.Aim = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_TMP_SIDEARM_PISTOL_T2_AIM;
			Template.CritChance = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_TMP_SIDEARM_PISTOL_T2_CRITCHANCE;
			Template.iClipSize = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_TMP_SIDEARM_PISTOL_T2_ICLIPSIZE;
			Template.iSoundRange = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_TMP_SIDEARM_PISTOL_T2_ISOUNDRANGE;
			Template.iEnvironmentDamage = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_TMP_SIDEARM_PISTOL_T2_IENVIRONMENTDAMAGE;
			Template.NumUpgradeSlots = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_TMP_SIDEARM_PISTOL_T2_UPGRADESLOTS;
			break;
		case('WOTC_STATS_TMP_SIDEARM_PISTOL_T3'):
			Template.RangeAccuracy = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_TMP_SIDEARM_PISTOL_T3_RANGE;
			Template.BaseDamage = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_TMP_SIDEARM_PISTOL_T3_BASEDAMAGE;
			Template.Aim = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_TMP_SIDEARM_PISTOL_T3_AIM;
			Template.CritChance = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_TMP_SIDEARM_PISTOL_T3_CRITCHANCE;
			Template.iClipSize = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_TMP_SIDEARM_PISTOL_T3_ICLIPSIZE;
			Template.iSoundRange = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_TMP_SIDEARM_PISTOL_T3_ISOUNDRANGE;
			Template.iEnvironmentDamage = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_TMP_SIDEARM_PISTOL_T3_IENVIRONMENTDAMAGE;
			Template.NumUpgradeSlots = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_TMP_SIDEARM_PISTOL_T3_UPGRADESLOTS;
			break;
		case('WOTC_STATS_TMP_SIDEARM_MACHINE_PISTOL_T1'): 
			Template.RangeAccuracy = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_TMP_SIDEARM_MACHINE_PISTOL_T1_RANGE;
			Template.BaseDamage = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_TMP_SIDEARM_MACHINE_PISTOL_T1_BASEDAMAGE;
			Template.Aim = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_TMP_SIDEARM_MACHINE_PISTOL_T1_AIM;
			Template.CritChance = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_TMP_SIDEARM_MACHINE_PISTOL_T1_CRITCHANCE;
			Template.iClipSize = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_TMP_SIDEARM_MACHINE_PISTOL_T1_ICLIPSIZE;
			Template.iSoundRange = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_TMP_SIDEARM_MACHINE_PISTOL_T1_ISOUNDRANGE;
			Template.iEnvironmentDamage = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_TMP_SIDEARM_MACHINE_PISTOL_T1_IENVIRONMENTDAMAGE;
			Template.NumUpgradeSlots = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_TMP_SIDEARM_MACHINE_PISTOL_T1_UPGRADESLOTS;
			break;
		case('WOTC_STATS_TMP_SIDEARM_MACHINE_PISTOL_T2'): 
			Template.RangeAccuracy = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_TMP_SIDEARM_MACHINE_PISTOL_T2_RANGE;
			Template.BaseDamage = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_TMP_SIDEARM_MACHINE_PISTOL_T2_BASEDAMAGE;
			Template.Aim = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_TMP_SIDEARM_MACHINE_PISTOL_T2_AIM;
			Template.CritChance = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_TMP_SIDEARM_MACHINE_PISTOL_T2_CRITCHANCE;
			Template.iClipSize = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_TMP_SIDEARM_MACHINE_PISTOL_T2_ICLIPSIZE;
			Template.iSoundRange = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_TMP_SIDEARM_MACHINE_PISTOL_T2_ISOUNDRANGE;
			Template.iEnvironmentDamage = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_TMP_SIDEARM_MACHINE_PISTOL_T2_IENVIRONMENTDAMAGE;
			Template.NumUpgradeSlots = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_TMP_SIDEARM_MACHINE_PISTOL_T2_UPGRADESLOTS;
			break;
		case('WOTC_STATS_TMP_SIDEARM_MACHINE_PISTOL_T3'):
			Template.RangeAccuracy = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_TMP_SIDEARM_MACHINE_PISTOL_T3_RANGE;
			Template.BaseDamage = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_TMP_SIDEARM_MACHINE_PISTOL_T3_BASEDAMAGE;
			Template.Aim = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_TMP_SIDEARM_MACHINE_PISTOL_T3_AIM;
			Template.CritChance = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_TMP_SIDEARM_MACHINE_PISTOL_T3_CRITCHANCE;
			Template.iClipSize = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_TMP_SIDEARM_MACHINE_PISTOL_T3_ICLIPSIZE;
			Template.iSoundRange = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_TMP_SIDEARM_MACHINE_PISTOL_T3_ISOUNDRANGE;
			Template.iEnvironmentDamage = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_TMP_SIDEARM_MACHINE_PISTOL_T3_IENVIRONMENTDAMAGE;
			Template.NumUpgradeSlots = class'X2Item_Global_WeaponStats'.default.WOTC_STATS_TMP_SIDEARM_MACHINE_PISTOL_T3_UPGRADESLOTS;
			break;
		case('CUSTOM'):
			// Custom Mode Weapon stats
			Template.BaseDamage = WepBasedmg[0];
			Template.Aim = iAim;
			Template.CritChance = iCritChance;
			Template.iClipSize = iClipSize;
			Template.iSoundRange = iSoundRange;
			Template.iEnvironmentDamage = iEnvironmentDamage;
			Template.NumUpgradeSlots = iNumUpgradeSlots;			
			// Custom mode Range table select.
			switch (RangeTableSelect) 
			{	
				case('Short_CV'):
					Template.RangeAccuracy = class'X2Item_DefaultWeapons'.default.SHORT_CONVENTIONAL_RANGE;
					break;
				case('Medium_CV'):
					Template.RangeAccuracy = class'X2Item_DefaultWeapons'.default.MEDIUM_CONVENTIONAL_RANGE;
					break;
				case('Long_CV'):
					Template.RangeAccuracy = class'X2Item_DefaultWeapons'.default.LONG_CONVENTIONAL_RANGE;
					break;
				case('Short_MG'):
					Template.RangeAccuracy = class'X2Item_DefaultWeapons'.default.MEDIUM_CONVENTIONAL_RANGE;
					break;
				case('Medium_MG'):
					Template.RangeAccuracy = class'X2Item_DefaultWeapons'.default.MEDIUM_MAGNETIC_RANGE;
					break;
				case('Long_MG'):
					Template.RangeAccuracy = class'X2Item_DefaultWeapons'.default.LONG_MAGNETIC_RANGE;
					break;
				case('Short_BM'):
					Template.RangeAccuracy = class'X2Item_DefaultWeapons'.default.LONG_CONVENTIONAL_RANGE;
					break;
				case('Medium_BM'):
					Template.RangeAccuracy = class'X2Item_DefaultWeapons'.default.MEDIUM_BEAM_RANGE;
					break;
				case('Long_BM'):
					Template.RangeAccuracy = class'X2Item_DefaultWeapons'.default.LONG_BEAM_RANGE;
					break;
				case('MidShort_CV'):
					Template.RangeAccuracy = class'X2Item_CVWPRangeTable'.default.MIDSHORT_CONVENTIONAL_RANGE;
					break;
				case('MidShort_MG'):
					Template.RangeAccuracy = class'X2Item_CVWPRangeTable'.default.MIDSHORT_MAGNETIC_RANGE;
					break;
				case('MidShort_BM'):
					Template.RangeAccuracy = class'X2Item_CVWPRangeTable'.default.MIDSHORT_BEAM_RANGE;
					break;
				case('Flat_CV'):
					Template.RangeAccuracy = class'X2Item_DefaultWeapons'.default.FLAT_CONVENTIONAL_RANGE;
					break;
				case('Flat_MG'):
					Template.RangeAccuracy = class'X2Item_DefaultWeapons'.default.FLAT_MAGNETIC_RANGE;
					break;
				case('Flat_BM'):
					Template.RangeAccuracy = class'X2Item_DefaultWeapons'.default.FLAT_BEAM_RANGE;
					break;
				default:
					`Log(nTemplateName$ ": Range Table" @RangeTableSelect@ "is not a valid range!");
					break;
			}
			break;
		default: 
//			Template.BaseDamage = (Damage=0, Spread=0, PlusOne=0, Crit=0, Pierce=0, Tag="None", DamageType="None");
			Template.Aim = 0;
			Template.CritChance = 0;
			Template.iClipSize = 0;
			Template.iSoundRange = 0;
			Template.iEnvironmentDamage = 0;
			Template.NumUpgradeSlots = 0;

			`Log("Stat Select Mode, ERROR Invalid entry for" @nTemplateName);
		break;
	}

	//3.21.17: Infinite Ammo, 
	Template.InfiniteAmmo = bInfiniteAmmo;
	Template.bHideClipSizeStat = bHideClipSizeStat;
	if (bOverwatchActionPoint == true) 
	{
		Template.OverwatchActionPoint = class'X2CharacterTemplateManager'.default.PistolOverwatchReserveActionPoint;
	}
	else if (bOverwatchActionPoint == false)
	{
	
	}



	//11.9.17: Logging
	if (class'X2DownloadableContentInfo_RFData_WotC'.default.ENABLE_DEBUG_LOGGING == true)
	{
			`Log(nTemplateName$ ": Using Stat:" @StatSelectMode);
			`Log(nTemplateName$ ": Using Modifier:" @StatSelectMobilityDetectionRadius);
		`LOG("-------------------------------------------------------------------------------");
			`Log(nTemplateName$ ": Damage:" @Template.BaseDamage.Damage);
			`Log(nTemplateName$ ": Spread:" @Template.BaseDamage.Spread);
			`Log(nTemplateName$ ": PlusOne:" @Template.BaseDamage.PlusOne);
			`Log(nTemplateName$ ": Crit:" @Template.BaseDamage.Crit);
			`Log(nTemplateName$ ": Pierce:" @Template.BaseDamage.Pierce);
			`Log(nTemplateName$ ": Rupture:" @Template.BaseDamage.Rupture);
			`Log(nTemplateName$ ": Shred:" @Template.BaseDamage.Shred);
			`Log(nTemplateName$ ": Tag:" @Template.BaseDamage.Tag);
			`Log(nTemplateName$ ": DamageType:" @Template.BaseDamage.DamageType);
		`LOG("-------------------------------------------------------------------------------");			
			`Log(nTemplateName$ ": Aim:" @Template.Aim );
			`Log(nTemplateName$ ": Crit Chance:" @Template.CritChance );

		if (bInfiniteAmmo == true)
		{
			`Log(nTemplateName$ ": Clip Size: INFINITE" );			
		} 
		else
		{
			`Log(nTemplateName$ ": Clip Size:" @Template.iClipSize );
		}

			`Log(nTemplateName$ ": Sound Range:" @Template.iSoundRange );
			`Log(nTemplateName$ ": Environment Dmg:" @Template.iEnvironmentDamage );
			`Log(nTemplateName$ ": Num of Upg Slots:" @Template.NumUpgradeSlots);
		`LOG("-------------------------------------------------------------------------------");
		for (i = 0; i < Template.RangeAccuracy.Length; i++) 
		{
			`Log(nTemplateName$ ": Accuracy for Distance: [" $ i $ "]:" @ Template.RangeAccuracy[i]);
		}
	}

	return Template;
}



defaultproperties
{
	bShouldCreateDifficultyVariants = true
}