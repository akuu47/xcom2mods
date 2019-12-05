//---------------------------------------------------------------------------------------
//  FILE:   XComDownloadableContentInfo_WOTCModernWarfareArmoury.uc                                    
//           
//	Use the X2DownloadableContentInfo class to specify unique mod behavior when the 
//  player creates a new campaign or loads a saved game.
//  
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class X2DownloadableContentInfo_WotC_MissionOverhaul_Mercury extends X2DownloadableContentInfo config (GameData);

struct SitrepStruct
{
	var name SitrepName;
	var int  MinForceLevel;
	var int  MaxForceLevel;

	structdefaultproperties
	{
		SitrepName = none;
		MinForceLevel = 1;
		MaxForceLevel = 9999;
	}
};

var config array<name> CharacterTemplatesForInteractions;

var config array<SitrepStruct> ExtraSitreps;

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
	PatchNarratives();
}

static function PatchNarratives() 
{
	local X2MissionNarrativeTemplateManager NarrativeMgr;
	local X2MissionNarrativeTemplate NarrativeTemplate;

	NarrativeMgr = class'X2MissionNarrativeTemplateManager'.static.GetMissionNarrativeTemplateManager();

	NarrativeTemplate = NarrativeMgr.FindMissionNarrativeTemplate("Extract");

	if (NarrativeTemplate != none && NarrativeTemplate.DataName == 'DefaultExtract')
	{
		NarrativeTemplate.NarrativeMoments[19]="XPACK_NarrativeMoments.X2_XP_CEN_T_Swarm_Reinforcements_Dropping";
		NarrativeTemplate.NarrativeMoments[20]="XPACK_NarrativeMoments.X2_XP_CEN_T_Swarm_No_Reinforcements_left";
	}

	NarrativeTemplate = NarrativeMgr.FindMissionNarrativeTemplate("Rescue_AdventCell");

	if (NarrativeTemplate != none && NarrativeTemplate.DataName == 'DefaultRescue_AdventCell')
	{
		NarrativeTemplate.NarrativeMoments[22]="XPACK_NarrativeMoments.X2_XP_CEN_T_Swarm_Reinforcements_Dropping";
		NarrativeTemplate.NarrativeMoments[23]="XPACK_NarrativeMoments.X2_XP_CEN_T_Swarm_No_Reinforcements_left";
	}

	NarrativeTemplate = NarrativeMgr.FindMissionNarrativeTemplate("Rescue_Vehicle");

	if (NarrativeTemplate != none && NarrativeTemplate.DataName == 'DefaultRescue_Vehicle')
	{
		NarrativeTemplate.NarrativeMoments[22]="XPACK_NarrativeMoments.X2_XP_CEN_T_Swarm_Reinforcements_Dropping";
		NarrativeTemplate.NarrativeMoments[23]="XPACK_NarrativeMoments.X2_XP_CEN_T_Swarm_No_Reinforcements_left";
	}

	NarrativeTemplate = NarrativeMgr.FindMissionNarrativeTemplate("NeutralizeTarget");

	if (NarrativeTemplate != none && NarrativeTemplate.DataName == 'DefaultNeutralizeTarget')
	{
		NarrativeTemplate.NarrativeMoments[22]="XPACK_NarrativeMoments.X2_XP_CEN_T_Swarm_Reinforcements_Dropping";
		NarrativeTemplate.NarrativeMoments[23]="XPACK_NarrativeMoments.X2_XP_CEN_T_Swarm_No_Reinforcements_left";
	}
}

static function PostSitRepCreation(out GeneratedMissionData GeneratedMission, optional XComGameState_BaseObject SourceObject)
{
    local XComGameState_MissionSite				MissionState;
	local XComGameState_HeadquartersXCom		XComHQ;
	local XComGameState_HeadquartersAlien		AlienHQ;
	local int									i;
	local int									ForceLevel;

	AlienHQ = XComGameState_HeadquartersAlien(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersAlien'));
	ForceLevel = AlienHQ.GetForceLevel();

    if (`HQGAME  != none && `HQPC != None && `HQPRES != none) // we're in strategy
    {
        MissionState = XComGameState_MissionSite(SourceObject);

        if (MissionState.GeneratedMission.Mission.MissionFamily == "ProtectDevice")
        {
			XComHQ = class'UIUtilities_Strategy'.static.GetXComHQ();

			if (XComHQ.TacticalGameplayTags.Find('AvengerDefenseTurrets') != INDEX_NONE )
				GeneratedMission.SitReps.AddItem('TurretFall');									 //The ability will handle the number of charges

			for (i = 0; i < default.ExtraSitreps.Length; i++)
			{
				if (ForceLevel >= default.ExtraSitreps[i].MinForceLevel && ForceLevel <= default.ExtraSitreps[i].MaxForceLevel)
				{
					//Add new sitrep to the mission
					GeneratedMission.SitReps.AddItem(default.ExtraSitreps[i].SitrepName);
				}

			}
        }
    }
	else if (`HQPRES == none)								// TQL, Ladder, or Skirmish mode
	{
        MissionState = XComGameState_MissionSite(SourceObject);
			if (MissionState.GeneratedMission.Mission.MissionFamily == "ProtectDevice")
				GeneratedMission.SitReps.AddItem('TurretFall');

		for (i = 0; i < default.ExtraSitreps.Length; i++)
		{
			if (ForceLevel >= default.ExtraSitreps[i].MinForceLevel && ForceLevel <= default.ExtraSitreps[i].MaxForceLevel)
			{
				//Add new sitrep to the mission
				GeneratedMission.SitReps.AddItem(default.ExtraSitreps[i].SitrepName);
			}

		}
	}
}
