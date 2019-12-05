//---------------------------------------------------------------------------------------
//  FILE:    X2StrategyElement_Rewards_PrisonBreak.uc
//  AUTHOR:  E3245
//  PURPOSE: Creates rewards for completion of Covert Ops/Prison Break mission.
//           
//---------------------------------------------------------------------------------------
class X2StrategyElement_Rewards_PrisonBreak extends X2StrategyElement_XPACKRewards
	dependson(X2RewardTemplate)
	config(GameData);

var config int MinPrisonBreakDuration;
var config int MaxPrisonBreakDuration;
var config int RequiredForceLevel;

var config int CapturedUnitThreshold;
var config int ChanceForChosenCapturedSoldier;
var config int ChanceForADVENTCapturedSoldier;
var config int ChanceForRandomHighRankSoldier;
var config int ChanceForRandomRookie;
var config int ChanceForRandomFactionSoldier;
var config int ChanceForRandomScientist;
var config int ChanceForRandomEngineer;
var config int ChanceForReward;
var config bool bEnableRewardChanceForStandardMission;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Rewards;

	//Missions
	Rewards.AddItem(CreatePrisonBreakMissionRewardTemplate());

	return Rewards;
}

static function X2DataTemplate CreatePrisonBreakMissionRewardTemplate()
{
	local X2RewardTemplate Template;

	Template= new(None, string('Reward_Mission_PrisonBreakRescue')) class'X2RewardTemplate'; Template.SetTemplateName('Reward_Mission_PrisonBreakRescue');;;

	Template.GiveRewardFn = GiveRescueSoldierReward;
	Template.GetRewardStringFn = GetMissionRewardString;
	Template.RewardPopupFn = MissionRewardPopup;
//	Template.IsRewardAvailableFn = IsPrisonMissionAvailable;

	return Template;
}

