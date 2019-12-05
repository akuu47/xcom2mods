class  X2Action_WaitForDestructibleActorActionTriggerFix extends  X2Action_WaitForDestructibleActorActionTrigger;

`include(OverWatchLockUpFix\Src\ModConfigMenuAPI\MCM_API_CfgHelpers_ALT.uci);

var bool DESTRUCTABLE_TIMEOUT;

//Mr. Nice: Annoyingly, all 4 of these are private in the parents class, so have to reimplement them!
var X2EventManager EventManager;
var bool bTriggered;
var class<XComDestructibleActor_Action> WaitForActionClass;
var int WaitForDestructibleActorObjectID;

function Init()
{
	DESTRUCTABLE_TIMEOUT=`GETMCMVAR(DESTRUCTABLE_TIMEOUT);
	Super.Init();
}	



function SetTriggerParameters(class<XComDestructibleActor_Action> WaitForClass, int InWaitForDestructibleActorObjectID)
{
	local Object ThisObj;

	WaitForActionClass = WaitForClass;
	WaitForDestructibleActorObjectID = InWaitForDestructibleActorObjectID;

	//Register for the event here, to cover the situation where the event we are waiting on is triggered in the same frame
	//as init
	EventManager = `XEVENTMGR;
	ThisObj = self;
	EventManager.RegisterForEvent(ThisObj, 'DestructibleActorActionTrigger', OnHandleActionTrigger, ELD_Immediate);
}

function EventListenerReturn OnHandleActionTrigger(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{		
	local XComDestructibleActor Destructible;
	local XComDestructibleActor_Action TriggeredAction;

	TriggeredAction = XComDestructibleActor_Action(EventData);
	Destructible = XComDestructibleActor(EventSource);
	if (TriggeredAction != none && TriggeredAction.Class == WaitForActionClass &&
		Destructible != none && Destructible.ObjectID == WaitForDestructibleActorObjectID)
	{
		bTriggered = true;
	}	
	
	return ELR_NoInterrupt;
}

function TriggerWaitCondition()
{
	bTriggered = true;
}

//------------------------------------------------------------------------------------------------
simulated state Executing
{	
Begin:
	while( WaitForActionClass!=none && WaitForDestructibleActorObjectID!=0
		&& !bTriggered && !(IsTimedOut() && DESTRUCTABLE_TIMEOUT) )
	{
		sleep(0.0);
	}
	if (!bTriggered)
	{
		`redscreen( `showvar(self) @ "didn't trigger successfully!!");
		`redscreen(`showvar(WaitForActionClass));
		`redscreen(`showvar(WaitForDestructibleActorObjectID));
		`redscreen(`showvar(IsTimedOut()));

		`log(`showvar(self) @ "didn't trigger successfully!!");
		`log(`showvar(WaitForActionClass));
		`log(`showvar(WaitForDestructibleActorObjectID));
		`log(`showvar(IsTimedOut()));
	}

	CompleteAction();
}

defaultproperties
{
	TimeoutSeconds=60
}
