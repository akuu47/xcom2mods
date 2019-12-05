//---------------------------------------------------------------------------------------
//  FILE:    MNT_Utility.uc
//  AUTHOR:  Ziodyne, shamelessly borrowing much code from Amineri (Long War Studios)
//  PURPOSE:	This container holds config, localization, and utility code for the Psion system
//				and all other manners of perk-granting additions made to base XCOM
//           
//---------------------------------------------------------------------------------------
class MNT_Utility extends Object config(Mint_StrategyOverhaul);

// #######################################################################################
// ----------------------- STRUCTS/VARS --------------------------------------------------
// #######################################################################################

struct PsionAbilityConfig
{
	var int Rank;
	var int Option;
	var name AbilityName;
};

struct SpecializationConfig
{
	var name Spec;
	var string Icon;
	var string Desc;
	var array<SoldierClassAbilityType> SpecPerks;
};

///////////////////////////////
// Ability tree
var config array<PsionAbilityConfig> PsionAbilityTree;
var config array<SpecializationConfig> Specializations;

///////////////////////////////
// Content 

var protected config array<string> PsionRankIcons;		//imagepaths to rank icons -- img:/// part not part of config file
var protected config string PsionClassIcon;				//imagepath to Psion class icon

///////////////////////////////
// Config 

var protected config array<int> RequiredRankPerPsionRank;		//  the minimum regular soldier rank required for each Psion rank

///////////////////////////////
// Localization 

var protected localized array<string> PsionRankNames;       //  there should be one name for each rank; e.g. Rookie, Squaddie, etc.
var protected localized array<string> PsionShortNames;      //  the abbreviated rank name; e.g. Rk., Sq., etc.
var localized string PsionDescription;					//  the class description for a psion

///////////////////////////////
// Covert Action related 

var name nmFaction;

var config array<SoldierClassAbilityType> SkirmisherReward;
var config array<SoldierClassAbilityType> ReaperReward;
var config array<SoldierClassAbilityType> TemplarReward;

///////////////////////////////
// more values to access

var config int SpecTrainingDays;
var config int PsionTrainingDays;

// #######################################################################################
// ----------------------- GENERAL HELPERS -----------------------------------------------
// #######################################################################################

// Returns the extra component attached to the supplied Unit GameState
static function XComGameState_Unit_Additional GetExtraComponent(XComGameState_Unit Unit)
{
	if (Unit != none) 
		return XComGameState_Unit_Additional(Unit.FindComponentObject(class'XComGameState_Unit_Additional'));
	return none;
}