//
// Prison Break - Reward - Rescue Soldier Mission
// --------------------------------------------------
static function bool IsPrisonMissionAvailable(optional XComGameState NewGameState, optional StateObjectReference AuxRef)
{
	local XComGameStateHistory						History;
	local XComGameState_CovertAction				ActionState;
	local XComGameState_HeadquartersAlien			AlienHQ;
	local XComGameState_CampaignSettings			CampaignSettings;
	local XComGameState_MissionSite					MissionState;

	History = `XCOMHISTORY;
	AlienHQ = XComGameState_HeadquartersAlien(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersAlien'));

	//Disable this reward until Mox is rescued to prevent duplication bugs.
	CampaignSettings = XComGameState_CampaignSettings(History.GetSingleGameStateObjectForClass(class'XComGameState_CampaignSettings'));
	if (CampaignSettings.bXPackNarrativeEnabled || !(class'XComGameState_HeadquartersXCom'.static.IsObjectiveCompleted('XP0_M4_RescueMoxComplete')))
	{
		return false;
	}

	if(AlienHQ.GetForceLevel() < default.RequiredForceLevel)
		return false;

	foreach History.IterateByClassType(class'XComGameState_CovertAction', ActionState)
	{
		if(ActionState.GetMyTemplateName() == 'CovertAction_PrisonBreakMission' && (ActionState.bStarted || ActionState.bCompleted)) //this is dumb but we have to account for this
			return false;
	}

	//Disable spawning this reward if an existing mission of this type already exists
	foreach History.IterateByClassType(class'XComGameState_MissionSite', MissionState)
	{
		if (MissionState.Source == 'MissionSource_RescuePrisonBreak')
			return false;
	}

	return true;
}

static function GiveRescueSoldierReward(XComGameState NewGameState, XComGameState_Reward RewardState, optional StateObjectReference AuxRef, optional bool bOrder = false, optional int OrderHours = -1)
{
	local XComGameState_MissionSite					MissionState;
	local XComGameState_WorldRegion					RegionState;
	local XComGameState_Reward						MissionRewardState;
	local XComGameState_CovertAction				ActionState;
	local X2RewardTemplate							RewardTemplate;
	local X2StrategyElementTemplateManager			StratMgr;
	local X2MissionSourceTemplate					MissionSource;
	local array<XComGameState_Reward>				MissionRewards;
	local array<XComGameState_WorldRegion>			ContactRegions;
	local XComGameState_AdventChosen				ChosenState;
	local XComGameState_HeadquartersAlien			AlienHQ;
	local XComGameStateHistory						History;
	local XComGameState_HeadquartersResistance		ResHQ;

	local int										IteratorCapturedUnitsChosen;
	local int										MaxNumberOfPrisoners;

	local float										MissionDuration;
	local int										i, index;
	local string									PrisonerTag;


	History = `XCOMHISTORY;
	StratMgr = class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager();
	ResHQ = class'UIUtilities_Strategy'.static.GetResistanceHQ();
	ActionState = XComGameState_CovertAction(`XCOMHISTORY.GetGameStateForObjectID(AuxRef.ObjectID));
	RegionState = ActionState.GetWorldRegion();

	if(RegionState == none)
	{
		foreach `XCOMHistory.IterateByClassType(class'XComGameState_WorldRegion', RegionState)
		{
			ContactRegions.AddItem(RegionState);
		}
		RegionState = ContactRegions[`SYNC_RAND_STATIC(ContactRegions.Length)];
	}

	//Firstly, get the max number of captured soldiers by one particular Chosen Faction or ADVENT
	ChosenState = ActionState.GetFaction().GetRivalChosen();
	AlienHQ = XComGameState_HeadquartersAlien(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersAlien'));

	MaxNumberOfPrisoners = ChosenState.CapturedSoldiers.Length + AlienHQ.CapturedSoldiers.Length;
	//If for some reason we don't have enough soldiers to fill all 6 slots, fill it with random recruits/HVTs
	if (ChosenState.CapturedSoldiers.Length < 6)
		IteratorCapturedUnitsChosen = ChosenState.CapturedSoldiers.Length;
	else
		//Cap at 6 units
		IteratorCapturedUnitsChosen = 6;

	//For the tactical tags. Concatenate the variable index to end of string, up to 5. This is used for the objective tags from MissionDef.ini.
	PrisonerTag = "Prisoner_0";
	index = 0;

	//Reset Mission Rewards
	MissionRewards.Length = 0;

	//Set the first reward as the intel reward, because it's Objective 0
	RewardTemplate = X2RewardTemplate(StratMgr.FindStrategyElementTemplate('Reward_Intel'));
	MissionRewardState = RewardTemplate.CreateInstanceFromTemplate(NewGameState);
	MissionRewardState.GenerateReward(NewGameState, ResHQ.GetMissionResourceRewardScalar(RewardState), RegionState.GetReference()); // Gib Intel
	MissionRewards.AddItem(MissionRewardState);

	//If the number of prisoners from both the rival chosen and ADVENT is greater than the set threshold, the standard mission takes priority.

	if(MaxNumberOfPrisoners >= default.CapturedUnitThreshold)
	{
	//
	//BEGIN STANDARD MISSION
	//
		`log(" GiveRescueSoldierReward() : Generating Standard Rescue Prisoners",, 'WotC_Mission_PrisonBreak');
		//Generate however many prisoners for the mission
		for (i = 0; i < IteratorCapturedUnitsChosen; i++)
		{
			RewardTemplate = X2RewardTemplate(StratMgr.FindStrategyElementTemplate('Reward_ChosenSoldierCaptured'));
			MissionRewardState = RewardTemplate.CreateInstanceFromTemplate(NewGameState);
			MissionRewardState.GenerateReward(NewGameState, , RegionState.GetReference()); // Gib Chosen Captured Soldier
			//Add tag to unit and iterate
			AddTacticalTagToRewardUnit(NewGameState, RewardState, name(PrisonerTag $ index)); 	index++;
			MissionRewards.AddItem(MissionRewardState);
		}
		//If we run out of captured units by the chosen and have some slots left, then check and add captured units by ADVENT.
		if (MissionRewards.Length < 7)
		{
			//Start from where we left off
			for (i = IteratorCapturedUnitsChosen; i < 6; i++)
			{
				if (AlienHQ.CapturedSoldiers.Length > 0)
				{
					RewardTemplate = X2RewardTemplate(StratMgr.FindStrategyElementTemplate('Reward_SoldierCaptured'));
					MissionRewardState = RewardTemplate.CreateInstanceFromTemplate(NewGameState);
					MissionRewardState.GenerateReward(NewGameState, , RegionState.GetReference()); // Gib ADVENT Prisoner
					//Add tag to unit and iterate
					AddTacticalTagToRewardUnit(NewGameState, RewardState, name(PrisonerTag $ index)); 	index++;
					MissionRewards.AddItem(MissionRewardState);
				}
				else
				{
					//There are no more captured units
					break;
				}
			}
		}
		//If there are no more captured units at all, then start creating either random soldiers or random personnel until all of the rewards are filled.
		while (MissionRewards.Length < 7)
		{
			//Choose between random rookies and high ranking soldiers
			if (`SYNC_RAND_STATIC(100) < default.ChanceForRandomHighRankSoldier)
			{
				RewardTemplate = X2RewardTemplate(StratMgr.FindStrategyElementTemplate('Reward_Soldier'));
				MissionRewardState = RewardTemplate.CreateInstanceFromTemplate(NewGameState);
				MissionRewardState.GenerateReward(NewGameState, ResHQ.GetMissionResourceRewardScalar(RewardState), RegionState.GetReference()); // Gib High Ranking Soldier
				//Add tag to unit and iterate
				AddTacticalTagToRewardUnit(NewGameState, RewardState, name(PrisonerTag $ index)); 	index++;
				MissionRewards.AddItem(MissionRewardState);
			}
			//Choose between random rookies and high ranking soldiers
			else if (`SYNC_RAND_STATIC(100) < default.ChanceForRandomFactionSoldier)
			{
				RewardTemplate = X2RewardTemplate(StratMgr.FindStrategyElementTemplate('Reward_ExtraFactionSoldier'));
				MissionRewardState = RewardTemplate.CreateInstanceFromTemplate(NewGameState);
				MissionRewardState.GenerateReward(NewGameState, ResHQ.GetMissionResourceRewardScalar(RewardState), RegionState.GetReference()); // Gib Faction Soldier
				//Add tag to unit and iterate
				AddTacticalTagToRewardUnit(NewGameState, RewardState, name(PrisonerTag $ index)); 	index++;
				MissionRewards.AddItem(MissionRewardState);
			}
			//Choose between random rookies and high ranking soldiers
			else if (`SYNC_RAND_STATIC(100) < default.ChanceForRandomScientist)
			{
				RewardTemplate = X2RewardTemplate(StratMgr.FindStrategyElementTemplate('Reward_Scientist'));
				MissionRewardState = RewardTemplate.CreateInstanceFromTemplate(NewGameState);
				MissionRewardState.GenerateReward(NewGameState, ResHQ.GetMissionResourceRewardScalar(RewardState), RegionState.GetReference()); // Gib Scientist
				//Add tag to unit and iterate
				AddTacticalTagToRewardUnit(NewGameState, RewardState, name(PrisonerTag $ index)); 	index++;
				MissionRewards.AddItem(MissionRewardState);
			}
			//Choose between random rookies and high ranking soldiers
			else if (`SYNC_RAND_STATIC(100) < default.ChanceForRandomEngineer)
			{
				RewardTemplate = X2RewardTemplate(StratMgr.FindStrategyElementTemplate('Reward_Engineer'));
				MissionRewardState = RewardTemplate.CreateInstanceFromTemplate(NewGameState);
				MissionRewardState.GenerateReward(NewGameState, ResHQ.GetMissionResourceRewardScalar(RewardState), RegionState.GetReference()); // Gib Engineer
				//Add tag to unit and iterate
				AddTacticalTagToRewardUnit(NewGameState, RewardState, name(PrisonerTag $ index)); 	index++;
				MissionRewards.AddItem(MissionRewardState);
			}
			else if (`SYNC_RAND_STATIC(100) < default.ChanceForRandomRookie)
			{
				RewardTemplate = X2RewardTemplate(StratMgr.FindStrategyElementTemplate('Reward_Rookie'));
				MissionRewardState = RewardTemplate.CreateInstanceFromTemplate(NewGameState);
				MissionRewardState.GenerateReward(NewGameState, ResHQ.GetMissionResourceRewardScalar(RewardState), RegionState.GetReference()); // Gib Random Rookie
				//Add tag to unit and iterate
				AddTacticalTagToRewardUnit(NewGameState, RewardState, name(PrisonerTag $ index)); 	index++;
				MissionRewards.AddItem(MissionRewardState);
			}
		}
	//
	//END STANDARD MISSION
	//
	}
	// Otherwise, generate soldiers for Variety 01
	else
	{
	//
	//BEGIN VARIETY 01
	//
		`log(" GiveRescueSoldierReward() : Generating Variety Mission 01: Rescue Random Prisoners", , 'WotC_Mission_PrisonBreak');
		//Generate however many prisoners for the mission
		for (i = 0; i < 6; i++)
		{

			if (`SYNC_RAND_STATIC(100) < default.ChanceForReward)
			{
				if (`SYNC_RAND_STATIC(100) < default.ChanceForChosenCapturedSoldier)
				{
					RewardTemplate = X2RewardTemplate(StratMgr.FindStrategyElementTemplate('Reward_ChosenSoldierCaptured'));
					MissionRewardState = RewardTemplate.CreateInstanceFromTemplate(NewGameState);
					MissionRewardState.GenerateReward(NewGameState, , RegionState.GetReference()); // Gib Chosen Captured Soldier
					//Add tag to unit and iterate
					AddTacticalTagToRewardUnit(NewGameState, RewardState, name(PrisonerTag $ index)); 	index++;
					MissionRewards.AddItem(MissionRewardState);
				}
				else if (`SYNC_RAND_STATIC(100) < default.ChanceForADVENTCapturedSoldier)
				{
					RewardTemplate = X2RewardTemplate(StratMgr.FindStrategyElementTemplate('Reward_SoldierCaptured'));
					MissionRewardState = RewardTemplate.CreateInstanceFromTemplate(NewGameState);
					MissionRewardState.GenerateReward(NewGameState, , RegionState.GetReference()); // Gib ADVENT Prisoner
					//Add tag to unit and iterate
					AddTacticalTagToRewardUnit(NewGameState, RewardState, name(PrisonerTag $ index)); 	index++;
					MissionRewards.AddItem(MissionRewardState);
				}
				//Choose between random rookies and high ranking soldiers
				else if (`SYNC_RAND_STATIC(100) < default.ChanceForRandomHighRankSoldier)
				{
					RewardTemplate = X2RewardTemplate(StratMgr.FindStrategyElementTemplate('Reward_Soldier'));
					MissionRewardState = RewardTemplate.CreateInstanceFromTemplate(NewGameState);
					MissionRewardState.GenerateReward(NewGameState, ResHQ.GetMissionResourceRewardScalar(RewardState), RegionState.GetReference()); // Gib High Ranking Soldier
					//Add tag to unit and iterate
					AddTacticalTagToRewardUnit(NewGameState, RewardState, name(PrisonerTag $ index)); 	index++;
					MissionRewards.AddItem(MissionRewardState);
				}
				//Choose between random rookies and high ranking soldiers
				else if (`SYNC_RAND_STATIC(100) < default.ChanceForRandomFactionSoldier)
				{
					RewardTemplate = X2RewardTemplate(StratMgr.FindStrategyElementTemplate('Reward_ExtraFactionSoldier'));
					MissionRewardState = RewardTemplate.CreateInstanceFromTemplate(NewGameState);
					MissionRewardState.GenerateReward(NewGameState, ResHQ.GetMissionResourceRewardScalar(RewardState), RegionState.GetReference()); // Gib Faction Soldier
					//Add tag to unit and iterate
					AddTacticalTagToRewardUnit(NewGameState, RewardState, name(PrisonerTag $ index)); 	index++;
					MissionRewards.AddItem(MissionRewardState);
				}
				//Choose between random rookies and high ranking soldiers
				else if (`SYNC_RAND_STATIC(100) < default.ChanceForRandomScientist)
				{
					RewardTemplate = X2RewardTemplate(StratMgr.FindStrategyElementTemplate('Reward_Scientist'));
					MissionRewardState = RewardTemplate.CreateInstanceFromTemplate(NewGameState);
					MissionRewardState.GenerateReward(NewGameState, ResHQ.GetMissionResourceRewardScalar(RewardState), RegionState.GetReference()); // Gib Scientist
					//Add tag to unit and iterate
					AddTacticalTagToRewardUnit(NewGameState, RewardState, name(PrisonerTag $ index)); 	index++;
					MissionRewards.AddItem(MissionRewardState);
				}
				//Choose between random rookies and high ranking soldiers
				else if (`SYNC_RAND_STATIC(100) < default.ChanceForRandomEngineer)
				{
					RewardTemplate = X2RewardTemplate(StratMgr.FindStrategyElementTemplate('Reward_Engineer'));
					MissionRewardState = RewardTemplate.CreateInstanceFromTemplate(NewGameState);
					MissionRewardState.GenerateReward(NewGameState, ResHQ.GetMissionResourceRewardScalar(RewardState), RegionState.GetReference()); // Gib Engineer
					//Add tag to unit and iterate
					AddTacticalTagToRewardUnit(NewGameState, RewardState, name(PrisonerTag $ index)); 	index++;
					MissionRewards.AddItem(MissionRewardState);
				}
				//Choose between random rookies and high ranking soldiers
				else if (`SYNC_RAND_STATIC(100) < default.ChanceForRandomRookie)
				{
					RewardTemplate = X2RewardTemplate(StratMgr.FindStrategyElementTemplate('Reward_Rookie'));
					MissionRewardState = RewardTemplate.CreateInstanceFromTemplate(NewGameState);
					MissionRewardState.GenerateReward(NewGameState, ResHQ.GetMissionResourceRewardScalar(RewardState), RegionState.GetReference()); // Gib Random Rookie
					//Add tag to unit and iterate
					AddTacticalTagToRewardUnit(NewGameState, RewardState, name(PrisonerTag $ index)); 	index++;
					MissionRewards.AddItem(MissionRewardState);
				}
			}
		}
		//If nothing has been picked for a reward (very rare case), then generate one rookie reward
		if(MissionRewards.Length == 1)
		{
			//Add 6 rookies
			for (i = 0; i < 6; i++)
			{
				RewardTemplate = X2RewardTemplate(StratMgr.FindStrategyElementTemplate('Reward_Rookie'));
				MissionRewardState = RewardTemplate.CreateInstanceFromTemplate(NewGameState);
				MissionRewardState.GenerateReward(NewGameState, ResHQ.GetMissionResourceRewardScalar(RewardState), RegionState.GetReference()); // Gib Random Rookie
				//Add tag to unit and iterate
				AddTacticalTagToRewardUnit(NewGameState, RewardState, name(PrisonerTag $ index)); 	index++;
				MissionRewards.AddItem(MissionRewardState);
			}
		}
	//
	//END VARIETY 01
	//
	}

	`LOG(" GiveRescueSoldierReward() : Generated " $ MissionRewards.Length $ " rewards for Prison Break mission", , 'WotC_Mission_PrisonBreak');
	//Calculate Duration
	MissionDuration = float((default.MissionMinDuration + `SYNC_RAND_STATIC(default.MissionMaxDuration - default.MissionMinDuration + 1)) * 3600);

	`LOG(" GiveRescueSoldierReward() : Mission Expiry: " $ MissionDuration, , 'WotC_Mission_PrisonBreak');	

	MissionSource = X2MissionSourceTemplate(StratMgr.FindStrategyElementTemplate('MissionSource_RescuePrisonBreak'));

	MissionState = XComGameState_MissionSite_PrisonBreak(NewGameState.CreateNewStateObject(class'XComGameState_MissionSite_PrisonBreak'));
	MissionState.BuildMission(MissionSource, RegionState.GetRandom2DLocationInRegion(), RegionState.GetReference(), MissionRewards, true, true, , MissionDuration);
	// Set this mission as associated with the Faction whose Covert Action spawned it
	MissionState.ResistanceFaction = ActionState.Faction;

	// Then overwrite the reward reference so the mission is properly awarded when the Action completes
	RewardState.RewardObjectReference = MissionState.GetReference();

	`XEVENTMGR.TriggerEvent('PrisonBreakMissionSpawned', , , NewGameState);
}

private static function AddTacticalTagToRewardUnit(XComGameState NewGameState, XComGameState_Reward RewardState, name TacticalTag)
{
	local XComGameState_Unit UnitState;

	UnitState = XComGameState_Unit(NewGameState.GetGameStateForObjectID(RewardState.RewardObjectReference.ObjectID));
	if (UnitState != none)
	{
		UnitState.TacticalTag = TacticalTag;
	}
}