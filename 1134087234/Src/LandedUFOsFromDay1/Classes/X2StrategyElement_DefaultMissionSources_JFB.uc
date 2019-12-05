class X2StrategyElement_DefaultMissionSources_JFB extends X2StrategyElement_DefaultMissionSources config(GameData);

static function CreateSupplyRaidMission(XComGameState NewGameState, int MissionMonthIndex)
{
	local XComGameState_Reward RewardState;
	local X2RewardTemplate RewardTemplate;
	local X2StrategyElementTemplateManager StratMgr;
	local array<XComGameState_Reward> MissionRewards;
	local StateObjectReference RegionRef;
	local Vector2D v2Loc;
	local XComGameState_MissionSite MissionState;
	local X2MissionSourceTemplate MissionSource;
	local XComGameState_MissionCalendar CalendarState;

	CalendarState = GetMissionCalendar(NewGameState);
	StratMgr = class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager();
	RewardTemplate = X2RewardTemplate(StratMgr.FindStrategyElementTemplate('Reward_None'));

	MissionRewards.Length = 0;
	RewardState = RewardTemplate.CreateInstanceFromTemplate(NewGameState);
	NewGameState.AddStateObject(RewardState);
	MissionRewards.AddItem(RewardState);
	
	// Roll on whether this should be a Supply Raid or Landed UFO mission
	if (class'X2StrategyGameRulesetDataStructures'.static.Roll(default.PercentChanceLandedUFO))
	{
		MissionSource = X2MissionSourceTemplate(StratMgr.FindStrategyElementTemplate('MissionSource_LandedUFO'));
	}
	else
	{
		MissionSource = X2MissionSourceTemplate(StratMgr.FindStrategyElementTemplate('MissionSource_SupplyRaid'));
	}

	// Build Mission, region and loc will be determined later so defer computing biome/plot data
	MissionState = XComGameState_MissionSite(NewGameState.CreateStateObject(class'XComGameState_MissionSite'));
	NewGameState.AddStateObject(MissionState);
	MissionState.BuildMission(MissionSource, v2Loc, RegionRef, MissionRewards, false, false, , , , , false);
	CalendarState.CurrentMissionMonth[MissionMonthIndex].Missions.AddItem(MissionState.GetReference());

	CalendarState.CreatedMissionSources.AddItem(MissionSource.DataName);
}