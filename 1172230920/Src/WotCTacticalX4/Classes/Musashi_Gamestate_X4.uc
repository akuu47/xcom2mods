class Musashi_Gamestate_X4 extends XComGameState_Effect;

var array<Vector> TargetLocations;
var name EffectName;

function EventListenerReturn OnTacticalGameEnd(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
	local X2EventManager EventManager;
	local Object ListenerObj;
    local XComGameState NewGameState;
	
	EventManager = `XEVENTMGR;

	// Unregister our callbacks
	ListenerObj = self;
	
	EventManager.UnRegisterFromEvent(ListenerObj, 'AbilityActivated');
	EventManager.UnRegisterFromEvent(ListenerObj, 'TacticalGameEnd');
	
    NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("X4 states cleanup");
	NewGameState.RemoveStateObject(ObjectID);
	`GAMERULES.SubmitGameState(NewGameState);

	return ELR_NoInterrupt;
}

function EventListenerReturn OnAbilityActivated(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
	local XComGameStateContext_Ability AbilityContext;
	local XComGameState_Unit SourceUnitState;
	local X2Effect_Persistent EffectTemplate;

	EffectTemplate = GetX2Effect();

	AbilityContext = XComGameStateContext_Ability(GameState.GetContext());
	
	if (AbilityContext.InterruptionStatus != eInterruptionStatus_Interrupt)
	{
		SourceUnitState = XComGameState_Unit(AbilityContext.AssociatedState.GetGameStateForObjectID(AbilityContext.InputContext.SourceObject.ObjectID));
		if (SourceUnitState != none)
		{
			if (AbilityContext.InputContext.AbilityTemplateName == class'Musashi_X4_AbilitySet'.default.TriggerC4AbilityName &&
				EffectName == class'Musashi_X4_AbilitySet'.default.C4EffectName)
			{
				Detonate(class'Musashi_X4_AbilitySet'.default.ExplodeC4AbilityName, SourceUnitState, GameState);
			}
				
			if (AbilityContext.InputContext.AbilityTemplateName == class'Musashi_X4_AbilitySet'.default.TriggerX4AbilityName &&
				EffectName == class'Musashi_X4_AbilitySet'.default.X4EffectName)
			{
				Detonate(class'Musashi_X4_AbilitySet'.default.ExplodeX4AbilityName, SourceUnitState, GameState);
			}
			if (AbilityContext.InputContext.AbilityTemplateName == class'Musashi_X4_AbilitySet'.default.TriggerE4AbilityName &&
				EffectName == class'Musashi_X4_AbilitySet'.default.E4EffectName)
			{
				Detonate(class'Musashi_X4_AbilitySet'.default.ExplodeE4AbilityName, SourceUnitState, GameState);
			}
			
			return ELR_NoInterrupt;
		}
	}

	// If some part of the above checks failed, notify the unit state of ability activation
	return SourceUnitState.OnAbilityActivated(EventData, EventSource, GameState, Event, CallbackData);
}

private function Detonate(Name ExplodeAbilityName, XComGameState_Unit SourceUnit, XComGameState RespondingToGameState)
{
	local XComGameState_Ability AbilityState;
	local AvailableAction Action;
	local AvailableTarget Target;
	local XComGameStateContext_EffectRemoved EffectRemovedState;
	local XComGameState NewGameState;
	local XComGameStateHistory History;

	History = `XCOMHISTORY;
	Action.AbilityObjectRef = SourceUnit.FindAbility(ExplodeAbilityName);
	if (Action.AbilityObjectRef.ObjectID != 0)
	{
		AbilityState = XComGameState_Ability(History.GetGameStateForObjectID(Action.AbilityObjectRef.ObjectID));
		if (AbilityState != none)
		{
			Action.AvailableCode = 'AA_Success';

			AbilityState.GatherAdditionalAbilityTargetsForLocation(TargetLocations[0], Target);
			`LOG("Musashi_Gamestate_X4 Trigger " @ AbilityState.GetMyTemplateName(),, 'TacticalX4');
			Action.AvailableTargets.AddItem(Target);

			if (class'XComGameStateContext_Ability'.static.ActivateAbility(Action, 0, TargetLocations))
			{
				`LOG("Musashi_Gamestate_X4 DetonateX4 at location " @ TargetLocations[0],, 'TacticalX4');
				EffectRemovedState = class'XComGameStateContext_EffectRemoved'.static.CreateEffectRemovedContext(self);
				NewGameState = History.CreateNewGameState(true, EffectRemovedState);
				RemoveEffect(NewGameState, RespondingToGameState);
				SourceUnit = XComGameState_Unit(NewGameState.CreateStateObject(SourceUnit.Class, SourceUnit.ObjectID));
				SourceUnit.SetUnitFloatValue(EffectName, float(0), eCleanup_BeginTactical);
				NewGameState.ModifyStateObject(class'XComGameState_Unit', SourceUnit.ObjectID);
				SubmitNewGameState(NewGameState);
			}
		}
	}
}
