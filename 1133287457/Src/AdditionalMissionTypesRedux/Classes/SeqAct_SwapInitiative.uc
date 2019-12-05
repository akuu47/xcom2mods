///---------------------------------------------------------------------------------------
//  FILE:    SeqAct_IsUnitSoldier.uc
//  AUTHOR:  David Burchanowski  --  9/20/2016
//  PURPOSE: Action to determine if a given unit is a solider
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class SeqAct_SwapInitiative extends SequenceAction;

var XComGameState_Unit Unit, OriginalTeamUnit;
var() ETeam DestinationTeam;

event Activated()
{
	local XComGameState NewGameState;
	local XComGameState_AIPlayerData kAIData;
	local int iAIDataID;

	if(Unit == none || OriginalTeamUnit == none)
	{
		`Redscreen("Warning: SeqAct_SwapInitiative was called without specifying a unit.");
		return;
	}

	if(OriginalTeamUnit.GetTeam() != DestinationTeam)
	{
		return; //return if it wouldn't give us a group on the player's original team
	}

	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Swap Unit Initiative");

	iAIDataID = OriginalTeamUnit.GetAIPlayerDataID(true);
	kAIData = XComGameState_AIPlayerData(NewGameState.ModifyStateObject(class'XComGameState_AIPlayerData', iAIDataID));

	kAIData.UpdateForMindControlledUnit(NewGameState, Unit, OriginalTeamUnit.GetReference());

	`TACTICALRULES.SubmitGameState(NewGameState);
}

defaultproperties
{
	ObjName="Swap Unit Initiative"
	ObjCategory="Unit"
	bCallHandler=false
	DestinationTeam = eTeam_XCom

	bConvertedForReplaySystem=true
	bCanBeUsedForGameplaySequence=true

	bAutoActivateOutputLinks = true
	OutputLinks(0)=(LinkDesc="Out")


	VariableLinks(0)=(ExpectedType=class'SeqVar_GameUnit', LinkDesc="Unit", PropertyName=Unit)
	VariableLinks(1)=(ExpectedType=class'SeqVar_GameUnit', LinkDesc="OriginalTeamUnit", PropertyName=OriginalTeamUnit)
}