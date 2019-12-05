//-----------------------------------------------------------
//	Class:	CinematicRapidFIre_MCMScreenListener
//	Author: Mr.Nice
//	
//-----------------------------------------------------------

class OverWatchLockupFix_MCMScreenListener extends UIScreenListener;

event OnInit(UIScreen Screen)
{
	local OverWatchLockupFix_MCMScreen MCMScreen;
	// Everything out here runs on every UIScreen. Not great but necessary.
	if (ScreenClass==none)
	{
		if (MCM_API(Screen) != none)
			ScreenClass=Screen.Class;
		else return;
	}

	MCMScreen = new class'OverWatchLockupFix_MCMScreen';
	MCMScreen.OnInit(Screen);
}

defaultproperties
{
    ScreenClass = none;
}