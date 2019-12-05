//---------------------------------------------------------------------------------------
//  FILE:    XComGameState_HeadquartersProject_TrainPsion.uc
//  AUTHOR:  Mark Nauta  --  11/11/2014
//  PURPOSE: This object represents the instance data for an XCom HQ psi training project
//           Will eventually be a component
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class XComGameState_HeadquartersProject_TrainPsion extends XComGameState_HeadquartersProjectPsiTraining config(Mint_StrategyOverhaul);

//class XComGameState_HeadquartersProject_TrainPsion extends XComGameState_HeadquartersProject config(AdditionalPerks);

var name AbilityName;	// name of the ability being trained
var int NewRank;		// the new Psion rank to be achieved

var config int BasePsiOnPromotion;
var config int AveragePsiPerRank;
var config int PsiVarianceLevelUp;
var config float PotencyLossPerRank;
var config bool DebugInstantTrain;

//---------------------------------------------------------------------------------------
function SetProjectFocus(StateObjectReference FocusRef, optional XComGameState NewGameState, optional StateObjectReference AuxRef)
{

	local XComGameStateHistory History;
	local XComGameState_Unit UnitState;
	local XComGameState_GameTime TimeState;
	local XComGameState_Unit_Additional ExtraState;

	History = `XCOMHISTORY;
	ProjectFocus = FocusRef; // Unit
	AuxilaryReference = AuxRef; // Facility

	UnitState = XComGameState_Unit(NewGameState.GetGameStateForObjectID(ProjectFocus.ObjectID));
	if (UnitState == none)
		UnitState = XComGameState_Unit(History.GetGameStateForObjectID(ProjectFocus.ObjectID));

	ExtraState = class'MNT_Utility'.static.GetExtraComponent(UnitState);

	// If the soldier hasn't leveled as a psion yet
	if (ExtraState.GetPsionRank() < 1)
	{
		// Randomly choose a branch and ability from the starting tier of the psi op tree

		AbilityName = class'MNT_Utility'.static.GetAbilityName(1, `SYNC_RAND(3));
		NewRank = 1;
		ProjectPointsRemaining = CalculatePointsToTrain(true);
		ExtraState.AbilityTrainingName = AbilityName;
		UnitState.SetStatus(eStatus_PsiTesting);
	}
	else
	{
		ProjectPointsRemaining = CalculatePointsToTrain();
		UnitState.SetStatus(eStatus_PsiTraining);
		NewRank = ExtraState.GetPsionRank() + 1;
	}

	
	InitialProjectPoints = ProjectPointsRemaining;
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

	if(MakingProgress())
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
function int CalculatePointsToTrain(optional bool bClassTraining = false)
{
	local XComGameStateHistory History;
	local XComGameState_HeadquartersXCom XComHQ;

	History = `XCOMHISTORY;
	XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
	if (bClassTraining)
	{
		if(DebugInstantTrain)
			return 1;
		return class'MNT_Utility'.default.PsionTrainingDays * XComHQ.XComHeadquarters_DefaultPsiTrainingWorkPerHour * 24;
	}
	else
	{
		if(DebugInstantTrain)
			return 1;
		return (class'MNT_Utility'.default.PsionTrainingDays + Round(XComHQ.GetPsiTrainingScalar())) * XComHQ.XComHeadquarters_DefaultPsiTrainingWorkPerHour * 24;
	}
}

//---------------------------------------------------------------------------------------
function int CalculateWorkPerHour(optional XComGameState StartState = none, optional bool bAssumeActive = false)
{
	local XComGameStateHistory History;
	local XComGameState_HeadquartersXCom XComHQ;
	local int iTotalWork;

	History = `XCOMHISTORY;
	XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
	iTotalWork = XComHQ.PsiTrainingRate;

	// Can't make progress when paused
	if (bForcePaused && !bAssumeActive)
	{
		return 0;
	}

	return iTotalWork;
}

