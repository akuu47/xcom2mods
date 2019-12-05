//---------------------------------------------------------------------------------------
//  FILE:    X2DownloadableContentInfo_*.uc
//  AUTHOR:  Joe Weinhoffer
//           
//	Installs content into new campaigns and loaded ones. New armors, weapons, etc
//
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class X2DownloadableContentInfo_Mission_PrisonBreak extends X2DownloadableContentInfo;

/// <summary>
/// This method is run if the player loads a saved game that was created prior to this DLC / Mod being installed, and allows the 
/// DLC / Mod to perform custom processing in response. This will only be called once the first time a player loads a save that was
/// create without the content installed. Subsequent saves will record that the content was installed.
/// </summary>
static event OnLoadedSavedGame()
{

}

/// <summary>
/// Called after the Templates have been created (but before they are validated) while this DLC / Mod is installed.
/// </summary>
static event OnPostTemplatesCreated()
{

}

static event OnLoadedSavedGameToStrategy()
{

}

// Called in Strategy layer. Sends recruitables into the Gulag
exec function SendRecruitablesToGulag()
{
	local XComGameState_HeadquartersResistance ResistHQ;
	local XComGameState_HeadquartersAlien AlienHQ;
	local XComGameState_AdventChosen ChosenState;
	local XComGameStateHistory History;
	local int i;

	//Grab both Resistance HQ and Alien HQ
	History = `XCOMHISTORY;
	AlienHQ = XComGameState_HeadquartersAlien(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersAlien'));
	ResistHQ = XComGameState_HeadquartersResistance(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersResistance'));
	ChosenState = XComGameState_AdventChosen(History.GetSingleGameStateObjectForClass(class'XComGameState_AdventChosen'));

	//Send everyone to Gulag or Chosen Fun House to be tickled to death
	for(i = 0; i < ResistHQ.Recruits.Length; i++)
	{
		if (`SYNC_RAND_STATIC(100) < 50)
		{
			AlienHQ.CapturedSoldiers.AddItem(ResistHQ.Recruits[i]);
		}
		else
		{
			ChosenState.bCapturedSoldier = true;
			ChosenState.CapturedSoldiers.AddItem(ResistHQ.Recruits[i]);
			ChosenState.TotalCapturedSoldiers++;
		}
		//Remove from ResistanceHQ
		ResistHQ.Recruits.Remove(i, 1);
	}
}


exec function SpawnCovertAction(name TemplateName, optional name FactionTemplateName = '')
{
	local XComGameStateHistory History;
	local XComGameState NewGameState;

	local XComGameState_ResistanceFaction FactionState;
	local X2StrategyElementTemplateManager StratMgr;
	local X2CovertActionTemplate ActionTemplate;
	local array<name> ActionExclusionList;

	StratMgr = class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager();
	ActionTemplate = X2CovertActionTemplate(StratMgr.FindStrategyElementTemplate(TemplateName));

	if (ActionTemplate == none)
	{
		`REDSCREEN("Cannot execute SpawnCovertAction cheat - invalid template name");
		return;
	}

	History = `XCOMHISTORY;
	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("CHEAT: CreateCovertAction" @ TemplateName);

	// Find first faction
	foreach History.IterateByClassType(class'XComGameState_ResistanceFaction', FactionState)
	{
		if (FactionTemplateName == '' || FactionState.GetMyTemplateName() == FactionTemplateName)
		{
			FactionState = XComGameState_ResistanceFaction(NewGameState.ModifyStateObject(class'XComGameState_ResistanceFaction', FactionState.ObjectID));
			break;
		}
	}

	if (FactionState == none)
	{
		`REDSCREEN("Cannot execute SpawnCovertAction cheat - invalid faction template name");
		History.CleanupPendingGameState(NewGameState);
	}
	else
	{
		FactionState.AddCovertAction(NewGameState, ActionTemplate, ActionExclusionList);
		`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);
	}
}