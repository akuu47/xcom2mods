class HitChanceNotify extends Object;

var array<String> Message;
var int StateRef;
var bool IsAlly;
var int RollTarget;
var XComGameState GameState;
var bool Used;

function EventListenerReturn DisplayThisEvent(Object EventData, Object EventSource, XComGameState NewGameState, Name EventID, Object CallbackData)
{
	//`log("Notif received visualization event",, 'EUAimRollsVis');
	if ((!class'OldAimRoll'.default.SHOW_ONLY_ALLIES || IsAlly) && !Used)
	{
		Used = true;
		Notify();
	}
	`XEVENTMGR.UnRegisterFromAllEvents(EventSource);
	return ELR_NoInterrupt;
}

function Notify()
{
	local string s;

	foreach Message(s)
	{
		`PRES.Notify(s);
	}
}