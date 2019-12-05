//---------------------------------------------------------------------------------------
//  FILE:   XComDownloadableContentInfo_PodlessWOTC.uc                                    
//           
//	Use the X2DownloadableContentInfo class to specify unique mod behavior when the 
//  player creates a new campaign or loads a saved game.
//  
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class YellowAlert_X2DownloadableContentInfo extends X2DownloadableContentInfo config(YellowAlert);

var config array<name> DefensiveReflexAbilities;

static event OnPostTemplatesCreated()
{
	AddReflexActions();
}

static function AddReflexActions()
{
	local X2AbilityTemplateManager			AbilityManager;
	local name								AbilityName;
	local X2AbilityTemplate					Template;

	AbilityManager = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();

	foreach default.DefensiveReflexAbilities(AbilityName)
	{
		Template = AbilityManager.FindAbilityTemplate(AbilityName);
		if (Template != none)
		{
			AddReflexActionPoint(Template, class'YellowAlert_UIScreenListener'.const.DefensiveReflexAction);
		}
		else
		{
		`LogAI("Cannot add reflex ability " $ AbilityName $ ": Is not a valid ability");
		}
		
	}
}

static function AddReflexActionPoint(X2AbilityTemplate Template, Name ActionPointName)
{
    local X2AbilityCost_ActionPoints        ActionPointCost;
    local X2AbilityCost                     Cost;

    foreach Template.AbilityCosts(Cost)
    {
        ActionPointCost = X2AbilityCost_ActionPoints(Cost);
        if (ActionPointCost != none)
        {
            ActionPointCost.AllowedTypes.AddItem(ActionPointName);
            `LogAI("Adding reflex action point " $ ActionPointName $ " to " $ Template.DataName);
            return;
        }
    }

    `LogAI("Cannot add reflex ability " $ Template.DataName $ ": Has no action point cost");
}
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