class X2StrategyElement_MissionSource_PrisonBreak extends X2StrategyElement_DefaultMissionSources
	config(GameData);

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> MissionSources;

	MissionSources.AddItem(CreatePrisonBreakTemplate());

	return MissionSources;
}

// CHEEKY PRISON BREAKY
//---------------------------------------------------------------------------------------
static function X2DataTemplate CreatePrisonBreakTemplate()
{
	local X2MissionSourceTemplate Template;

	`CREATE_X2TEMPLATE(class'X2MissionSourceTemplate', Template, 'MissionSource_RescuePrisonBreak');
	Template.bIncreasesForceLevel = true;
	Template.bDisconnectRegionOnFail = false;

	Template.OnSuccessFn = PrisonBreakOnSuccess;
	Template.OnFailureFn = PrisonBreakOnFailure;

	Template.GetMissionDifficultyFn = GetMissionDifficultyFromTemplate;
	Template.OverworldMeshPath = "StaticMesh'UI_3D.Overwold_Final.RescueOps'";
	Template.MissionImage = "img:///UILibrary_XPACK_StrategyImages.CovertOp_Reduce_Avatar_Project_Progress";
	Template.MissionPopupFn = PrisonBreakPopup;
	Template.WasMissionSuccessfulFn = OneStrategyObjectiveCompleted;
	Template.GetMissionRegionFn = GetCalendarMissionRegion;
	Template.GetMissionDifficultyFn = GetMissionDifficultyFromMonth;

	return Template;
}

static function PrisonBreakOnSuccess(XComGameState NewGameState, XComGameState_MissionSite MissionState)
{
	local array<int> ExcludeIndices;

	ExcludeIndices = GetPrisonBreakExcludeRewards(MissionState);
	GiveRewards(NewGameState, MissionState, ExcludeIndices);
	MissionState.RemoveEntity(NewGameState);
	class'XComGameState_HeadquartersResistance'.static.RecordResistanceActivity(NewGameState, 'ResAct_Mission_PrisonBreak_Success');
	
	`XEVENTMGR.TriggerEvent('PrisonBreakoutComplete', , , NewGameState);
}

static function PrisonBreakOnFailure(XComGameState NewGameState, XComGameState_MissionSite MissionState)
{
	local array<int> ExcludeIndices;
	ExcludeIndices = GetPrisonBreakExcludeRewards(MissionState);
	GiveRewards(NewGameState, MissionState, ExcludeIndices);

	MissionState.RemoveEntity(NewGameState);
	class'XComGameState_HeadquartersResistance'.static.RecordResistanceActivity(NewGameState, 'ResAct_Mission_PrisonBreak_Failed');

	`XEVENTMGR.TriggerEvent('PrisonBreakoutComplete', , , NewGameState);
}

static function PrisonBreakOnExpire(XComGameState NewGameState, XComGameState_MissionSite MissionState)
{
	class'XComGameState_HeadquartersResistance'.static.RecordResistanceActivity(NewGameState, 'ResAct_Mission_PrisonBreak_Failed');
}

static function PrisonBreakPopup(optional XComGameState_MissionSite MissionState)
{
	class'X2Helpers_Mission_PrisonBreak'.static.ShowMissionPrisonBreakPopup(MissionState);
}

static function array<int> GetPrisonBreakExcludeRewards(XComGameState_MissionSite MissionState)
{
	local XComGameStateHistory History;
	local XComGameState_BattleData BattleData;
	local array<int> ExcludeIndices;
	local int idx;

	History = `XCOMHISTORY;
	BattleData = XComGameState_BattleData(History.GetSingleGameStateObjectForClass(class'XComGameState_BattleData'));

	for (idx = 0; idx < BattleData.MapData.ActiveMission.MissionObjectives.Length; idx++)
	{
		// Check if any prisoners were extracted from the mission
		if (BattleData.MapData.ActiveMission.MissionObjectives[idx].ObjectiveName != 'SaveAnyPrisoners' &&
			!BattleData.MapData.ActiveMission.MissionObjectives[idx].bCompleted)
		{
			// Forfeit if ded or not extracted
			ExcludeIndices.AddItem(idx);
			`LOG(" GetPrisonBreakExcludeRewards() : Objective " $ BattleData.MapData.ActiveMission.MissionObjectives[idx].ObjectiveName $ " was not completed. Removing index " $ idx, , 'WotC_Mission_PrisonBreak');
		}
		// Special case, if this objective was completed, give intel reward
		else if(BattleData.MapData.ActiveMission.MissionObjectives[idx].ObjectiveName == 'SaveAnyPrisoners' &&
			!BattleData.MapData.ActiveMission.MissionObjectives[idx].bCompleted)
		{
			// Forfeit Intel Reward
			ExcludeIndices.AddItem(idx);
			`LOG(" GetPrisonBreakExcludeRewards() : Objective " $ BattleData.MapData.ActiveMission.MissionObjectives[idx].ObjectiveName $ " was not completed. Removing index " $ idx, , 'WotC_Mission_PrisonBreak');
		}
	}

	return ExcludeIndices;
}