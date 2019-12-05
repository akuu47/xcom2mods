//---------------------------------------------------------------------------------------
//  FILE:    X2StrategyElement_DefaultFacilities.uc
//  AUTHOR:  Mark Nauta
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class X2StrategyElement_AdditionalStaffSlots extends X2StrategyElement_DefaultStaffSlots config(GameData);

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> StaffSlots;

	StaffSlots.AddItem(CreateGTSStaffSlotTemplate());
	StaffSlots.AddItem(CreatePsionSoldierStaffSlotTemplate());
		
	return StaffSlots;
}

//---------------------------------------------------------------------------------------
// OFFICER TRAINING SCHOOL
//---------------------------------------------------------------------------------------
static function X2DataTemplate CreateGTSStaffSlotTemplate()
{
	local X2StaffSlotTemplate Template;

	Template = CreateStaffSlotTemplate('GTSStaffSlot');
	Template.bSoldierSlot = true;
	Template.bRequireConfirmToEmpty = true;
	Template.bPreventFilledPopup = true;
	Template.UIStaffSlotClass = class'UIFacility_SpecializeSlot';
	Template.FillFn = FillGTSSlot;
	Template.EmptyFn = EmptyGTSSlot;
	Template.EmptyStopProjectFn = EmptyStopProjectGTSSoldierSlot;
	Template.ShouldDisplayToDoWarningFn = ShouldDisplayGTSSoldierToDoWarning;
	Template.GetSkillDisplayStringFn = GetGTSSkillDisplayString;
	Template.GetBonusDisplayStringFn = GetGTSBonusDisplayString;
	Template.IsUnitValidForSlotFn = IsUnitValidForGTSSoldierSlot;
	Template.MatineeSlotName = "Soldier";

	return Template;
}

static function FillGTSSlot(XComGameState NewGameState, StateObjectReference SlotRef, StaffUnitInfo UnitInfo, optional bool bTemporary = false)
{
	local XComGameState_Unit NewUnitState;
	local XComGameState_StaffSlot NewSlotState;
	local XComGameState_HeadquartersXCom NewXComHQ;
	local XComGameState_HeadquartersProject_Specialize ProjectState;
	local StateObjectReference EmptyRef;
	local int SquadIndex;

	FillSlot(NewGameState, SlotRef, UnitInfo, NewSlotState, NewUnitState);
	NewXComHQ = GetNewXComHQState(NewGameState);
	
	ProjectState = XComGameState_HeadquartersProject_Specialize(NewGameState.CreateNewStateObject(class'XComGameState_HeadquartersProjectTrainRookie'));
	ProjectState.SetProjectFocus(UnitInfo.UnitRef, NewGameState, NewSlotState.Facility);

	NewUnitState.SetStatus(eStatus_Training);
	NewXComHQ.Projects.AddItem(ProjectState.GetReference());

	// Remove their gear
	NewUnitState.MakeItemsAvailable(NewGameState, false);
	
	// If the unit undergoing training is in the squad, remove them
	SquadIndex = NewXComHQ.Squad.Find('ObjectID', UnitInfo.UnitRef.ObjectID);
	if (SquadIndex != INDEX_NONE)
	{
		// Remove them from the squad
		NewXComHQ.Squad[SquadIndex] = EmptyRef;
	}
}

static function EmptyGTSSlot(XComGameState NewGameState, StateObjectReference SlotRef)
{
	local XComGameState_StaffSlot NewSlotState;
	local XComGameState_Unit NewUnitState;

	EmptySlot(NewGameState, SlotRef, NewSlotState, NewUnitState);

	NewUnitState.SetStatus(eStatus_Active);
}

