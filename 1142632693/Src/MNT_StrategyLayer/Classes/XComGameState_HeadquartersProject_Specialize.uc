//---------------------------------------------------------------------------------------
//  FILE:    XComGameState_HeadquartersProjectTrainRookie.uc
//  AUTHOR:  Joe Weinhoffer  --  06/05/2015
//  PURPOSE: This object represents the instance data for an XCom HQ train rookie project
//           Will eventually be a component
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class XComGameState_HeadquartersProject_Specialize extends XComGameState_HeadquartersProject;

var() name NewSpecialization; // the name of the class the rookie will eventually be promoted to
var bool bForcePaused;


//---------------------------------------------------------------------------------------
// Call when you start a new project, NewGameState should be none if not coming from tactical
function SetProjectFocus(StateObjectReference FocusRef, optional XComGameState NewGameState, optional StateObjectReference AuxRef)
{
	local XComGameStateHistory History;
	local XComGameState_GameTime TimeState;
	local XComGameState_Unit UnitState;

	History = `XCOMHISTORY;
	ProjectFocus = FocusRef; // Unit
	AuxilaryReference = AuxRef; // Facility
	
	ProjectPointsRemaining = CalculatePointsToTrain();
	InitialProjectPoints = ProjectPointsRemaining;

	UnitState = XComGameState_Unit(NewGameState.GetGameStateForObjectID(ProjectFocus.ObjectID));
	UnitState.SetStatus(eStatus_Training);

	UpdateWorkPerHour(NewGameState);
	TimeState = XComGameState_GameTime(History.GetSingleGameStateObjectForClass(class'XComGameState_GameTime'));
	StartDateTime = TimeState.CurrentTime;

	if (`STRATEGYRULES != none)
	{
		if (class'X2StrategyGameRulesetDataStructures'.static.LessThan(TimeState.CurrentTime, `STRATEGYRULES.GameTime))
		{
			StartDateTime = `STRATEGYRULES.GameTime;
		}
	}
	
	if (MakingProgress())
	{
		SetProjectedCompletionDateTime(StartDateTime);
	}
	else
	{
		// Set completion time to unreachable future
		CompletionDateTime.m_iYear = 9999;
	}
}

//---------------------------------------------------------------------------------------
function int CalculatePointsToTrain()
{
	return class'MNT_Utility'.default.SpecTrainingDays * 24;
}

//---------------------------------------------------------------------------------------
function int CalculateWorkPerHour(optional XComGameState StartState = none, optional bool bAssumeActive = false)
{
	// Can't make progress when paused
	if (bForcePaused && !bAssumeActive)
	{
		return 0;
	}

	return 1;
}

//---------------------------------------------------------------------------------------
function name GetSpecializationName()
{
	return NewSpecialization;
}


//---------------------------------------------------------------------------------------
// Remove the project
function OnProjectCompleted()
{
	local XComHeadquartersCheatManager CheatMgr;
	local XComGameStateHistory History;
	local XComGameState_HeadquartersXCom XComHQ, NewXComHQ;

	local XComGameState_Unit Unit, UpdatedUnit;
	local XComGameState_Unit_Additional ExtraState;
	local XComGameState UpdateState;
	local SoldierClassAbilityType Ability;
	local ClassAgnosticAbility NewSpecPerk;
	local string PerkName;
	local XComGameStateContext_ChangeContainer ChangeContainer;
	local XComGameState_HeadquartersProject_Specialize ProjectState;
	local XComGameState_StaffSlot StaffSlotState;

	History = `XCOMHISTORY;
	Unit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(ProjectFocus.ObjectID));
	
	ChangeContainer = class'XComGameStateContext_ChangeContainer'.static.CreateEmptyChangeContainer("Specialization Complete");
	UpdateState = History.CreateNewGameState(true, ChangeContainer);
	UpdatedUnit = XComGameState_Unit(UpdateState.CreateStateObject(class'XComGameState_Unit', Unit.ObjectID));

	ExtraState = class'MNT_Utility'.static.GetExtraComponent(Unit);

	if(ExtraState == none)
	{
		ExtraState = XComGameState_Unit_Additional(UpdateState.CreateStateObject(class'XComGameState_Unit_Additional'));
		ExtraState.InitComponent();
		UpdatedUnit.AddComponentObject(ExtraState);
	}
	else
		ExtraState = XComGameState_Unit_Additional(UpdateState.CreateStateObject(class'XComGameState_Unit_Additional', ExtraState.ObjectID));

	class'MNT_Utility'.static.SetSpec(ExtraState, NewSpecialization);

	PerkName = "Specialization_" $ string(NewSpecialization);

	Ability.AbilityName = name(PerkName);
	Ability.ApplyToWeaponSlot = eInvSlot_Unknown;
	Ability.UtilityCat = '';
	NewSpecPerk.AbilityType = Ability;
	NewSpecPerk.iRank = 0;
	NewSpecPerk.bUnlocked = true;
	UpdatedUnit.AWCAbilities.AddItem(NewSpecPerk);

	UpdatedUnit.SetStatus(eStatus_Active);
	ProjectState = XComGameState_HeadquartersProject_Specialize(`XCOMHISTORY.GetGameStateForObjectID(GetReference().ObjectID));
	if (ProjectState != none)
	{
		XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
		if (XComHQ != none)
		{
			NewXComHQ = XComGameState_HeadquartersXCom(UpdateState.CreateStateObject(class'XComGameState_HeadquartersXCom', XComHQ.ObjectID));
			UpdateState.AddStateObject(NewXComHQ);
			NewXComHQ.Projects.RemoveItem(ProjectState.GetReference());
			UpdateState.RemoveStateObject(ProjectState.ObjectID);
		}

		// Remove the soldier from the staff slot
		StaffSlotState = UpdatedUnit.GetStaffSlot();
		if (StaffSlotState != none)
			StaffSlotState.EmptySlot(UpdateState);
	}

	UpdateState.AddStateObject(UpdatedUnit);
	UpdateState.AddStateObject(ExtraState);
	UpdateState.AddStateObject(ProjectState);
	`GAMERULES.SubmitGameState(UpdateState);

	CheatMgr = XComHeadquartersCheatManager(class'WorldInfo'.static.GetWorldInfo().GetALocalPlayerController().CheatManager);
	if (CheatMgr == none || !CheatMgr.bGamesComDemo)
	{
		UISpecializationComplete(UpdatedUnit, NewSpecialization);
	}
}

function UISpecializationComplete(XComGameState_Unit Unit, name NewSpec)
{
	local XComHQPresentationLayer HQPres;
	local UIAlert_Specialized Alert;

	HQPres = `HQPRES;

	Alert = HQPres.Spawn(class'UIAlert_Specialized', `HQPres);
	Alert.UnitState = Unit;
	Alert.Spec = NewSpec;
	Alert.eAlertName = 'eAlert_SoldierShakenRecovered';
	HQPres.ScreenStack.Push(Alert);
}

//---------------------------------------------------------------------------------------
DefaultProperties
{
}
