class X2Action_WaitForAnotherActionFix extends X2Action_WaitForAnotherAction;

`include(OverWatchLockUpFix\Src\ModConfigMenuAPI\MCM_API_CfgHelpers_ALT.uci);

var bool ACTION_TIMEOUT;

function Init()
{
	ACTION_TIMEOUT=`GETMCMVAR(ACTION_TIMEOUT);
	Super.Init();
}	

simulated state Executing
{
Begin:
	while( ActionToWaitFor != None && !ActionToWaitFor.bCompleted && !(IsTimedOut() && ACTION_TIMEOUT) )
	{
		Sleep(0.0f);
	}
	
	if (!ActionToWaitFor.bCompleted)
	{
		`redscreen( `showvar(self) @ "didn't trigger successfully!!");
		`redscreen(`showvar(ActionToWaitFor));
		`redscreen(`showvar(IsTimedOut()));

		`log(`showvar(self) @ "didn't trigger successfully!!");
		`log(`showvar(ActionToWaitFor));
		`log(`showvar(IsTimedOut()));
	}

	CompleteAction();
}