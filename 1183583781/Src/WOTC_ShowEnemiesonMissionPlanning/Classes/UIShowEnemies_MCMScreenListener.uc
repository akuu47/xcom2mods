class UIShowEnemies_MCMScreenListener extends UIScreenListener;

event OnInit(UIScreen Screen)
{
	local UIShowEnemies_MCMScreen MCMScreen;
	
	// Everything out here runs on every UIScreen. Not great but necessary.
	if (MCM_API(Screen) != none)
	{
		MCMScreen = new class'UIShowEnemies_MCMScreen';
		MCMScreen.OnInit(Screen);
	}
}

defaultproperties
{
    ScreenClass = none;
}