//---------------------------------------------------------------------------------------
//  FILE:   X2DownloadableContentInfo_RFData_WotC.uc                                    
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
//
// 10/3/18: Wrote brand new Update storage code. Thanks goes out to PZ and Ginger for the initial implementation.
// 10/8/18: Removed InstallNewCampaign() event.
// 11/1/18: Updated BlacklistWeaponFromGame to actually remove the weapon from the game.
//

class X2DownloadableContentInfo_RFData_WotC extends X2DownloadableContentInfo config(_DownloadableContentInfo_RF_WotC);

struct SocketReplacementInfo
{
    var name TorsoName;
    var string SocketMeshString;
    var bool Female;
};

struct HQWeaponPair
{
	var name ReqItem;
	var name NewItem;
};

var config array<HQWeaponPair> NewWeaponToHQ;
var config array<name>		   BlacklistWeaponFromGame;

var config array<SocketReplacementInfo> SocketReplacements;
var config bool ENABLE_DEBUG_LOGGING; //This will enable the `log functions to begin printing onto the Launch.log file.
var config bool ENABLE_DEBUG_ATTACHMENT_LOGGING; //This will enable the `log functions inside the Global_Upgrades.uc to begin printing onto the Launch.log file.

//Don't allow anyone to change this! Bad things will happen!
var const string DLCName_1;

/// <summary>
/// Called when the player starts a new campaign while this DLC / Mod is installed. When a new campaign is started the initial state of the world
/// is contained in a strategy start state. Never add additional history frames inside of InstallNewCampaign, add new state objects to the start state
/// or directly modify start state objects
/// </summary>
//static event InstallNewCampaign(XComGameState StartState)
//{
//}

/// <summary>
/// This method is run if the player loads a saved game that was created prior to this DLC / Mod being installed, and allows the 
/// DLC / Mod to perform custom processing in response. This will only be called once the first time a player loads a save that was
/// create without the content installed. Subsequent saves will record that the content was installed.
/// </summary>
static event OnLoadedSavedGame()
{
	
	`Log("Starting OnLoadedSavedGame",, 'CVWP');
	UpdateStorage();
	//class'X2CVWPDataStructures'.static.CheckSaveGameForItem();
}

static event OnLoadedSavedGameToStrategy()
{
	`Log("Starting OnLoadedSavedGameToStrategy",, 'CVWP');
	UpdateStorageOnEveryLoad();
}

/// <summary>
/// Called after the Templates have been created (but before they are validated) while this DLC / Mod is installed.
/// </summary>
static event OnPostTemplatesCreated()
{
	class'X2Item_Global_Upgrades'.static.AddAllAttachments();
}


//Search through the blacklist and see if any of these templates are on the list
//If they are, remove it to make the game not load it
static function RemoveWeaponTemplateFromGame(out array<X2DataTemplate> NewWeaponsToBeAdded)
{
	local int j;
	for (j = NewWeaponsToBeAdded.Length - 1; j >= 0; j--) 
	{
	    if(default.BlacklistWeaponFromGame.Find(NewWeaponsToBeAdded[j].DataName) != INDEX_NONE)
	    {
	        NewWeaponsToBeAdded.Remove(j, 1);
	    }
	}
}

// ******** HANDLE UPDATING STORAGE ************* //
static function UpdateStorage()
{
    local XComGameState NewGameState;
    local XComGameStateHistory History;
    local XComGameState_HeadquartersXCom XComHQ;
    local X2ItemTemplateManager ItemTemplateMgr;
    local X2ItemTemplate ItemTemplate;
    local XComGameState_Item NewItemState;
	local int x;
 
    History = `XCOMHISTORY;
    NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState(" Updating HQ Storage to add new weapons from Resistance Firearms");
    XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
    XComHQ = XComGameState_HeadquartersXCom(NewGameState.CreateStateObject(class'XComGameState_HeadquartersXCom', XComHQ.ObjectID));
    NewGameState.AddStateObject(XComHQ);
    ItemTemplateMgr = class'X2ItemTemplateManager'.static.GetItemTemplateManager();

    for(x = 0; x < default.NewWeaponToHQ.Length; x++)
	{
		ItemTemplate = ItemTemplateMgr.FindItemTemplate(default.NewWeaponToHQ[x].ReqItem);
		if(XComHQ.HasItem(ItemTemplate)) // Does XComHQ have the required item?
		{
			ItemTemplate = ItemTemplateMgr.FindItemTemplate(default.NewWeaponToHQ[x].NewItem);
			if(!XComHQ.HasItem(ItemTemplate)) // Does XComHQ NOT have the new item?
			{
                `LOG("Adding to HQ" @ ItemTemplate.DataName,, 'WOTC_ResistanceFirearms');
                NewItemState = ItemTemplate.CreateInstanceFromTemplate(NewGameState);
                NewGameState.AddStateObject(NewItemState);
                XComHQ.AddItemToHQInventory(NewItemState);
			}
		}
	}
	History.AddGameStateToHistory(NewGameState);
	History.CleanupPendingGameState(NewGameState);
}

