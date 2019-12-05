class UISLTactical_RegisterVisualizationMgr extends UIScreenListener;

function UninitializeVisObs(VisualizerObserver VOPanel)
{
	if (VOPanel != none)
	{
		VOPanel.PendingNotifications.Length = 0;
		`XEVENTMGR.UnRegisterFromAllEvents(VOPanel);
		`XCOMVISUALIZATIONMGR.RemoveObserver(VOPanel);
		VOPanel.Remove();
	}
}

event OnInit(UIScreen Screen)
{
	local VisualizerObserver VisObs;
	VisObs = VisualizerObserver(Screen.GetChildByName('EUAimRollPIListener', false));
	UninitializeVisObs(VisObs);

	VisObs = Screen.Spawn(class'VisualizerObserver', Screen);
	VisObs.InitPanel('EUAimRollPIListener');
	VisObs.Hide();
	VisObs.InitObs();
}

static function VisualizerObserver GetCurrentVisObs()
{
	local UITacticalHUD tacHUD;
	local VisualizerObserver VisObsR;

	if (`PRES == none)
		return none;

	tacHUD = UITacticalHUD(`PRES.ScreenStack.GetFirstInstanceOf(class'UITacticalHUD'));

	if (tacHUD == none)
		return none;

	VisObsR = VisualizerObserver(tacHUD.GetChildByName('EUAimRollPIListener', false));

	`log("Found our VisObs", VisObsR != none, 'EUAimRollsVis');

	return VisObsR;
}

event OnRemoved(UIScreen Screen)
{
	local VisualizerObserver VisObs;
	VisObs = VisualizerObserver(Screen.GetChildByName('EUAimRollPIListener'));
	UninitializeVisObs(VisObs);
}

defaultproperties
{
	ScreenClass = class'UITacticalHUD';
}