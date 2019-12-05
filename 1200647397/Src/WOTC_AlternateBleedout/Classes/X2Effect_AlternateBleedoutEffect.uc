// Implements the effect that overrides the Bleedout chance:
class X2Effect_AlternateBleedoutEffect extends X2Effect_Persistent config(AlternateBleedout);


var config float	BLEEDOUT_CHANCE_PER_RANK;
var config float	BLEEDOUT_MAX_WILL_WEIGHT;
var config float	BLEEDOUT_CURRENT_WILL_WEIGHT;

var config float	STAY_WITH_ME_CHANCE_PER_RANK;
var config float	STAY_WITH_ME_OVERKILL_MOD;

var bool			bDebugLogging;


// Register for the Event Trigger
function RegisterForEvents(XComGameState_Effect EffectGameState)
{
	local X2EventManager		EventMgr;
	local Object				EffectObj;
	local XComGameState_Unit	EffectTargetUnit;

	// Exit if Alternate Bleedout Mechanics is not enabled
	if (!`SecondWaveEnabled('AlternateBleedout'))
	{
		return;
	}

	EventMgr = `XEVENTMGR;
	EffectObj = EffectGameState;
	EffectTargetUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectGameState.ApplyEffectParameters.TargetStateObjectRef.ObjectID));

	// Register for event at highest priority so any other modification events can happen after we rework the chance.
	EventMgr.RegisterForEvent(EffectObj, 'OverrideBleedoutChance', OnOverrideBleedoutChance, ELD_Immediate, 100, EffectTargetUnit);
}


// Manipulate the Bleedout Chance
static function EventListenerReturn OnOverrideBleedoutChance(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
	local XComLWTuple						OverrideTuple;
	local float								BleedoutChance, fVal;
	local bool								bStayWithMe, bLog;
	local XComGameState_Unit				UnitState;
	local XComGameState_HeadquartersXCom	XComHQ;

	// Exit if Alternate Bleedout Mechanics is not enabled
	if (!`SecondWaveEnabled('AlternateBleedout'))
	{
		return ELR_NoInterrupt;
	}

	bLog = class'X2DownloadableContentInfo_WOTC_AlternateBleedout'.default.bDEBUG_LOG;

	// Pull in data from Tuple
	OverrideTuple = XComLWTuple(EventData);
	if(OverrideTuple == none)
		return ELR_NoInterrupt;

	if(OverrideTuple.Id != 'OverrideBleedoutChance')
		return ELR_NoInterrupt;

	// For Reference:
	// OverrideTuple.Data[0].i = Bleedout Chance Roll Target
	// OverrideTuple.Data[1].i = Bleedout Chance Roll Maximum
	// OverrideTuple.Data[2].i = Overkill Damage

	UnitState = XComGameState_Unit(EventSource);
	/*DEBUG*/`LOG("Alternate Bleedout: Overriding Bleedout Chance for" @ UnitState.GetFullName(), bLog);

	// Determine if Stay With Me is active
	XComHQ = XComGameState_HeadquartersXCom(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom', true));
	bStayWithMe = (XComHQ != none && XComHQ.SoldierUnlockTemplates.Find('StayWithMeUnlock') != INDEX_NONE);
	/*DEBUG*/`LOG("Alternate Bleedout: 'Stay With Me' active =" @ bStayWithMe, bLog);

	// Fix the Bleedout chance random number roll to always be between 0 and 100
	OverrideTuple.Data[1].i = 100;

	// Cap Overkill Damage at 10
	if (OverrideTuple.Data[2].i > 10)
	{
		/*DEBUG*/`LOG("Alternate Bleedout: Overkill Damage of" @ OverrideTuple.Data[2].i @ "> 10. Capping at 10.", bLog);
		OverrideTuple.Data[2].i = 10;
	}

	// Get UnitState's ranks above squaddie
	BleedoutChance = Max(0, UnitState.GetSoldierRank() - 1);

	// Calculate Bleedout chance according to rank and the Overkill Damage contribution
	if (!bStayWithMe)
	{
		fVal = BleedoutChance * default.BLEEDOUT_CHANCE_PER_RANK;
		BleedoutChance = fVal;
		/*DEBUG*/`LOG("Alternate Bleedout: Base Bleedout Chance From Rank:" @ fVal, bLog);

		fVal = OverrideTuple.Data[2].i ** 2;
		BleedoutChance -= fVal;
		/*DEBUG*/`LOG("Alternate Bleedout: Subtracting chance due to Overkill Damage (" $ OverrideTuple.Data[2].i $ "):" @ fVal, bLog);
		
	}
	else
	{
		fVal = BleedoutChance * default.STAY_WITH_ME_CHANCE_PER_RANK;
		BleedoutChance = fVal;
		/*DEBUG*/`LOG("Alternate Bleedout: Base Bleedout Chance From Rank:" @ fVal, bLog);

		fVal = default.STAY_WITH_ME_OVERKILL_MOD * OverrideTuple.Data[2].i ** 2;
		BleedoutChance -= fVal;
		/*DEBUG*/`LOG("Alternate Bleedout: Subtracting chance due to Overkill Damage (" $ OverrideTuple.Data[2].i $ "):" @ fVal, bLog);
	}

	// Add Unit's Will stat contribution to the Bleedout chance
	fVal = (UnitState.GetMaxStat(eStat_Will) * default.BLEEDOUT_MAX_WILL_WEIGHT) + (UnitState.GetCurrentStat(eStat_Will) * default.BLEEDOUT_CURRENT_WILL_WEIGHT);
	fVal = 10 * (fVal ** 0.5);
	BleedoutChance += fVal;
	/*DEBUG*/`LOG("Alternate Bleedout: Adding chance due to Unit's Will stat:" @ fVal, bLog);
	/*DEBUG*/`LOG("Alternate Bleedout: Final Bleedout chance:" @ Round(BleedoutChance) @"/ 100", bLog);

	OverrideTuple.Data[0].i = Round(BleedoutChance);
}