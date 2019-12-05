//---------------------------------------------------------------------------------------
//  FILE:   XComDownloadableContentInfo_AdditionalMissionTypesRedux.uc                                    
//           
//	Use the X2DownloadableContentInfo class to specify unique mod behavior when the 
//  player creates a new campaign or loads a saved game.
//  
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class X2DownloadableContentInfo_AdditionalMissionTypesRedux extends X2DownloadableContentInfo;

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

static event OnPreMission(XComGameState StartGameState, XComGameState_MissionSite MissionState)
{
	local XComGameState_HeadquartersXCom XComHQ;
	local name VolunteerCharacterTemplate;

	if (IsSplitMission( StartGameState ))
		return;

	if (MissionState.GeneratedMission.Mission.sType != "RM_OperativeEscort")
		return;

	foreach StartGameState.IterateByClassType( class'XComGameState_HeadquartersXCom', XComHQ )
		break;
	
	if(XComHQ == none)
		return; 


	if (XComHQ.IsTechResearched('PlasmaRifle'))
	{
		VolunteerCharacterTemplate = 'ResistanceOperative_M3';
	}
	else if (XComHQ.IsTechResearched('MagnetizedWeapons'))
	{
		VolunteerCharacterTemplate = 'ResistanceOperative_M2';
	}
	else
	{
		VolunteerCharacterTemplate = 'ResistanceOperative';
	}

	XComTeamSoldierSpawnTacticalStartModifier( VolunteerCharacterTemplate, StartGameState );

}



static function XComTeamSoldierSpawnTacticalStartModifier(name CharTemplateName, XComGameState StartState)
{
	local X2CharacterTemplate Template;
	local XComGameState_Unit SoldierState;
	local XGCharacterGenerator CharacterGenerator;
	local XComGameState_Player PlayerState;
	local TSoldier Soldier;
	local XComGameState_HeadquartersXCom XComHQ;

	// generate a basic resistance soldier unit
	Template = class'X2CharacterTemplateManager'.static.GetCharacterTemplateManager().FindCharacterTemplate( CharTemplateName );

	if(Template == none)
		Template = class'X2CharacterTemplateManager'.static.GetCharacterTemplateManager().FindCharacterTemplate('ResistanceOperative');

	SoldierState = Template.CreateInstanceFromTemplate(StartState);
	SoldierState.bMissionProvided = true;

	if (Template.bAppearanceDefinesPawn)
	{
		CharacterGenerator = `XCOMGRI.Spawn(Template.CharacterGeneratorClass);
		//`assert(CharacterGenerator != none);

		Soldier = CharacterGenerator.CreateTSoldier(Template.DataName); //make the appearance created according to a specific type
		SoldierState.SetTAppearance( Soldier.kAppearance );
		SoldierState.SetCharacterName( Soldier.strFirstName, Soldier.strLastName, Soldier.strNickName );
		SoldierState.SetCountry( Soldier.nmCountry );
	}

	// assign the player to him
	foreach StartState.IterateByClassType(class'XComGameState_Player', PlayerState)
	{
		if(PlayerState.GetTeam() == eTeam_XCom)
		{
			SoldierState.SetControllingPlayer(PlayerState.GetReference());
			break;
		}
	}

	// give him a loadout
	SoldierState.ApplyInventoryLoadout(StartState);

	foreach StartState.IterateByClassType( class'XComGameState_HeadquartersXCom', XComHQ )
		break;

	XComHQ.Squad.AddItem( SoldierState.GetReference() );
	XComHQ.AllSquads[0].SquadMembers.AddItem( SoldierState.GetReference() );
}

static function bool IsSplitMission( XComGameState StartState )
{
	local XComGameState_BattleData BattleData;

	foreach StartState.IterateByClassType( class'XComGameState_BattleData', BattleData )
		break;

	return (BattleData != none) && BattleData.DirectTransferInfo.IsDirectMissionTransfer;
}

static event OnPostTemplatesCreated()
{
	EditQuestItemTemplates();

}

static function EditQuestItemTemplates()
{
	local X2ItemTemplateManager ItemTemplateManager;

	ItemTemplateManager = class'X2ItemTemplateManager'.static.GetItemTemplateManager();

	UpdateQuestItemTemplate(ItemTemplateManager, 'DecryptionAlgorithms', "RM_OperativeEscort");
	UpdateQuestItemTemplate(ItemTemplateManager, 'AccessCodes', "RM_OperativeEscort");
	UpdateQuestItemTemplate(ItemTemplateManager, 'CollaboratorDatabase', "RM_OperativeEscort");
	UpdateQuestItemTemplate(ItemTemplateManager, 'ArchivalFootage', "RM_OperativeEscort");
	UpdateQuestItemTemplate(ItemTemplateManager, 'EquipmentAllocations', "RM_OperativeEscort");
	UpdateQuestItemTemplate(ItemTemplateManager, 'ChipCensusData', "RM_OperativeEscort");
	UpdateQuestItemTemplate(ItemTemplateManager, 'TroopMovements', "RM_OperativeEscort");
	UpdateQuestItemTemplate(ItemTemplateManager, 'EncryptionKeys', "RM_OperativeEscort");
	UpdateQuestItemTemplate(ItemTemplateManager, 'SensorData', "RM_OperativeEscort");
	UpdateQuestItemTemplate(ItemTemplateManager, 'DissectionReport', "RM_OperativeEscort");
	UpdateQuestItemTemplate(ItemTemplateManager, 'DiagnosticReports', "RM_OperativeEscort");
	UpdateQuestItemTemplate(ItemTemplateManager, 'ExposureTestingData', "RM_OperativeEscort");

}


static function UpdateQuestItemTemplate(X2ItemTemplateManager ItemTemplateMgr, name QuestItem, string BaseItem)
{
	local array<X2ItemTemplate> ItemTemplates;
	local X2QuestItemTemplate QuestTemplate;
	local X2ItemTemplate ItemTemplate;

	FindItemTemplateAllDifficulties(QuestItem, ItemTemplates, ItemTemplateMgr);

	foreach ItemTemplates(ItemTemplate)
	{
		QuestTemplate = X2QuestItemTemplate(ItemTemplate);
		if(QuestTemplate != none)
		{
			QuestTemplate.MissionType.AddItem(BaseItem);
		}
	}


}


//retrieves all difficulty variants of a given item template
static function FindItemTemplateAllDifficulties(name DataName, out array<X2ItemTemplate> ItemTemplates, optional X2ItemTemplateManager ItemTemplateMgr)
{
	local array<X2DataTemplate> DataTemplates;
	local X2DataTemplate DataTemplate;
	local X2ItemTemplate ItemTemplate;

	if(ItemTemplateMgr == none)
		ItemTemplateMgr = class'X2ItemTemplateManager'.static.GetItemTemplateManager();

	ItemTemplateMgr.FindDataTemplateAllDifficulties(DataName, DataTemplates);
	ItemTemplates.Length = 0;
	foreach DataTemplates(DataTemplate)
	{
		ItemTemplate = X2ItemTemplate(DataTemplate);
		if( ItemTemplate != none )
		{
			ItemTemplates.AddItem(ItemTemplate);
		}
	}
}