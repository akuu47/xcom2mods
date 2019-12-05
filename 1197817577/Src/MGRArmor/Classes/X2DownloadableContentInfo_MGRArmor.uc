//---------------------------------------------------------------------------------------
//  FILE:   XComDownloadableContentInfo_MGRArmor.uc                                    
//           
//	Use the X2DownloadableContentInfo class to specify unique mod behavior when the 
//  player creates a new campaign or loads a saved game.
//  
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------



class X2DownloadableContentInfo_MGRArmor extends X2DownloadableContentInfo;

static event OnPostTemplatesCreated()
{
	`LOG("X2DownloadableContentInfo_MGRArmor" @ GetFuncName(),, 'MGRArmor'); 
}
/// <summary>
/// This method is run if the player loads a saved game that was created prior to this DLC / Mod being installed, and allows the 
/// DLC / Mod to perform custom processing in response. This will only be called once the first time a player loads a save that was
/// create without the content installed. Subsequent saves will record that the content was installed.
/// </summary>
//static event OnLoadedSavedGame()
static event OnLoadedSavedGameToStrategy()
{
	`Log("MGRArmor : Starting OnLoadedSavedGame");

	UpdateStorage();
}

// ******** HANDLE UPDATING STORAGE ************* //
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
	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("MRGArmor: Updating HQ Storage to add CombatKnife");
	XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
	XComHQ = XComGameState_HeadquartersXCom(NewGameState.CreateStateObject(class'XComGameState_HeadquartersXCom', XComHQ.ObjectID));
	NewGameState.AddStateObject(XComHQ);
	ItemTemplateMgr = class'X2ItemTemplateManager'.static.GetItemTemplateManager();
	
	//ItemTemplates.AddItem(ItemTemplateMgr.FindItemTemplate('UtilityNinjato_CV'));
	//ItemTemplates.AddItem(ItemTemplateMgr.FindItemTemplate('UtilityKatana_CV'));
	//ItemTemplates.AddItem(ItemTemplateMgr.FindItemTemplate('UtilityWakizashi_CV'));
	//ItemTemplates.AddItem(ItemTemplateMgr.FindItemTemplate('Ninjato_CV'));
	ItemTemplates.AddItem(ItemTemplateMgr.FindItemTemplate('HFBlade_CV'));
	//ItemTemplates.AddItem(ItemTemplateMgr.FindItemTemplate('Wakizashi_CV'));

	for (i = 0; i < ItemTemplates.Length; ++i)
	{
		if(ItemTemplates[i] != none)
		{
			if (!XComHQ.HasItem(ItemTemplates[i]))
			{
				`Log("MGRArmor : " @ ItemTemplates[i].GetItemFriendlyName() @ " not found, adding to inventory");
				NewItemState = ItemTemplates[i].CreateInstanceFromTemplate(NewGameState);
				NewGameState.AddStateObject(NewItemState);
				XComHQ.AddItemToHQInventory(NewItemState);
				History.AddGameStateToHistory(NewGameState);
			} else {
				`Log("MGRArmor : " @ ItemTemplates[i].GetItemFriendlyName() @ " found, skipping inventory add");
				History.CleanupPendingGameState(NewGameState);
			}
		}
	}

	// Check Tier 2 & 3 for running campaigns that already bought the swords
//	AddHigherTiers('UtilityNinjato_MG', 'Sword_MG', XComHQ, NewGameState);
//	AddHigherTiers('UtilityNinjato_BM', 'Sword_MG', XComHQ, NewGameState);
	AddHigherTiers('UtilityHFBlade_MG', 'Sword_MG', XComHQ, NewGameState);
	AddHigherTiers('UtilityHFBlade_BM', 'Sword_BM', XComHQ, NewGameState);
//	AddHigherTiers('UtilityWakizashi_MG', 'Sword_MG', XComHQ, NewGameState);
//	AddHigherTiers('UtilityWakizashi_BM', 'Sword_BM', XComHQ, NewGameState);
//	AddHigherTiers('Ninjato_MG', 'Sword_MG', XComHQ, NewGameState);
//	AddHigherTiers('Ninjato_BM', 'Sword_BM', XComHQ, NewGameState);
	AddHigherTiers('HFBlade_MG', 'Sword_MG', XComHQ, NewGameState);
	AddHigherTiers('HFBlade_BM', 'Sword_BM', XComHQ, NewGameState);
//	AddHigherTiers('Wakizashi_MG', 'Sword_MG', XComHQ, NewGameState);
//	AddHigherTiers('Wakizashi_BM', 'Sword_BM', XComHQ, NewGameState);
	//schematics should be handled already, as the BuildItem UI draws from ItemTemplates, which are automatically loaded
}

static function AddHigherTiers(
	name Template,
	name CheckTemplate,
	XComGameState_HeadquartersXCom XComHQ,
	XComGameState NewGameState
	)
{
	local XComGameState_Item NewItemState;
	local XComGameStateHistory History;
	local X2ItemTemplate ItemTemplate, CheckItemTemplate;
	local X2ItemTemplateManager ItemTemplateMgr;

	History = `XCOMHISTORY;

	ItemTemplateMgr = class'X2ItemTemplateManager'.static.GetItemTemplateManager();
	ItemTemplate = ItemTemplateMgr.FindItemTemplate(Template);
	CheckItemTemplate = ItemTemplateMgr.FindItemTemplate(CheckTemplate);
	if(ItemTemplate != none)
	{
		if (!XComHQ.HasItem(ItemTemplate) && 
			XComHQ.HasItem(CheckItemTemplate))
		{
			`Log("MGRArmor : " @ ItemTemplate.GetItemFriendlyName() @ " not found, adding to inventory");
			NewItemState = ItemTemplate.CreateInstanceFromTemplate(NewGameState);
			NewGameState.AddStateObject(NewItemState);
			XComHQ.AddItemToHQInventory(NewItemState);
			History.AddGameStateToHistory(NewGameState);
		} else if(XComHQ.HasItem(ItemTemplate) && !XComHQ.HasItem(CheckItemTemplate)) {
			NewItemState = ItemTemplate.CreateInstanceFromTemplate(NewGameState);
			XComHQ.RemoveItemFromInventory(NewGameState, NewItemState.GetReference(), 1);
			`Log("MGRArmor : " @ ItemTemplate.GetItemFriendlyName() @ " removed because coressponding tier not unlocked");
		} else {
			`Log("MGRArmor : " @ ItemTemplate.GetItemFriendlyName() @ " found or not unlocked yet, skipping inventory add");
			History.CleanupPendingGameState(NewGameState);
		}
	}
}

/// <summary>
/// Called when the player starts a new campaign while this DLC / Mod is installed
/// </summary>
static event InstallNewCampaign(XComGameState StartState)
{}