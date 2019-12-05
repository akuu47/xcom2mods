class UISL_UIShell_MotD extends UIScreenListener config(RF_NullConfig);

//var config bool bDismissedSummerWeekday;
var config bool bDismissedStartUp;

var localized string strDescAssetsModMissing;
//var localized string strIncompatibleModsFound;
var localized string strTitleAssetsModMissing;
//var localized string strTitleIncompatibleMod;
//var localized string strTitleRequiredMod;
//var localized string strRequiredModsMissing;
var localized string strDescNewMotDInfo;
var localized string strTitleNewMotDInfo;
var localized string strDescOPMotDInfo;
var localized string strTitleOPMotDInfo;
var localized string strTitleRequiredMod;
var localized string strRequiredModsMissing;
var localized string m_strOKDisable;

event OnInit(UIScreen Screen)
{
    // if UIShell(Screen).DebugMenuContainer is set do NOT show since were not on the final shell
    if(UIShell(Screen) != none && UIShell(Screen).DebugMenuContainer == none)
	{
		if (!class'X2Helpers_UniversalFunctions'.static.IsDLCInstalled('ResistanceFirearms_WotC_Assets') &&
		!class'X2Helpers_UniversalFunctions'.static.IsDLCInstalled('00_ResFirearms_WotC_Attachments'))
		{
			Screen.SetTimer(1.5f, false, nameof(MakePopupMissing_RFAssets), self);
		}
		if (!bDismissedStartUp)
		{
			Screen.SetTimer(2.0f, false, nameof(OPMotDInfo), self);
		}
//		if (!bDismissedSummerWeekday)
//		{
//			Screen.SetTimer(2.1f, false, nameof(NewMotDInfo), self);
//		}

//		Screen.SetTimer(2.0f, false, nameof(IncompatibleModWarning), self);
//		Screen.SetTimer(2.1f, false, nameof(RequiredModWarning), self);
	}
}

simulated function MakePopupMissing_RFAssets()
{
	local TDialogueBoxData kDialogData;
	kDialogData.eType = eDialog_Warning;
	kDialogData.strTitle = strTitleAssetsModMissing;
	kDialogData.strText = strDescAssetsModMissing;
	kDialogData.fnCallback = OKClickedGeneric;

	kDialogData.strAccept = class'UIUtilities_Text'.default.m_strGenericContinue;

	`LOG("ERROR -------------------------------------------------------------------------",, '00_ResFirm_Master_Data');
	`LOG("ERROR ------------- Missing Resistance_Firearms_WotC_Assets -------------------",, '00_ResFirm_Master_Data');
	`LOG("ERROR -------------------------------------------------------------------------",, '00_ResFirm_Master_Data');

	`PRESBASE.UIRaiseDialog(kDialogData);
}

simulated function OPMotDInfo()
{
	local TDialogueBoxData kDialogData;
	kDialogData.eType = eDialog_Normal;
	kDialogData.strTitle = strTitleOPMotDInfo;
	kDialogData.strText = `XEXPAND.ExpandString(strDescOPMotDInfo);
	kDialogData.fnCallback = OnAcceptOPMotDCallback;

	kDialogData.strCancel = class'UIUtilities_Text'.default.m_strGenericContinue;
	kDialogData.strAccept = m_strOKDisable;


	`PRESBASE.UIRaiseDialog(kDialogData);
}

simulated function NewMotDInfo()
{
	local TDialogueBoxData kDialogData;
	kDialogData.eType = eDialog_Normal;
	kDialogData.strTitle = strTitleNewMotDInfo;
	kDialogData.strText = `XEXPAND.ExpandString(strDescNewMotDInfo);
	kDialogData.fnCallback = OnAcceptNewMotDCallback;

	kDialogData.strCancel = class'UIUtilities_Text'.default.m_strGenericContinue;
	kDialogData.strAccept = m_strOKDisable;


	`PRESBASE.UIRaiseDialog(kDialogData);
}
/*
simulated function IncompatibleModWarning()
{
	local TDialogueBoxData kDialogData;
	local array<string> FoundIncompatibleMods;

	FoundIncompatibleMods = class'RPGO_UI_Helper'.static.GetIncompatibleMods();

	if (FoundIncompatibleMods.Length == 0)
	{
		return;
	}

	`LOG(GetFuncName() @ class'RPGO_UI_Helper'.static.Join(FoundIncompatibleMods, ","),, 'RPG');

	kDialogData.eType = eDialog_Warning;
	kDialogData.strTitle = strTitleIncompatibleMod;
	kDialogData.strText = class'UIUtilities_Text'.static.GetColoredText(strIncompatibleModsFound, eUIState_Header) @
						  class'UIUtilities_Text'.static.GetColoredText(class'RPGO_UI_Helper'.static.MakeBulletList(FoundIncompatibleMods), eUIState_Bad);
	kDialogData.fnCallback = OKClickedGeneric;

	kDialogData.strAccept = class'UIUtilities_Text'.default.m_strGenericContinue;
	`PRESBASE.UIRaiseDialog(kDialogData);
}

simulated function RequiredModWarning()
{
	local TDialogueBoxData kDialogData;
	local array<string> RequiredMods;

	RequiredMods = class'RPGO_UI_Helper'.static.GetRequiredModsMissing();

	if (RequiredMods.Length == 0)
	{
		return;
	}

	`LOG(GetFuncName() @ class'RPGO_UI_Helper'.static.Join(RequiredMods, ","),, 'RPG');

	kDialogData.eType = eDialog_Warning;
	kDialogData.strTitle = strTitleRequiredMod;
	kDialogData.strText = class'UIUtilities_Text'.static.GetColoredText(strRequiredModsMissing, eUIState_Header) @
						  class'UIUtilities_Text'.static.GetColoredText(class'RPGO_UI_Helper'.static.MakeBulletList(RequiredMods), eUIState_Bad);
	kDialogData.fnCallback = OKClickedGeneric;

	kDialogData.strAccept = class'UIUtilities_Text'.default.m_strGenericContinue;
	`PRESBASE.UIRaiseDialog(kDialogData);
}
*/

simulated function OKClickedGeneric(Name eAction)
{
	`PRESBASE.PlayUISound(eSUISound_MenuSelect);
}

simulated function OnAcceptOPMotDCallback(Name eAction)
{
	if (eAction == 'eUIAction_Accept')
	{
		`PRESBASE.PlayUISound(eSUISound_MenuSelect);
		bDismissedStartUp = true;
		self.SaveConfig();
	}
	else
	{
		`PRESBASE.PlayUISound(eSUISound_MenuSelect);
	}
}

simulated function OnAcceptNewMotDCallback(Name eAction)
{
	if (eAction == 'eUIAction_Accept')
	{
		`PRESBASE.PlayUISound(eSUISound_MenuSelect);
//		bDismissedSummerWeekday = true;
		self.SaveConfig();
	}
	else
	{
		`PRESBASE.PlayUISound(eSUISound_MenuSelect);
	}
}