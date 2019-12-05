//---------------------------------------------------------------------------------------
//  FILE:   XComDownloadableContentInfo_WOTC_CostBasedAbilityColors.uc                                    
//           
//	Use the X2DownloadableContentInfo class to specify unique mod behavior when the 
//  player creates a new campaign or loads a saved game.
//  
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class X2DownloadableContentInfo_WOTC_CostBasedAbilityColors extends X2DownloadableContentInfo;


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
	UpdateBombardActionPointCosts();
}	


// Remove the extra FreeCost ActionPointCost in Bombard
static function UpdateBombardActionPointCosts()
{
	local X2AbilityTemplateManager				AbilityTemplateMgr;
	local array<X2AbilityTemplate>				AbilityTemplateArray;
	local X2AbilityTemplate						AbilityTemplate;
	local X2AbilityCost_ActionPoints			ActionPointCost;
	local int									i;

	AbilityTemplateMgr = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();
	AbilityTemplateMgr.FindAbilityTemplateAllDifficulties('Bombard', AbilityTemplateArray);
	foreach AbilityTemplateArray(AbilityTemplate)
	{
		for (i = 0; i < AbilityTemplate.AbilityCosts.Length; ++i)
		{
			ActionPointCost = X2AbilityCost_ActionPoints(AbilityTemplate.AbilityCosts[i]);
			if (ActionPointCost != none)
			{
				if (ActionPointCost.bFreeCost)
				{
					AbilityTemplate.AbilityCosts.RemoveItem(ActionPointCost);
}	}	}	}	}