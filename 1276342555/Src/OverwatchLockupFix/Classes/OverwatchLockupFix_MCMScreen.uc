//-----------------------------------------------------------
//	Class:	OverWatchLockupFix_MCMScreen
//	Author: Mr.Nice
//	
//-----------------------------------------------------------


class OverWatchLockupFix_MCMScreen extends Object config(OverwatchLockupFix);

var config int CONFIG_VERSION;

var localized string ModName;
var localized string PageName;
var localized string GroupDesc;

`include(OverWatchLockUpFix\Src\ModConfigMenuAPI\MCM_API_Includes.uci)

`MCM_API_AutoCheckboxVars(DESTRUCTABLE_TIMEOUT);
`MCM_API_AutoCheckboxVars(ACTION_TIMEOUT);
`MCM_API_AutoCheckboxVars(MOVE_SKIPANIM);
`MCM_API_AutoCheckboxVars(SEQUENCER_FIX);

`include(OverWatchLockUpFix\Src\ModConfigMenuAPI\MCM_API_CfgHelpers_ALT.uci)

`MCM_API_AutoCheckboxFns(DESTRUCTABLE_TIMEOUT);
`MCM_API_AutoCheckboxFns(ACTION_TIMEOUT);
`MCM_API_AutoCheckboxFns(MOVE_SKIPANIM);
`MCM_API_AutoCheckboxFns(SEQUENCER_FIX, 2);

event OnInit(UIScreen Screen)
{
	// Everything in here runs only when you need to touch MCM.
	`MCM_API_Register(Screen, ClientModCallback);
}

simulated function ClientModCallback(MCM_API_Instance ConfigAPI, int GameMode)
{
	local MCM_API_SettingsPage Page;
	local MCM_API_SettingsGroup Group;

	LoadSavedSettings();
	Page = ConfigAPI.NewSettingsPage(ModName);
	Page.SetPageTitle(PageName);
	Page.SetSaveHandler(SaveButtonClicked);
	Page.EnableResetButton(ResetButtonClicked);

	Group = Page.AddGroup('Group', GroupDesc);
	`MCM_API_AutoAddCheckbox(Group, DESTRUCTABLE_TIMEOUT);
	`MCM_API_AutoAddCheckbox(Group, ACTION_TIMEOUT);
	`MCM_API_AutoAddCheckbox(Group, MOVE_SKIPANIM);
	`MCM_API_AutoAddCheckbox(Group, SEQUENCER_FIX);
	
	Page.ShowSettings();
}

simulated function LoadSavedSettings()
{
	DESTRUCTABLE_TIMEOUT=`GETMCMVAR(DESTRUCTABLE_TIMEOUT);
	ACTION_TIMEOUT=`GETMCMVAR(ACTION_TIMEOUT);
	MOVE_SKIPANIM=`GETMCMVAR(MOVE_SKIPANIM);
	SEQUENCER_FIX=`GETMCMVAR(SEQUENCER_FIX);
}

simulated function ResetButtonClicked(MCM_API_SettingsPage Page)
{
	`MCM_API_AutoReset(DESTRUCTABLE_TIMEOUT);
	`MCM_API_AutoReset(ACTION_TIMEOUT);
	`MCM_API_AutoReset(MOVE_SKIPANIM);
	`MCM_API_AutoReset(SEQUENCER_FIX);
}


simulated function SaveButtonClicked(MCM_API_SettingsPage Page)
{
	CONFIG_VERSION = `MCM_CH_GetCompositeVersion();
	SaveConfig();
}
