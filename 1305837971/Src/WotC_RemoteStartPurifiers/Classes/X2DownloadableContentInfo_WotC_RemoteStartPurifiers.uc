//---------------------------------------------------------------------------------------
//  FILE:   XComDownloadableContentInfo_WotC_RemoteStartPurifiers.uc                                    
//           
//	Use the X2DownloadableContentInfo class to specify unique mod behavior when the 
//  player creates a new campaign or loads a saved game.
//  
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class X2DownloadableContentInfo_WotC_RemoteStartPurifiers extends X2DownloadableContentInfo;

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
	local X2AbilityTemplateManager ATMgr;
	local array<X2DataTemplate> TemplateAllDiffs;
	local int i;
	ATMgr = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();
	ATMgr.FindDataTemplateAllDifficulties('RemoteStart', TemplateAllDiffs);
	for (i = 0; i < TemplateAllDiffs.Length; i++)
	{
		X2AbilityTemplate(TemplateAllDiffs[i]).AdditionalAbilities.AddItem('RemoteStartUnit');
	}

	ATMgr.FindDataTemplateAllDifficulties('PurifierInit', TemplateAllDiffs);
	for (i = 0; i < TemplateAllDiffs.Length; i++)
	{
		X2AbilityTemplate(TemplateAllDiffs[i]).AdditionalAbilities.AddItem('PurifierRemoteStartExplosion');
	}
}