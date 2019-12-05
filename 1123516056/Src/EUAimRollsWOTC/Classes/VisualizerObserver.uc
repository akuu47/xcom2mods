class VisualizerObserver extends UIPanel implements (X2VisualizationMgrObserverInterface);

var array<HitChanceNotify> PendingNotifications;
var array<HitChanceNotify> NotificationsToAssociate;

function InitObs()
{
	local Object ThisObj;
	`log("Initializing PERFECT INFORMATION",, 'EUAimRollsVis');

	ThisObj = self;

	`XCOMVISUALIZATIONMGR.RegisterObserver(self);
	//`XEVENTMGR.RegisterForEvent(ThisObj, 'AbilityActivated', ListenForAbilityGameState, ELD_Immediate);
	`XEVENTMGR.RegisterForEvent(ThisObj, 'RequestNotifyOnVisualization', OnNotificationRequested, ELD_Immediate);
	`XEVENTMGR.RegisterForEvent(ThisObj, 'PlayerTurnEnded', ClearAllNotifications, ELD_OnStateSubmitted); // Clean up extra rolls on turn end
	if (class'OldAimRoll'.default.DIRTY_CINEMATIC)
	{
		`XEVENTMGR.RegisterForEvent(ThisObj, 'AbilityActivated', OnNotifyBeforeVis, ELD_OnVisualizationBlockStarted);
		`PRES.m_kEventNotices.bShowDuringCinematic = true;
	}
	`log("Finshed initializing PERFECT INFORMATION",, 'EUAimRollsVis');
}

function EventListenerReturn ListenForAbilityGameState(Object EventData, Object EventSource, XComGameState NewGameState, Name EventID)
{
	local HitChanceNotify Notif;
	local Object NotifyObj;
	local int i;
	local XComGameState_Ability AbilityState;
	AbilityState = XComGameState_Ability(EventData);
	//`log("Event: AbilityActivated ID=" $ AbilityState.ObjectID,, 'EUAimRollsVis');
	if (XComGameStateContext_Ability(NewGameState.GetContext()) != none && NewGameState.GetNumGameStateObjects() > 0)
	{
		//`log("AbilityActivated is a XComGameStateContext_Ability:" @ XComGameStateContext_Ability(NewGameState.GetContext()).SummaryString(),, 'EUAimRollsVis');
		//`log("Context:" @ NewGameState.GetContext().ToString(),, 'EUAimRollsVis');
		for (i = 0; i < NotificationsToAssociate.Length; i++)
		{
			Notif = NotificationsToAssociate[i];
			if (Notif.StateRef == AbilityState.ObjectID)
			{
				//`log("Notif transferred for HACK event listener",, 'EUAimRollsVis');
				Notif.GameState = NewGameState;
				PendingNotifications.AddItem(Notif);
				NotifyObj = Notif;
				`XEVENTMGR.RegisterForEvent(NotifyObj, 'HACK_VisualizeNotify', Notif.DisplayThisEvent, class'OldAimRoll'.default.DIRTY_CINEMATIC ? ELD_OnVisualizationBlockStarted : ELD_OnVisualizationBlockCompleted);
				`XEVENTMGR.TriggerEvent('HACK_VisualizeNotify', self, Notif, NewGameState);
				//`log("Notif HACK completed",, 'EUAimRollsVis');
				NotificationsToAssociate.Remove(i, 1);
				i--;
			}
		}

		//if (j == 0)
		//{
			//`log("Generating empty HACK event listener",, 'EUAimRollsVis');
			//Notif = new class'HitChanceNotify';
			//Notif.StateRef = AbilityState.ObjectID;
			//Notif.Message = "[No Notify]" @ NewGameState.GetContext().ToString();
			//Notif.IsAlly = true;
			//Notif.RollTarget = XComGameStateContext_Ability(NewGameState.GetContext()).InputContext.PrimaryTarget.ObjectID;
			//NotifyObj = Notif;
			//`XEVENTMGR.RegisterForEvent(NotifyObj, 'HACK_VisualizeNotify', Notif.DisplayThisEvent, class'OldAimRoll'.default.DIRTY_CINEMATIC ? ELD_OnVisualizationBlockStarted : ELD_OnVisualizationBlockCompleted);
			//`XEVENTMGR.RegisterForEvent(NotifyObj, 'HACK_VisualizeNotify2', Notif.DebugEvent, ELD_Immediate);
			//`XEVENTMGR.RegisterForEvent(NotifyObj, 'HACK_VisualizeNotify3', Notif.DebugEventSS, ELD_OnStateSubmitted);
			//`XEVENTMGR.TriggerEvent('HACK_VisualizeNotify', self, Notif, NewGameState);
			//`XEVENTMGR.TriggerEvent('HACK_VisualizeNotify2', self, Notif, NewGameState);
			//`XEVENTMGR.TriggerEvent('HACK_VisualizeNotify3', self, Notif, NewGameState);
			//`log("Notif HACK completed",, 'EUAimRollsVis');
		//}
	}

	return ELR_NoInterrupt;
}

