class XComGameState_Ability_DeepCover extends XComGameState_Ability;

function EventListenerReturn DeepCoverTurnEndListener(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
	local XComGameState_Unit UnitState;
	local UnitValue AttacksThisTurn;
	local bool GotValue;
	local StateObjectReference HunkerDownRef;
	local XComGameState_Ability HunkerDownState;
	local XComGameStateHistory History;
	local XComGameState NewGameState;

	History = `XCOMHISTORY;
	UnitState = XComGameState_Unit(GameState.GetGameStateForObjectID(OwnerStateObject.ObjectID));
	if (UnitState == none)
		UnitState = XComGameState_Unit(History.GetGameStateForObjectID(OwnerStateObject.ObjectID));

	if (UnitState != none && !UnitState.IsHunkeredDown())
	{
		GotValue = UnitState.GetUnitValue('AttacksThisTurn', AttacksThisTurn);
		if (!GotValue || AttacksThisTurn.fValue == 0)
		{
			HunkerDownRef = UnitState.FindAbility('HunkerDown');
			HunkerDownState = XComGameState_Ability(History.GetGameStateForObjectID(HunkerDownRef.ObjectID));
			if (HunkerDownState != none && HunkerDownState.CanActivateAbility(UnitState,,true) == 'AA_Success')
			{
				if (UnitState.NumActionPoints() == 0)
				{
					NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState(string(GetFuncName()));
					UnitState = XComGameState_Unit(NewGameState.ModifyStateObject(UnitState.Class, UnitState.ObjectID));
					//  give the unit an action point so they can activate hunker down										
					UnitState.ActionPoints.AddItem(class'X2CharacterTemplateManager'.default.DeepCoverActionPoint);					
					`TACTICALRULES.SubmitGameState(NewGameState);
				}
							
				return HunkerDownState.AbilityTriggerEventListener_Self(EventData, EventSource, GameState, EventID, CallbackData);
			}
			// ADDING HUNKER DOWN NO ANIM
			HunkerDownRef = UnitState.FindAbility('HunkerDownNoAnim');
			HunkerDownState = XComGameState_Ability(History.GetGameStateForObjectID(HunkerDownRef.ObjectID));
			if (HunkerDownState != none && HunkerDownState.CanActivateAbility(UnitState,,true) == 'AA_Success')
			{
				if (UnitState.NumActionPoints() == 0)
				{
					NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState(string(GetFuncName()));
					UnitState = XComGameState_Unit(NewGameState.ModifyStateObject(UnitState.Class, UnitState.ObjectID));
					//  give the unit an action point so they can activate hunker down										
					UnitState.ActionPoints.AddItem(class'X2CharacterTemplateManager'.default.DeepCoverActionPoint);					
					`TACTICALRULES.SubmitGameState(NewGameState);
				}
							
				return HunkerDownState.AbilityTriggerEventListener_Self(EventData, EventSource, GameState, EventID, CallbackData);
			}
			`log("Deep Cover was checked for HunkerDownNoAnim (which is good!)");
			`RedScreen("Deep Cover was checked for HunkerDownNoAnim (which is good!)");
		}
	}

	return ELR_NoInterrupt;
}