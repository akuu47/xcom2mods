//----------------------------------------------------------------------------
//  *********   FIRAXIS SOURCE CODE   ******************
//  FILE:    UIChooseClass.uc
//  AUTHOR:  Joe Weinhoffer
//  PURPOSE: Screen that allows the player to select the class in which will a rookie will be trained.
//----------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//----------------------------------------------------------------------------

class UIChooseSpecialization extends UISimpleCommodityScreen;

var array<SpecializationConfig> m_arrSpecs;

var StateObjectReference m_UnitRef; // set in XComHQPresentationLayer
var StateObjectReference m_StaffSlotRef; // set in XComHQPresentationLayer

//-------------- EVENT HANDLING --------------------------------------------------------
simulated function OnPurchaseClicked(UIList kList, int itemIndex)
{
	if (itemIndex != iSelectedItem)
	{
		iSelectedItem = itemIndex;
	}

	if (CanAffordItem(iSelectedItem))
	{
		if (OnSpecializationSelected(iSelectedItem))
			Movie.Stack.Pop(self);
		//UpdateData();
	}
	else
	{
		PlayNegativeSound(); // bsg-jrebar (4/20/17): New PlayNegativeSound Function in Parent Class
	}
}

simulated function InitScreen(XComPlayerController InitController, UIMovie InitMovie, optional name InitName)
{
	super.InitScreen(InitController, InitMovie, InitName);

	ItemCard.Hide();
	Navigator.SetSelected(List);
	List.SetSelectedIndex(0);
}

simulated function PopulateData()
{
	local Commodity Template;
	local int i;

	List.ClearItems();
	List.bSelectFirstAvailable = false;
	
	for(i = 0; i < arrItems.Length; i++)
	{
		Template = arrItems[i];
		if(i < m_arrRefs.Length)
		{
			Spawn(class'UIInventory_ClassListItem', List.itemContainer).InitInventoryListCommodity(Template, m_arrRefs[i], GetButtonString(i), m_eStyle, , 126);
		}
		else
		{
			Spawn(class'UIInventory_ClassListItem', List.itemContainer).InitInventoryListCommodity(Template, , GetButtonString(i), m_eStyle, , 126);
		}
	}
}

simulated function PopulateResearchCard(optional Commodity ItemCommodity, optional StateObjectReference ItemRef)
{
}

//-------------- GAME DATA HOOKUP --------------------------------------------------------
simulated function GetItems()
{
	arrItems = ConvertSpecsToCommodities();
}

simulated function array<Commodity> ConvertSpecsToCommodities()
{
	local SpecializationConfig SpecData;
	local int iSpec;
	local array<Commodity> arrCommodoties;
	local Commodity SpecComm;
	
	m_arrSpecs.Remove(0, m_arrSpecs.Length);
	m_arrSpecs = GetSpecs();
	m_arrSpecs.Sort(SortSpecByName);

	for (iSpec = 0; iSpec < m_arrSpecs.Length; iSpec++)
	{
		SpecData = m_arrSpecs[iSpec];
		
		SpecComm.Title = Caps(SpecData.Spec);
		SpecComm.Image = SpecData.Icon;
		SpecComm.Desc = SpecData.Desc;
		SpecComm.OrderHours = class'MNT_Utility'.default.SpecTrainingDays * 24;

		arrCommodoties.AddItem(SpecComm);
	}

	return arrCommodoties;
}

//-----------------------------------------------------------------------------

