//-----------------------------------------------------------
//	Class:	AWCCostFixW_MCMScreenListener
//	Author: Mr. Nice
//	
//-----------------------------------------------------------

class AWCCostFixW_MCMScreenListener extends UIScreenListener;

event OnInit(UIScreen Screen)
{
	local AWCCostFixW_MCMScreen MCMScreen;

	if (ScreenClass==none)
	{
		if (MCM_API(Screen) != none)
			ScreenClass=Screen.Class;
		else return;
	}

	MCMScreen = new class'AWCCostFixW_MCMScreen';
	MCMScreen.OnInit(Screen);
}

defaultproperties
{
    ScreenClass = none;
}
