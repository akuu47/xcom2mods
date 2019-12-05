//---------------------------------------------------------------------------------------
//  FILE:   XComDownloadableContentInfo_RestoredChosenTraits.uc                                    
//           
//	Use the X2DownloadableContentInfo class to specify unique mod behavior when the 
//  player creates a new campaign or loads a saved game.
//  
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class X2DownloadableContentInfo_RestoredChosenTraits extends X2DownloadableContentInfo;

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
	EditChosenAbilities();

}

static function EditChosenAbilities()
{
	local X2AbilityTemplateManager							AbilityManager;
	local X2AbilityTemplate									AbilityTemplate;


	AbilityManager = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();

	AbilityTemplate = AbilityManager.FindAbilityTemplate('ChosenImmuneEnvironmental');

	AbilityTemplate.ChosenExcludeTraits.AddItem('ChosenWeakEnviro');

	AbilityTemplate = AbilityManager.FindAbilityTemplate('ChosenImmunePsi');

	AbilityTemplate.ChosenExcludeTraits.AddItem('ChosenWeakPsi');
	AbilityTemplate.ChosenExcludeTraits.AddItem('ChosenTemplarAdversary'); //templars get super nerfed with a psi immunity

	AbilityTemplate = AbilityManager.FindAbilityTemplate('ChosenWeakPsi');

	AbilityTemplate.ChosenExcludeTraits.AddItem('ChosenImmunePsi');
	//immunities done

	AbilityTemplate = AbilityManager.FindAbilityTemplate('ChosenOblivious');

	AbilityTemplate.ChosenExcludeTraits.AddItem('ChosenAllSeeing');

	AbilityTemplate = AbilityManager.FindAbilityTemplate('ChosenAllSeeing');

	AbilityTemplate.ChosenExcludeTraits.AddItem('ChosenOblivious');
	//oblivious done

	AbilityTemplate = AbilityManager.FindAbilityTemplate('ChosenShadowstep');

	AbilityTemplate.ChosenExcludeTraits.AddItem('ChosenImpatient');

	AbilityTemplate = AbilityManager.FindAbilityTemplate('ChosenImpatient');

	AbilityTemplate.ChosenExcludeTraits.AddItem('ChosenShadowstep');
	//impatient done

	// edit chosen immune psi so it actually has an icon
	AbilityTemplate = AbilityManager.FindAbilityTemplate('ChosenImmunePsi');

	AbilityTemplate.IconImage = "img:///UILibrary_XPACK_Common.PerkIcons.str_immunetopsionics";
}

