//-----------------------------------------------------------
//	Class:	CinematicRapidFIre_MCMScreen
//	Author: Mr.Nice
//	
//-----------------------------------------------------------


class CinematicRapidFire_MCMScreen extends Object config(CinematicRapidFire_WotC);

var config int CONFIG_VERSION;

var localized string ModName;
var localized string PageName;
var localized string GroupDesc[3];

`include(CinematicRapidFireW\Src\ModConfigMenuAPI\MCM_API_Includes.uci)

`MCM_API_AutoCheckboxVars(SHOW_ACTIVATION);
`MCM_API_AutoCheckboxVars(LOST_OTS);
`MCM_API_AutoCheckboxVars(LOST_CINEMATIC);
`MCM_API_AutoIndexSpinnerVars(SHOT_VERBOSITY);
`MCM_API_AutoCheckboxVars(DUAL_OTS);
`MCM_API_AutoCheckboxVars(DUAL_CINEMATIC);
`MCM_API_AutoSliderVars(TURN_ANGLE);

`include(CinematicRapidFireW\Src\ModConfigMenuAPI\MCM_API_CfgHelpers_ALT.uci)

`MCM_API_AutoCheckboxFns(SHOW_ACTIVATION);
`MCM_API_AutoCheckboxFns(LOST_OTS);
`MCM_API_AutoCheckboxFns(LOST_CINEMATIC);
`MCM_API_AutoIndexFns(SHOT_VERBOSITY);
`MCM_API_AutoCheckboxFns(DUAL_OTS, 2);
`MCM_API_AutoCheckboxFns(DUAL_CINEMATIC, 2);
`MCM_API_AutoSliderFns(TURN_ANGLE,, 3);

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

	Group = Page.AddGroup('Group0', GroupDesc[0]);
	`MCM_API_AutoAddCheckbox(Group, SHOW_ACTIVATION);
	`MCM_API_AutoAddIndexSpinner(Group, SHOT_VERBOSITY);
	`MCM_API_AutoAddSlider(Group, TURN_ANGLE, 0, 90, 1);

	Group = Page.AddGroup('Group1', GroupDesc[1]);
	`MCM_API_AutoAddCheckbox(Group, LOST_OTS);
	`MCM_API_AutoAddCheckbox(Group, LOST_CINEMATIC);
	
	Group = Page.AddGroup('Group1', GroupDesc[2]);
	`MCM_API_AutoAddCheckbox(Group, DUAL_OTS);
	`MCM_API_AutoAddCheckbox(Group, DUAL_CINEMATIC);

	Page.ShowSettings();
}

simulated function LoadSavedSettings()
{
	SHOT_VERBOSITY=`GETMCMVAR(SHOT_VERBOSITY);
	SHOW_ACTIVATION=`GETMCMVAR(SHOW_ACTIVATION);
	LOST_OTS=`GETMCMVAR(LOST_OTS);
	LOST_CINEMATIC=`GETMCMVAR(LOST_CINEMATIC);
	DUAL_OTS=`GETMCMVAR(DUAL_OTS);
	DUAL_CINEMATIC=`GETMCMVAR(DUAL_CINEMATIC);
	TURN_ANGLE=`GETMCMVAR(TURN_ANGLE);
}

simulated function ResetButtonClicked(MCM_API_SettingsPage Page)
{
	`MCM_API_AutoReset(SHOW_ACTIVATION);
	`MCM_API_AutoReset(LOST_OTS);
	`MCM_API_AutoReset(LOST_CINEMATIC);
	`MCM_API_AutoIndexReset(SHOT_VERBOSITY);
	`MCM_API_AutoReset(DUAL_OTS);
	`MCM_API_AutoReset(DUAL_CINEMATIC);
	`MCM_API_AutoReset(TURN_ANGLE);
}


simulated function SaveButtonClicked(MCM_API_SettingsPage Page)
{
	CONFIG_VERSION = `MCM_CH_GetCompositeVersion();
	SaveConfig();
	class'X2DownloadableContentInfo_CinematicRapidFire'.static.MCMUpdate();
}
