//---------------------------------------------------------------------------------------
//  FILE:   XComDownloadableContentInfo_RapidFireDe-Nerfed.uc                                    
//           
//	Use the X2DownloadableContentInfo class to specify unique mod behavior when the 
//  player creates a new campaign or loads a saved game.
//  
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class X2DownloadableContentInfo_RapidFireReverted extends X2DownloadableContentInfo;

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

// When the ability templates are created everytime you load the game, execute these three functions
static event OnPostTemplatesCreated()
{
	UpdateRangerAbilities();
}

static function UpdateRangerAbilities()
{
	UpdateRapidFire();
}

static function UpdateRapidFire()
{
	local X2AbilityTemplateManager			AbilityManager;
	local array<X2AbilityTemplate>			TemplateAllDifficulties;
	local X2AbilityTemplate					Template;

	local X2AbilityCooldown					Cooldown;


	AbilityManager = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();
	AbilityManager.FindAbilityTemplateAllDifficulties('RapidFire', TemplateAllDifficulties);

	foreach TemplateAllDifficulties(Template)
	{
		Cooldown = new class'X2AbilityCooldown';
		Cooldown.iNumTurns = 0;
		Template.AbilityCooldown = Cooldown;
	}
}