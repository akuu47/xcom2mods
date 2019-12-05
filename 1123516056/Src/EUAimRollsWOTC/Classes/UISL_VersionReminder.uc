class UISL_VersionReminder extends UIScreenListener config(ModVersion);

var config int VERSION;
var int CURRENT_VERSION;

event OnInit(UIScreen Screen)
{
	local UIFinalShell MainScreen;
	MainScreen = UIFinalShell(Screen);

	if (MainScreen == none)
		return;

	if ((default.VERSION) == 0)
	{
		default.VERSION = CURRENT_VERSION;
		StaticSaveConfig();
	}
	if ((default.Version) < CURRENT_VERSION)
	{
		default.VERSION = CURRENT_VERSION;
		StaticSaveConfig();

		MainScreen.SetTimer(0.5f, false, nameof(ShowError), self);
	}
	else if (class'XComModOptions'.default.ActiveMods.Find("LW_Overhaul") != INDEX_NONE && class'OldAimRoll'.default.ENABLE_EU_AIM_ROLLS)
	{
		MainScreen = UIFinalShell(Screen);
		MainScreen.SetTimer(0.5f, false, nameof(ShowLWError), self);
	}
}

simulated function ShowError()
{
	local UIScreen Screen;
	local TDialogueBoxData DialogData;

	Screen = `SCREENSTACK.GetCurrentScreen();

	DialogData.eType = eDialog_Warning;
	DialogData.strTitle = "Mod updated!";
	DialogData.strText = "This mod has been updated recently and your config might have been overwritten! Don't forget to restore your custom config and update your backup to reflect the latest changes!";
	DialogData.strAccept = class'UIDialogueBox'.default.m_strDefaultAcceptLabel;
	Screen.Movie.Pres.UIRaiseDialog(DialogData);
}

simulated function ShowLWError()
{
	local UIScreen Screen;
	local TDialogueBoxData DialogData;

	Screen = `SCREENSTACK.GetCurrentScreen();

	DialogData.eType = eDialog_Warning;
	DialogData.strTitle = "Bad config for LW2!";
	DialogData.strText = "You enabled EU aim rolls with LW2 without changing to the correct configuration! Please follow the instructions to update your config and restart the game, or you you'll experience unexpected behaviour in hit rolls.";
	DialogData.strAccept = class'UIDialogueBox'.default.m_strDefaultAcceptLabel;
	Screen.Movie.Pres.UIRaiseDialog(DialogData);
}

defaultproperties
{
	ScreenClass = none;
	CURRENT_VERSION = 6;
}
