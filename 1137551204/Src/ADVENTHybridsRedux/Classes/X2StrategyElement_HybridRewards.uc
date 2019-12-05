class X2StrategyElement_HybridRewards extends X2StrategyElement_DefaultRewards
	dependson(X2RewardTemplate);

	
static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Rewards;

	// Mission Rewards
	Rewards.AddItem(CreateHybridSoldierRewardTemplate()); //this is so we can rescue soldiers just captured by ADVENT

	return Rewards;
}

// #######################################################################################
// -------------------- MISSION REWARDS --------------------------------------------------
// #######################################################################################

static function X2DataTemplate CreateHybridSoldierRewardTemplate()
{
	local X2RewardTemplate Template;

	`CREATE_X2Reward_TEMPLATE(Template, 'Reward_HybridSoldier');
	Template.rewardObjectTemplateName = 'RM_HybridSoldier';

	Template.GenerateRewardFn = GeneratePersonnelReward;
	Template.SetRewardFn = SetPersonnelReward;
	Template.GiveRewardFn = GivePersonnelReward;
	Template.GetRewardStringFn = GetPersonnelRewardString;
	Template.GetRewardImageFn = GetPersonnelRewardImage;
	Template.GetBlackMarketStringFn = GetSoldierBlackMarketString;
	Template.GetRewardIconFn = GetGenericRewardIcon;
	Template.RewardPopupFn = PersonnelRewardPopup;
	Template.IsRewardAvailableFn = IsFactionSkirmishers;

	return Template;
}

static function bool IsFactionSkirmishers(optional XComGameState NewGameState, optional StateObjectReference AuxRef)
{
	local XComGameState_ResistanceFaction FactionState;

	FactionState = GetFactionState(NewGameState, AuxRef);
	if (FactionState != none)
	{
		return FactionState.GetMyTemplateName() == 'Faction_Skirmishers';
	}

	return false;
}
