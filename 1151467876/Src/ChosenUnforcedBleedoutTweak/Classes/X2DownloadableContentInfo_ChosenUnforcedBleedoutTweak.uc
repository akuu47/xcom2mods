//---------------------------------------------------------------------------------------
//  FILE:   XComDownloadableContentInfo_ChosenUnforcedBleedoutTweak.uc                                    
//           
//	Use the X2DownloadableContentInfo class to specify unique mod behavior when the 
//  player creates a new campaign or loads a saved game.
//  
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class X2DownloadableContentInfo_ChosenUnforcedBleedoutTweak extends X2DownloadableContentInfo;


static event OnPostTemplatesCreated()
{
	local X2CharacterTemplate 				Char, Template;
	local X2CharacterTemplateManager		CharMgr;
	local X2DataTemplate					DifficultyTemplate, Iter;
	local array<X2DataTemplate>				DifficultyTemplates;
	local int idx;
	
	CharMgr = class'X2CharacterTemplateManager'.static.GetCharacterTemplateManager();
	
	foreach CharMgr.IterateTemplates(Iter, none)
	{
		Template = X2CharacterTemplate(Iter);
		CharMgr.FindDataTemplateAllDifficulties(Template.DataName, DifficultyTemplates);
		foreach DifficultyTemplates(DifficultyTemplate) 
		{
			Char = X2CharacterTemplate(DifficultyTemplate);
			for(idx=0;idx<Char.Abilities.Length;idx++)
			{
				if(Char.Abilities[idx] == 'ChosenKeen')
				{
					Char.Abilities[idx] = 'ChosenKeenRoll';
				}
			}
		}
	}
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