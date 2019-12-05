//---------------------------------------------------------------------------------------
//  FILE:   XComDownloadableContentInfo_SPARKLaunchersRedux.uc                                    
//           
//	Use the X2DownloadableContentInfo class to specify unique mod behavior when the 
//  player creates a new campaign or loads a saved game.
//  
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class X2DownloadableContentInfo_SPARKLaunchersRedux extends X2DownloadableContentInfo config(SPARKLaunchers);

var config array<name> AllowedCharacters;

/// <summary>
/// This method is run if the player loads a saved game that was created prior to this DLC / Mod being installed, and allows the 
/// DLC / Mod to perform custom processing in response. This will only be called once the first time a player loads a save that was
/// create without the content installed. Subsequent saves will record that the content was installed.
/// </summary>
static event OnLoadedSavedGame()
{
	UpdateStorage();
}

/// <summary>
/// This method is run when the player loads a saved game directly into Strategy while this DLC is installed
/// </summary>
static event OnLoadedSavedGameToStrategy()
{
	UpdateStorage();
}

/// <summary>
/// Called when the player starts a new campaign while this DLC / Mod is installed. When a new campaign is started the initial state of the world
/// is contained in a strategy start state. Never add additional history frames inside of InstallNewCampaign, add new state objects to the start state
/// or directly modify start state objects
/// </summary>
static event InstallNewCampaign(XComGameState StartState)
{

}

/// <summary>
/// Called just before the player launches into a tactical a mission while this DLC / Mod is installed.
/// Allows dlcs/mods to modify the start state before launching into the mission
/// </summary>
static event OnPreMission(XComGameState StartGameState, XComGameState_MissionSite MissionState)
{

}

/// <summary>
/// Called when the player completes a mission while this DLC / Mod is installed.
/// </summary>
static event OnPostMission()
{

}

/// <summary>
/// Called when the player is doing a direct tactical->tactical mission transfer. Allows mods to modify the
/// start state of the new transfer mission if needed
/// </summary>
static event ModifyTacticalTransferStartState(XComGameState TransferStartState)
{

}

/// <summary>
/// Called after the player exits the post-mission sequence while this DLC / Mod is installed.
/// </summary>
static event OnExitPostMissionSequence()
{

}

/// <summary>
/// Called after the Templates have been created (but before they are validated) while this DLC / Mod is installed.
/// </summary>
static event OnPostTemplatesCreated()
{

}

/// <summary>
/// Called when the difficulty changes and this DLC is active
/// </summary>
static event OnDifficultyChanged()
{

}

/// <summary>
/// Called by the Geoscape tick
/// </summary>
static event UpdateDLC()
{

}

/// <summary>
/// Called after HeadquartersAlien builds a Facility
/// </summary>
static event OnPostAlienFacilityCreated(XComGameState NewGameState, StateObjectReference MissionRef)
{

}

/// <summary>
/// Called after a new Alien Facility's doom generation display is completed
/// </summary>
static event OnPostFacilityDoomVisualization()
{

}

/// <summary>
/// Called when viewing mission blades with the Shadow Chamber panel, used primarily to modify tactical tags for spawning
/// Returns true when the mission's spawning info needs to be updated
/// </summary>
static function bool UpdateShadowChamberMissionInfo(StateObjectReference MissionRef)
{
	return false;
}

