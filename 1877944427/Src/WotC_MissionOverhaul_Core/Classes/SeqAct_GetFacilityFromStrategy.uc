///---------------------------------------------------------------------------------------
//  FILE:    SeqAct_GetFacilityFromStrategy.uc
//  AUTHOR:  E3245
//  PURPOSE: Determine if a given facility is built in strategy layer.
//           
//---------------------------------------------------------------------------------------

class SeqAct_GetFacilityFromStrategy extends SequenceAction;

var() Name FacilityName;
var() Name FacilityUpgrade;

event Activated()
{
	local XComGameStateHistory History;
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_FacilityXCom FacilityState;

	History = `XCOMHISTORY;
	XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));

	if(XComHQ != None)
	{
		FacilityState = XComHQ.GetFacilityByName(FacilityName);
		if(FacilityState != none)
		{
			if (FacilityUpgrade != 'none')
			{
				if(FacilityState.HasUpgrade(FacilityUpgrade))
				{
					OutputLinks[0].bHasImpulse = true; 
					OutputLinks[1].bHasImpulse = false;
				}
				else
				{
					OutputLinks[0].bHasImpulse = false; 
					OutputLinks[1].bHasImpulse = true;
				}
			}
			else // We just want to evaluate if we have the facility
			{
				OutputLinks[0].bHasImpulse = true; 
				OutputLinks[1].bHasImpulse = false;
			}
		}
		else
		{
			OutputLinks[0].bHasImpulse = false; 
			OutputLinks[1].bHasImpulse = true;
		}
	}
	else
	{
		OutputLinks[0].bHasImpulse = false;	
		OutputLinks[1].bHasImpulse = true;
	}
}

defaultproperties
{
	ObjName="Is Facility Built"
	ObjCategory="WotC Mission Overhaul"
	bCallHandler=false

	bConvertedForReplaySystem=true
	bCanBeUsedForGameplaySequence=true

	OutputLinks(0)=(LinkDesc="True")
	OutputLinks(1)=(LinkDesc="False")
}