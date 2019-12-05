//---------------------------------------------------------------------------------------
// 
//  FILE:   X2Item_Weapon_Assault_AK74m.uc
//  AUTHOR:  Krakah, E3245
//           
//---------------------------------------------------------------------------------------
class X2Item_Weapon_Assault_AK74m extends X2Item dependson(X2CVWPDataStructures) config(_TC_WOTC_S79_AK74M);


	// Tier 1 weapon template Values.
	var config name CVWPdata_T1_TemplateName;
	var config int CVWPdata_T1_iNumUpgradeSlots;
	var config int CVWPdata_T1_iNumOfAbilities;
	var config array<name> CVWPdata_T1_Abilities;
	var config int CVWPdata_T1_iNumOfAttachments_Default;
	var config array<CVWP_DefaultWepAttachment> CVWPdata_T1_DefaultAttach;
	var config array<WeaponDamageValue> CVWPdata_T1_WepBasedmg;
	var config int CVWPdata_T1_iNumOfResources;
	var config array<CVWP_ResourceTypeCost> CVWPdata_T1_Resources;
	var config bool CVWPdata_T1_CanBeBuilt;
	var config bool CVWPdata_T1_StartingItem;
	var config bool CVWPdata_T1_bIsLargeWeapon; 
	var config bool CVWPdata_T1_bInfiniteItem;	
	var config int CVWPdata_T1_PointsToCompleteStaff;
	var config int CVWPdata_T1_PointsToCompleteDays;
	var config int CVWPdata_T1_TradingPostValue;
	var config int CVWPdata_T1_iNumOfRequiredTechs;
	var config array<name> CVWPdata_T1_RequiredTechs;			
	var config string CVWPdata_T1_WeaponPanelImage;
	var config string CVWPdata_T1_EquipSound;
	var config name CVWPdata_T1_ItemCat;
	var config name CVWPdata_T1_WeaponCat;
	var config name CVWPdata_T1_WeaponTech;
	var config string CVWPdata_T1_strImage;
	var config int CVWPdata_T1_Tier;
	var config int CVWPdata_T1_Aim;
	var config int CVWPdata_T1_CritChance;
	var config int CVWPdata_T1_iClipSize;
	var config int CVWPdata_T1_iSoundRange;
	var config int CVWPdata_T1_iEnvironmentDamage;
	var config int CVWPdata_T1_iTypicalActionCost;
	var config string CVWPdata_T1_GameArchetype;
	var config name CVWPdata_T1_UIArmoryCameraPointTag;
	var config int CVWPdata_T1_iPhysicsImpulse;
	var config float CVWPdata_T1_fKnockbackDamageAmount;
	var config float CVWPdata_T1_fKnockbackDamageRadius;
	var config name CVWPdata_T1_DamageTypeTemplateName;
	var config name CVWPdata_T1_CreatorTemplateName;
	var config name CVWPdata_T1_BaseItem;
	var config name CVWPdata_T1_WeaponSlotSelect;
	var config array<CVWP_HideIfResearched> CVWPdata_T1_HideIfResearched;
	var config array<CVWP_HideIfPurchased> CVWPdata_T1_HideIfPurchased;
	var config name CVWPdata_T1_StatSelectMode;
	var config name CVWPdata_T1_RangeTableSelect;
	var config name CVWP_T1_StatSelectMobilityDetectionRadius;
	var config bool CVWP_T1_InfiniteAmmo;
	var config bool CVWP_T1_OverwatchActionPoint;
	var config bool CVWP_T1_bHideClipSizeStat;
	var config int CVWPdata_T1_iNumOfAnimationOverrides;
	var config array<CVWP_SetAnimationNameForAbility> CVWPdata_T1_SetAnimationNameForAbility;

	// Tier 2 weapon template Values.
	var config name CVWPdata_T2_TemplateName;
	var config int CVWPdata_T2_iNumUpgradeSlots;
	var config int CVWPdata_T2_iNumOfAbilities;
	var config array<name> CVWPdata_T2_Abilities;
	var config int CVWPdata_T2_iNumOfAttachments_Default;
	var config array<CVWP_DefaultWepAttachment> CVWPdata_T2_DefaultAttach;
	var config array<WeaponDamageValue> CVWPdata_T2_WepBasedmg;
	var config int CVWPdata_T2_iNumOfResources;
	var config array<CVWP_ResourceTypeCost> CVWPdata_T2_Resources;
	var config bool CVWPdata_T2_CanBeBuilt;
	var config bool CVWPdata_T2_StartingItem;
	var config bool CVWPdata_T2_bIsLargeWeapon; 
	var config bool CVWPdata_T2_bInfiniteItem;	
	var config int CVWPdata_T2_PointsToCompleteStaff;
	var config int CVWPdata_T2_PointsToCompleteDays;
	var config int CVWPdata_T2_TradingPostValue;
	var config int CVWPdata_T2_iNumOfRequiredTechs;
	var config array<name> CVWPdata_T2_RequiredTechs;			
	var config string CVWPdata_T2_WeaponPanelImage;
	var config string CVWPdata_T2_EquipSound;
	var config name CVWPdata_T2_ItemCat;
	var config name CVWPdata_T2_WeaponCat;
	var config name CVWPdata_T2_WeaponTech;
	var config string CVWPdata_T2_strImage;
	var config int CVWPdata_T2_Tier;
	var config int CVWPdata_T2_Aim;
	var config int CVWPdata_T2_CritChance;
	var config int CVWPdata_T2_iClipSize;
	var config int CVWPdata_T2_iSoundRange;
	var config int CVWPdata_T2_iEnvironmentDamage;
	var config int CVWPdata_T2_iTypicalActionCost;
	var config string CVWPdata_T2_GameArchetype;
	var config name CVWPdata_T2_UIArmoryCameraPointTag;
	var config int CVWPdata_T2_iPhysicsImpulse;
	var config float CVWPdata_T2_fKnockbackDamageAmount;
	var config float CVWPdata_T2_fKnockbackDamageRadius;
	var config name CVWPdata_T2_DamageTypeTemplateName;
	var config name CVWPdata_T2_CreatorTemplateName;
	var config name CVWPdata_T2_BaseItem;
	var config name CVWPdata_T2_WeaponSlotSelect;
	var config array<CVWP_HideIfResearched> CVWPdata_T2_HideIfResearched;
	var config array<CVWP_HideIfPurchased> CVWPdata_T2_HideIfPurchased;
	var config name CVWPdata_T2_StatSelectMode;
	var config name CVWPdata_T2_RangeTableSelect;
	var config name CVWP_T2_StatSelectMobilityDetectionRadius;
	var config bool CVWP_T2_InfiniteAmmo;
	var config bool CVWP_T2_OverwatchActionPoint;
	var config bool CVWP_T2_bHideClipSizeStat;	
	var config int CVWPdata_T2_iNumOfAnimationOverrides;
    var config array<CVWP_SetAnimationNameForAbility> CVWPdata_T2_SetAnimationNameForAbility;

	// Tier 3 weapon template Values.
	var config name CVWPdata_T3_TemplateName;
	var config int CVWPdata_T3_iNumUpgradeSlots;
	var config int CVWPdata_T3_iNumOfAbilities;
	var config array<name> CVWPdata_T3_Abilities;
	var config int CVWPdata_T3_iNumOfAttachments_Default;
	var config array<CVWP_DefaultWepAttachment> CVWPdata_T3_DefaultAttach;
	var config array<WeaponDamageValue> CVWPdata_T3_WepBasedmg;
	var config int CVWPdata_T3_iNumOfResources;
	var config array<CVWP_ResourceTypeCost> CVWPdata_T3_Resources;
	var config bool CVWPdata_T3_CanBeBuilt;
	var config bool CVWPdata_T3_StartingItem;
	var config bool CVWPdata_T3_bIsLargeWeapon; 
	var config bool CVWPdata_T3_bInfiniteItem;	
	var config int CVWPdata_T3_PointsToCompleteStaff;
	var config int CVWPdata_T3_PointsToCompleteDays;
	var config int CVWPdata_T3_TradingPostValue;
	var config int CVWPdata_T3_iNumOfRequiredTechs;
	var config array<name> CVWPdata_T3_RequiredTechs;			
	var config string CVWPdata_T3_WeaponPanelImage;
	var config string CVWPdata_T3_EquipSound;
	var config name CVWPdata_T3_ItemCat;
	var config name CVWPdata_T3_WeaponCat;
	var config name CVWPdata_T3_WeaponTech;
	var config string CVWPdata_T3_strImage;
	var config int CVWPdata_T3_Tier;
	var config int CVWPdata_T3_Aim;
	var config int CVWPdata_T3_CritChance;
	var config int CVWPdata_T3_iClipSize;
	var config int CVWPdata_T3_iSoundRange;
	var config int CVWPdata_T3_iEnvironmentDamage;
	var config int CVWPdata_T3_iTypicalActionCost;
	var config string CVWPdata_T3_GameArchetype;
	var config name CVWPdata_T3_UIArmoryCameraPointTag;
	var config int CVWPdata_T3_iPhysicsImpulse;
	var config float CVWPdata_T3_fKnockbackDamageAmount;
	var config float CVWPdata_T3_fKnockbackDamageRadius;
	var config name CVWPdata_T3_DamageTypeTemplateName;
	var config name CVWPdata_T3_CreatorTemplateName;
	var config name CVWPdata_T3_BaseItem;
	var config name CVWPdata_T3_WeaponSlotSelect;
	var config array<CVWP_HideIfResearched> CVWPdata_T3_HideIfResearched;
	var config array<CVWP_HideIfPurchased> CVWPdata_T3_HideIfPurchased;
	var config name CVWPdata_T3_StatSelectMode;
	var config name CVWPdata_T3_RangeTableSelect;
	var config name CVWP_T3_StatSelectMobilityDetectionRadius;
	var config bool CVWP_T3_InfiniteAmmo;
	var config bool CVWP_T3_OverwatchActionPoint;
	var config bool CVWP_T3_bHideClipSizeStat;	
	var config int CVWPdata_T3_iNumOfAnimationOverrides;
    var config array<CVWP_SetAnimationNameForAbility> CVWPdata_T3_SetAnimationNameForAbility;


	// Attachment Upgrades.
	var config array<CVWP_WepAttachment> CVWPdata_AttachmentCrit;
	var config array<CVWP_WepAttachment> CVWPdata_AttachmentAim;
	var config array<CVWP_WepAttachment> CVWPdata_AttachmentClipSize;
	var config array<CVWP_WepAttachment> CVWPdata_AttachmentFreeFire;
	var config array<CVWP_WepAttachment> CVWPdata_AttachmentReload;
	var config array<CVWP_WepAttachment> CVWPdata_AttachmentMissDamage;
	var config array<CVWP_WepAttachment> CVWPdata_AttachmentFreekill;

	var config int iNumOfAttachments_Crit;
	var config int iNumOfAttachments_Aim;
	var config int iNumOfAttachments_ClipSize;
	var config int iNumOfAttachments_FreeFire;
	var config int iNumOfAttachments_Reload;
	var config int iNumOfAttachments_MissDamage;
	var config int iNumOfAttachments_FreeKill;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> CVWP_Weapons;
