//		Kismet action that will wound or kill a random staff member. This includes soldiers.
//		Contains an optional feature where the higher iIntensity is, the greater the chance of the staff member getting killed.

class SeqAct_HQWoundKillStaff extends SequenceAction config (Kismet_Action);

var bool				bTargetStaffedDefenseMatrix;		// Specifically target the defense matrix, if staffed
var int					iIntensity;							// Higher the intensity, the higher the chance that a staff member will die
var int					iDamage;							// How much health will the unforunate staff member will take
var XComGameState_Unit	Aggressor;							// The unit that instigated this attack. Used for memorial.
var private string		StaffFullName;						// Full name of the staff.	Writable
var private string		Status;								// Status of the staff.		Writable
var localized string	m_strUnitWounded;					// Custom string indicating that the unit was wounded


var config float			IntensityMultiplier;
var config int				DefaultDamage;
var config array<int>		WoundStaffMinDays;
var config array<int>		WoundStaffMaxDays;

function Activated()
{
	// If both iDamage and Aggressor is active, or if iDamage is not active but Aggressor is active
	// Override the iDamage varible to the Aggressor's Weapon Damage Value
	if ((InputLinks[1].bHasImpulse && InputLinks[2].bHasImpulse) || (!InputLinks[1].bHasImpulse && InputLinks[2].bHasImpulse))
		iDamage = X2WeaponTemplate(Aggressor.GetPrimaryWeapon().GetMyTemplate()).BaseDamage.Damage;

	// If there's no value, set to the default value
	if (iDamage <= 0)
		iDamage = DefaultDamage;

	//Set intensity to 0 if there's no impulse
	if (!InputLinks[3].bHasImpulse)
		iIntensity = 0;
}