// Cleanup and validation
static function GCandValidationChecks()
{
	local XComGameStateHistory History;
	local XComGameState NewGameState;
	local XComGameState_Unit UnitState, UpdatedUnit;
	local XComGameState_Unit_Additional ExtraState, UpdatedPsion;

	`LOG("MNT_Utility: Starting Garbage Collection and Validation.");

	History = `XCOMHISTORY;
	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Psion States cleanup");
	foreach History.IterateByClassType(class'XComGameState_Unit_Additional', ExtraState,,true)
	{
		`LOG("MNT_Utility: Found ExtraState, OwningObjectID=" $ ExtraState.OwningObjectId $ ", Deleted=" $ ExtraState.bRemoved);
		//check and see if the OwningObject is still alive and exists
		if(ExtraState.OwningObjectId > 0)
		{
			UnitState = XComGameState_Unit(History.GetGameStateForObjectID(ExtraState.OwningObjectID));
			if(UnitState == none)
			{
				`LOG("MNT_Utility: Extra Component has no current owning unit, cleaning up state.");
				// Remove disconnected Psion state
				NewGameState.RemoveStateObject(ExtraState.ObjectID);
			}
			else
			{
				`LOG("MNT_Utility: Found Owning Unit=" $ UnitState.GetFullName() $ ", Deleted=" $ UnitState.bRemoved);
				if(UnitState.bRemoved)
				{
					`LOG("MNT_Utility: Owning Unit was removed, Removing and unlinking ExtraState");
					UpdatedUnit = XComGameState_Unit(NewGameState.CreateStateObject(class'XComGameState_Unit', UnitState.ObjectID));
					UpdatedPsion = XComGameState_Unit_Additional(NewGameState.CreateStateObject(class'XComGameState_Unit_Additional', ExtraState.ObjectID));
					NewGameState.RemoveStateObject(UpdatedPsion.ObjectID);
					UpdatedUnit.RemoveComponentObject(UpdatedPsion);
					NewGameState.AddStateObject(UpdatedPsion);
					NewGameState.AddStateObject(UpdatedUnit);
				}
			}
		}
	}
	//foreach History.IterateByClassType(class'XComGameState_HeadquartersProject_TrainPsion', TrainExtraState,,true)
	//{
		////check and see if the OwningObject is still alive and exists
		//`LOG("MNT_Utility: Found TrainExtraState, ObjectID=" $  TrainExtraState.ObjectId);
	//}
	if (NewGameState.GetNumGameStateObjects() > 0)
		`GAMERULES.SubmitGameState(NewGameState);
	else
		History.CleanupPendingGameState(NewGameState);
}


// #######################################################################################
// ----------------------- PSION SYSTEM --------------------------------------------------
// #######################################################################################

///////////////////////////////
// Accessor and helper functions

// return psion ability tree
static function array<PsionAbilityConfig> GetAbilityTree()
{
	return default.PsionAbilityTree;
}

//checks if a unit has any Psion abilities
static function bool IsPsion(XComGameState_Unit Unit)
{
	local XComGameState_Unit_Additional ExtraState;

	ExtraState = GetExtraComponent(Unit);
	if (ExtraState == none) return false;
	if (ExtraState.GetPsionRank() > 0) return true;
	return false;
}

// Returns the name of the ability at the given rank/option in the Psion Ability tree
static function name GetAbilityName(const int Rank, const int Option)
{
	local PsionAbilityConfig ab;
	local int count;

	count = 0;
	foreach default.PsionAbilityTree(ab)
	{
		if (ab.Rank == Rank) 
		{
			if (count == Option)
			{
				return ab.AbilityName;
			} else {
				count++;
			}
		}
	}
	return '';
}

//Returns the path to the Psion rank icon of the given rank
static function string GetRankIcon(const int Rank)
{
	if (ValidateRank(Rank))
		return "img:///" $ default.PsionRankIcons[Rank];
	return "none";
}

//Returns the path to the Psion class icon
static function string GetClassIcon()
{
	return "img:///" $ default.PsionClassIcon;
}

//Returns the localized string rank name of the given rank
static function string GetRankName(const int Rank)
{
	if (ValidateRank(Rank))
		return Colorize(default.PsionRankNames[Rank]);
	return "none";
}

//Returns the short version of the localized string name of the given rank
static function string GetShortRankName(const int Rank)
{
	if (ValidateRank(Rank))
		return Colorize(default.PsionShortNames[Rank]);
	return "none";
}

//Returns the regular rank (non-Psion) required to train a given Psion rank 
static function int GetRequiredRegularRank(const int Rank)
{
	if (ValidateRank(Rank))
		return default.RequiredRankPerPsionRank[Rank];
	return 0;
}

//Returns the maximum possible Psion rank
static function int GetMaxRank()
{
	return default.RequiredRankPerPsionRank.Length;
}

static function bool ValidateRank(const int Rank)
{
	if (!CheckRank(Rank))
	{
		`RedScreen("PsionRank" @ Rank @ "is out of bounds for regular ranks (" $ Rank $ "/" $ default.RequiredRankPerPsionRank.length $ ")\n" $ GetScriptTrace());
		return false;
	} 
	return true;
}

//Validation check that Rank is within required bounds
static function bool CheckRank(const int Rank)
{
	if (Rank < 0 || Rank > default.RequiredRankPerPsionRank.length)
	{
		return false;
	}
	return true;
}

//Check if soldier has both regular rank and psion rank to learn a new psion skill
static function bool CanLearnNewPsiSkill(int sRank, int pRank){
	
	if(CheckRank(pRank)) // make sure that psion rank is valid
		return (sRank >= GetRequiredRegularRank(pRank)); //then check if soldier rank is high enough
	return false;
}