//---------------------------------------------------------------------------------------
function OnProjectCompleted()
{
	local XComGameState_Unit Unit;
	local X2AbilityTemplate AbilityTemplate;
	local XComGameStateHistory History;
	local XComGameState_HeadquartersXCom XComHQ, NewXComHQ;

	local XComGameState_Unit UpdatedUnit;
	local XComGameState_Unit_Additional ExtraState;
	local XComGameState UpdateState;
	local XComGameStateContext_ChangeContainer ChangeContainer;
	local SoldierClassAbilityType Ability;
	//local ClassAgnosticAbility NewPsionAbility;
	local XComGameState_HeadquartersProject_TrainPsion ProjectState;
	local XComGameState_StaffSlot StaffSlotState;

	Ability.AbilityName = AbilityName;
	Ability.ApplyToWeaponSlot = eInvSlot_Utility;
	Ability.UtilityCat = '';
	//NewPsionAbility.AbilityType = Ability;
	//NewPsionAbility.iRank = iAbilityRank;
	//NewPsionAbility.bUnlocked = true;

	History = `XCOMHISTORY;
	Unit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(ProjectFocus.ObjectID));
	
	ChangeContainer = class'XComGameStateContext_ChangeContainer'.static.CreateEmptyChangeContainer("Psion Training Complete");
	UpdateState = History.CreateNewGameState(true, ChangeContainer);
	UpdatedUnit = XComGameState_Unit(UpdateState.CreateStateObject(class'XComGameState_Unit', Unit.ObjectID));

	// Change class BUT NOTHING ELSE. Mostly for icon.
	if(NewRank == 1)
		PsionPromotion(UpdatedUnit);
	else
		PsionRankUp(UpdatedUnit);

	ExtraState = class'MNT_Utility'.static.GetExtraComponent(Unit);

	if(ExtraState == none)
	{
		//Add a LatentPsionic Component
		ExtraState = XComGameState_Unit_Additional(UpdateState.CreateStateObject(class'XComGameState_Unit_Additional'));
		ExtraState.InitComponent();
		UpdatedUnit.AddComponentObject(ExtraState);
	}
	else
		ExtraState = XComGameState_Unit_Additional(UpdateState.CreateStateObject(class'XComGameState_Unit_Additional', ExtraState.ObjectID));
			
	
	ExtraState.SetPsionRank(NewRank);

	if(ExtraState.HasPsionAbility(AbilityName))
		`LOG("MNT_Utility: Psion training completed, but with redundant skill. ");
	else
		ExtraState.PsionAbilities.AddItem(Ability);

	UpdatedUnit.SetStatus(eStatus_Active);

	`Log("MNT_Utility: Psion training completed. "$ ExtraState.AbilityTrainingName);

	ProjectState = XComGameState_HeadquartersProject_TrainPsion(`XCOMHISTORY.GetGameStateForObjectID(GetReference().ObjectID));
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

	ExtraState.ValidateAbilities();

	AbilityTemplate = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager().FindAbilityTemplate(AbilityName);
	UIPsiTrainingComplete(ProjectFocus, AbilityTemplate);
	
}

simulated function UIPsiTrainingComplete(StateObjectReference UnitRef, X2AbilityTemplate AbilityTemplate)
{
	local DynamicPropertySet PropertySet;
	local XComHQPresentationLayer HQPres;

	HQPres = `HQPRES;

	HQPres.BuildUIAlert(PropertySet, 'eAlert_PsiTrainingComplete', None, '', "Geoscape_CrewMemberLevelledUp", true);
	class'X2StrategyGameRulesetDataStructures'.static.AddDynamicIntProperty(PropertySet, 'UnitRef', UnitRef.ObjectID);

	class'X2StrategyGameRulesetDataStructures'.static.AddDynamicNameProperty(PropertySet, 'AbilityTemplate', AbilityTemplate.DataName);
	HQPres.QueueDynamicPopup(PropertySet);
}

//Roll for increase in psi stat
function PsionRankUp(XComGameState_Unit Unit){
	local int PsiIncrease;

	PsiIncrease = default.AveragePsiPerRank;

	if(`SYNC_RAND(2) >=1)
		PsiIncrease += (`SYNC_FRAND() * default.PsiVarianceLevelUp);
	else
		PsiIncrease -= (`SYNC_FRAND() * default.PsiVarianceLevelUp);

	Unit.SetBaseMaxStat(eStat_PsiOffense, Unit.GetBaseStat(eStat_PsiOffense) + PsiIncrease);

}

// colorize name and hair/eyes and grant initial psi stat bonus
function PsionPromotion(XComGameState_Unit Unit){

	local string fName, lName, nName;
	local int PsiIncrease;

	fName = "<font color='#C08EDA'>" $ Unit.GetFirstName() $ "</font>";
	lName = "<font color='#C08EDA'>" $ Unit.GetLastName() $ "</font>";
	nName = Unit.GetNickName();

	Unit.SetUnitName(fName, lName, nName);

	//Default psi operative colors
	Unit.kAppearance.iHairColor = 25;
	Unit.kAppearance.iEyeColor = 19;

	PsiIncrease = default.BasePsiOnPromotion;

	if(`SYNC_RAND(2) >=1)
		PsiIncrease += (`SYNC_FRAND() * default.PsiVarianceLevelUp);
	else
		PsiIncrease -= (`SYNC_FRAND() * default.PsiVarianceLevelUp);

	//If we lose points due to late psionification
	PsiIncrease *= (1 - (Unit.GetRank() * default.PotencyLossPerRank));

	Unit.SetBaseMaxStat(eStat_PsiOffense, Unit.GetBaseStat(eStat_PsiOffense) + PsiIncrease);

}










//---------------------------------------------------------------------------------------
DefaultProperties
{
}