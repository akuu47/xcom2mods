class UISL_UIPersonnel_Psi extends UIScreenListener;

var bool bRegisteredForEvents; 

private function bool IsInStrategy()
{
	return `HQGAME  != none && `HQPC != None && `HQPRES != none;
}

event OnInit(UIScreen Screen)
{
	//reset switch in tactical so we re-register back in strategy
	if(UITacticalHUD(Screen) == none)
	{
		RegisterForEvents();
		bRegisteredForEvents = false;
	}
	if(IsInStrategy() && !bRegisteredForEvents)
	{
		RegisterForEvents();
		bRegisteredForEvents = true;
	}

}

function RegisterForEvents()
{
	local X2EventManager EventManager;
	local Object ThisObj;

	ThisObj = self;

	EventManager = `XEVENTMGR;
	EventManager.UnRegisterFromAllEvents(ThisObj);

	EventManager.RegisterForEvent(ThisObj, 'DSLShouldShowPsi', ShowIfPsion,,,,true,);
}

function EventListenerReturn ShowIfPsion(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
	local LWTuple EventTup;
	local XComGameState_Unit Unit;

	EventTup = LWTuple(EventData);

	//Is already a psi-operative by base game standards
	if (EventTup.Data[0].b)
		return ELR_NoInterrupt;

	//Grab the related unit
	Unit = XComGameState_Unit(EventSource);
	
	//If doesn't exist, that's weird, but we don't care
	if(Unit == none)
		return ELR_NoInterrupt;

	//Is this a psion by our standards?
	if(class'MNT_Utility'.static.IsPsion(Unit)){
		//Show psi stat!
		EventTup.Data[0].b = true;
		return ELR_NoInterrupt;
	}

	//We're technically done here, but just in case...
	if(Unit.GetBaseStat(eStat_PsiOffense) > 50){
		//If you have more than 50 psi attack, hopefully that's for a good reason...
		EventTup.Data[0].b = true;
		return ELR_NoInterrupt;
	}

	return ELR_NoInterrupt;
}

defaultproperties
{
	// Leaving this assigned to none will cause every screen to trigger its signals on this class
	ScreenClass = none;
}