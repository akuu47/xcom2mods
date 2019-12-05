class UIScreenListener_MCMHook_WorldWarLost extends UIScreenListener;

event OnInit(UIScreen Screen)
{
	local UIScreenListener_MCM_WorldWarLost Listener;
	//`Log("GrimyLoot_ScreenListener_MCM_Hook.OnInit starting...");
	if (MCM_API(Screen) != none)
	{
		Listener = new class'UIScreenListener_MCM_WorldWarLost';
		Listener.OnInit(Screen);
	}
	//`Log("GrimyLoot_ScreenListener_MCM_Hook.OnInit completing...");
}

defaultproperties
{
	ScreenClass = none;
}