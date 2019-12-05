//---------------------------------------------------------------------------------------
//  FILE:    XComGameState_Unit_Additional.uc
//  AUTHOR:  Amineri
//  PURPOSE: This is a component extension for Unit GameStates, containing 
//				additional data used for Psions.
//---------------------------------------------------------------------------------------
class XComGameState_Unit_Additional extends XComGameState_BaseObject;

var array<SoldierClassAbilityType>	SpecializationAbilities;
var array<SoldierClassAbilityType>	BondAbilities;
var array<SoldierClassAbilityType>	GTSAbilities;
var array<SoldierClassAbilityType>	PsionAbilities;

var protected name Specialization;
var protected bool isSpecialized;
var protected bool isMentored;
var protected int PsionRank;
var protected int RankTraining;
var name AbilityTrainingName;

function XComGameState_Unit_Additional InitComponent()
{
	PsionRank = 0;
	isSpecialized = false;
	isMentored = false;
	return self;
}

function bool SetRankTraining(int Rank, name AbilityName)
{
	if (CheckRank(Rank))
	{
		RankTraining = Rank;
		AbilityTrainingName = AbilityName;
		return true;
	} else {
		return false;
	}	
}

function SetSpecialization(name NewSpec){
	Specialization = NewSpec;
	isSpecialized = true;
}

function bool HasSpecialized(){
	return isSpecialized;
}

function bool HasPsionAbility(name AbilityName)
{
	local SoldierClassAbilityType Ability;
	
	foreach PsionAbilities(Ability)
	{
		if(Ability.AbilityName == AbilityName)
			return true;
	}
	return false;
}

function int GetPsionRank()
{
	return PsionRank;
}

function string GetSpecializationName()
{
	return string(Specialization);
}

function bool SetPsionRank(int Rank)
{
	if (CheckRank(Rank))
	{
		PsionRank = Rank;
		return true;
	} else {
		`Redscreen("MNT_Utility: Attempting to set invalid Psion Rank=" $ Rank);
		return false;
	}	
}

function bool CheckRank(int Rank)
{
	return class'MNT_Utility'.static.CheckRank(Rank);
}

function bool HasExtraAbility(name AbilityName)
{
	local SoldierClassAbilityType Ability;
	
	foreach SpecializationAbilities(Ability)
	{
		if(Ability.AbilityName == AbilityName)
			return true;
	}

	foreach BondAbilities(Ability)
	{
		if(Ability.AbilityName == AbilityName)
			return true;
	}


	return false;
}

function array<name> GetPerksForColumn(int Rank){
	
	local array<name> Abilities;

	Abilities[0] = (SpecializationAbilities[Rank].AbilityName);
	Abilities[1] = (BondAbilities[Rank].AbilityName);
	Abilities[2] = (GTSAbilities[Rank].AbilityName);
	Abilities[3] = (PsionAbilities[Rank].AbilityName);

	return Abilities;

}

//Grabs the nonpsionic perks, since those need to be initialized differently
function array<SoldierClassAbilityType> GetAllPerksToInit(){

	local array<SoldierClassAbilityType> ToInit;
	local SoldierClassAbilityType Item;

	foreach SpecializationAbilities(Item)
		ToInit.AddItem(Item);

	foreach BondAbilities(Item)
		ToInit.AddItem(Item);

	foreach GTSAbilities(Item)
		ToInit.AddItem(Item);

	foreach ToInit(Item)
		`LOG("MNT_Utility: Passing to init " $ Item.AbilityName);
	return ToInit;
}

function ValidateAbilities(){

	local SoldierClassAbilityType			CheckAbility;
	local array<SoldierClassAbilityType>	ValidatedAbilities;
	local array<name>						ValidNames;
	local int								i;

	for(i = 0; i < 4; ++i){
		
		switch(i){
			case 0: 
				ValidatedAbilities = SpecializationAbilities;
				break;
			case 1:
				ValidatedAbilities = BondAbilities;
				break;
			case 2:
				ValidatedAbilities = GTSAbilities;
				break;
			case 3:
				ValidatedAbilities = PsionAbilities;
				break;
			default:
				break;
		}

		foreach ValidatedAbilities(CheckAbility){

			if(ValidNames.Find(CheckAbility.AbilityName) != INDEX_NONE){
				//singular exception to not destroy all the empty perks
				if(CheckAbility.AbilityName == '')
					continue;

				`LOG("MNT_Utility: Found duplicate " $ CheckAbility.AbilityName);			
				ValidatedAbilities.RemoveItem(CheckAbility);
			
			}
			else{
				ValidNames.AddItem(CheckAbility.AbilityName);	
			}		
		}

		switch(i){
			case 0: 
				SpecializationAbilities = ValidatedAbilities;
				break;
			case 1:
				BondAbilities = ValidatedAbilities;
				break;
			case 2:
				GTSAbilities = ValidatedAbilities;
				break;
			case 3:
				PsionAbilities = ValidatedAbilities;
				break;
			default:
				break;
		}

		ValidatedAbilities.Length = 0;
	}
}