//Colorize things for psi font
static function string Colorize(String s){
	return "<font color='#C08EDA'>" $ s $ "</font>";
}

// #######################################################################################
// ----------------------- SPECIALIATIONS ------------------------------------------------
// #######################################################################################

// return array of all specializations
static function array<SpecializationConfig> GetSpecializations()
{
	return default.Specializations;
}

// return a specific specialization
static function SetSpec(XComGameState_Unit_Additional Unit, name SpecName)
{
	local SpecializationConfig Specialization;
	local SoldierClassAbilityType SpecPerk;

	foreach default.Specializations(Specialization){
		if(Specialization.Spec == SpecName){
			Unit.SetSpecialization(SpecName);

			foreach Specialization.SpecPerks(SpecPerk){
				Unit.SpecializationAbilities.AddItem(SpecPerk);
			}		
			break;
		}
	}

	if(!Unit.HasSpecialized())
		`LOG("MNT_Utility: Failed to specialize...?");
}

//checks if a unit has Specialized
static function bool IsSpecialized(XComGameState_Unit Unit)
{
	local XComGameState_Unit_Additional ExtraState;

	ExtraState = GetExtraComponent(Unit);
	if (ExtraState == none) return false;
	if (ExtraState.HasSpecialized()) return true;
	return false;
}

// #######################################################################################
// ----------------------- COVERT ACTIONS ------------------------------------------------
// #######################################################################################

// generates a reward for a covert action
function SoldierClassAbilityType GenerateFactionAbility(){
	local int RewardRoll;

	if (CAPS(nmFaction) == CAPS('Faction_Skirmishers')){
		RewardRoll = `SYNC_RAND(default.SkirmisherReward.Length);

		return default.SkirmisherReward[RewardRoll];
	}
	else if (CAPS(nmFaction) == CAPS('Faction_Reapers')){
		RewardRoll = `SYNC_RAND(default.ReaperReward.Length);

		return default.ReaperReward[RewardRoll];
	}

	else if (CAPS(nmFaction) == CAPS('Faction_Templars')){
		RewardRoll = `SYNC_RAND(default.TemplarReward.Length);
			return default.TemplarReward[RewardRoll];
	}

	else{
		`LOG("Couldn't generate a faction ability");
		return default.SkirmisherReward[0];
	}
}

// #######################################################################################
// ---------------------------- HQ CHECKS ------------------------------------------------
// #######################################################################################

static function XComGameState_HeadquartersProject_TrainPsion GetPsiTrainingProject(StateObjectReference UnitRef)
{
	local int idx;
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_HeadquartersProject_TrainPsion PsiProject;

	XComHQ = class'UIUtilities_Strategy'.static.GetXComHQ();

	for (idx = 0; idx < XcomHQ.Projects.Length; idx++)
	{
		PsiProject = XComGameState_HeadquartersProject_TrainPsion(`XCOMHISTORY.GetGameStateForObjectID(XcomHQ.Projects[idx].ObjectID));

		if (PsiProject != none)
		{
			if (UnitRef == PsiProject.ProjectFocus)
			{
				return PsiProject;
			}
		}
	}
	return none;
}
//---------------------------------------------------------------------------------------
static function bool HasPausedPsiAbilityTrainingProject(StateObjectReference UnitRef)
{
	local int idx;
	local XComGameStateHistory History;
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_HeadquartersProject_TrainPsion PsiTrainingProject;

	XComHQ = class'UIUtilities_Strategy'.static.GetXComHQ();

	History = `XCOMHISTORY;

	for (idx = 0; idx < XComHQ.Projects.Length; idx++)
	{
		PsiTrainingProject = XComGameState_HeadquartersProject_TrainPsion(History.GetGameStateForObjectID(XComHQ.Projects[idx].ObjectID));

		//if (PsiTrainingProject != none && PsiTrainingProject.ProjectFocus == UnitRef && class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager().FindAbilityTemplate(PsiTrainingProject.AbilityName) == AbilityInfo.AbilityTemplate)
		if (PsiTrainingProject != none && PsiTrainingProject.ProjectFocus == UnitRef && PsiTrainingProject.bForcePaused)
		{
			return true;
		}
	}

	return false;
}

//---------------------------------------------------------------------------------------
static function XComGameState_HeadquartersProject_TrainPsion GetPausedPsiAbilityTrainingProject(StateObjectReference UnitRef)
{
	local int idx;
	local XComGameStateHistory History;
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_HeadquartersProject_TrainPsion PsiTrainingProject;

	XComHQ = class'UIUtilities_Strategy'.static.GetXComHQ();

	History = `XCOMHISTORY;

	`LOG("Attempting to find a paused Psi Training project");

	for (idx = 0; idx < XComHQ.Projects.Length; idx++)
	{
		PsiTrainingProject = XComGameState_HeadquartersProject_TrainPsion(History.GetGameStateForObjectID(XComHQ.Projects[idx].ObjectID));

		//if (PsiTrainingProject != none && PsiTrainingProject.ProjectFocus == UnitRef && class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager().FindAbilityTemplate(PsiTrainingProject.AbilityName) == AbilityInfo.AbilityTemplate)
		if (PsiTrainingProject != none && PsiTrainingProject.ProjectFocus == UnitRef && PsiTrainingProject.bForcePaused)
		{
			`LOG("Found a paused Psi Training project with " $ PsiTrainingProject.AbilityName);
			return PsiTrainingProject;
		}
	}

	return none;
}

