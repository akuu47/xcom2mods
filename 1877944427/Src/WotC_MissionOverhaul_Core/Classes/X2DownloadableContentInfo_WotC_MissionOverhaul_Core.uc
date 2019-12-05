//---------------------------------------------------------------------------------------
//  FILE:   XComDownloadableContentInfo_WOTCModernWarfareArmoury.uc                                    
//           
//	Use the X2DownloadableContentInfo class to specify unique mod behavior when the 
//  player creates a new campaign or loads a saved game.
//  
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class X2DownloadableContentInfo_WotC_MissionOverhaul_Core extends X2DownloadableContentInfo;

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

exec function ListAllConfigurableEncounters()
{
	local XComTacticalMissionManager MissionManager;
	local int i, j;
	
	MissionManager = `TACTICALMISSIONMGR;

	`LOG("Begin: Configurable Encounters");
	for(i = 0; i < MissionManager.ConfigurableEncounters.Length; i++)
	{
		`LOG("Name: " $ MissionManager.ConfigurableEncounters[i].EncounterID,,'WotC_MissionOverhaul_Core');
		`LOG("MaxSpawnCount: " $ MissionManager.ConfigurableEncounters[i].MaxSpawnCount ,,'WotC_MissionOverhaul_Core');
		`LOG("OffsetForceLevel: " $ MissionManager.ConfigurableEncounters[i].OffsetForceLevel ,,'WotC_MissionOverhaul_Core');
		`LOG("OffsetAlertLevel: " $ MissionManager.ConfigurableEncounters[i].OffsetAlertLevel ,,'WotC_MissionOverhaul_Core');
		`LOG("EncounterLeaderSpawnList: " $ MissionManager.ConfigurableEncounters[i].EncounterLeaderSpawnList ,,'WotC_MissionOverhaul_Core');
		`LOG("EncounterFollowerSpawnList: " $ MissionManager.ConfigurableEncounters[i].EncounterFollowerSpawnList ,,'WotC_MissionOverhaul_Core');
		`LOG("MinRequiredAlertLevel: " $ MissionManager.ConfigurableEncounters[i].MinRequiredAlertLevel ,,'WotC_MissionOverhaul_Core');
		`LOG("MaxRequiredAlertLevel: " $ MissionManager.ConfigurableEncounters[i].MaxRequiredAlertLevel ,,'WotC_MissionOverhaul_Core');		
		`LOG("MinRequiredForceLevel: " $ MissionManager.ConfigurableEncounters[i].MinRequiredForceLevel ,,'WotC_MissionOverhaul_Core');
		`LOG("MaxRequiredForceLevel: " $ MissionManager.ConfigurableEncounters[i].MaxRequiredForceLevel ,,'WotC_MissionOverhaul_Core');			
		`LOG("TeamToSpawnInto: " $ MissionManager.ConfigurableEncounters[i].TeamToSpawnInto ,,'WotC_MissionOverhaul_Core');
		for (j = 0; j < MissionManager.ConfigurableEncounters[i].ForceSpawnTemplateNames.Length; j++)
		{
			`LOG("ForceSpawnTemplateNames[" $ j $ "]: " $ MissionManager.ConfigurableEncounters[i].ForceSpawnTemplateNames[j] ,,'WotC_MissionOverhaul_Core');		
		}
		`LOG("====================================================================================",,'WotC_MissionOverhaul_Core');
	}
	`LOG("End: Configurable Encounters");
}

exec function ListAllMissionSchedules()
{
	local XComTacticalMissionManager MissionManager;
	local int i;
		
	MissionManager = `TACTICALMISSIONMGR;

	`LOG("Begin: Mission Schedules");
	for(i = 0; i < MissionManager.MissionSchedules.Length; i++)
	{
		`LOG("Name: " $ MissionManager.MissionSchedules[i].ScheduleID,,'WotC_MissionOverhaul_Core');
		`LOG("IdealTurnCount: " $ MissionManager.MissionSchedules[i].IdealTurnCount ,,'WotC_MissionOverhaul_Core');
		`LOG("IdealObjectiveCompletion: " $ MissionManager.MissionSchedules[i].IdealObjectiveCompletion,,'WotC_MissionOverhaul_Core');
		`LOG("IdealXComSpawnDistance: " $ MissionManager.MissionSchedules[i].IdealXComSpawnDistance,,'WotC_MissionOverhaul_Core');
		`LOG("MinXComSpawnDistance: " $ MissionManager.MissionSchedules[i].MinXComSpawnDistance,,'WotC_MissionOverhaul_Core');
		`LOG("MinRequiredAlertLevel: " $ MissionManager.MissionSchedules[i].MinRequiredAlertLevel,,'WotC_MissionOverhaul_Core');
		`LOG("MaxRequiredAlertLevel: " $ MissionManager.MissionSchedules[i].MaxRequiredAlertLevel,,'WotC_MissionOverhaul_Core');
		`LOG("MinRequiredForceLevel: " $ MissionManager.MissionSchedules[i].MinRequiredForceLevel,,'WotC_MissionOverhaul_Core');		
		`LOG("MaxRequiredForceLevel: " $ MissionManager.MissionSchedules[i].MaxRequiredForceLevel,,'WotC_MissionOverhaul_Core');
		`LOG("MaxTurrets: " $ MissionManager.MissionSchedules[i].MaxTurrets ,,'WotC_MissionOverhaul_Core');			
		`LOG("XComSquadStartsConcealed: " $ MissionManager.MissionSchedules[i].XComSquadStartsConcealed ,,'WotC_MissionOverhaul_Core');
		`LOG("====================================================================================",,'WotC_MissionOverhaul_Core');		
	}
	`LOG("End: Mission Schedules");
}

exec function LookupMissionSchedules(name LookupID)
{
	local XComTacticalMissionManager MissionManager;
	local MissionSchedule			 ReturnValue;

	if (LookupID != 'none')
	{
		MissionManager = `TACTICALMISSIONMGR;
		MissionManager.GetMissionSchedule(LookupID, ReturnValue);
		if (ReturnValue.ScheduleID != 'none')
			`LOG(ReturnValue.ScheduleID $ " Exists in TacticalMissionMgr",,'WotC_MissionOverhaul_Core'); 
		else
			`LOG("Cannot Find ScheduleID " $ LookupID,,'WotC_MissionOverhaul_Core');
	}
}