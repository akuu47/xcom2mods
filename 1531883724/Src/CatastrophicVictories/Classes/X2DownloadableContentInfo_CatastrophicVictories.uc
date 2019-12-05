//---------------------------------------------------------------------------------------
//  FILE:   XComDownloadableContentInfo_CatastrophicVictories.uc                                    
//           
//	Use the X2DownloadableContentInfo class to specify unique mod behavior when the 
//  player creates a new campaign or loads a saved game.
//  
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class X2DownloadableContentInfo_CatastrophicVictories extends X2DownloadableContentInfo config(Game);

var config bool ComplexMissionVictories;

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

	EditMissionSourceTemplates();

}


static function EditMissionSourceTemplates()
{
	// we edit mission source templates here so they only check for strategic objective completion
	HandleTemplate('MissionSource_GuerillaOp');
	HandleTemplate('MissionSource_SupplyRaid');
	HandleTemplate('MissionSource_LandedUFO');
	HandleTemplate('MissionSource_Retaliation');

}


static function HandleTemplate(name templateName){
	local X2MissionSourceTemplate Template;
	local X2StrategyElementTemplateManager Manager;

	Manager =class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager();

	Template = X2MissionSourceTemplate(Manager.FindStrategyElementTemplate(templateName));

	if (Template == none)
	{
		`log("Could not find template:"@string(templateName));
		return;
	}
	
	// only one strategy objective to be successful
	Template.WasMissionSuccessfulFn = class'X2StrategyElement_DefaultMissionSources'.static.OneStrategyObjectiveCompleted;

	if(templateName == 'MissionSource_SupplyRaid')
	{
		//losing just decreases income, not lose a region
		Template.OnFailureFn = SupplyRaidFailure;
		Template.OnExpireFn = SupplyRaidExpire;
		Template.bDisconnectRegionOnFail = false;
	}
	else if  (templateName == 'MissionSource_LandedUFO')
	{
		//losing just decreases income, not lose a region
		Template.OnFailureFn = UFOFailure;
		Template.OnExpireFn = UFOExpire;
		Template.bDisconnectRegionOnFail = false;
	}

	if(default.ComplexMissionVictories)
	{
		if(templateName == 'MissionSource_GuerillaOp')
		{
			Template.OnSuccessFn = GuerillaOnSuccess;
		}
		else if(templateName == 'MissionSource_Retaliation')
		{
			Template.OnSuccessFn = RetaliationOnSuccess;
		}

	}
}

static function RetaliationOnSuccess(XComGameState NewGameState, XComGameState_MissionSite MissionState)
{
	local XComGameState_BattleData BattleData;
	local bool GiveReward;

	BattleData = XComGameState_BattleData(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_BattleData'));

	if(BattleData.OneStrategyObjectiveCompleted() && !BattleData.AllTacticalObjectivesCompleted()) 
	{
		// did the mission, but had to leave: do partial rewards for complex mode
		GiveReward = class'X2StrategyGameRulesetDataStructures'.static.Roll(50);

		if(GiveReward)
		{
			class'X2StrategyElement_DefaultMissionSources'.static.GiveRewards(NewGameState, MissionState);
		}
		else
		{	
			class'X2StrategyElement_DefaultMissionSources'.static.SpawnPointOfInterest(NewGameState, MissionState);
		}
	}
	else // normal mission completion, give all rewards
	{
		class'X2StrategyElement_DefaultMissionSources'.static.GiveRewards(NewGameState, MissionState);
		class'X2StrategyElement_DefaultMissionSources'.static.SpawnPointOfInterest(NewGameState, MissionState);
	}
	MissionState.RemoveEntity(NewGameState);
	class'XComGameState_HeadquartersResistance'.static.RecordResistanceActivity(NewGameState, 'ResAct_RetaliationsStopped');

	`XEVENTMGR.TriggerEvent('RetaliationComplete', , , NewGameState);
}


static function GuerillaOnSuccess(XComGameState NewGameState, XComGameState_MissionSite MissionState)
{
	local XComGameState_BattleData BattleData;
	local bool GiveReward;
	if(MissionState.HasDarkEvent())
	{
		class'X2StrategyElement_DefaultMissionSources'.static.StopMissionDarkEvent(NewGameState, MissionState);
	}
	BattleData = XComGameState_BattleData(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_BattleData'));

	if(BattleData.OneStrategyObjectiveCompleted() && !BattleData.AllTacticalObjectivesCompleted()) 
	{
		// did the mission, but had to leave: do partial rewards for complex mode
		GiveReward = class'X2StrategyGameRulesetDataStructures'.static.Roll(50);

		if(GiveReward)
		{
			class'X2StrategyElement_DefaultMissionSources'.static.GiveRewards(NewGameState, MissionState);
		}
		else
		{	
			class'X2StrategyElement_DefaultMissionSources'.static.SpawnPointOfInterest(NewGameState, MissionState);
		}
	}
	else // normal mission completion, give all rewards
	{
		class'X2StrategyElement_DefaultMissionSources'.static.GiveRewards(NewGameState, MissionState);
		class'X2StrategyElement_DefaultMissionSources'.static.SpawnPointOfInterest(NewGameState, MissionState);
	}
	class'X2StrategyElement_DefaultMissionSources'.static.CleanUpGuerillaOps(NewGameState, MissionState.ObjectID);
	class'XComGameState_HeadquartersResistance'.static.RecordResistanceActivity(NewGameState, 'ResAct_GuerrillaOpsCompleted');
}

static function SupplyRaidFailure(XComGameState NewGameState, XComGameState_MissionSite MissionState)
{

	class'X2StrategyElement_DefaultMissionSources'.static.ModifyRegionSupplyYield(NewGameState, MissionState, class'XComGameState_WorldRegion'.static.GetRegionDisconnectSupplyChangePercent(), , true);
	
	
	MissionState.RemoveEntity(NewGameState);
	class'XComGameState_HeadquartersResistance'.static.DeactivatePOI(NewGameState, MissionState.POIToSpawn);
	class'XComGameState_HeadquartersResistance'.static.RecordResistanceActivity(NewGameState, 'ResAct_SupplyRaidsFailed');
}


static function SupplyRaidExpire(XComGameState NewGameState, XComGameState_MissionSite MissionState)
{
	class'X2StrategyElement_DefaultMissionSources'.static.ModifyRegionSupplyYield(NewGameState, MissionState, class'XComGameState_WorldRegion'.static.GetRegionDisconnectSupplyChangePercent(), , true);	
	
	class'XComGameState_HeadquartersResistance'.static.DeactivatePOI(NewGameState, MissionState.POIToSpawn);
	class'XComGameState_HeadquartersResistance'.static.RecordResistanceActivity(NewGameState, 'ResAct_SupplyRaidsFailed');
}

static function UFOFailure(XComGameState NewGameState, XComGameState_MissionSite MissionState)
{	

	class'X2StrategyElement_DefaultMissionSources'.static.ModifyRegionSupplyYield(NewGameState, MissionState, class'XComGameState_WorldRegion'.static.GetRegionDisconnectSupplyChangePercent(), , true);
	
	
	MissionState.RemoveEntity(NewGameState);
	class'XComGameState_HeadquartersResistance'.static.DeactivatePOI(NewGameState, MissionState.POIToSpawn);
	class'XComGameState_HeadquartersResistance'.static.RecordResistanceActivity(NewGameState, 'ResAct_LandedUFOsFailed');
}


static function UFOExpire(XComGameState NewGameState, XComGameState_MissionSite MissionState)
{
	class'X2StrategyElement_DefaultMissionSources'.static.ModifyRegionSupplyYield(NewGameState, MissionState, class'XComGameState_WorldRegion'.static.GetRegionDisconnectSupplyChangePercent(), , true);
	
	class'XComGameState_HeadquartersResistance'.static.DeactivatePOI(NewGameState, MissionState.POIToSpawn);
	class'XComGameState_HeadquartersResistance'.static.RecordResistanceActivity(NewGameState, 'ResAct_LandedUFOsFailed');	
}
