//---------------------------------------------------------------------------------------
//  FILE:   XComDownloadableContentInfo_MWBeagleEdition.uc                                    
//           
//	Use the X2DownloadableContentInfo class to specify unique mod behavior when the 
//  player creates a new campaign or loads a saved game.
//  
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class X2DownloadableContentInfo_MWBeagleEdition extends X2DownloadableContentInfo;

var config int KS_ACTIONPOINTS;
var config bool KS_TURNENDING;

var config bool KINETICSTRIKE_CHANGES;
var config bool COUNTERSTRIKE_CHANGES;
var config bool AUTOCANNON_CHANGES;
var config bool AVENGER_CHANGES;

/// <summary>
/// This method is run if the player loads a saved game that was created prior to this DLC / Mod being installed, and allows the 
/// DLC / Mod to perform custom processing in response. This will only be called once the first time a player loads a save that was
/// create without the content installed. Subsequent saves will record that the content was installed.
/// </summary>
static event OnLoadedSavedGame()
{}

/// <summary>
/// Called when the player starts a new campaign while this DLC / Mod is installed
/// </summary>
static event InstallNewCampaign(XComGameState StartState)
{}

static event OnPostTemplatesCreated()
{
	if(default.AUTOCANNON_CHANGES)
	{
		PatchSparkAutocannon();
	}
	if(default.AVENGER_CHANGES)
	{
		PatchAvenger();
	}
	PatchSpectreTech();
}


static event OnLoadedSavedGameToStrategy()
{
	UpdateInventory();
}

static function PatchSparkAutocannon()
{
    local X2ItemTemplateManager                    ItemTemplateManager;
    local array<name>                            TemplateNames;
    local array<X2DataTemplate>                    DifficultyVariants;
    local name                                    TemplateName;
    local X2DataTemplate                        ItemTemplate;
    local X2WeaponTemplate                        WeaponTemplate;

    ItemTemplateManager = class'X2ItemTemplateManager'.static.GetItemTemplateManager();

    ItemTemplateManager.GetTemplateNames(TemplateNames);

    foreach TemplateNames(TemplateName)
    {
        ItemTemplateManager.FindDataTemplateAllDifficulties(TemplateName, DifficultyVariants);
        // Iterate over all variants
        
        foreach DifficultyVariants(ItemTemplate)
        {
            WeaponTemplate = X2WeaponTemplate(ItemTemplate);
            if (WeaponTemplate != none)
            {
                if (WeaponTemplate.WeaponCat == 'sparkrifle')
                {
                    // If the weapon template does not already have the 'PistolReturnFire' ability (used to trigger the Return Fire ability), then add it
                    if (WeaponTemplate.Abilities.Find('F_BlindingFire') == INDEX_NONE)
                    {
                        WeaponTemplate.Abilities.AddItem('F_BlindingFire');
                        `Log("Beaglerush - Adding 'F_BlindingFire' ability to " @ WeaponTemplate.DataName);
					}
				}    
			}    
		}    
	}
}

static function PatchKineticStrike()
{
	local X2AbilityTemplateManager TemplateManager;
	local X2AbilityTemplate Template;
	local X2AbilityCost_ActionPoints ActionPointCost;

	TemplateManager = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();
	
	Template = TemplateManager.FindAbilityTemplate('KineticStrike');

	Template.AbilityTargetStyle = none;
	Template.TargetingMethod = none;
	Template.AbilityTriggers.length = 0;
	Template.AbilityCosts.length = 0;
	
    Template.AbilityTargetStyle = class'X2Ability_SparkAbilitySet_MWBE'.static.GetSSMT();
	Template.AbilityTriggers.AddItem(class'X2Ability_SparkAbilitySet_MWBE'.static.GetPIT());

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = default.KS_ACTIONPOINTS;
	ActionPointCost.bConsumeAllPoints = default.KS_TURNENDING;
	Template.AbilityCosts.AddItem(ActionPointCost);
}

static function PatchAvenger()
{
	local X2AbilityTemplateManager TemplateManager;
	local X2AbilityTemplate Template;

	TemplateManager = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();
	
	Template = TemplateManager.FindAbilityTemplate('F_Avenger');
	
	Template.AdditionalAbilities.AddItem('PistolReturnFire');
}

static function UpdateInventory()
{
	local XComGameState NewGameState;
	local XComGameStateHistory History;
	local XComGameState_HeadquartersXCom XComHQ;
	local X2ItemTemplateManager ItemTemplateMgr;
	local X2ItemTemplate ItemTemplate;
	local XComGameState_Item NewItemState, InvItemState;
	local array<StateObjectReference> InventoryItemRefs;
	local array<XComGameState_Tech> CompletedTechs;
	local bool HasItem, ShouldOverhaul;
	local name ItemName;
	local int i;

	History = `XCOMHISTORY;
	ItemTemplateMgr = class'X2ItemTemplateManager'.static.GetItemTemplateManager();

	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Updating HQ Storage to add SPARK items");
	XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
	XComHQ = XComGameState_HeadquartersXCom(NewGameState.CreateStateObject(class'XComGameState_HeadquartersXCom', XComHQ.ObjectID));
	NewGameState.AddStateObject(XComHQ);
	
	CompletedTechs = XComHQ.GetAllCompletedTechStates();
	ItemName = 'RepairKit';

	for(i = 0; i < CompletedTechs.length; i++)
	{
		if(CompletedTechs[i].GetMyTemplateName() == 'AutopsySpectre')
		{
			ItemName = 'NanoRepairKit';
		}
	}

	ItemTemplate = ItemTemplateMgr.FindItemTemplate(ItemName);
	if (ItemTemplate != none)
	{
		if (!XComHQ.HasItem(ItemTemplate))
		{
			`LOG("MWBeagleEdition: updating armory with: " $ ItemName);
			NewItemState = ItemTemplate.CreateInstanceFromTemplate(NewGameState);
			NewGameState.AddStateObject(NewItemState);
			XComHQ.AddItemToHQInventory(NewItemState);
			History.AddGameStateToHistory(NewGameState);
		}
	}
	History.CleanupPendingGameState(NewGameState);
}

static function PatchSpectreTech()
{
	local X2StrategyElementTemplateManager TemplateManager;
	local X2TechTemplate Template;

	TemplateManager = class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager();
	
	Template = X2TechTemplate(TemplateManager.FindStrategyElementTemplate('AutopsySpectre'));
	
	Template.ResearchCompletedFn = class'X2StrategyElement_DefaultTechs'.static.UpgradeItems;
}
