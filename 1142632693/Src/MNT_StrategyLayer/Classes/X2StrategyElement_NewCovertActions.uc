//---------------------------------------------------------------------------------------
//  FILE:    X2StrategyElement_DefaultCovertActions.uc
//  AUTHOR:  Joe Weinhoffer
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class X2StrategyElement_NewCovertActions extends X2StrategyElement;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> CovertActions;

	CovertActions.AddItem(CreateLearnWeaponMasteryTemplate());
	CovertActions.AddItem(CreateTrainEngineerTemplate());
	CovertActions.AddItem(CreateGuerillaOpTemplate());
	CovertActions.AddItem(CreateSupplyRaidTemplate());

	return CovertActions;
}

//---------------------------------------------------------------------------------------
// LEARN A NEW PERK
//---------------------------------------------------------------------------------------

static function X2DataTemplate CreateLearnWeaponMasteryTemplate()
{
	local X2CovertActionTemplate Template;
	
	`CREATE_X2TEMPLATE(class'X2CovertActionTemplate', Template, 'CovertAction_LearnWeaponMastery');

	Template.ChooseLocationFn = ChooseFactionRegion;
	Template.OverworldMeshPath = "UI_3D.Overwold_Final.CovertAction";
	Template.RequiredFactionInfluence = eFactionInfluence_Influential;

	Template.Narratives.AddItem('CAN_LearnWeaponMastery_Skirmishers');
	Template.Narratives.AddItem('CAN_LearnWeaponMastery_Reapers');
	Template.Narratives.AddItem('CAN_LearnWeaponMastery_Templars');
	
	Template.Slots.AddItem(CreateDefaultSoldierSlot('CovertActionSoldierStaffSlot', 6));
	Template.Slots.AddItem(CreateDefaultStaffSlot('CovertActionSoldierStaffSlot'));
	Template.Slots.AddItem(CreateDefaultOptionalSlot('CovertActionSoldierStaffSlot', 5, false));
	
	Template.Risks.AddItem('CovertActionRisk_SoldierWounded');
	Template.Risks.AddItem('CovertActionRisk_Ambush');

	Template.Rewards.AddItem('Reward_LearnWeaponMastery');

	return Template;
}

//---------------------------------------------------------------------------------------
// LEVEL UP AN ENGINEER
//---------------------------------------------------------------------------------------

static function X2DataTemplate CreateTrainEngineerTemplate()
{
	local X2CovertActionTemplate Template;
	
	`CREATE_X2TEMPLATE(class'X2CovertActionTemplate', Template, 'CovertAction_TrainEngineer');

	Template.ChooseLocationFn = ChooseRivalChosenHomeContinentRegion;
	Template.OverworldMeshPath = "UI_3D.Overwold_Final.CovertAction";
	Template.RequiredFactionInfluence = eFactionInfluence_Respected;
	Template.bUnique = true;

	Template.Narratives.AddItem('CAN_TrainEngineer_Skirmishers');
	Template.Narratives.AddItem('CAN_TrainEngineer_Reapers');
	Template.Narratives.AddItem('CAN_TrainEngineer_Templars');
	
	Template.Slots.AddItem(CreateDefaultStaffSlot('CovertActionEngineerStaffSlot'));
	Template.Slots.AddItem(CreateDefaultSoldierSlot('CovertActionSoldierStaffSlot', 3));
	Template.Slots.AddItem(CreateDefaultOptionalSlot('CovertActionSoldierStaffSlot', 3, false));
	
	Template.Risks.AddItem('CovertActionRisk_SoldierWounded');
	Template.Risks.AddItem('CovertActionRisk_SoldierCaptured');
	Template.Risks.AddItem('CovertActionRisk_Ambush');

	Template.Rewards.AddItem('Reward_TrainEngineer');

	return Template;
}

//---------------------------------------------------------------------------------------
// GENERATE A GUERILLA OP
//---------------------------------------------------------------------------------------