function ModifyKismetGameState(out XComGameState GameState)
{
	local XComGameState_Unit				UnitState;
	local int								ProjectDays;
	local XGParamTag						kTag;

	UnitState = WoundRandomScientistOrEngineer(GameState, ProjectDays);

	//Fail if there was no unit state to kill/wound
	// (Probably means that there's no more staff to wound/kill)
	if (UnitState == none)
	{
		OutputLinks[0].bHasImpulse = false;
		OutputLinks[1].bHasImpulse = true;
	}
	else
	{
		//Pass outside of sequence action for message purposes.
		StaffFullName = UnitState.GetFullName();

		if (UnitState.IsDead())
		{
			kTag = XGParamTag(`XEXPANDCONTEXT.FindTag("XGParam"));
			kTag.StrValue0 = UnitState.GetFullName();

			//Write to the status string
			Status = `XEXPAND.ExpandString(`PRES.m_strUnitDied);
		}
		else	//Must be wounded, what other possibility is there?
		{
			kTag = XGParamTag(`XEXPANDCONTEXT.FindTag("XGParam"));
			kTag.StrValue0 = UnitState.GetFullName();
			kTag.StrValue1 = string(ProjectDays);

			//Write to the status string
			Status = `XEXPAND.ExpandString(m_strUnitWounded);
		}

		OutputLinks[0].bHasImpulse = true;
		OutputLinks[1].bHasImpulse = false;
	}
}

//---------------------------------------------------------------------------------------
function XComGameState_Unit WoundRandomScientistOrEngineer(XComGameState NewGameState, out int ProjectDays)
{
	local XComGameStateHistory							History;
	local XComGameState_HeadquartersXCom				XComHQ;
	local XComGameState_HeadquartersProjectHealSoldier	ProjectState;
	local XComGameState_StaffSlot						SlotState;
	local XComGameState_Unit							UnitState;
	local XComGameState_FacilityXCom					FacilityState;
	local XComGameState_BattleData						BattleData;
	local array<XComGameState_Unit>						UnstaffedSci, UnstaffedEng, StaffedSci, StaffedEng, UnstaffedSLD, StaffedSLD;
	local StateObjectReference							UnitRef;
	local bool											bCanWoundEng, bCanWoundSci, bWoundEng, bWoundSci, bWoundSLD, bCanWoundSLD, bFoundDefenseMatrixStaff;
	local int											MinDaysToAdd, MaxDaysToAdd, ProjectHours, Roll, idx;


	History = `XCOMHISTORY;

	XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
	XComHQ = XComGameState_HeadquartersXCom(NewGameState.ModifyStateObject(class'XComGameState_HeadquartersXCom', XComHQ.ObjectID));

	UnstaffedSci.Length = 0;
	UnstaffedEng.Length = 0;
	StaffedSci.Length = 0;
	StaffedEng.Length = 0;

	bWoundEng = false;
	bWoundSci = false;
	bWoundSLD = false;
	bFoundDefenseMatrixStaff = false;


	if (bTargetStaffedDefenseMatrix)
	{
		//Grab the unit that's in the staff slot of the Defense Matrix
		FacilityState = XComHQ.GetFacilityByName('UFODefense');
		if (FacilityState != none)
		{
			SlotState = FacilityState.GetStaffSlotByTemplate('UFODefenseStaffSlot');
			if (SlotState != none)
			{
				SlotState = XComGameState_StaffSlot(NewGameState.ModifyStateObject(class'XComGameState_StaffSlot', SlotState.ObjectID));

				//Grab the unit state before ejecting the slot
				UnitState = XComGameState_Unit(History.GetGameStateForObjectID(SlotState.AssignedStaff.UnitRef.ObjectID));
				SlotState.EmptySlot(NewGameState);
				bFoundDefenseMatrixStaff = true;
			}
		}
	}

	if (!bFoundDefenseMatrixStaff)
	{
		foreach XComHQ.Crew(UnitRef)
		{
			UnitState = XComGameState_Unit(History.GetGameStateForObjectID(UnitRef.ObjectID));

			if(IsStaffValidForWounding(UnitState))
			{
				if(UnitState.IsEngineer())
				{
					if(UnitState.StaffingSlot.ObjectID == 0)
					{
						UnstaffedEng.AddItem(UnitState);
					}
					else
					{
						StaffedEng.AddItem(UnitState);
					}
				}
				else if(UnitState.IsScientist())
				{
					if(UnitState.StaffingSlot.ObjectID == 0)
					{
						UnstaffedSci.AddItem(UnitState);
					}
					else
					{
						StaffedSci.AddItem(UnitState);
					}
				}
				//Consider Soldiers, Sparks, and other Robotic units
				else if (UnitState.IsSoldier())
				{
					if(UnitState.StaffingSlot.ObjectID == 0)
					{
						UnstaffedSLD.AddItem(UnitState);
					}
					else
					{
						StaffedSLD.AddItem(UnitState);
					}
				}
			}
		}

		bCanWoundSci = (UnstaffedSci.Length > 0 || StaffedSci.Length > 0);
		bCanWoundEng = (UnstaffedEng.Length > 0 || StaffedEng.Length > 0);
		bCanWoundSLD = (UnstaffedSLD.Length > 0 || StaffedSLD.Length > 0);

		if(!bCanWoundSci && !bCanWoundEng && !bCanWoundSLD)
			{ return none; } // Do not do anything else
		else
		{
			//Randomly pick one of the three categories
			Roll = `SYNC_RAND_STATIC(100);
			if (Roll <= 33 && ( bCanWoundSci && !bCanWoundEng && !bCanWoundSLD ))
			{
				bWoundEng = true;
			}
			else if ((Roll > 33 || Roll < 66) &&  (!bCanWoundSci && bCanWoundEng && !bCanWoundSLD))
			{
				bWoundSci = true;
			}
			else if (Roll >= 67 && ( !bCanWoundSci && !bCanWoundEng && bCanWoundSLD ))
			{
				bWoundSLD = true;
			}
		}

		if(bWoundEng)
		{
			if(UnstaffedEng.Length > 0)
			{
				UnitState = UnstaffedEng[`SYNC_RAND_STATIC(UnstaffedEng.Length)];
			}
			else
			{
				UnitState = StaffedEng[`SYNC_RAND_STATIC(StaffedEng.Length)];
			}
		}
		else if (bWoundSci)
		{
			if(UnstaffedSci.Length > 0)
			{
				UnitState = UnstaffedSci[`SYNC_RAND_STATIC(UnstaffedSci.Length)];
			}
			else
			{
				UnitState = StaffedSci[`SYNC_RAND_STATIC(StaffedSci.Length)];
			}
		}
		else if (bWoundSLD)
		{
			if(UnstaffedSci.Length > 0)
			{
				UnitState = UnstaffedSLD[`SYNC_RAND_STATIC(UnstaffedSLD.Length)];
			}
			else
			{
				UnitState = StaffedSLD[`SYNC_RAND_STATIC(StaffedSLD.Length)];
			}
		}
		else //At this point if we still don't have a unit state for any of the categories, return with nothing
		{
			return none; 
		}

		UnitState = XComGameState_Unit(NewGameState.ModifyStateObject(class'XComGameState_Unit', UnitState.ObjectID));
		SlotState = UnitState.GetStaffSlot();

		if(SlotState != none)
		{
			SlotState = XComGameState_StaffSlot(NewGameState.ModifyStateObject(class'XComGameState_StaffSlot', SlotState.ObjectID));
			SlotState.EmptySlot(NewGameState);
		}
	}

	//Roll dice. If the dice is greater than the current intensity * Multiplier, damage the unit.
	if (`SYNC_RAND_STATIC(100) > Round(default.IntensityMultiplier * default.iIntensity))
		UnitState.SetCurrentStat(eStat_HP, (UnitState.GetCurrentStat(eStat_HP) - default.iDamage));
	else	//Instantly kill the unit
		UnitState.SetCurrentStat(eStat_HP, -UnitState.GetCurrentStat(eStat_HP));

	// If the unit is not dead, then create infirmary project for unit
	if (UnitState.GetCurrentStat(eStat_HP) > 0)
	{
		ProjectState = XComGameState_HeadquartersProjectHealSoldier(NewGameState.CreateNewStateObject(class'XComGameState_HeadquartersProjectHealSoldier'));
		ProjectState.SetProjectFocus(UnitState.GetReference(), NewGameState);
		ProjectDays = ProjectState.GetProjectNumDaysRemaining();
		MinDaysToAdd = `ScaleStrategyArrayInt(default.WoundStaffMinDays);
		MinDaysToAdd = Clamp((MinDaysToAdd - ProjectDays), 0, MinDaysToAdd);
		MaxDaysToAdd = `ScaleStrategyArrayInt(default.WoundStaffMaxDays);
		MaxDaysToAdd = Clamp((MaxDaysToAdd - ProjectDays), 0, MaxDaysToAdd);
		ProjectState.AddRecoveryDays(`SYNC_RAND_STATIC(MaxDaysToAdd - MinDaysToAdd + 1));
		ProjectDays = ProjectState.GetProjectNumDaysRemaining();
		ProjectHours = ProjectState.GetProjectedNumHoursRemaining();

		if(ProjectHours > (ProjectDays * 24))
		{
			ProjectDays++;
		}

		XComHQ.Projects.AddItem(ProjectState.GetReference());
	}
	else				//The unit was killed
	{
		//Handle death and if was wounded previously, remove the project to heal this unit.
		BattleData = XComGameState_BattleData(History.GetSingleGameStateObjectForClass(class'XComGameState_BattleData'));
		UnitState.m_strKIAOp = BattleData.m_strOpName;
		UnitState.m_KIADate = BattleData.LocalTime;

		//Create Cause of Death string
		UnitState.m_strCauseOfDeath = class'UIBarMemorial_Details'.static.FormatCauseOfDeath( UnitState, Aggressor, NewGameState.GetContext() );
		UnitState.bBodyRecovered = true;

		XComHQ.RemoveFromCrew(UnitState.GetReference());
		for (idx = 0; idx < XComHQ.Projects.Length; idx++)
		{
			ProjectState = XComGameState_HeadquartersProjectHealSoldier(History.GetGameStateForObjectID(XComHQ.Projects[idx].ObjectID));
			if (ProjectState != none)
			{
				if (UnitState.ObjectID == ProjectState.ProjectFocus.ObjectID)
				{
					XComHQ.Projects.RemoveItem(ProjectState.GetReference());
					break;
				}
			}
		}	

	}

	return UnitState;
}

//---------------------------------------------------------------------------------------
private static function bool IsStaffValidForWounding(XComGameState_Unit UnitState)
{
	return (UnitState != none &&
			((UnitState.IsEngineer() && UnitState.GetMyTemplateName() != 'HeadEngineer') ||
			(UnitState.IsScientist() && UnitState.GetMyTemplateName() != 'HeadScientist') ||
			(UnitState.IsSoldier()	 && UnitState.GetMyTemplateName() != 'StrategyCentral') ||
			(UnitState.IsSoldier()	 && UnitState.GetMyTemplateName() != 'TutorialCentral')
			));
}

defaultproperties
{
	ObjName = "Avenger - Wound or Kill Staff Member"
	ObjCategory = "WotC Mission Overhaul"
	bCallHandler = false

	bConvertedForReplaySystem = true
	bCanBeUsedForGameplaySequence = true
	bAutoActivateOutputLinks = false

	OutputLinks(0) = (LinkDesc = "Success")
	OutputLinks(1) = (LinkDesc = "Failed")

	VariableLinks(0) = (ExpectedType = class'SeqVar_Bool',		LinkDesc = "Target Defense Matrix Staff Member",	PropertyName = bTargetStaffedDefenseMatrix)
	VariableLinks(1) = (ExpectedType = class'SeqVar_Int',		LinkDesc = "Damage",								PropertyName = iDamage)
	VariableLinks(2) = (ExpectedType = class'SeqVar_GameUnit',	LinkDesc = "Attacking Unit",						PropertyName = Aggressor)
	VariableLinks(3) = (ExpectedType = class'SeqVar_Int',		LinkDesc = "Intensity",								PropertyName = iIntensity,		bWriteable = true)
	VariableLinks(4) = (ExpectedType = class'SeqVar_String',	LinkDesc = "Staff Name",							PropertyName = StaffFullName,	bWriteable = true)
	VariableLinks(5) = (ExpectedType = class'SeqVar_String',	LinkDesc = "Status",								PropertyName = Status,			bWriteable = true)

}