function EventListenerReturn ClearAllNotifications(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
	PendingNotifications.Length = 0;
	NotificationsToAssociate.Length = 0;

	return ELR_NoInterrupt;
}

function EventListenerReturn OnNotifyBeforeVis(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
	local XComGameStateContext_Ability Context;
	local array<HitChanceNotify> MatchedNotifications;
	local HitChanceNotify NotifyEntry;

	if (GameState == none)
		return ELR_NoInterrupt;

	Context = XComGameStateContext_Ability(GameState.GetContext());

	`log("Pre block notified",, 'EUAimRollsVis');

	if (Context == none)
		return ELR_NoInterrupt;

	if (class'OldAimRoll'.default.OVERWATCH_ABILITIES.Find(Context.InputContext.AbilityTemplateName) != INDEX_NONE)
		return ELR_NoInterrupt;

	`log("Pre block got context",, 'EUAimRollsVis');

	foreach PendingNotifications(NotifyEntry)
	{
		if (NotifyEntry.StateRef == Context.InputContext.AbilityRef.ObjectID)
		{
			if (Context.InputContext.PrimaryTarget.ObjectID != NotifyEntry.RollTarget && Context.InputContext.MultiTargets.Find('ObjectID', NotifyEntry.RollTarget) == INDEX_NONE)
			{
				// This ability was used multiple times before the first visualization block, suppress irreleavant messages until its turn
				continue;
			}
			MatchedNotifications.AddItem(NotifyEntry);
		}
	}

	foreach MatchedNotifications(NotifyEntry)
	{
		PendingNotifications.RemoveItem(NotifyEntry);
		if (!class'OldAimRoll'.default.SHOW_ONLY_ALLIES || NotifyEntry.IsAlly)
			NotifyEntry.Notify();
	}

	return ELR_NoInterrupt;
}

function EventListenerReturn OnNotificationRequested(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
	local HitChanceNotify Notification;
	Notification = HitChanceNotify(EventData);
	`log("Notif event requested",, 'EUAimRollsVis');

	if (Notification != none)
	{
		//NotificationsToAssociate.AddItem(Notification);
		PendingNotifications.AddItem(Notification);
	}

	return ELR_NoInterrupt;
}

//function AddNotification(XComGameState_Ability GameState, String Message)
//{
	//local HitChanceNotify Notification;
	//Notification = new class'HitChanceNotify';
	//Notification.StateRef = GameState.ObjectID;
	//Notification.Message = Message;
	//PendingNotifications.AddItem(Notification);
//}

event OnVisualizationBlockComplete(XComGameState AssociatedGameState)
{
	local XComGameStateContext_Ability Context;
	local array<HitChanceNotify> MatchedNotifications;
	local HitChanceNotify NotifyEntry;

	Context = XComGameStateContext_Ability(AssociatedGameState.GetContext());

	if (Context == none || class'OldAimRoll'.default.DIRTY_CINEMATIC)
		return;

	foreach PendingNotifications(NotifyEntry)
	{
		if (NotifyEntry.StateRef == Context.InputContext.AbilityRef.ObjectID)
		{
			if (Context.InputContext.PrimaryTarget.ObjectID != NotifyEntry.RollTarget && Context.InputContext.MultiTargets.Find('ObjectID', NotifyEntry.RollTarget) == INDEX_NONE)
			{
				// This ability was used multiple times before the first visualization block, suppress irreleavant messages until its turn
				continue;
			}
			MatchedNotifications.AddItem(NotifyEntry);
		}
	}

	foreach MatchedNotifications(NotifyEntry)
	{
		PendingNotifications.RemoveItem(NotifyEntry);
		if (!class'OldAimRoll'.default.SHOW_ONLY_ALLIES || NotifyEntry.IsAlly)
			NotifyEntry.Notify();
	}
}


/// <summary>
/// Called when the visualizer runs out of active and pending blocks, and becomes idle
/// </summary>
event OnVisualizationIdle();

/// <summary>
/// Called when the active unit selection changes
/// </summary>
event OnActiveUnitChanged(XComGameState_Unit NewActiveUnit);