static function X2DataTemplate CreateGuerillaOpTemplate()
{
	local X2CovertActionTemplate Template;
	
	`CREATE_X2TEMPLATE(class'X2CovertActionTemplate', Template, 'CovertAction_GuerillaOp');

	Template.ChooseLocationFn = ChooseRivalChosenHomeContinentRegion;
	Template.OverworldMeshPath = "UI_3D.Overwold_Final.CovertAction";
	Template.RequiredFactionInfluence = eFactionInfluence_Respected;
	Template.bUnique = true;

	Template.Narratives.AddItem('CAN_GuerillaOp_Skirmishers');
	Template.Narratives.AddItem('CAN_GuerillaOp_Reapers');
	Template.Narratives.AddItem('CAN_GuerillaOp_Templars');
	
	Template.Slots.AddItem(CreateDefaultStaffSlot('CovertActionEngineerStaffSlot'));
	Template.Slots.AddItem(CreateDefaultStaffSlot('CovertActionScientistStaffSlot'));
	Template.Slots.AddItem(CreateDefaultOptionalSlot('CovertActionSoldierStaffSlot', 6, false));
	
	Template.Risks.AddItem('CovertActionRisk_SoldierWounded');
	Template.Risks.AddItem('CovertActionRisk_SoldierCaptured');
	Template.Risks.AddItem('CovertActionRisk_Ambush');

	Template.Rewards.AddItem('Reward_GuerillaOp');

	return Template;
}

//---------------------------------------------------------------------------------------
// GENERATE A SUPPLY RAID
//---------------------------------------------------------------------------------------

static function X2DataTemplate CreateSupplyRaidTemplate()
{
	local X2CovertActionTemplate Template;
	
	`CREATE_X2TEMPLATE(class'X2CovertActionTemplate', Template, 'CovertAction_SupplyRaid');

	Template.ChooseLocationFn = ChooseRivalChosenHomeContinentRegion;
	Template.OverworldMeshPath = "UI_3D.Overwold_Final.CovertAction";
	Template.RequiredFactionInfluence = eFactionInfluence_Respected;
	Template.bUnique = true;

	Template.Narratives.AddItem('CAN_SupplyRaid_Skirmishers');
	Template.Narratives.AddItem('CAN_SupplyRaid_Reapers');
	Template.Narratives.AddItem('CAN_SupplyRaid_Templars');
	
	Template.Slots.AddItem(CreateDefaultStaffSlot('CovertActionEngineerStaffSlot'));
	Template.Slots.AddItem(CreateDefaultStaffSlot('CovertActionScientistStaffSlot'));
	Template.Slots.AddItem(CreateDefaultOptionalSlot('CovertActionSoldierStaffSlot', 6, false));
	
	Template.Risks.AddItem('CovertActionRisk_SoldierWounded');
	Template.Risks.AddItem('CovertActionRisk_SoldierCaptured');
	Template.Risks.AddItem('CovertActionRisk_Ambush');

	Template.Rewards.AddItem('Reward_SupplyRaid');

	return Template;
}

//---------------------------------------------------------------------------------------
// DEFAULT SLOTS
//---------------------------------------------------------------------------------------

private static function CovertActionSlot CreateDefaultSoldierSlot(name SlotName, optional int iMinRank, optional bool bRandomClass, optional bool bFactionClass)
{
	local CovertActionSlot SoldierSlot;

	SoldierSlot.StaffSlot = SlotName;
	SoldierSlot.Rewards.AddItem('Reward_StatBoostHP');
	SoldierSlot.Rewards.AddItem('Reward_StatBoostAim');
	SoldierSlot.Rewards.AddItem('Reward_StatBoostMobility');
	SoldierSlot.Rewards.AddItem('Reward_StatBoostDodge');
	SoldierSlot.Rewards.AddItem('Reward_StatBoostWill');
	SoldierSlot.Rewards.AddItem('Reward_StatBoostHacking');
	SoldierSlot.Rewards.AddItem('Reward_RankUp');
	SoldierSlot.iMinRank = iMinRank;
	SoldierSlot.bChanceFame = false;
	SoldierSlot.bRandomClass = bRandomClass;
	SoldierSlot.bFactionClass = bFactionClass;

	if (SlotName == 'CovertActionRookieStaffSlot')
	{
		SoldierSlot.bChanceFame = false;
	}

	return SoldierSlot;
}

private static function CovertActionSlot CreateDefaultStaffSlot(name SlotName)
{
	local CovertActionSlot StaffSlot;
	
	// Same as Soldier Slot, but no rewards
	StaffSlot.StaffSlot = SlotName;
	StaffSlot.bReduceRisk = false;
	
	return StaffSlot;
}

private static function CovertActionSlot CreateDefaultOptionalSlot(name SlotName, optional int iMinRank, optional bool bFactionClass)
{
	local CovertActionSlot OptionalSlot;

	OptionalSlot.StaffSlot = SlotName;
	OptionalSlot.bChanceFame = false;
	OptionalSlot.bReduceRisk = true;
	OptionalSlot.iMinRank = iMinRank;
	OptionalSlot.bFactionClass = bFactionClass;

	return OptionalSlot;
}

static function ChooseFactionRegion(XComGameState NewGameState, XComGameState_CovertAction ActionState, out array<StateObjectReference> ExcludeLocations)
{
	ActionState.LocationEntity = ActionState.GetFaction().HomeRegion;
}

static function ChooseRivalChosenHomeContinentRegion(XComGameState NewGameState, XComGameState_CovertAction ActionState, out array<StateObjectReference> ExcludeLocations)
{
	local XComGameState_Continent ContinentState;
	local XComGameState_WorldRegion RegionState;
	local XComGameState_AdventChosen ChosenState;
	local array<StateObjectReference> ValidRegionRefs;
	local StateObjectReference RegionRef;
	
	ChosenState = ActionState.GetFaction().GetRivalChosen();
	RegionState = ChosenState.GetHomeRegion();

	if (RegionState != none)
	{
		ContinentState = RegionState.GetContinent();
		ValidRegionRefs.Length = 0;

		foreach ContinentState.Regions(RegionRef)
		{
			if(ChosenState.TerritoryRegions.Find('ObjectID', RegionRef.ObjectID) != INDEX_NONE)
			{
				ValidRegionRefs.AddItem(RegionRef);
			}
		}

		if(ValidRegionRefs.Length > 0)
		{
			ActionState.LocationEntity = ValidRegionRefs[`SYNC_RAND_STATIC(ValidRegionRefs.Length)];
		}
		else
		{
		ActionState.LocationEntity = ContinentState.Regions[`SYNC_RAND_STATIC(ContinentState.Regions.Length)];
	}
	}
	else
	{
		ActionState.LocationEntity = ChosenState.HomeRegion;
	}
}