class X2TemplateHelper_USSWOTC extends Object config(UtilitySlotSidearms_WOTC);

struct AbilityWeaponCategoryRestriction
{
	var name AbilityName;
	var array<name> WeaponCategories;
};

var config array<AbilityWeaponCategoryRestriction> AbilityWeaponCategoryRestrictions;

static function FinalizeUnitAbilities(XComGameState_Unit UnitState, out array<AbilitySetupData> SetupData, optional XComGameState StartState, optional XComGameState_Player PlayerState, optional bool bMultiplayerDisplay)
{
	local int Index, CategoryIndex;
	local name WeaponCategory;
	local EInventorySlot InvSlot;
	local array<XComGameState_Item> CurrentInventory;
	local XComGameState_Item InventoryItem;
	local array<int> UsedGrenadeIDs;
	local int CurrentID;

	if (!UnitState.IsSoldier())
		return;

	CurrentInventory = UnitState.GetAllInventoryItems(StartState);

	for(Index = 0; Index < SetupData.Length; Index++)
	{
		`LOG("-----------------------------------------------------------------------",,'USSWOTC');
		CategoryIndex = default.AbilityWeaponCategoryRestrictions.Find('AbilityName', SetupData[Index].TemplateName);
		if (CategoryIndex != INDEX_NONE)
		{
			`LOG(GetFuncName() @ "found" @ default.AbilityWeaponCategoryRestrictions[CategoryIndex].AbilityName,,'UtilitySlotSidearms_WOTC');
			foreach default.AbilityWeaponCategoryRestrictions[CategoryIndex].WeaponCategories(WeaponCategory)
			{
				InvSlot = FindInventorySlotForItemCategory(UnitState, WeaponCategory, InventoryItem, StartState);
				if (InvSlot >= eInvSlot_TertiaryWeapon || InvSlot == eInvSlot_SecondaryWeapon)
				{
					//SetupData[Index].Template.DefaultSourceItemSlot = InvSlot;
					SetupData[Index].SourceWeaponRef = InventoryItem.GetReference();
					`LOG(GetFuncName()  @ UnitState.GetFullName() @ "Patching" @ SetupData[Index].TemplateName @ "setting SourceWeaponRef to" @ InvSlot,, 'UtilitySlotSidearms_WOTC');
				}
			}
		}
		
		// Do this here again because the launch grenade ability is now on the grenade launcher itself and not in earned soldier abilities
		if (SetupData[Index].Template.bUseLaunchedGrenadeEffects)
		{
			`LOG(GetFuncName() @ "found" @ SetupData[Index].TemplateName @ "which requires a grenade SourceAmmoRef",,'USSWOTC');
			`LOG(XComGameState_Item(`XCOMHISTORY.GetGameStateForObjectID(SetupData[Index].SourceWeaponRef.ObjectID)).GetMyTemplateName() @ SetupData[Index].SourceWeaponRef.ObjectID @ "is the current SourceWeaponRef",,'UtilitySlotSidearms_WOTC');
			`LOG(XComGameState_Item(`XCOMHISTORY.GetGameStateForObjectID(SetupData[Index].SourceAmmoRef.ObjectID)).GetMyTemplateName() @ SetupData[Index].SourceAmmoRef.ObjectID @ "is the current SourceAmmoRef",,'UtilitySlotSidearms_WOTC');
			//  populate a version of the ability for every grenade in the inventory
			foreach CurrentInventory(InventoryItem)
			{
				if (InventoryItem.bMergedOut)
					continue;

				if (X2GrenadeTemplate(InventoryItem.GetMyTemplate()) != none)
				{
					`LOG(GetFuncName() @ "found" @ InventoryItem.GetMyTemplateName() @ "to use as a grenade SourceAmmoRef",,'UtilitySlotSidearms_WOTC');
					CurrentID = InventoryItem.GetReference().ObjectID;
					if ( UsedGrenadeIDs.Find(CurrentID) == INDEX_NONE )
					{
						`LOG(GetFuncName() @ "found that" @ InventoryItem.GetMyTemplateName() @ "is unique, adding to" @ SetupData[Index].Template.DataName @ "as a grenade SourceAmmoRef",,'UtilitySlotSidearms_WOTC');
						SetupData[Index].SourceAmmoRef = InventoryItem.GetReference();
						UsedGrenadeIDs.AddItem(CurrentID);
						break; // stop considering new InventoryItems for this ability, move to the next Ability
					}
				}
			}
		}
		`LOG("-----------------------------------------------------------------------",,'UtilitySlotSidearms_WOTC');
	}
}

static function EInventorySlot FindInventorySlotForItemCategory(XComGameState_Unit UnitState, name WeaponCategory, out XComGameState_Item FoundItemState, optional XComGameState StartState)
{
	local array<XComGameState_Item> CurrentInventory;
	local XComGameState_Item InventoryItem;
	local X2WeaponTemplate WeaponTemplate;
	local X2WeaponSetTemplate WeaponSetTemplate;
	local array<name> SetTemplates;

	CurrentInventory = UnitState.GetAllInventoryItems(StartState);

	foreach CurrentInventory(InventoryItem)
	{
		WeaponSetTemplate = X2WeaponSetTemplate(InventoryItem.GetMyTemplate());
		if ( WeaponSetTemplate != none && WeaponSetTemplate.PairedTemplateNames.Length > 1 )
		{
			SetTemplates.AddItem(WeaponSetTemplate.PairedTemplateNames[1]); // We only want to ignore the non-primary set item
		}
	}

	foreach CurrentInventory(InventoryItem)
	{
		WeaponSetTemplate = X2WeaponSetTemplate(InventoryItem.GetMyTemplate());
		// Ignore Set templates, those are placeholders
		if ( WeaponSetTemplate != none )
		{
			continue;
		}

		// ignore paired targets like WristBladeLeft_CV
		if ( SetTemplates.Find(InventoryItem.GetMyTemplateName()) != INDEX_NONE )
		{
			continue;
		}

		WeaponTemplate = X2WeaponTemplate(InventoryItem.GetMyTemplate());
		if (WeaponTemplate != none && WeaponTemplate.WeaponCat == WeaponCategory)
		{
			`LOG(GetFuncName() @ InventoryItem.GetMyTemplate().DataName @ InventoryItem.GetMyTemplate().Class.Name @ X2WeaponTemplate(InventoryItem.GetMyTemplate()).WeaponCat @ WeaponCategory,, 'UtilitySlotSidearms_WOTC');
			FoundItemState = InventoryItem;
			return InventoryItem.InventorySlot;
		}
	}
	return eInvSlot_Unknown;
}