//---------------------------------------------------------------------------------------
//  FILE:   XComDownloadableContentInfo_ADVENTHybridsRedux.uc                                    
//           
//	Use the X2DownloadableContentInfo class to specify unique mod behavior when the 
//  player creates a new campaign or loads a saved game.
//  
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class X2DownloadableContentInfo_ADVENTHybridsRedux extends X2DownloadableContentInfo;

/// <summary>
/// This method is run if the player loads a saved game that was created prior to this DLC / Mod being installed, and allows the 
/// DLC / Mod to perform custom processing in response. This will only be called once the first time a player loads a save that was
/// create without the content installed. Subsequent saves will record that the content was installed.
/// </summary>
static event OnLoadedSavedGame()
{}

/// <summary>
/// Called when the player starts a new campaign while this DLC / Mod is installed
/// </summary>
static event InstallNewCampaign(XComGameState StartState)
{}

static function bool AbilityTagExpandHandler(string InString, out string OutString)
{
	local name Type;

	Type = name(InString);

	switch(Type)
	{
	case 'MARK_COOLDOWN':
		OutString = string(class'X2AbilitySet_Hybrid'.default.MarkCooldown / 2);
		return true;
	case 'MARK_TURNS':
		OutString = string(class'X2AbilitySet_Hybrid'.default.MarkTurns);
		return true;
	}
	return false;
}

/// <summary>
/// Called after the player exits the post-mission sequence while this DLC / Mod is installed.
/// </summary>
static event OnExitPostMissionSequence()
{
	CheckForRequiredHealing();
}


/// <summary>
/// Called after the player exits the post-mission sequence while this DLC / Mod is installed.
/// </summary>
// I'm using this event instead of OnPostMission(), since we're using XComHQ and I need to make sure the player's in the Geoscape fully by then
static function CheckForRequiredHealing()
{
	local XComGameState NewGameState;
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_Unit UnitState;
	local int i;
	local XComGameState_HeadquartersProjectRecoverWill WillProject;
	local XComGameState_HeadquartersProjectHealSoldier ProjectState;
	local bool AddedProject;

	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Checking Project Required");

	XComHQ = XComGameState_HeadquartersXCom(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));

	XComHQ = XComGameState_HeadquartersXCom(NewGameState.ModifyStateObject(class'XComGameState_HeadquartersXCom', XComHQ.ObjectID));

	AddedProject = false;
	//NewGameState.AddStateObject(XComHQ);

	for (i = 0; i < XComHQ.Crew.Length; i++)
	{
		if (XComHQ.Crew[i].ObjectID != 0)
		{
			UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(XComHQ.Crew[i].ObjectID));

			UnitState = XComGameState_Unit(NewGameState.ModifyStateObject(class'XComGameState_Unit', UnitState.GetReference().ObjectID));
			if (UnitState.GetMyTemplateName() == 'RM_HybridSoldier' && ((UnitState.IsInjured() && !UnitState.HasHealingProject()) || (!HasWillProject(UnitState) && UnitState.NeedsWillRecovery()) ) )
			{
		
				if(UnitState.IsInjured() && !UnitState.HasHealingProject())
				{
					ProjectState = XComGameState_HeadquartersProjectHealSoldier(NewGameState.CreateNewStateObject(class'XComGameState_HeadquartersProjectHealSoldier'));

					ProjectState.SetProjectFocus(UnitState.GetReference(), NewGameState);

					UnitState.SetStatus(eStatus_Healing);
					XComHQ.Projects.AddItem(ProjectState.GetReference());
					AddedProject = true;
				}

			 
				if(!HasWillProject(UnitState) && UnitState.NeedsWillRecovery())
				{
					WillProject = XComGameState_HeadquartersProjectRecoverWill(NewGameState.CreateNewStateObject(class'XComGameState_HeadquartersProjectRecoverWill'));
					WillProject.SetProjectFocus(UnitState.GetReference(), NewGameState);
					XComHQ.Projects.AddItem(WillProject.GetReference());
					AddedProject = true;
				}
			}
		}
	}
	if (AddedProject)
		`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);
	else
		`XCOMHISTORY.CleanupPendingGameState(NewGameState);

}


static function bool HasWillProject(XComGameState_Unit UnitState)
{
	local XComGameStateHistory History;
	local XComGameState_HeadquartersProjectRecoverWill WillProject;

	History = `XCOMHISTORY;

	foreach History.IterateByClassType(class'XComGameState_HeadquartersProjectRecoverWill', WillProject)
	{
		if(WillProject.ProjectFocus == UnitState.GetReference())
		{
			return true;
		}
	}

	return false;
}