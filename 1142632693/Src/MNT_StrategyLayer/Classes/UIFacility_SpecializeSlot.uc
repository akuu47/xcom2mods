//---------------------------------------------------------------------------------------
//  FILE:    UIFacility_AcademySlot.uc
//  AUTHOR:  Joe Weinhoffer
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class UIFacility_SpecializeSlot extends UIFacility_StaffSlot
	dependson(UIPersonnel);

var localized string m_strStopSpecializationTitle;
var localized string m_strStopSpecializationText;


simulated function UIStaffSlot InitStaffSlot(UIStaffContainer OwningContainer, StateObjectReference LocationRef, int SlotIndex, delegate<OnStaffUpdated> onStaffUpdatedDel)
{
	super.InitStaffSlot(OwningContainer, LocationRef, SlotIndex, onStaffUpdatedDel);
	
	return self;
}

//-----------------------------------------------------------------------------
simulated function ShowDropDown()
{
	local XComGameState_StaffSlot StaffSlot;
	local XComGameState_Unit UnitState;
	//local XComGameState_HeadquartersXCom XComHQ;
	//local XComGameState_HeadquartersProject_Specialize TrainProject;
	local string PopupText;

	StaffSlot = XComGameState_StaffSlot(`XCOMHISTORY.GetGameStateForObjectID(StaffSlotRef.ObjectID));

	if (StaffSlot.IsSlotEmpty())
	{
		StaffContainer.ShowDropDown(self);
	}
	else // Ask the user to confirm that they want to empty the slot and stop training
	{
		UnitState = StaffSlot.GetAssignedStaff();

		PopupText = m_strStopSpecializationText;
		PopupText = Repl(PopupText, "%UNITNAME", UnitState.GetName(eNameType_RankFull));

		ConfirmEmptyProjectSlotPopup(m_strStopSpecializationTitle, PopupText);
	}
}

simulated function OnPersonnelSelected(StaffUnitInfo UnitInfo)
{
	//local XComGameState_Unit Unit;
	local XComHQPresentationLayer HQPres;
	local UIChooseSpecialization SpecScreen;
	
	HQPres = `HQPRES;
	if (HQPres.ScreenStack.IsNotInStack(class'UIChooseSpecialization'))
	{
		SpecScreen = Spawn(class'UIChooseSpecialization', self);
		SpecScreen.m_UnitRef = UnitInfo.UnitRef;
		SpecScreen.m_StaffSlotRef = StaffSlotRef;
		HQPres.ScreenStack.Push(SpecScreen);
	}

}

//==============================================================================

defaultproperties
{
	//width = 370;
	width = 740;
	height = 65;
}