/// <summary>
/// A dialogue popup used for players to confirm or deny whether new gameplay content should be installed for this DLC / Mod.
/// </summary>
static function EnableDLCContentPopup()
{
	local TDialogueBoxData kDialogData;

	kDialogData.eType = eDialog_Normal;
	kDialogData.strTitle = default.EnableContentLabel;
	kDialogData.strText = default.EnableContentSummary;
	kDialogData.strAccept = default.EnableContentAcceptLabel;
	kDialogData.strCancel = default.EnableContentCancelLabel;

	kDialogData.fnCallback = EnableDLCContentPopupCallback_Ex;
	`HQPRES.UIRaiseDialog(kDialogData);
}

simulated function EnableDLCContentPopupCallback(eUIAction eAction)
{
}

simulated function EnableDLCContentPopupCallback_Ex(Name eAction)
{	
	switch (eAction)
	{
	case 'eUIAction_Accept':
		EnableDLCContentPopupCallback(eUIAction_Accept);
		break;
	case 'eUIAction_Cancel':
		EnableDLCContentPopupCallback(eUIAction_Cancel);
		break;
	case 'eUIAction_Closed':
		EnableDLCContentPopupCallback(eUIAction_Closed);
		break;
	}
}

/// <summary>
/// Called when viewing mission blades, used primarily to modify tactical tags for spawning
/// Returns true when the mission's spawning info needs to be updated
/// </summary>
static function bool ShouldUpdateMissionSpawningInfo(StateObjectReference MissionRef)
{
	return false;
}

/// <summary>
/// Called when viewing mission blades, used primarily to modify tactical tags for spawning
/// Returns true when the mission's spawning info needs to be updated
/// </summary>
static function bool UpdateMissionSpawningInfo(StateObjectReference MissionRef)
{
	return false;
}

/// <summary>
/// Called when viewing mission blades, used to add any additional text to the mission description
/// </summary>
static function string GetAdditionalMissionDesc(StateObjectReference MissionRef)
{
	return "";
}

/// <summary>
/// Called from X2AbilityTag:ExpandHandler after processing the base game tags. Return true (and fill OutString correctly)
/// to indicate the tag has been expanded properly and no further processing is needed.
/// </summary>
static function bool AbilityTagExpandHandler(string InString, out string OutString)
{
	return false;
}

/// <summary>
/// Called from XComGameState_Unit:GatherUnitAbilitiesForInit after the game has built what it believes is the full list of
/// abilities for the unit based on character, class, equipment, et cetera. You can add or remove abilities in SetupData.
/// </summary>
static function FinalizeUnitAbilitiesForInit(XComGameState_Unit UnitState, out array<AbilitySetupData> SetupData, optional XComGameState StartState, optional XComGameState_Player PlayerState, optional bool bMultiplayerDisplay)
{

}

/// <summary>
/// Calls DLC specific popup handlers to route messages to correct display functions
/// </summary>
static function bool DisplayQueuedDynamicPopup(DynamicPropertySet PropertySet)
{

}


static function bool CanAddItemToInventory_CH(out int bCanAddItem, const EInventorySlot Slot, const X2ItemTemplate ItemTemplate, int Quantity, XComGameState_Unit UnitState, optional XComGameState CheckGameState, optional out string DisabledReason)
{
	local name CurrentClass;
	local bool IsRightClass, AlreadyHasLauncher;
	local XGParamTag LocTag;
	local X2PairedWeaponTemplate WeaponTemplate;
	local int i;
	local XComGameState_Item kItem;
	local X2ItemTemplate UniqueItemTemplate;

	WeaponTemplate = X2PairedWeaponTemplate(ItemTemplate);
	AlreadyHasLauncher = false;
	IsRightClass = false;

	if(CheckGameState != none)
		return CanAddItemToInventory(bCanAddItem, Slot, ItemTemplate, Quantity, UnitState, CheckGameState);


	if(CheckGameState == none && WeaponTemplate.WeaponCat == 'shoulder_launcher') //only do this check for our shoulder launchers
	{
		if(DisabledReason != "") //if this is already set, assume we shouldn't be changing this.
			return true;

		foreach default.AllowedCharacters(CurrentClass)
		{
			if(UnitState.GetMyTemplateName() == CurrentClass)
			{
				IsRightClass = true;
				break;
			}
		}

		if(IsRightClass)
		{
			for (i = 0; i < UnitState.InventoryItems.Length; ++i)
			{
				kItem = UnitState.GetItemGameState(UnitState.InventoryItems[i], CheckGameState);
				if (kItem != none)
				{
					UniqueItemTemplate = kItem.GetMyTemplate();

					if(UniqueItemTemplate.ItemCat == 'shoulder_launcher')
					{
						AlreadyHasLauncher = true;
						break;
					}
				}
			}
			if(!AlreadyHasLauncher)
			{
				return true;
			}
		}
		else if (!IsRightClass)//invalid class, so give Unavailable to Class reason
		{
			LocTag = XGParamTag(`XEXPANDCONTEXT.FindTag("XGParam"));
			LocTag.StrValue0 = class'X2SoldierClassTemplateManager'.static.GetSoldierClassTemplateManager().FindSoldierClassTemplate('Spark').DisplayName;
			DisabledReason = class'UIUtilities_Text'.static.CapsCheckForGermanScharfesS(`XEXPAND.ExpandString(class'UIArmory_Loadout'.default.m_strNeedsSoldierClass));

			return false; //if we get this far, we gave a disabled reason for being an invalid class.
		}
		else if(AlreadyHasLauncher) // no duplicates
		{
			LocTag = XGParamTag(`XEXPANDCONTEXT.FindTag("XGParam"));
			LocTag.StrValue0 = "SHOULDER LAUNCHER";
			DisabledReason = class'UIUtilities_Text'.static.CapsCheckForGermanScharfesS(`XEXPAND.ExpandString(class'UIArmory_Loadout'.default.m_strCategoryRestricted));

			return false; //if we get this far, we gave a disabled reason for being an invalid class.
		}
	}

	return true; ///was not a spark launcher or otherwise we had no reason to change it

}


// Use SLG hook to add infiltration modifiers to alien units
static function bool CanAddItemToInventory(out int bCanAddItem, const EInventorySlot Slot, const X2ItemTemplate ItemTemplate, int Quantity, XComGameState_Unit UnitState, XComGameState CheckGameState)
{
	local int i, iUtility, size;
	local XComGameState_Item kItem;
	local X2PairedWeaponTemplate WeaponTemplate;
	local name CurrentClass;
	local bool IsRightClass;

	WeaponTemplate = X2PairedWeaponTemplate(ItemTemplate);
	IsRightClass = false;

	foreach default.AllowedCharacters(CurrentClass)
	{
		if(UnitState.GetMyTemplateName() == CurrentClass)
		{
			IsRightClass = true;
			break;
		}
	}

	if(WeaponTemplate != none && WeaponTemplate.WeaponCat == 'shoulder_launcher') // if we're trying to add a shoulder launche, run this
	{
		if(IsRightClass && Slot == eInvSlot_Utility) //basically is this a utility slot launcher weapon from this mod?
		{
			iUtility = 0;
			for (i = 0; i < UnitState.InventoryItems.Length; ++i)
			{
				kItem = UnitState.GetItemGameState(UnitState.InventoryItems[i], CheckGameState);
				if (kItem != none && kItem.InventorySlot == eInvSlot_Utility && kItem.GetWeaponCategory() != 'shoulder_launcher')
				{
					iUtility += kItem.GetItemSize();
				}
				if (kItem != none && kItem.InventorySlot == eInvSlot_Utility && kItem.GetWeaponCategory() == 'shoulder_launcher')
				{
					iUtility += 1; //to deal with our hacky workaround
				}

			}
			if(UnitState.GetMPCharacterTemplate() != none)
			{
				return false;
			}

			Size = ItemTemplate.iItemSize;

			if(WeaponTemplate != none && WeaponTemplate.WeaponCat == 'shoulder_launcher')
			{
				Size = 1;
			}

			if(iUtility + Size <= UnitState.GetCurrentStat(eStat_UtilityItems)) //we use 1 since we know that's their actual size: the 99's just to block it from regular soldiers using it
			{
				bCanAddItem = 1;
				return true;
			}

		}

	}
	// else, return false and let the "can add item to inventory" logic continue checking for other mods
	return false;
	
}


// ******** HANDLE UPDATING STORAGE ************* //
// This handles updating storage in order to create variations of various SMGs based on techs unlocked
static function UpdateStorage()
{
	local XComGameState NewGameState;
	local XComGameStateHistory History;
	local XComGameState_HeadquartersXCom XComHQ;
	local X2ItemTemplateManager ItemTemplateMgr;
	local X2ItemTemplate ItemTemplate;
	//local X2SchematicTemplate SchematicTemplate_MG, SchematicTemplate_BM;
	local XComGameState_Item NewItemState;

	History = `XCOMHISTORY;
	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Updating HQ Storage to add SPARK Launchers");
	XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
	XComHQ = XComGameState_HeadquartersXCom(NewGameState.CreateStateObject(class'XComGameState_HeadquartersXCom', XComHQ.ObjectID));
	NewGameState.AddStateObject(XComHQ);
	ItemTemplateMgr = class'X2ItemTemplateManager'.static.GetItemTemplateManager();

	ItemTemplate = ItemTemplateMgr.FindItemTemplate('RM_SupportLauncher_MG_Paired');

	if(IsResearchInHistory('AdvancedGrenades') && IsResearchInHistory('AutopsyAdventMEC') && !XComHQ.HasItem(ItemTemplate)) //if we've met the prereqs for the second tier of items....
	{
		NewItemState = ItemTemplate.CreateInstanceFromTemplate(NewGameState);
		NewGameState.AddStateObject(NewItemState);
		XComHQ.AddItemToHQInventory(NewItemState);

	}

	//add Conventional SMG always
	//`Log("LW SMGPack : Updated Conventional SMG");
	ItemTemplate = ItemTemplateMgr.FindItemTemplate('RM_SupportLauncher_CV_Paired');
	if(ItemTemplate != none)
	{
		//`Log("LW SMGPack : Found SMG_CV item template");
		if (!XComHQ.HasItem(ItemTemplate))
		{
			//`Log("LW SMGPack : SMG_CV not found, adding to inventory");
			NewItemState = ItemTemplate.CreateInstanceFromTemplate(NewGameState);
			NewGameState.AddStateObject(NewItemState);
			XComHQ.AddItemToHQInventory(NewItemState);
			History.AddGameStateToHistory(NewGameState);
		} 
		else {
			//`Log("LW SMGPack : SMG_CV found, skipping inventory add");
			History.CleanupPendingGameState(NewGameState);
		}

	}

	//schematics should be handled already, as the BuildItem UI draws from ItemTemplates, which are automatically loaded



}

static function bool IsResearchInHistory(name ResearchName)
{
	// Check if we've already injected the tech templates
	local XComGameState_Tech	TechState;
	
	foreach `XCOMHISTORY.IterateByClassType(class'XComGameState_Tech', TechState)
	{
		if ( TechState.GetMyTemplateName() == ResearchName && TechState.TimesResearched > 0)
		{
			return true;
		}
	}
	return false;
}