static function UpdateStorageOnEveryLoad()
{
    local XComGameState NewGameState;
    local XComGameStateHistory History;
    local XComGameState_HeadquartersXCom XComHQ;
    local X2ItemTemplateManager ItemTemplateMgr;
    local X2ItemTemplate ItemTemplate;
    local XComGameState_Item NewItemState;
	local int x;
 
    History = `XCOMHISTORY;
    NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Updating HQ Storage for mod");
    XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
    XComHQ = XComGameState_HeadquartersXCom(NewGameState.CreateStateObject(class'XComGameState_HeadquartersXCom', XComHQ.ObjectID));
    NewGameState.AddStateObject(XComHQ);
    ItemTemplateMgr = class'X2ItemTemplateManager'.static.GetItemTemplateManager();

    for(x = 0; x < default.NewWeaponToHQ.Length; x++)
	{
		ItemTemplate = ItemTemplateMgr.FindItemTemplate(default.NewWeaponToHQ[x].ReqItem);
		if(XComHQ.HasItem(ItemTemplate)) // Does XComHQ have the required item?
		{
			ItemTemplate = ItemTemplateMgr.FindItemTemplate(default.NewWeaponToHQ[x].NewItem);
			if(!XComHQ.HasItem(ItemTemplate)) // Does XComHQ NOT have the new item?
			{
                `LOG("Adding to HQ" @ ItemTemplate.DataName,, 'WOTC_ResistanceFirearms');
                NewItemState = ItemTemplate.CreateInstanceFromTemplate(NewGameState);
                NewGameState.AddStateObject(NewItemState);
                XComHQ.AddItemToHQInventory(NewItemState);
			}
		}
	}
	History.AddGameStateToHistory(NewGameState);
}
/* E3245: Comment this out until the M79 and China Lake are ready.
//Socket Stuff
static function string DLCAppendSockets(XComUnitPawn Pawn)
{
    local SocketReplacementInfo SocketReplacement;
    local name TorsoName;
    local bool bIsFemale;
    local string DefaultString, ReturnString;
    local XComHumanPawn HumanPawn;

    HumanPawn = XComHumanPawn(Pawn);
    if (HumanPawn == none) { return ""; }

    TorsoName = HumanPawn.m_kAppearance.nmTorso;
    bIsFemale = HumanPawn.m_kAppearance.iGender == eGender_Female;

    //`LOG("DLCAppendSockets: Torso= " $ TorsoName $ ", Female= " $ string(bIsFemale),, 'PredatorWeapons');

    foreach default.SocketReplacements(SocketReplacement)
    {
        if (TorsoName != 'None' && TorsoName == SocketReplacement.TorsoName && bIsFemale == SocketReplacement.Female)
        {
            ReturnString = SocketReplacement.SocketMeshString;
            break;
        }
        else
        {
            if (SocketReplacement.TorsoName == 'Default' && SocketReplacement.Female == bIsFemale)
            {
                DefaultString = SocketReplacement.SocketMeshString;
            }
        }
    }
    if (ReturnString == "")
    {
        // did not find, so use default
        ReturnString = DefaultString;
    }
    //`LOG("Returning mesh string: " $ ReturnString,, 'PredatorWeapons');
    //`LWTRACE("Returning mesh string: " $ ReturnString);

    return ReturnString;
}
*/
//Debug console command used to anticipate which weapons will be upgraded via schematics. 
//By: robojumper
exec function TestSchematic(name SchematicName)
{
	local array<X2ItemTemplate> CreatedItems, ItemsToUpgrade;
	local int i;
	local X2ItemTemplate UpgradeItemTemplate;
	
	CreatedItems = class'X2ItemTemplateManager'.static.GetItemTemplateManager().GetAllItemsCreatedByTemplate(SchematicName);
	
	for (i = 0; i < CreatedItems.Length; i++)
	{
		UpgradeItemTemplate = CreatedItems[i];
		ItemsToUpgrade.Length = 0; // Reset ItemsToUpgrade for this upgrade item iteration
		GetItemsToUpgrade(UpgradeItemTemplate, ItemsToUpgrade); 
	}
}


static function GetItemsToUpgrade(X2ItemTemplate UpgradeItemTemplate, out array<X2ItemTemplate> ItemsToUpgrade)
{
	local X2ItemTemplateManager ItemTemplateManager;
	local X2ItemTemplate BaseItemTemplate, AdditionalBaseItemTemplate;
	local array<X2ItemTemplate> BaseItems;
	`log("Getting Items to upgrade from for" @ UpgradeItemTemplate.DataName);
	ItemTemplateManager = class'X2ItemTemplateManager'.static.GetItemTemplateManager();

	// Search for any base items which specify this item as their upgrade. This accounts for the old version of schematics, mainly for Day 0 DLC
	BaseItems = ItemTemplateManager.GetAllBaseItemTemplatesFromUpgrade(UpgradeItemTemplate.DataName);
	foreach BaseItems(AdditionalBaseItemTemplate)
	{
		if (ItemsToUpgrade.Find(AdditionalBaseItemTemplate) == INDEX_NONE)
		{
			`log(AdditionalBaseItemTemplate.DataName @ "is upgraded by" @ UpgradeItemTemplate.DataName);
			ItemsToUpgrade.AddItem(AdditionalBaseItemTemplate);
		}
	}
	
	// If the base item was also the result of an upgrade, we need to save that base item as well to ensure the entire chain is upgraded
	BaseItemTemplate = ItemTemplateManager.FindItemTemplate(UpgradeItemTemplate.BaseItem);
	if (BaseItemTemplate != none)
	{
		`log(BaseItemTemplate.DataName @ "is base of" @ UpgradeItemTemplate.DataName);
		ItemsToUpgrade.AddItem(BaseItemTemplate);
		GetItemsToUpgrade(BaseItemTemplate, ItemsToUpgrade);
	}
}

defaultproperties
{
	DLCName_1="Resistance Firearms Addon - Expansion 1"
}