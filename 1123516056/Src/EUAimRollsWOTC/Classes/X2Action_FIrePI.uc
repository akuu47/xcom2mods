class X2Action_FIrePI extends X2Action_Fire;

var VisualizerObserver CurrentVO;

simulated state Executing
{
	simulated function RaiseRollEvent()
	{
		local HitChanceNotify NotifyEntry;
		local int TargetID;

		if (AbilityContext == none)
			return;
		`log("Pre block got context",, 'EUAimRollsVis');

		TargetID = -1;

		if (XGUnit(PrimaryTarget) != none)
		{
			TargetID = XGUnit(PrimaryTarget).ObjectID;
		}

		foreach CurrentVO.PendingNotifications(NotifyEntry)
		{
			if (NotifyEntry.StateRef == AbilityContext.InputContext.AbilityRef.ObjectID)
			{
				if (TargetID == NotifyEntry.RollTarget)
				{
					CurrentVO.PendingNotifications.RemoveItem(NotifyEntry);
					if (!class'OldAimRoll'.default.SHOW_ONLY_ALLIES || NotifyEntry.IsAlly)
						NotifyEntry.Notify();
					break;
				}
			}
		}
	}

	function HideFOW()
	{
		`log("Hide FOW Called",, 'EUAimRollsVis');
		super.HideFOW();
		CurrentVO = class'UISLTactical_RegisterVisualizationMgr'.static.GetCurrentVisObs();
		if (CurrentVO != none && class'OldAimRoll'.default.DIRTY_CINEMATIC)
		{
			RaiseRollEvent();
		}
	}
}