static function EmptyStopProjectGTSSoldierSlot(StateObjectReference SlotRef)
{
	local XComGameState NewGameState;
	local XComGameState_StaffSlot SlotState;
	local XComGameState_Unit Unit;
	local XComGameState_HeadquartersProject_Specialize SpecializeProject;

	//XComHQ = class'UIUtilities_Strategy'.static.GetXComHQ();
	SlotState = XComGameState_StaffSlot(`XCOMHISTORY.GetGameStateForObjectID(SlotRef.ObjectID));
	Unit = SlotState.GetAssignedStaff();

	SpecializeProject = class'MNT_Utility'.static.GetSpecializeProject(SlotState.GetAssignedStaffRef());

	if (SpecializeProject != none)
	{
		if (Unit.GetStatus() == eStatus_Training)
		{
			`LOG("Found and pausing training specialist.");

			NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Pausing Specialization");

			SpecializeProject = XComGameState_HeadquartersProject_Specialize(NewGameState.ModifyStateObject(SpecializeProject.Class, SpecializeProject.ObjectID));
			SpecializeProject.bForcePaused = true;
			SlotState.EmptySlot(NewGameState);

			`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);
		}
	}
}

static function bool ShouldDisplayGTSSoldierToDoWarning(StateObjectReference SlotRef)
{
	return false;
}

static function bool IsUnitValidForGTSSoldierSlot(XComGameState_StaffSlot SlotState, StaffUnitInfo UnitInfo)
{
	local XComGameState_Unit Unit;

	Unit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(UnitInfo.UnitRef.ObjectID));
	
	// Can't be a rookie, and can't already be specialized
	if (Unit.CanBeStaffed()
		&& Unit.IsSoldier()
		&& Unit.IsActive()
		&& Unit.GetRank() > 0
		&& !class'MNT_Utility'.static.IsSpecialized(Unit)
		&& SlotState.GetMyTemplate().ExcludeClasses.Find(Unit.GetSoldierClassTemplateName()) == INDEX_NONE)
	{
		return true;
	}

	return false;
}

static function string GetGTSSkillDisplayString(XComGameState_StaffSlot SlotState)
{
	return "";
}

static function string GetGTSBonusDisplayString(XComGameState_StaffSlot SlotState, optional bool bPreview)
{
	local XComGameState_HeadquartersProject_Specialize TrainProject;
	local string Contribution;

	if (SlotState.IsSlotFilled())
	{
		TrainProject = class'MNT_Utility'.static.GetSpecializeProject(SlotState.GetAssignedStaffRef());

		if (TrainProject.GetSpecializationName() != '')
			Contribution = Caps(TrainProject.GetSpecializationName());
		else
			Contribution = SlotState.GetMyTemplate().BonusDefaultText;
	}

	return GetBonusDisplayString(SlotState, "%SKILL", Contribution);
}

//#############################################################################################
//----------------   PSI CHAMBER   ------------------------------------------------------------
//#############################################################################################


static function X2DataTemplate CreatePsionSoldierStaffSlotTemplate()
{
	local X2StaffSlotTemplate Template;

	Template = CreateStaffSlotTemplate('PsionStaffSlot');
	Template.bSoldierSlot = true;
	Template.bRequireConfirmToEmpty = true;
	Template.bPreventFilledPopup = true;
	Template.UIStaffSlotClass = class'UIFacility_PsionLabSlot';
	Template.AssociatedProjectClass = class'XComGameState_HeadquartersProject_TrainPsion';
	Template.FillFn = FillPsionSoldierSlot;
	Template.EmptyFn = EmptyPsionSoldierSlot;
	Template.EmptyStopProjectFn = EmptyStopProjectPsionSoldierSlot;
	Template.ShouldDisplayToDoWarningFn = ShouldDisplayPsionSoldierToDoWarning;
	Template.GetSkillDisplayStringFn = GetPsionSoldierSkillDisplayString;
	Template.GetBonusDisplayStringFn = GetPsionSoldierBonusDisplayString;
	Template.IsUnitValidForSlotFn = IsUnitValidForPsionSoldierSlot;
	Template.MatineeSlotName = "Soldier";

	return Template;
}

static function FillPsionSoldierSlot(XComGameState NewGameState, StateObjectReference SlotRef, StaffUnitInfo UnitInfo, optional bool bTemporary = false)
{
	local XComGameState_Unit NewUnitState;
	local XComGameState_StaffSlot NewSlotState;
	local XComGameState_HeadquartersXCom NewXComHQ;
	local XComGameState_HeadquartersProject_TrainPsion ProjectState;
	local StateObjectReference EmptyRef;
	local int SquadIndex;

	FillSlot(NewGameState, SlotRef, UnitInfo, NewSlotState, NewUnitState);

	if (!class'MNT_Utility'.static.IsPsion(NewUnitState)) // If the Unit is not yet a psion
	{
		NewUnitState.SetStatus(eStatus_PsiTesting);

		NewXComHQ = GetNewXComHQState(NewGameState);

		ProjectState = XComGameState_HeadquartersProject_TrainPsion(NewGameState.CreateNewStateObject(class'XComGameState_HeadquartersProject_TrainPsion'));
		ProjectState.SetProjectFocus(UnitInfo.UnitRef, NewGameState, NewSlotState.Facility);

		NewXComHQ.Projects.AddItem(ProjectState.GetReference());
		
		// Remove their gear
		NewUnitState.MakeItemsAvailable(NewGameState, false);

		// If the unit undergoing training is in the squad, remove them
		SquadIndex = NewXComHQ.Squad.Find('ObjectID', UnitInfo.UnitRef.ObjectID);
		if (SquadIndex != INDEX_NONE)
		{
			// Remove them from the squad
			NewXComHQ.Squad[SquadIndex] = EmptyRef;
		}
	}
	else // The unit is either starting or resuming an ability training project, so set their status appropriately
	{
		NewUnitState.SetStatus(eStatus_PsiTraining);
	}
}

static function EmptyPsionSoldierSlot(XComGameState NewGameState, StateObjectReference SlotRef)
{
	local XComGameState_StaffSlot NewSlotState;
	local XComGameState_Unit NewUnitState;

	EmptySlot(NewGameState, SlotRef, NewSlotState, NewUnitState);

	NewUnitState.SetStatus(eStatus_Active);
}


static function EmptyStopProjectPsionSoldierSlot(StateObjectReference SlotRef)
{
	local XComGameState NewGameState;
	local HeadquartersOrderInputContext OrderInput;
	local XComGameState_StaffSlot SlotState;
	local XComGameState_Unit Unit;
	local XComGameState_HeadquartersProject_TrainPsion PsiTrainingProject;

	//XComHQ = class'UIUtilities_Strategy'.static.GetXComHQ();
	SlotState = XComGameState_StaffSlot(`XCOMHISTORY.GetGameStateForObjectID(SlotRef.ObjectID));
	Unit = SlotState.GetAssignedStaff();

	PsiTrainingProject = class'MNT_Utility'.static.GetPsiTrainingProject(SlotState.GetAssignedStaffRef());

	if (PsiTrainingProject != none)
	{
		// If the unit is undergoing initial Psi Op training, cancel the project
		if (Unit.GetStatus() == eStatus_PsiTesting)
		{
			OrderInput.OrderType = eHeadquartersOrderType_CancelPsiTraining;
			OrderInput.AcquireObjectReference = PsiTrainingProject.GetReference();

			class'XComGameStateContext_HeadquartersOrder'.static.IssueHeadquartersOrder(OrderInput);
		}
		else if (Unit.GetStatus() == eStatus_PsiTraining)
		{
			`LOG("MNT_Utility: UIStrategyElement_PsiSoldierSlot. Found training psion. Pausing.");
			NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Pause Psi Ability Training");

			PsiTrainingProject = XComGameState_HeadquartersProject_TrainPsion(NewGameState.ModifyStateObject(PsiTrainingProject.Class, PsiTrainingProject.ObjectID));
			PsiTrainingProject.bForcePaused = true;

			SlotState.EmptySlot(NewGameState);

			`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);
		}
	}
}