//	local X2ItemTemplateManager ItemTemplateManager;

	CVWP_Weapons.AddItem(class'X2Item_CVWPWeaponTemplate'.static.CVWPdataWeaponTemplateFN(
		default.CVWPdata_T1_TemplateName, 
		default.CVWPdata_T1_iNumUpgradeSlots,
		default.CVWPdata_T1_iNumOfAbilities,
		default.CVWPdata_T1_Abilities,
		default.CVWPdata_T1_iNumOfAttachments_Default,
		default.CVWPdata_T1_DefaultAttach,
		default.CVWPdata_T1_WepBasedmg,
		default.CVWPdata_T1_iNumOfResources,
		default.CVWPdata_T1_Resources,
		default.CVWPdata_T1_CanBeBuilt,
		default.CVWPdata_T1_StartingItem,
		default.CVWPdata_T1_bIsLargeWeapon,
		default.CVWPdata_T1_bInfiniteItem,
		default.CVWPdata_T1_PointsToCompleteStaff,
		default.CVWPdata_T1_PointsToCompleteDays,
		default.CVWPdata_T1_TradingPostValue,
		default.CVWPdata_T1_iNumOfRequiredTechs,
		default.CVWPdata_T1_RequiredTechs,
		default.CVWPdata_T1_WeaponPanelImage,
		default.CVWPdata_T1_EquipSound,
		default.CVWPdata_T1_ItemCat,
		default.CVWPdata_T1_WeaponCat,
		default.CVWPdata_T1_WeaponTech,
		default.CVWPdata_T1_strImage,
		default.CVWPdata_T1_Tier,
		default.CVWPdata_T1_Aim,
		default.CVWPdata_T1_CritChance,
		default.CVWPdata_T1_iClipSize,
		default.CVWPdata_T1_iSoundRange,
		default.CVWPdata_T1_iEnvironmentDamage,
		default.CVWPdata_T1_iTypicalActionCost,
		default.CVWPdata_T1_GameArchetype,
		default.CVWPdata_T1_UIArmoryCameraPointTag,
		default.CVWPdata_T1_iPhysicsImpulse,
		default.CVWPdata_T1_fKnockbackDamageAmount,
		default.CVWPdata_T1_fKnockbackDamageRadius,
		default.CVWPdata_T1_DamageTypeTemplateName,
		default.CVWPdata_T1_CreatorTemplateName,
		default.CVWPdata_T1_BaseItem,
		default.CVWPdata_T1_WeaponSlotSelect,
	    default.CVWPdata_T1_HideIfResearched,
	    default.CVWPdata_T1_HideIfPurchased,
		default.CVWPdata_T1_StatSelectMode,
		default.CVWPdata_T1_RangeTableSelect,
		default.CVWP_T1_StatSelectMobilityDetectionRadius,
		default.CVWP_T1_InfiniteAmmo,
		default.CVWP_T1_OverwatchActionPoint,
		default.CVWP_T1_bHideClipSizeStat,
		default.CVWPdata_T1_iNumOfAnimationOverrides,
		default.CVWPdata_T1_SetAnimationNameForAbility
		));

	CVWP_Weapons.AddItem(class'X2Item_CVWPWeaponTemplate'.static.CVWPdataWeaponTemplateFN(
		default.CVWPdata_T2_TemplateName, 
		default.CVWPdata_T2_iNumUpgradeSlots,
		default.CVWPdata_T2_iNumOfAbilities,
		default.CVWPdata_T2_Abilities,
		default.CVWPdata_T2_iNumOfAttachments_Default,
		default.CVWPdata_T2_DefaultAttach,
		default.CVWPdata_T2_WepBasedmg,
		default.CVWPdata_T2_iNumOfResources,
		default.CVWPdata_T2_Resources,
		default.CVWPdata_T2_CanBeBuilt,
		default.CVWPdata_T2_StartingItem,
		default.CVWPdata_T2_bIsLargeWeapon,
		default.CVWPdata_T2_bInfiniteItem,
		default.CVWPdata_T2_PointsToCompleteStaff,
		default.CVWPdata_T2_PointsToCompleteDays,
		default.CVWPdata_T2_TradingPostValue,
		default.CVWPdata_T2_iNumOfRequiredTechs,
		default.CVWPdata_T2_RequiredTechs,
		default.CVWPdata_T2_WeaponPanelImage,
		default.CVWPdata_T2_EquipSound,
		default.CVWPdata_T2_ItemCat,
		default.CVWPdata_T2_WeaponCat,
		default.CVWPdata_T2_WeaponTech,
		default.CVWPdata_T2_strImage,
		default.CVWPdata_T2_Tier,
		default.CVWPdata_T2_Aim,
		default.CVWPdata_T2_CritChance,
		default.CVWPdata_T2_iClipSize,
		default.CVWPdata_T2_iSoundRange,
		default.CVWPdata_T2_iEnvironmentDamage,
		default.CVWPdata_T2_iTypicalActionCost,
		default.CVWPdata_T2_GameArchetype,
		default.CVWPdata_T2_UIArmoryCameraPointTag,
		default.CVWPdata_T2_iPhysicsImpulse,
		default.CVWPdata_T2_fKnockbackDamageAmount,
		default.CVWPdata_T2_fKnockbackDamageRadius,
		default.CVWPdata_T2_DamageTypeTemplateName,
		default.CVWPdata_T2_CreatorTemplateName,
		default.CVWPdata_T2_BaseItem,
		default.CVWPdata_T2_WeaponSlotSelect,
	    default.CVWPdata_T2_HideIfResearched,
	    default.CVWPdata_T2_HideIfPurchased,
		default.CVWPdata_T2_StatSelectMode,
		default.CVWPdata_T2_RangeTableSelect,
		default.CVWP_T2_StatSelectMobilityDetectionRadius,
		default.CVWP_T2_InfiniteAmmo,
		default.CVWP_T2_OverwatchActionPoint,
		default.CVWP_T2_bHideClipSizeStat,
		default.CVWPdata_T2_iNumOfAnimationOverrides,
		default.CVWPdata_T2_SetAnimationNameForAbility
		));

	CVWP_Weapons.AddItem(class'X2Item_CVWPWeaponTemplate'.static.CVWPdataWeaponTemplateFN(
		default.CVWPdata_T3_TemplateName, 
		default.CVWPdata_T3_iNumUpgradeSlots,
		default.CVWPdata_T3_iNumOfAbilities,
		default.CVWPdata_T3_Abilities,
		default.CVWPdata_T3_iNumOfAttachments_Default,
		default.CVWPdata_T3_DefaultAttach,
		default.CVWPdata_T3_WepBasedmg,
		default.CVWPdata_T3_iNumOfResources,
		default.CVWPdata_T3_Resources,
		default.CVWPdata_T3_CanBeBuilt,
		default.CVWPdata_T3_StartingItem,
		default.CVWPdata_T3_bIsLargeWeapon,
		default.CVWPdata_T3_bInfiniteItem,
		default.CVWPdata_T3_PointsToCompleteStaff,
		default.CVWPdata_T3_PointsToCompleteDays,
		default.CVWPdata_T3_TradingPostValue,
		default.CVWPdata_T3_iNumOfRequiredTechs,
		default.CVWPdata_T3_RequiredTechs,
		default.CVWPdata_T3_WeaponPanelImage,
		default.CVWPdata_T3_EquipSound,
		default.CVWPdata_T3_ItemCat,
		default.CVWPdata_T3_WeaponCat,
		default.CVWPdata_T3_WeaponTech,
		default.CVWPdata_T3_strImage,
		default.CVWPdata_T3_Tier,
		default.CVWPdata_T3_Aim,
		default.CVWPdata_T3_CritChance,
		default.CVWPdata_T3_iClipSize,
		default.CVWPdata_T3_iSoundRange,
		default.CVWPdata_T3_iEnvironmentDamage,
		default.CVWPdata_T3_iTypicalActionCost,
		default.CVWPdata_T3_GameArchetype,
		default.CVWPdata_T3_UIArmoryCameraPointTag,
		default.CVWPdata_T3_iPhysicsImpulse,
		default.CVWPdata_T3_fKnockbackDamageAmount,
		default.CVWPdata_T3_fKnockbackDamageRadius,
		default.CVWPdata_T3_DamageTypeTemplateName,
		default.CVWPdata_T3_CreatorTemplateName,
		default.CVWPdata_T3_BaseItem,
		default.CVWPdata_T3_WeaponSlotSelect,
	    default.CVWPdata_T3_HideIfResearched,
	    default.CVWPdata_T3_HideIfPurchased,
		default.CVWPdata_T3_StatSelectMode,
		default.CVWPdata_T3_RangeTableSelect,
		default.CVWP_T3_StatSelectMobilityDetectionRadius,
		default.CVWP_T3_InfiniteAmmo,
		default.CVWP_T3_OverwatchActionPoint,
		default.CVWP_T3_bHideClipSizeStat,
		default.CVWPdata_T3_iNumOfAnimationOverrides,
		default.CVWPdata_T3_SetAnimationNameForAbility
		));	

	class'X2DownloadableContentInfo_RFData_WotC'.static.RemoveWeaponTemplateFromGame(CVWP_Weapons);
	
	

	return CVWP_Weapons;
	}




defaultproperties
{
	bShouldCreateDifficultyVariants = true
}
