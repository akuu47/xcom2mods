class RM_UIFinalShell_Listener extends UIScreenListener config(SPARKUpgradesSettings);

var bool FirstRun;

var UIPanel TestPanel;
var UIText TextStuff;
var UIText TextStuff2;
var UIButton DismissButton;

event OnInit(UIScreen Screen)
{

	if(UIFinalShell(Screen) != none || UIShell(Screen) != none)
	{
		FirstRun = IsGenerated();
		if(!FirstRun)
		{
		TestPanel = Screen.Spawn(class'UIPanel', Screen);
		TestPanel.InitPanel('BGBoxSimple', class'UIUtilities_Controls'.const.MC_X2BackgroundSimple);
		TestPanel.SetPosition(100, 200);
		TestPanel.SetSize(430, 800);

		TextStuff = Screen.Spawn(class'UIText', Screen);
		TextStuff.InitText(, "Test!");
		TextStuff.SetSize(280, 180); 
		TextStuff.SetPosition(185, 210);
		TextStuff.OriginTopCenter();


		TextStuff.SetHTMLText( class'UIUtilities_Text'.static.StyleText("WARNING", eUITextStyle_Title, eUIState_Bad ));

		TextStuff2 = Screen.Spawn(class'UIText', Screen);
		TextStuff2.InitText(, "Test!");
		TextStuff2.SetSize(430, 800); 
		TextStuff2.SetPosition(110, 260);

		TextStuff2.SetHTMLText( class'UIUtilities_Text'.static.StyleText("SPARK Upgrades has generated a default/new config file in the My Games directory. You'll need to restart XCOM 2 for it to take effect.", eUITextStyle_Tooltip_Body, eUIState_Warning ));

		DismissButton = Screen.Spawn(class'UIButton', Screen);
		DismissButton.InitButton('TestButton', "OK", DismissButtonHandler, );
		DismissButton.SetSize(280, 30); 
		DismissButton.SetPosition(175, 340);
		DismissButton.SetResizeToText(true);
		DismissButton.OriginBottomCenter();

		self.SaveConfig();
		class'RM_SparkUpgrade_Settings'.static.LoadSavedSettingsInitial();
		}
	}
}

simulated function DismissButtonHandler(UIButton Button)
{
	//self.SaveConfig();
	//class'RM_SparkUpgrade_Settings'.static.LoadSavedSettingsInitial();
	TestPanel.Remove();
	TextStuff.Remove();
	TextStuff2.Remove();
	DismissButton.Remove();
}
	

function bool IsGenerated()
{
	local int Version, DefaultVersion;

	Version = class'RM_SparkUpgrade_Settings'.default.CONFIG_VERSION;
	DefaultVersion = class'RM_SPARKUpgrades_DefaultSettings'.default.VERSION;
	if(Version >= DefaultVersion )
	{
		return true;
	}

	else
	{
		return false;
	}
}