//---------------------------------------------------------------------------------------

static function XComGameState_HeadquartersProject_Specialize GetSpecializeProject(StateObjectReference UnitRef)
{
	local int idx;
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_HeadquartersProject_Specialize SpecializeProject;

	XComHQ = class'UIUtilities_Strategy'.static.GetXComHQ();

	for (idx = 0; idx < XcomHQ.Projects.Length; idx++)
	{
		SpecializeProject = XComGameState_HeadquartersProject_Specialize(`XCOMHISTORY.GetGameStateForObjectID(XcomHQ.Projects[idx].ObjectID));

		if (SpecializeProject != none)
		{
			if (UnitRef == SpecializeProject.ProjectFocus)
			{
				return SpecializeProject;
			}
		}
	}
	return none;
}
//---------------------------------------------------------------------------------------
static function bool HasPausedSpecializeProject(StateObjectReference UnitRef)
{
	local int idx;
	local XComGameStateHistory History;
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_HeadquartersProject_Specialize SpecializeProject;

	XComHQ = class'UIUtilities_Strategy'.static.GetXComHQ();

	History = `XCOMHISTORY;

	for (idx = 0; idx < XComHQ.Projects.Length; idx++)
	{
		SpecializeProject = XComGameState_HeadquartersProject_Specialize(History.GetGameStateForObjectID(XComHQ.Projects[idx].ObjectID));

		//if (SpecializeProject != none && SpecializeProject.ProjectFocus == UnitRef && class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager().FindAbilityTemplate(SpecializeProject.AbilityName) == AbilityInfo.AbilityTemplate)
		if (SpecializeProject != none && SpecializeProject.ProjectFocus == UnitRef && SpecializeProject.bForcePaused)
		{
			return true;
		}
	}

	return false;
}

//---------------------------------------------------------------------------------------
static function XComGameState_HeadquartersProject_Specialize GetPausedSpecializeProject(StateObjectReference UnitRef)
{
	local int idx;
	local XComGameStateHistory History;
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_HeadquartersProject_Specialize SpecializeProject;

	XComHQ = class'UIUtilities_Strategy'.static.GetXComHQ();
	History = `XCOMHISTORY;

	for (idx = 0; idx < XComHQ.Projects.Length; idx++)
	{
		SpecializeProject = XComGameState_HeadquartersProject_Specialize(History.GetGameStateForObjectID(XComHQ.Projects[idx].ObjectID));

		if (SpecializeProject != none && SpecializeProject.ProjectFocus == UnitRef && SpecializeProject.bForcePaused)
		{
			return SpecializeProject;
		}
	}

	return none;
}

//---------------------------------------------------------------------------------------