class UISL_StrategyMap extends UIScreenListener config (StillDontWasteMyTime);

var config int DEFAULT_SPEED;
var config int UPDATE_SPEED;

event OnInit(UIScreen Screen)
{
	if (UIStrategyMap(Screen) != none)
	{
		`LOG(default.class @ GetFuncName() @ default.UPDATE_SPEED,, 'StillDontWasteMyTime');
		`XWORLDINFO.Game.SetGameSpeed(default.UPDATE_SPEED);
	}
}

event OnReceiveFocus(UIScreen Screen)
{
	if (UIStrategyMap(Screen) != none)
	{
		`LOG(default.class @ GetFuncName() @ default.UPDATE_SPEED,, 'StillDontWasteMyTime');
		`XWORLDINFO.Game.SetGameSpeed(default.UPDATE_SPEED);
	}
}

event OnLoseFocus(UIScreen Screen)
{
	if (UIStrategyMap(Screen) != none)
	{
		`LOG(default.class @ GetFuncName() @ default.DEFAULT_SPEED,, 'StillDontWasteMyTime');
		`XWORLDINFO.Game.SetGameSpeed(default.DEFAULT_SPEED);
	}
}

event OnRemoved(UIScreen Screen)
{
	if (UIStrategyMap(Screen) != none)
	{
		`LOG(default.class @ GetFuncName() @ default.DEFAULT_SPEED,, 'StillDontWasteMyTime');
		`XWORLDINFO.Game.SetGameSpeed(default.DEFAULT_SPEED);
	}
}