//---------------------------------------------------------------------------------------
//  FILE:   XComDownloadableContentInfo_SmartOverwatchAll.uc                                    
//           
//	Use the X2DownloadableContentInfo class to specify unique mod behavior when the 
//  player creates a new campaign or loads a saved game.
//  
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class X2DownloadableContentInfo_SmartOverwatchAll extends X2DownloadableContentInfo;

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
	local X2CharacterTemplateManager CharMgr;
	local array<name> AllTemplateNames;
	local name TemplateName;
	local array<X2DataTemplate> AllTemplates;
	local X2DataTemplate DataTemplate;
	local X2CharacterTemplate CharTemplate;

	CharMgr = class'X2CharacterTemplateManager'.static.GetCharacterTemplateManager();
	CharMgr.GetTemplateNames(AllTemplateNames);
	foreach AllTemplateNames(TemplateName)
	{
		CharMgr.FindDataTemplateAllDifficulties(TemplateName, AllTemplates);
		foreach AllTemplates(DataTemplate)
		{
			CharTemplate = X2CharacterTemplate(DataTemplate);
			if (CharTemplate.bIsSoldier)
			{
				CharTemplate.Abilities.AddItem('SmartOverwatchAll');
				CharTemplate.Abilities.AddItem('SmartOverwatchAll_Commander');
				CharTemplate.Abilities.AddItem('SmartOverwatchOthers');
			}
		}
	}
}