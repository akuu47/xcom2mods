//---------------------------------------------------------------------------------------
//  FILE:   XComDownloadableContentInfo_TacticalX4.uc                                    
//           
//	Use the X2DownloadableContentInfo class to specify unique mod behavior when the 
//  player creates a new campaign or loads a saved game.
//  
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class X2DownloadableContentInfo_WotCTacticalX4 extends X2DownloadableContentInfo;

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

static function UpdateStorage()
{
	local XComGameState NewGameState;
	local XComGameStateHistory History;
	local XComGameState_HeadquartersXCom XComHQ;
	local X2ItemTemplateManager ItemTemplateMgr;
	local array<X2ItemTemplate> ItemTemplates;
	local XComGameState_Item NewItemState;
	local int i;

	History = `XCOMHISTORY;
	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Musashi: Updating HQ Storage to add CombatKnife");
	XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
	XComHQ = XComGameState_HeadquartersXCom(NewGameState.CreateStateObject(class'XComGameState_HeadquartersXCom', XComHQ.ObjectID));
	NewGameState.AddStateObject(XComHQ);
	ItemTemplateMgr = class'X2ItemTemplateManager'.static.GetItemTemplateManager();
	
	ItemTemplates.AddItem(ItemTemplateMgr.FindItemTemplate('TacticalC4'));
	for (i = 0; i < ItemTemplates.Length; ++i)
	{
		if(ItemTemplates[i] != none)
		{
			if (!XComHQ.HasItem(ItemTemplates[i]))
			{
				`Log(ItemTemplates[i].GetItemFriendlyName() @ " not found, adding to inventory",, 'TacticalX4');
				NewItemState = ItemTemplates[i].CreateInstanceFromTemplate(NewGameState);
				NewGameState.AddStateObject(NewItemState);
				XComHQ.AddItemToHQInventory(NewItemState);
				History.AddGameStateToHistory(NewGameState);
			} else {
				`Log(ItemTemplates[i].GetItemFriendlyName() @ " found, skipping inventory add",,  'Tactical X4');
				History.CleanupPendingGameState(NewGameState);
			}
		}
	}

}

/// <summary>
/// Called from XComGameState_Unit:GatherUnitAbilitiesForInit after the game has built what it believes is the full list of
/// abilities for the unit based on character, class, equipment, et cetera. You can add or remove abilities in SetupData.
/// </summary>
static function FinalizeUnitAbilitiesForInit(XComGameState_Unit UnitState, out array<AbilitySetupData> SetupData, optional XComGameState StartState, optional XComGameState_Player PlayerState, optional bool bMultiplayerDisplay)
{
	local AbilitySetupData AbilityData;
	local array<AbilitySetupData> RemoveAbilities;
	local XComGameState_Item ItemState;
	local array<name> Explosives;

	Explosives.AddItem('TacticalC4');
	Explosives.AddItem('TacticalX4');
	Explosives.AddItem('TacticalE4');

	foreach SetupData(AbilityData)
	{
		if (AbilityData.Template.DataName == 'LaunchGrenade' || AbilityData.Template.DataName == 'ThrowGrenade')
		{
			ItemState = XComGameState_Item(`XCOMHISTORY.GetGameStateForObjectID(AbilityData.SourceAmmoRef.ObjectID));
			// `LOG(UnitState.GetSoldierClassTemplateName() @ "Found " @ AbilityData.Template.DataName @ ItemState.GetMyTemplateName(),, 'TacticalX4');
			if (Explosives.Find(ItemState.GetMyTemplateName()) != INDEX_NONE) {
				RemoveAbilities.AddItem(AbilityData);
			}
		}
	}
	foreach RemoveAbilities(AbilityData)
	{
		SetupData.RemoveItem(AbilityData);
		`LOG("Removing " @ AbilityData.Template.DataName,, 'TacticalX4');
	}
}