static function bool ShouldDisplayPsionSoldierToDoWarning(StateObjectReference SlotRef)
{
	local XComGameStateHistory History;
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_StaffSlot SlotState;
	local XComGameState_Unit Unit;
	local StaffUnitInfo UnitInfo;
	local int i;

	History = `XCOMHISTORY;
	XComHQ = class'UIUtilities_Strategy'.static.GetXComHQ();
	SlotState = XComGameState_StaffSlot(History.GetGameStateForObjectID(SlotRef.ObjectID));

	for (i = 0; i < XComHQ.Crew.Length; i++)
	{
		UnitInfo.UnitRef = XComHQ.Crew[i];
		Unit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(XComHQ.Crew[i].ObjectID));

		if (Unit.bHasPsiGift && IsUnitValidForPsionSoldierSlot(SlotState, UnitInfo))
		{
			return true;
		}
	}

	return false;
}

static function bool IsUnitValidForPsionSoldierSlot(XComGameState_StaffSlot SlotState, StaffUnitInfo UnitInfo)
{
	local XComGameState_Unit Unit; 
	local XComGameState_Unit_Additional ExtraState;
	
	Unit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(UnitInfo.UnitRef.ObjectID));
	
	if (Unit.CanBeStaffed()
		&& Unit.IsSoldier()
		&& Unit.IsActive())
	{
		if (Unit.bHasPsiGift && !class'MNT_Utility'.static.IsPsion(Unit)) // All soldiers with "The Gift" but is not a psion yet
		{
			return true;
		}
		else if (class'MNT_Utility'.static.IsPsion(Unit)) // But Psions can only learn RANK number of abilities
		{
			ExtraState = class'MNT_Utility'.static.GetExtraComponent(Unit);
			return class'MNT_Utility'.static.CanLearnNewPsiSkill(Unit.GetRank(), ExtraState.GetPsionRank());
		}
	}

	return false;
}


static function string GetPsionSoldierBonusDisplayString(XComGameState_StaffSlot SlotState, optional bool bPreview)
{
	local XComGameState_HeadquartersProject_TrainPsion TrainProject;
	local XComGameState_Unit Unit;
	local X2AbilityTemplate AbilityTemplate;
	local string Contribution;

	if (SlotState.IsSlotFilled())
	{
		//XComHQ = class'UIUtilities_Strategy'.static.GetXComHQ();
		TrainProject = class 'MNT_Utility'.static.GetPsiTrainingProject(SlotState.GetAssignedStaffRef());
		Unit = SlotState.GetAssignedStaff();

		if (class'MNT_Utility'.static.IsPsion(Unit) && TrainProject != none)
		{
			AbilityTemplate = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager().FindAbilityTemplate(TrainProject.AbilityName);
			Contribution = Caps(AbilityTemplate.LocFriendlyName);
		}
		else
		{
			Contribution = SlotState.GetMyTemplate().BonusDefaultText;
		}
	}

	return GetBonusDisplayString(SlotState, "%SKILL", Contribution);
}


static function string GetPsionSoldierSkillDisplayString(XComGameState_StaffSlot SlotState)
{
	return "";
}