//This is overwritten in the research archives. 
simulated function array<SpecializationConfig> GetSpecs()
{
	local XComGameState_HeadquartersProject_Specialize SpecProject;
	local array<SpecializationConfig> AllSpecs;
	local SpecializationConfig Spec;
	
	SpecProject = class'MNT_Utility'.static.GetSpecializeProject(m_UnitRef);

	if(SpecProject == none)
		return class'MNT_Utility'.static.GetSpecializations();
	else{
		if(SpecProject!= none && SpecProject.bForcePaused){

			AllSpecs = class'MNT_Utility'.static.GetSpecializations();

			foreach AllSpecs(Spec){
				if(Spec.Spec == SpecProject.NewSpecialization){
					AllSpecs.length = 0;
					AllSpecs.AddItem(Spec);
					return AllSpecs;
				}
			}
		}
		
		`LOG("Cleaning out possible options for a paused project");
		return class'MNT_Utility'.static.GetSpecializations();
	}
}

function int SortSpecByName(SpecializationConfig SpecA, SpecializationConfig SpecB)
{	
	local string A,B;

	A = string(SpecA.Spec);
	B = string(SpecB.Spec);

	if (A < B)
	{
		return 1;
	}
	else if (A > B)
	{
		return -1;
	}
	else
	{
		return 0;
	}
}

function bool OnSpecializationSelected(int iOption)
{
	local XComGameState NewGameState;
	local XComGameState_FacilityXCom FacilityState;
	local XComGameState_StaffSlot StaffSlotState;
	local XComGameState_HeadquartersProject_Specialize SpecializationProject;
	local StaffUnitInfo UnitInfo;

	FacilityState = XComHQ.GetFacilityByName('OfficerTrainingSchool');
	StaffSlotState = FacilityState.GetEmptyStaffSlotByTemplate('GTSStaffSlot');
	
	if (StaffSlotState != none)
	{
		// The Training project is started when the staff slot is filled. Pass in the NewGameState so the project can be found below.
		NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Staffing GTS Slot");
		UnitInfo.UnitRef = m_UnitRef;
		StaffSlotState.FillSlot(UnitInfo, NewGameState);
		
		// If a paused project already exists for this ability, resume it
		SpecializationProject = class'MNT_Utility'.static.GetPausedSpecializeProject(m_UnitRef);
		if (SpecializationProject != None)
		{
			`LOG("MNT_Utility: UIChooseSpecialization: Found a paused training project. Resuming.");
			SpecializationProject = XComGameState_HeadquartersProject_Specialize(NewGameState.ModifyStateObject(SpecializationProject.Class, SpecializationProject.ObjectID));
			SpecializationProject.bForcePaused = false;
		}
		else{
			// Otherwise start a new psi ability training project
			`LOG("MNT_Utility: UIChooseSpecialization: Did not find a paused training project. Creating new project.");

			// Find the new Training Project which was just created by filling the staff slot and set the class
			foreach NewGameState.IterateByClassType(class'XComGameState_HeadquartersProject_Specialize', SpecializationProject)
			{
				SpecializationProject.NewSpecialization = m_arrSpecs[iOption].Spec;
				break;
			}

			SpecializationProject = XComGameState_HeadquartersProject_Specialize(NewGameState.CreateNewStateObject(class'XComGameState_HeadquartersProject_Specialize'));
			SpecializationProject.NewSpecialization = m_arrSpecs[iOption].Spec;
			SpecializationProject.SetProjectFocus(UnitInfo.UnitRef, NewGameState, StaffSlotState.Facility);

			XComHQ = XComGameState_HeadquartersXCom(NewGameState.ModifyStateObject(class'XComGameState_HeadquartersXCom', XComHQ.ObjectID));
			XComHQ.Projects.AddItem(SpecializationProject.GetReference());
		}

		`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);

		`XSTRATEGYSOUNDMGR.PlaySoundEvent("StrategyUI_Staff_Assign");
		
		RefreshFacility();
	}

	return true;
}

simulated function RefreshFacility()
{
	local UIScreen QueueScreen;

	QueueScreen = Movie.Stack.GetScreen(class'UIFacility_Academy');
	if (QueueScreen != None)
		UIFacility_Academy(QueueScreen).RealizeFacility();
}

//----------------------------------------------------------------
simulated function OnCancelButton(UIButton kButton) { OnCancel(); }
simulated function OnCancel()
{
	CloseScreen();
}

//==============================================================================

simulated function OnLoseFocus()
{
	super.OnLoseFocus();
	`HQPRES.m_kAvengerHUD.NavHelp.ClearButtonHelp();
}

simulated function OnReceiveFocus()
{
	super.OnReceiveFocus();
	`HQPRES.m_kAvengerHUD.NavHelp.ClearButtonHelp();
	`HQPRES.m_kAvengerHUD.NavHelp.AddBackButton(OnCancel);
}

defaultproperties
{
	InputState = eInputState_Consume;

	bHideOnLoseFocus = true;
	//bConsumeMouseEvents = true;

	DisplayTag="UIDisplay_Academy"
	CameraTag="UIDisplay_Academy"
}
