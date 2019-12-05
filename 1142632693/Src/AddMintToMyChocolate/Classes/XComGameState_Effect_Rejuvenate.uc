//---------------------------------------------------------------------------------------
//  FILE:    XComGameState_Effect_Rejuvenate.uc
//  AUTHOR:  Amineri (Pavonis Interactive)
//  PURPOSE: This is an effect component extension listening for medikit heals to grant extra health to the healed unit
//---------------------------------------------------------------------------------------

class XComGameState_Effect_Rejuvenate extends XComGameState_BaseObject;

function XComGameState_Effect_Rejuvenate InitComponent()
{
	return self;
}

function XComGameState_Effect GetOwningEffect()
{
	return XComGameState_Effect(`XCOMHISTORY.GetGameStateForObjectID(OwningObjectId));
}

//This is triggered by a Medikit heal
simulated function EventListenerReturn OnMedikitHeal(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
	local XComGameState_Unit SourceUnit, TargetUnit;
	local XpEventData XpEvent;
	local XComGameStateHistory History;
	local XComGameState_Effect EffectState;

	History = `XCOMHISTORY;
	XpEvent = XpEventData(EventData);
	if(XpEvent == none)
	{
		return ELR_NoInterrupt;
	}
	EffectState = GetOwningEffect();
	if (EffectState == none || EffectState.bReadOnly)  // this indicates that this is a stale effect from a previous battle
		return ELR_NoInterrupt;

	SourceUnit = XComGameState_Unit(History.GetGameStateForObjectID(XpEvent.XpEarner.ObjectID));
	if(SourceUnit == none || SourceUnit != XComGameState_Unit(History.GetGameStateForObjectID(GetOwningEffect().ApplyEffectParameters.TargetStateObjectRef.ObjectID)))
		return ELR_NoInterrupt;

	TargetUnit = XComGameState_Unit(History.GetGameStateForObjectID(XpEvent.EventTarget.ObjectID));
	if(TargetUnit == none)
		return ELR_NoInterrupt;

	TargetUnit.ModifyCurrentStat(eStat_HP, class'X2Effect_Rejuvenate'.default.RejuvenateBonusHealAmount);
	TargetUnit.ModifyCurrentStat(eStat_Will, class'X2Effect_Rejuvenate'.default.RejuvenateBonusWillAmount);

	return ELR_NoInterrupt;
}

