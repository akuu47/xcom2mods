class XComGameState_MissionSite_PrisonBreak extends XComGameState_MissionSite;

// copied from RM's Genji Redux and Iridar's Duke Nukem mod
// Copy ahoy!

function MissionSelected()
{
	local XComHQPresentationLayer Pres;
	local UIMission_PrisonBreak kScreen;

	Pres = `HQPRES;

	// Show the lost towers mission
	if (!Pres.ScreenStack.GetCurrentScreen().IsA('UIMission_PrisonBreak'))
	{
		kScreen = Pres.Spawn(class'UIMission_PrisonBreak');
		kScreen.MissionRef = GetReference();
		Pres.ScreenStack.Push(kScreen);
	}

	if (`GAME.GetGeoscape().IsScanning())
	{
		Pres.StrategyMap2D.ToggleScan();
	}
}


function string GetUIButtonIcon()
{
	//	2d nuke logo at the bottom of the screen in the points-of-interest list
	return "img:///UILibrary_StrategyImages.X2StrategyMap.MissionIcon_Advent";
}