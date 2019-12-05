//---------------------------------------------------------------------------------------
//  FILE:    X2DownloadableContentInfo_*.uc
//  AUTHOR:  Ryan McFall
//
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class X2DownloadableContentInfo_WotC_GrenadierWeaponPack extends X2DownloadableContentInfo config(DLC_GrenadierWeaponPack);

var private name DLCName;

struct HQWeaponPair
{
	var name ReqItem;
	var name NewItem;
};

var config array<HQWeaponPair> NewWeaponToHQ;
var config array<name>		   BlacklistWeaponFromGame;

/// <summary>
/// This method is run if the player loads a saved game that was created prior to this DLC / Mod being installed, and allows the 
/// DLC / Mod to perform custom processing in response. This will only be called once the first time a player loads a save that was
/// create without the content installed. Subsequent saves will record that the content was installed.
/// </summary>
static event OnLoadedSavedGame()
{
	UpdateStorage();
}

/*
static event OnLoadedSavedGameToStrategy()
{
	UpdateStorage();
}
*/

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
    NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState(" Updating HQ Storage to add new weapons from " $ default.DLCName);
	
	XComHQ = `XCOMHQ;
	XComHQ = XComGameState_HeadquartersXCom(NewGameState.ModifyStateObject(class'XComGameState_HeadquartersXCom', XComHQ.ObjectID));
    ItemTemplateMgr = class'X2ItemTemplateManager'.static.GetItemTemplateManager();

    for(x = 0; x < default.NewWeaponToHQ.Length; x++)
	{
		ItemTemplate = ItemTemplateMgr.FindItemTemplate(default.NewWeaponToHQ[x].ReqItem);
		if(XComHQ.HasItem(ItemTemplate)) // Does XComHQ have the required item?
		{
			ItemTemplate = ItemTemplateMgr.FindItemTemplate(default.NewWeaponToHQ[x].NewItem);
			if(!XComHQ.HasItem(ItemTemplate)) // Does XComHQ NOT have the new item?
			{
                `LOG("Adding to HQ" @ ItemTemplate.DataName,, default.DLCName);
                NewItemState = ItemTemplate.CreateInstanceFromTemplate(NewGameState);
                NewGameState.AddStateObject(NewItemState);
                XComHQ.AddItemToHQInventory(NewItemState);
			}
		}
	}
	History.AddGameStateToHistory(NewGameState);
	History.CleanupPendingGameState(NewGameState);
}

static function string DLCAppendSockets(XComUnitPawn Pawn)
{
    local XComGameState_Unit UnitState;

    UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(Pawn.ObjectID));

    if (UnitState.IsSoldier())
    {
        if (UnitState.kAppearance.iGender == eGender_Male)
        {
            return "00_ResOrd_Master.Meshes.SM_MaleSockets";
        }
        else
        {
            return "00_ResOrd_Master.Meshes.SM_FemaleSockets";
        }
    }
    return "";
}

defaultproperties
{
	DLCName=GrenadierWeaponPack_WotC_Data
}