//-----------------------------------------------------------
//	Class:	CinematicRapidFIre_MCMScreenListener
//	Author: Mr.Nice
//	
//-----------------------------------------------------------

class CinematicRapidFire_MCMScreenListener extends UIScreenListener;

event OnInit(UIScreen Screen)
{
	local CinematicRapidFIre_MCMScreen CinematicRapidFireMCMScreen;

	if (ScreenClass==none)
	{
		if (MCM_API(Screen) != none)
			ScreenClass=Screen.Class;
		else return;
	}

	CinematicRapidFireMCMScreen = new class'CinematicRapidFIre_MCMScreen';
	CinematicRapidFireMCMScreen.OnInit(Screen);
}

defaultproperties
{
    ScreenClass = none;
}