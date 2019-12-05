//-----------------------------------------------------------
//	Class:	AWCCostFixW_MCMScreen
//	Author: Mr. Nice
//	
//-----------------------------------------------------------


class AWCCostFixW_MCMScreen extends Object config(AbilityFix);

var config int VERSION_CFG;

var localized string ModName;
var localized string PageTitle;
var localized array<string> GroupHeader;

`include(AWCCostFixW\Src\ModConfigMenuAPI\MCM_API_Includes.uci)

/***************************************
Insert `MCM_API_Auto????Vars macros here
***************************************/
`MCM_API_AutoCheckboxVars(FIX_SERIAL_TRIGGER);
`MCM_API_AutoCheckboxVars(FIX_DEATHFROMABOVE_TRIGGER);
`MCM_API_AutoCheckboxVars(FIX_REAPER_MOMENTUM);
`MCM_API_AutoCheckboxVars(FIX_IMPLACABLE_CONSUMPTION);
`MCM_API_AutoCheckboxVars(FIX_COMBATPROTOCOL_ROBOTIC);
`MCM_API_AutoCheckboxVars(FIX_ARCWAVE);
`MCM_API_AutoCheckboxVars(FIX_ANNIHILATE);

`include(AWCCostFixW\Src\ModConfigMenuAPI\MCM_API_CfgHelpers.uci)

/********************************************************************
Insert `MCM_API_Auto????Fns and MCM_API_AutoButtonHandler macros here
********************************************************************/
`MCM_API_AutoCheckboxFns(FIX_SERIAL_TRIGGER);
`MCM_API_AutoCheckboxFns(FIX_DEATHFROMABOVE_TRIGGER);
`MCM_API_AutoCheckboxFns(FIX_REAPER_MOMENTUM);
`MCM_API_AutoCheckboxFns(FIX_IMPLACABLE_CONSUMPTION);
`MCM_API_AutoCheckboxFns(FIX_COMBATPROTOCOL_ROBOTIC, 2);
`MCM_API_AutoCheckboxFns(FIX_ARCWAVE, 3);
`MCM_API_AutoCheckboxFns(FIX_ANNIHILATE, 4);

event OnInit(UIScreen Screen)
{
	`MCM_API_Register(Screen, ClientModCallback);
}

//Simple one group framework code
simulated function ClientModCallback(MCM_API_Instance ConfigAPI, int GameMode)
{
	local MCM_API_SettingsPage Page;
	local MCM_API_SettingsGroup Group;

	LoadSavedSettings();
	Page = ConfigAPI.NewSettingsPage(ModName);
	Page.SetPageTitle(PageTitle);
	Page.SetSaveHandler(SaveButtonClicked);
	
	//Uncomment to enable reset
	Page.EnableResetButton(ResetButtonClicked);

	Group = Page.AddGroup('Group0', GroupHeader[0]);
/********************************************************
	MCM_API_AutoAdd??????? Macro's go here
********************************************************/
	`MCM_API_AutoAddCheckbox(Group, FIX_SERIAL_TRIGGER);
	`MCM_API_AutoAddCheckbox(Group, FIX_DEATHFROMABOVE_TRIGGER);

	Group = Page.AddGroup('Group1', GroupHeader[1]);
	`MCM_API_AutoAddCheckbox(Group, FIX_REAPER_MOMENTUM);
	`MCM_API_AutoAddCheckbox(Group, FIX_IMPLACABLE_CONSUMPTION);

	Group = Page.AddGroup('Group2', GroupHeader[2]);
	`MCM_API_AutoAddCheckbox(Group, FIX_COMBATPROTOCOL_ROBOTIC);
	`MCM_API_AutoAddCheckbox(Group, FIX_ARCWAVE);
	`MCM_API_AutoAddCheckbox(Group, FIX_ANNIHILATE);
	Page.ShowSettings();
}

simulated function LoadSavedSettings()
{
/************************************************************************
	Use GETMCMVAR macro to assign values to the config variables here
************************************************************************/
	FIX_SERIAL_TRIGGER=`GETMCMVAR(FIX_SERIAL_TRIGGER);
	FIX_DEATHFROMABOVE_TRIGGER=`GETMCMVAR(FIX_DEATHFROMABOVE_TRIGGER);
	FIX_REAPER_MOMENTUM=`GETMCMVAR(FIX_REAPER_MOMENTUM);
	FIX_IMPLACABLE_CONSUMPTION=`GETMCMVAR(FIX_IMPLACABLE_CONSUMPTION);
	FIX_COMBATPROTOCOL_ROBOTIC=`GETMCMVAR(FIX_COMBATPROTOCOL_ROBOTIC);
	FIX_ARCWAVE=`GETMCMVAR(FIX_ARCWAVE);
	FIX_ANNIHILATE=`GETMCMVAR(FIX_ANNIHILATE);
}

simulated function ResetButtonClicked(MCM_API_SettingsPage Page)
{
/********************************************************
	MCM_API_AutoReset macros go here
********************************************************/
	`MCM_API_AutoReset(FIX_SERIAL_TRIGGER);
	`MCM_API_AutoReset(FIX_DEATHFROMABOVE_TRIGGER);
	`MCM_API_AutoReset(FIX_REAPER_MOMENTUM);
	`MCM_API_AutoReset(FIX_IMPLACABLE_CONSUMPTION);
	`MCM_API_AutoReset(FIX_COMBATPROTOCOL_ROBOTIC);
	`MCM_API_AutoReset(FIX_ARCWAVE);
	`MCM_API_AutoReset(FIX_ANNIHILATE);
}


simulated function SaveButtonClicked(MCM_API_SettingsPage Page)
{
	VERSION_CFG = `MCM_CH_GetCompositeVersion();
	SaveConfig();
	class'X2DownloadableContentInfo_AbilityFix'.static.LiveApply();
}


