//---------------------------------------------------------------------------------------
//  FILE:    X2DownloadableContentInfo.uc
//  AUTHOR:  Ryan McFall
//           
//	Mods and DLC derive from this class to define their behavior with respect to 
//  certain in-game activities like loading a saved game. Should the DLC be installed
//  to a campaign that was already started?
//
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class X2DownloadableContentInfo_SuppressableTargetingAbilitiesWOTC extends X2DownloadableContentInfo;

var config array<name> TARGETING_BLASTERLAUNCHER;
var config array<name> TARGETING_CLAYMORE;

/// <summary>
/// This method is run if the player loads a saved game that was created prior to this DLC / Mod being installed, and allows the 
/// DLC / Mod to perform custom processing in response. This will only be called once the first time a player loads a save that was
/// create without the content installed. Subsequent saves will record that the content was installed.
/// </summary>
static event OnLoadedSavedGame()
{

}

/// <summary>
/// This method is run when the player loads a saved game directly into Strategy while this DLC is installed
/// </summary>
static event OnLoadedSavedGameToStrategy()
{

}

/// <summary>
/// Called when the player starts a new campaign while this DLC / Mod is installed. When a new campaign is started the initial state of the world
/// is contained in a strategy start state. Never add additional history frames inside of InstallNewCampaign, add new state objects to the start state
/// or directly modify start state objects
/// </summary>
static event InstallNewCampaign(XComGameState StartState)
{

}

/// <summary>
/// Called just before the player launches into a tactical a mission while this DLC / Mod is installed.
/// Allows dlcs/mods to modify the start state before launching into the mission
/// </summary>
static event OnPreMission(XComGameState StartGameState, XComGameState_MissionSite MissionState)
{

}

/// <summary>
/// Called when the player completes a mission while this DLC / Mod is installed.
/// </summary>
static event OnPostMission()
{

}

/// <summary>
/// Called when the player is doing a direct tactical->tactical mission transfer. Allows mods to modify the
/// start state of the new transfer mission if needed
/// </summary>
static event ModifyTacticalTransferStartState(XComGameState TransferStartState)
{

}

/// <summary>
/// Called after the player exits the post-mission sequence while this DLC / Mod is installed.
/// </summary>
static event OnExitPostMissionSequence()
{

}

/// <summary>
/// Called after the Templates have been created (but before they are validated) while this DLC / Mod is installed.
/// </summary>
static event OnPostTemplatesCreated()
{

	local X2AbilityTemplateManager			AbilityTemplateManager;
	local X2AbilityTemplate					AbilityTemplate;
	local X2DataTemplate					DataTemplate;
	local X2Cursor_Suppressable				CursorTarget;
	local X2AbilityTarget_Cursor 			CursorOld;
	local name								AbilityName;

	AbilityTemplateManager = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();

	`log("Patching suppressable cursor",, 'Suppressable abilities');
	foreach AbilityTemplateManager.IterateTemplates(DataTemplate, none)
	{
		AbilityTemplate = X2AbilityTemplate(DataTemplate);
		if (AbilityTemplate == none)
		{
			`log("Ability not found:" @ DataTemplate.DataName,, 'Suppressable abilities');
			continue;
		}
		CursorOld = X2AbilityTarget_Cursor(AbilityTemplate.AbilityTargetStyle);
		if (CursorOld != none)
		{
			`log("Ability patched:" @ AbilityTemplate.DataName,, 'Suppressable abilities');
			
			CursorTarget = new class'X2Cursor_Suppressable';
			CursorTarget.bRestrictToWeaponRange = CursorOld.bRestrictToWeaponRange;
			CursorTarget.FixedAbilityRange = CursorOld.FixedAbilityRange;
			CursorTarget.bRestrictToSquadsightRange = CursorOld.bRestrictToSquadsightRange;
			CursorTarget.IncreaseWeaponRange = CursorOld.IncreaseWeaponRange;
			AbilityTemplate.AbilityTargetStyle = CursorTarget;
		}
	}
	
	`log("X2TargetingMethod_BlasterLauncher",, 'Suppressable abilities');
	foreach default.TARGETING_BLASTERLAUNCHER(AbilityName)
	{
		AbilityTemplate = AbilityTemplateManager.FindAbilityTemplate(AbilityName);
		if (AbilityTemplate == none)
		{
			`log("Ability not found:" @ AbilityName,, 'Suppressable abilities');
			continue;
		}
		`log("Ability patched:" @ AbilityName,, 'Suppressable abilities');
		AbilityTemplate.TargetingMethod = class'X2TargetingMethod_NoSnapBlasterLauncher';
	}
	
	`log("X2TargetingMethod_Claymore",, 'Suppressable abilities');
	foreach default.TARGETING_CLAYMORE(AbilityName)
	{
		AbilityTemplate = AbilityTemplateManager.FindAbilityTemplate(AbilityName);
		if (AbilityTemplate == none)
		{
			`log("Ability not found:" @ AbilityName,, 'Suppressable abilities');
			continue;
		}
		`log("Ability patched:" @ AbilityName,, 'Suppressable abilities');
		AbilityTemplate.TargetingMethod = class'X2TargetingMethod_Claymore';
	}

	X2TargetingMethod_Grenade(class'Engine'.static.FindClassDefaultObject("X2TargetingMethod_Grenade")).SnapToTile = false;
	X2TargetingMethod_GremlinAOE(class'Engine'.static.FindClassDefaultObject("X2TargetingMethod_GremlinAOE")).SnapToTile = false;
	X2TargetingMethod_GrenadePerkWeapon(class'Engine'.static.FindClassDefaultObject("X2TargetingMethod_GrenadePerkWeapon")).SnapToTile = false;
	X2TargetingMethod_MassPsiReanimation(class'Engine'.static.FindClassDefaultObject("X2TargetingMethod_MassPsiReanimation")).SnapToTile = false;
	X2TargetingMethod_MECMicroMissile(class'Engine'.static.FindClassDefaultObject("X2TargetingMethod_MECMicroMissile")).SnapToTile = false;
	X2TargetingMethod_ViperSpit(class'Engine'.static.FindClassDefaultObject("X2TargetingMethod_ViperSpit")).SnapToTile = false;
	X2TargetingMethod_VoidRift(class'Engine'.static.FindClassDefaultObject("X2TargetingMethod_VoidRift")).SnapToTile = false;
}

/// <summary>
/// Called when the difficulty changes and this DLC is active
/// </summary>
static event OnDifficultyChanged()
{

}

/// <summary>
/// Called by the Geoscape tick
/// </summary>
static event UpdateDLC()
{

}

/// <summary>
/// Called after HeadquartersAlien builds a Facility
/// </summary>
static event OnPostAlienFacilityCreated(XComGameState NewGameState, StateObjectReference MissionRef)
{

}

/// <summary>
/// Called after a new Alien Facility's doom generation display is completed
/// </summary>
static event OnPostFacilityDoomVisualization()
{

}

/// <summary>
/// Called when viewing mission blades with the Shadow Chamber panel, used primarily to modify tactical tags for spawning
/// Returns true when the mission's spawning info needs to be updated
/// </summary>
static function bool UpdateShadowChamberMissionInfo(StateObjectReference MissionRef)
{
	return false;
}

/// <summary>
/// A dialogue popup used for players to confirm or deny whether new gameplay content should be installed for this DLC / Mod.
/// </summary>
static function EnableDLCContentPopup()
{
	local TDialogueBoxData kDialogData;

	kDialogData.eType = eDialog_Normal;
	kDialogData.strTitle = default.EnableContentLabel;
	kDialogData.strText = default.EnableContentSummary;
	kDialogData.strAccept = default.EnableContentAcceptLabel;
	kDialogData.strCancel = default.EnableContentCancelLabel;

	kDialogData.fnCallback = EnableDLCContentPopupCallback_Ex;
	`HQPRES.UIRaiseDialog(kDialogData);
}

