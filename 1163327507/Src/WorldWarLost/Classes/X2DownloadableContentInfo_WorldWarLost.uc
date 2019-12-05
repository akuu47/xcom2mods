//---------------------------------------------------------------------------------------
//  FILE:   XComDownloadableContentInfo_WorldWarLost.uc                                    
//           
//	Use the X2DownloadableContentInfo class to specify unique mod behavior when the 
//  player creates a new campaign or loads a saved game.
//  
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class X2DownloadableContentInfo_WorldWarLost extends X2DownloadableContentInfo;

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
    local X2CharacterTemplateManager CharacterMgr;
    local array<name> TemplateNames;
    local name TemplateName;
    local array<X2DataTemplate> TemplateAllDifficulties;
    local X2DataTemplate Template;
    local X2CharacterTemplate CharacterTemplate;

    CharacterMgr = class'X2CharacterTemplateManager'.static.GetCharacterTemplateManager();

    CharacterMgr.GetTemplateNames(TemplateNames);

    foreach TemplateNames(TemplateName)
    {
        CharacterMgr.FindDataTemplateAllDifficulties(TemplateName, TemplateAllDifficulties);

        foreach TemplateAllDifficulties(Template)
        {
            CharacterTemplate = X2CharacterTemplate(Template);

			switch(CharacterTemplate.DataName)
			{
				case 'TheLostDasherHP2':
					CharacterTemplate.bCanUse_eTraversal_WallClimb = true;
					break;
				case 'TheLostDasherHP3':
					CharacterTemplate.bCanUse_eTraversal_WallClimb = true;
					break;
				case 'TheLostDasherHP4':
					CharacterTemplate.bCanUse_eTraversal_WallClimb = true;
					break;
				case 'TheLostDasherHP5':
					CharacterTemplate.bCanUse_eTraversal_WallClimb = true;
					break;
				case 'TheLostDasherHP6':
					CharacterTemplate.bCanUse_eTraversal_WallClimb = true;
					break;
				case 'TheLostDasherHP7':
					CharacterTemplate.bCanUse_eTraversal_WallClimb = true;
					break;
				case 'TheLostDasherHP8':
					CharacterTemplate.bCanUse_eTraversal_WallClimb = true;
					break;
				case 'TheLostDasherHP9':
					CharacterTemplate.bCanUse_eTraversal_WallClimb = true;
					break;
				case 'TheLostDasherHP10':
					CharacterTemplate.bCanUse_eTraversal_WallClimb = true;
					break;
				case 'TheLostDasherHP11':
					CharacterTemplate.bCanUse_eTraversal_WallClimb = true;
					break;
				case 'TheLostDasherHP12':
					CharacterTemplate.bCanUse_eTraversal_WallClimb = true;
					break;
				case 'TheLostDasherHP13':
					CharacterTemplate.bCanUse_eTraversal_WallClimb = true;
					break;
				case 'TheLostDasherHP14':
					CharacterTemplate.bCanUse_eTraversal_WallClimb = true;
					break;
				case 'TheLostDasherHP15':
					CharacterTemplate.bCanUse_eTraversal_WallClimb = true;
					break;
				case 'TheLostDasherHP16':
					CharacterTemplate.bCanUse_eTraversal_WallClimb = true;
					break;
				case 'TheLostDasherHP17':
					CharacterTemplate.bCanUse_eTraversal_WallClimb = true;
					break;
				case 'TheLostDasherHP18':
					CharacterTemplate.bCanUse_eTraversal_WallClimb = true;
					break;
				case 'TheLostDasherHP19':
					CharacterTemplate.bCanUse_eTraversal_WallClimb = true;
					break;
				case 'TheLostDasherHP20':
					CharacterTemplate.bCanUse_eTraversal_WallClimb = true;
					break;
				case 'TheLostDasherHP21':
					CharacterTemplate.bCanUse_eTraversal_WallClimb = true;
					break;
				case 'TheLostDasherHP22':
					CharacterTemplate.bCanUse_eTraversal_WallClimb = true;
					break;
			}
        }
    }
}