//---------------------------------------------------------------------------------------
//  FILE:    X2StrategyElement_XpackRewards.uc
//  AUTHOR:  Mark Nauta  --  07/20/2016
//  PURPOSE: Create Xpack reward templates
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class X2StrategyElement_NewRewards extends X2StrategyElement_XpackRewards;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Rewards;

	// Covert Actions
	Rewards.AddItem(CreateLearnWeaponMasteryRewardTemplate());
	Rewards.AddItem(CreateTrainEngineerRewardTemplate());

	return Rewards;
}

// #######################################################################################
// --------------------- MASTERY SKILL REWARD --------------------------------------------
// #######################################################################################


static function X2DataTemplate CreateLearnWeaponMasteryRewardTemplate()
{
	local X2RewardTemplate Template;

	`CREATE_X2Reward_TEMPLATE(Template, 'Reward_LearnWeaponMastery');
	Template.RewardImage = "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_Intel";

	Template.GenerateRewardFn = GenerateLearnWeaponMasteryReward;
	Template.GiveRewardFn = GiveLearnWeaponMasteryReward;
	Template.GetRewardStringFn = GetLearnWeaponMasteryRewardString;
	Template.CleanUpRewardFn = CleanUpRewardWithoutRemoval;

	return Template;
}

static function GenerateLearnWeaponMasteryReward(XComGameState_Reward RewardState, XComGameState NewGameState, optional float RewardScalar = 1.0, optional StateObjectReference AuxRef)
{
	RewardState.RewardObjectReference = AuxRef;
}

static function GiveLearnWeaponMasteryReward(XComGameState NewGameState, XComGameState_Reward RewardState, optional StateObjectReference AuxRef, optional bool bOrder = false, optional int OrderHours = -1)
{
	local XComGameState_CovertAction ActionState;
	local XComGameState_StaffSlot SlotState;
	local XComGameState_Unit UnitState;
	local int idx;
	local MNT_Utility RewardUtil;
	local ClassAgnosticAbility NewWeaponAbility;
	local name AbilityName;

	ActionState = XComGameState_CovertAction(`XCOMHISTORY.GetGameStateForObjectID(RewardState.RewardObjectReference.ObjectID));
	
	if (ActionState != none)
	{
		for (idx = 0; idx < ActionState.StaffSlots.Length; idx++)
		{
			SlotState = ActionState.GetStaffSlot(idx);
			if (SlotState.IsSoldierSlot() && SlotState.IsSlotFilled())
			{
				RewardUtil = new class 'MNT_Utility';
				RewardUtil.nmFaction = ActionState.GetFaction().GetMyTemplateName();

				UnitState = SlotState.GetAssignedStaff();
				UnitState = XComGameState_Unit(NewGameState.ModifyStateObject(class'XComGameState_Unit', UnitState.ObjectID));
				
				NewWeaponAbility.AbilityType = RewardUtil.GenerateFactionAbility();
				NewWeaponAbility.iRank = 0;
				NewWeaponAbility.bUnlocked = true;

				AbilityName = NewWeaponAbility.AbilityType.AbilityName;

				if(!UnitState.HasSoldierAbility(AbilityName, true))
					UnitState.AWCAbilities.AddItem(NewWeaponAbility);

				`LOG("Learned " $ NewWeaponAbility.AbilityType.AbilityName);
				// Save the state of the unit who received the improved Combat Intelligence
				RewardState.RewardObjectReference = UnitState.GetReference();
				RewardState.RewardObjectTemplateName = NewWeaponAbility.AbilityType.AbilityName;
				break;
			}
		}
	}
}

static function string GetLearnWeaponMasteryRewardString(XComGameState_Reward RewardState)
{	
	local XComGameState_Unit UnitState;
	local XGParamTag kTag;
	local string RewardString;
	local X2AbilityTemplateManager AbilityManager;
	local X2AbilityTemplate	Template;

	UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(RewardState.RewardObjectReference.ObjectID));
	AbilityManager = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();
	Template = AbilityManager.FindAbilityTemplate(RewardState.RewardObjectTemplateName);

	RewardString = "<XGParam:StrValue0/> has learned <XGParam:StrValue1/>!";

	kTag = XGParamTag(`XEXPANDCONTEXT.FindTag("XGParam"));
	kTag.StrValue0 = UnitState.GetFullName();
	kTag.StrValue1 = Template.LocFriendlyName;

	return `XEXPAND.ExpandString(RewardString);

	return "";
}

// #######################################################################################
// --------------------- TRAIN ENGINEER ---------------------------------------------
// #######################################################################################

static function X2DataTemplate CreateTrainEngineerRewardTemplate()
{
	local X2RewardTemplate Template;

	`CREATE_X2Reward_TEMPLATE(Template, 'Reward_TrainEngineer');
	Template.RewardImage = "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_Intel";

	Template.GenerateRewardFn = GenerateTrainEngineerReward;
	Template.GiveRewardFn = GiveTrainEngineerReward;
	Template.GetRewardStringFn = GetTrainEngineerRewardString;
	Template.CleanUpRewardFn = CleanUpRewardWithoutRemoval;

	return Template;
}

static function GenerateTrainEngineerReward(XComGameState_Reward RewardState, XComGameState NewGameState, optional float RewardScalar = 1.0, optional StateObjectReference AuxRef)
{
	RewardState.RewardObjectReference = AuxRef;
}

static function GiveTrainEngineerReward(XComGameState NewGameState, XComGameState_Reward RewardState, optional StateObjectReference AuxRef, optional bool bOrder = false, optional int OrderHours = -1)
{
	local XComGameState_CovertAction ActionState;
	local XComGameState_StaffSlot SlotState;
	local XComGameState_Unit UnitState;
	local int idx;
	
	ActionState = XComGameState_CovertAction(`XCOMHISTORY.GetGameStateForObjectID(RewardState.RewardObjectReference.ObjectID));
	
	if (ActionState != none)
	{
		for (idx = 0; idx < ActionState.StaffSlots.Length; idx++)
		{
			SlotState = ActionState.GetStaffSlot(idx);
			if (SlotState.IsEngineerSlot() && SlotState.IsSlotFilled())
			{
				UnitState = SlotState.GetAssignedStaff();
				UnitState = XComGameState_Unit(NewGameState.ModifyStateObject(class'XComGameState_Unit', UnitState.ObjectID));
				
				UnitState.SetSkillLevel(UnitState.GetSkillLevel() + 1);

				// Save the state of the unit who received the improved Combat Intelligence
				RewardState.RewardObjectReference = UnitState.GetReference();
				break;
			}
		}
	}
}

static function string GetTrainEngineerRewardString(XComGameState_Reward RewardState)
{	
	local XComGameState_Unit UnitState;
	local XGParamTag kTag;
	local string RewardString;

	UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(RewardState.RewardObjectReference.ObjectID));
	
	RewardString = "<XGParam:StrValue0/> has increased in ability!";

	//if (UnitState != none)
	//{
	kTag = XGParamTag(`XEXPANDCONTEXT.FindTag("XGParam"));
	kTag.StrValue0 = UnitState.GetFullName();
	kTag.StrValue1 = string(RewardState.RewardObjectTemplateName);

	return `XEXPAND.ExpandString(RewardString);
	//}

	return "";
}