simulated function EnableDLCContentPopupCallback(eUIAction eAction)
{
}

simulated function EnableDLCContentPopupCallback_Ex(Name eAction)
{	
	switch (eAction)
	{
	case 'eUIAction_Accept':
		EnableDLCContentPopupCallback(eUIAction_Accept);
		break;
	case 'eUIAction_Cancel':
		EnableDLCContentPopupCallback(eUIAction_Cancel);
		break;
	case 'eUIAction_Closed':
		EnableDLCContentPopupCallback(eUIAction_Closed);
		break;
	}
}

/// <summary>
/// Called when viewing mission blades, used primarily to modify tactical tags for spawning
/// Returns true when the mission's spawning info needs to be updated
/// </summary>
static function bool ShouldUpdateMissionSpawningInfo(StateObjectReference MissionRef)
{
	return false;
}

/// <summary>
/// Called when viewing mission blades, used primarily to modify tactical tags for spawning
/// Returns true when the mission's spawning info needs to be updated
/// </summary>
static function bool UpdateMissionSpawningInfo(StateObjectReference MissionRef)
{
	return false;
}

/// <summary>
/// Called when viewing mission blades, used to add any additional text to the mission description
/// </summary>
static function string GetAdditionalMissionDesc(StateObjectReference MissionRef)
{
	return "";
}

/// <summary>
/// Called from X2AbilityTag:ExpandHandler after processing the base game tags. Return true (and fill OutString correctly)
/// to indicate the tag has been expanded properly and no further processing is needed.
/// </summary>
static function bool AbilityTagExpandHandler(string InString, out string OutString)
{
	return false;
}

/// <summary>
/// Called from XComGameState_Unit:GatherUnitAbilitiesForInit after the game has built what it believes is the full list of
/// abilities for the unit based on character, class, equipment, et cetera. You can add or remove abilities in SetupData.
/// </summary>
static function FinalizeUnitAbilitiesForInit(XComGameState_Unit UnitState, out array<AbilitySetupData> SetupData, optional XComGameState StartState, optional XComGameState_Player PlayerState, optional bool bMultiplayerDisplay)
{

}

/// <summary>
/// Calls DLC specific popup handlers to route messages to correct display functions
/// </summary>
static function bool DisplayQueuedDynamicPopup(DynamicPropertySet PropertySet)
{

}