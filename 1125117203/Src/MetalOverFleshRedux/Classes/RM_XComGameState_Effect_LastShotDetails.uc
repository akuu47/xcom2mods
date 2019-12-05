class RM_XComGameState_Effect_LastShotDetails extends XComGameState_BaseObject config (SPARKUpgrades);

var config array<name> SHOTFIRED_ABILITYNAMES;

var bool				b_AnyShotTaken;
var bool				b_LastShotHit;
var XComGameState_Unit	LastShotTarget;
var int					LSTObjID;

function RM_XComGameState_Effect_LastShotDetails InitComponent()
{
	b_AnyShotTaken = false;
	return self;
}

function XComGameState_Effect GetOwningEffect()
{
	return XComGameState_Effect(`XCOMHISTORY.GetGameStateForObjectID(OwningObjectId));
}

simulated function EventListenerReturn RecordShot(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
    local XComGameState								NewGameState;
	local RM_XComGameState_Effect_LastShotDetails		ThisEffect;		
	local XComGameState_Ability						ActivatedAbilityState;
    local XComGameStateContext_Ability				ActivatedAbilityStateContext;
	local XComGameState_Unit						TargetUnit;

	ActivatedAbilityState = XComGameState_Ability(EventData);
	if (ActivatedAbilityState != none)
	{
		if (default.SHOTFIRED_ABILITYNAMES.Find(ActivatedAbilityState.GetMyTemplateName()) != -1)
		{
			ActivatedAbilityStateContext = XComGameStateContext_Ability(GameState.GetContext());	
			TargetUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(ActivatedAbilityStateContext.InputContext.PrimaryTarget.ObjectID));
			If (TargetUnit != none)
			{
				NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Update: Gather Shot Details");
				ThisEffect=RM_XComGameState_Effect_LastShotDetails(NewGameState.CreateStateObject(Class,ObjectID));
				ThisEffect.b_AnyShotTaken = true;
				ThisEffect.LastShotTarget = TargetUnit;
				ThisEffect.LSTObjID = TargetUnit.ObjectID;
				ThisEffect.b_LastShotHit = !ActivatedAbilityStateContext.IsResultContextMiss();
				NewGameState.AddStateObject(ThisEffect);
				`TACTICALRULES.SubmitGameState(NewGameState);    
			}
		}
	}	
	return ELR_NoInterrupt;
}


DefaultProperties
{
	bTacticalTransient=true
}
