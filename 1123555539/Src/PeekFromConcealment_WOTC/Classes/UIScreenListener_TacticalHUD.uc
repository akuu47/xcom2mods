class UIScreenListener_TacticalHUD extends UIScreenListener;

var int numRevealedSteps, numSteps;

// TODO use GetCoverTypeForTarget to examine the path and ignore blocked concealment tiles for the path warning.
// override XComPathingPawn.RebuildPathInformation
// see Helpers.GetInstalledModNames to handle perfect information conflict??

// This event is triggered after a screen is initialized
event OnInit(UIScreen Screen)
{
	local Object ThisObj;

    `LOG("Starting Peek TacticalHUD Listener OnInit: " @ self);

	// make sure new units (eg. from reinforcements) have their movement events deregistered
	// This assumes that units don't spawn during the player's turn
    //`XCOMHISTORY.RegisterOnNewGameStateDelegate(OnNewGameState);
	ThisObj = self;
	`XEVENTMGR.RegisterForEvent(ThisObj, 'PlayerTurnBegun', BeginTurn, ELD_OnStateSubmitted);

	AttachCallbacks();
}

function EventListenerReturn BeginTurn(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData) {
    AttachCallbacks();
	return ELR_NoInterrupt;
}

event OnRemoved(UIScreen screen)
{
	// WTF: strangely enough this seems to be called at the beginning of tactical missions.
	// if I remove listeners here, I lose access to events and bugs happen.
	// I think I have to just ignore this and rely on the uniqueness of this listener and de-duplication to avoid excess registrations.

    //`LOG("Peek TacticalHUD Listener OnRemoved: " @ self);
    //local Object ThisObj;
    //ThisObj = self;
	//`XEVENTMGR.UnRegisterFromAllEvents(ThisObj);
    //`XCOMHISTORY.UnRegisterOnNewGameStateDelegate(OnNewGameState);
}

// This removes the default ObjectMoved callback from units.  It is replaced with the code in this class.
private function AttachCallbacks() {
    local Object ThisObj;
    local X2EventManager EventMgr;
	local XComGameStateHistory History;
    local XComGameState_Unit UnitState;
    local XComGameState_Player PlayerState;

    History = `XCOMHISTORY;
    EventMgr = `XEVENTMGR;
	ThisObj = self;

    foreach History.IterateByClassType(class'XComGameState_Unit', UnitState)
    {
		// remove vanilla callbacks
		EventMgr.UnRegisterFromEvent(UnitState, 'ObjectMoved');
    }

	// if allowing exposure during a move, hook the player visibility check to avoid a bug
	// which would cause the player to become exposed prematurely.
	// if in strict mode, we don't have to do this, which avoids some compatibility issues.
	if (class'ConcealmentRules'.default.NumGraceTiles > 0) {
		foreach History.IterateByClassType(class'XComGameState_Player', PlayerState)
		{
			// remove vanilla callbacks
			EventMgr.UnRegisterFromEvent(PlayerState, 'ObjectVisibilityChanged');
		}

		EventMgr.RegisterForEvent(ThisObj, 'ObjectVisibilityChanged', OnObjectVisibilityChanged, ELD_OnStateSubmitted);
	}


	// handle movement events ourselves
    EventMgr.RegisterForEvent(ThisObj, 'ObjectMoved', OnUnitEnteredTile, ELD_OnStateSubmitted);
    EventMgr.RegisterForEvent(ThisObj, 'UnitMoveFinished', OnUnitMoveFinished, ELD_OnStateSubmitted);
}

// This is copied from LW2 to get the Gremlin pod activation fix.  Otherwise it seems equivalent to Vanilla, so it should be compatible.
private function EventListenerReturn OnObjectVisibilityChanged(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
	local X2GameRulesetVisibilityInterface SourceObject;
	local XComGameState_Unit SeenUnit;
	local XComGameState_Unit SourceUnit;
	local GameRulesCache_VisibilityInfo VisibilityInfo;
	local X2GameRulesetVisibilityManager VisibilityMgr;

	VisibilityMgr = `TACTICALRULES.VisibilityMgr;

	SourceObject = X2GameRulesetVisibilityInterface(EventSource); 

	SeenUnit = XComGameState_Unit(EventData); // we only care about enemy units
    // LWS Mods: Don't trigger on cosmetic units (see comments in XCGS_Unit about gremlins not wanting to receive movement events).
    // Fixes bugs with Gremlins activating pods when you cancel a hack or when movement causes the gremlin to be visible while the unit
    // isn't.
	if(SeenUnit != none && SourceObject.TargetIsEnemy(SeenUnit.ObjectID) && !SeenUnit.GetMyTemplate().bIsCosmetic)
	{
		SourceUnit = XComGameState_Unit(SourceObject);
		if(SourceUnit != none && GameState != none)
		{
			VisibilityMgr.GetVisibilityInfo(SourceUnit.ObjectID, SeenUnit.ObjectID, VisibilityInfo, GameState.HistoryIndex);
			if(VisibilityInfo.bVisibleGameplay)
			{
				// private variable is not accessible - small sacrifice, aliens which are barely visible are not recorded in the counter
				// the counter creates alien noises for the player.

				/*if(PlayerState.TurnsSinceEnemySeen > 0 && SeenUnit.IsAlive())
				{
					NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("PlayerRecordEnemiesSeen");
					UpdatedPlayerState = XComGameState_Player(NewGameState.CreateStateObject(Class, PlayerObjectID));
					UpdatedPlayerState.TurnsSinceEnemySeen = 0;
					NewGameState.AddStateObject(UpdatedPlayerState);
					`GAMERULES.SubmitGameState(NewGameState);
				}*/

				//Inform the units that they see each other
				class'XComGameState_Unit'.static.UnitASeesUnitB(SourceUnit, SeenUnit, GameState);
			}
			else if (VisibilityInfo.bVisibleBasic)
			{
				//If the target is not yet gameplay-visible, it might be because they are concealed.
				//Check if the source should break their concealment due to the new conditions.
				//(Typically happens in XComGameState_Unit when a unit moves, but there are edge cases,
				//like blowing up the last structure between two units, when it needs to happen here.)
				// HACK -- don't count this when a unit is moving (NumSteps > 0).  NumSteps is set to 0 when motion ends.
				if (SeenUnit.IsConcealed() && SeenUnit.UnitBreaksConcealment(SourceUnit) && VisibilityInfo.TargetCover == CT_None && numSteps == 0)
				{
					if (VisibilityInfo.DefaultTargetDist <= Square(SeenUnit.GetConcealmentDetectionDistance(SourceUnit)))
					{
						`LOG("Breaking concealment for player visibility check!");
						SeenUnit.BreakConcealment(SourceUnit, VisibilityInfo.TargetCover == CT_None);
					}
				}
			}
		}
	}

	return ELR_NoInterrupt;
}

// unit moves - alert for him for other units he sees from the new location
// unit moves - alert for other units towards this unit
// NOTE - this replaces the vanilla logic in XComGameState_Unit and is adapted from it.
function EventListenerReturn OnUnitEnteredTile(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
	local XComGameState_Unit OtherUnitState, ThisUnitState;
	local XComGameStateHistory History;
	local X2GameRulesetVisibilityManager VisibilityMgr;
	local GameRulesCache_VisibilityInfo VisibilityInfoFromThisUnit, VisibilityInfoFromOtherUnit;
	local float ConcealmentDetectionDistance;
	local XComGameState_AIGroup AIGroupState;
	local XComGameStateContext_Ability SourceAbilityContext;
	local XComGameState_InteractiveObject InteractiveObjectState;
	local XComWorldData WorldData;
	local Vector CurrentPosition, TestPosition;
	local TTile CurrentTileLocation;
	local XComGameState_Effect EffectState;
	local X2Effect_Persistent PersistentEffect;
	local XComGameState NewGameState;
	local XComGameStateContext_EffectRemoved EffectRemovedContext;
	local bool DoesUnitBreaksConcealmentIgnoringDistance;
	local name RetainConcealmentName;
	local bool RetainConcealment;
	local bool bRevealedByMovement;

	WorldData = `XWORLD;
	History = `XCOMHISTORY;

	ThisUnitState = XComGameState_Unit(EventData);

	// don't activate from Gremlins etc
	if (ThisUnitState.GetMyTemplate().bIsCosmetic) { return ELR_NoInterrupt; }

	// cleanse burning on entering water
	ThisUnitState.GetKeystoneVisibilityLocation(CurrentTileLocation);
	if( ThisUnitState.IsBurning() && WorldData.IsWaterTile(CurrentTileLocation) )
	{
		foreach History.IterateByClassType(class'XComGameState_Effect', EffectState)
		{
			if( EffectState.ApplyEffectParameters.TargetStateObjectRef.ObjectID == ThisUnitState.ObjectID )
			{
				PersistentEffect = EffectState.GetX2Effect();
				if( PersistentEffect.EffectName == class'X2StatusEffects'.default.BurningName )
				{
					EffectRemovedContext = class'XComGameStateContext_EffectRemoved'.static.CreateEffectRemovedContext(EffectState);
					NewGameState = History.CreateNewGameState(true, EffectRemovedContext);
					EffectState.RemoveEffect(NewGameState, NewGameState, true); //Cleansed

					`TACTICALRULES.SubmitGameState(NewGameState);
				}
			}
		}
	}

	SourceAbilityContext = XComGameStateContext_Ability(GameState.GetContext());
	if( SourceAbilityContext != None )
	{
		// concealment for this unit is broken when stepping into a new tile if the act of stepping into the new tile caused environmental damage (ex. "broken glass")
		// if this occurred, then the GameState will contain either an environmental damage state or an InteractiveObject state
		// unless you're in challenge mode, then breaking stuff doesn't break concealment
		if( ThisUnitState.IsConcealed() && SourceAbilityContext.ResultContext.bPathCausesDestruction && (History.GetSingleGameStateObjectForClass( class'XComGameState_ChallengeData', true ) == none))
		{
			ThisUnitState.BreakConcealment();
		}

		ThisUnitState = XComGameState_Unit(History.GetGameStateForObjectID(ThisUnitState.ObjectID));

		// check if this unit is a member of a group waiting on this unit's movement to complete 
		// (or at least reach the interruption step where the movement should complete)
		AIGroupState = ThisUnitState.GetGroupMembership();
		if( AIGroupState != None &&
			AIGroupState.IsWaitingOnUnitForReveal(ThisUnitState) &&
			(SourceAbilityContext.InterruptionStatus != eInterruptionStatus_Interrupt ||
			(AIGroupState.FinalVisibilityMovementStep > INDEX_NONE &&
			AIGroupState.FinalVisibilityMovementStep <= SourceAbilityContext.ResultContext.InterruptionStep)) )
		{
			AIGroupState.StopWaitingOnUnitForReveal(ThisUnitState);
		}
	}

	// concealment may be broken by moving within range of an interactive object 'detector'
	if( ThisUnitState.IsConcealed() )
	{
		foreach class'X2AbilityTemplateManager'.default.AbilityRetainsConcealmentVsInteractives(RetainConcealmentName)
		{
			if (ThisUnitState.HasSoldierAbility(RetainConcealmentName))
			{
				RetainConcealment = true;
				break;
			}
		}

		if (!RetainConcealment)
		{
			ThisUnitState.GetKeystoneVisibilityLocation(CurrentTileLocation);
			CurrentPosition = WorldData.GetPositionFromTileCoordinates(CurrentTileLocation);
		
			foreach History.IterateByClassType(class'XComGameState_InteractiveObject', InteractiveObjectState)
			{
				if (InteractiveObjectState.DetectionRange > 0.0 && !InteractiveObjectState.bHasBeenHacked)
				{
					TestPosition = WorldData.GetPositionFromTileCoordinates(InteractiveObjectState.TileLocation);

					if (VSizeSq(TestPosition - CurrentPosition) <= Square(InteractiveObjectState.DetectionRange))
					{
						ThisUnitState.BreakConcealment();
						ThisUnitState = XComGameState_Unit(History.GetGameStateForObjectID(ThisUnitState.ObjectID));
						break;
					}
				}
			}
		}
	}

	// concealment may also be broken if this unit moves into detection range of an enemy unit
	VisibilityMgr = `TACTICALRULES.VisibilityMgr;
	foreach History.IterateByClassType(class'XComGameState_Unit', OtherUnitState)
	{
		// don't process visibility against self
		if( OtherUnitState.ObjectID == ThisUnitState.ObjectID )
		{
			continue;
		}

		VisibilityMgr.GetVisibilityInfo(ThisUnitState.ObjectID, OtherUnitState.ObjectID, VisibilityInfoFromThisUnit);

		if( VisibilityInfoFromThisUnit.bVisibleBasic )
		{
			// check if the other unit is concealed, and this unit's move has revealed him
			if( OtherUnitState.IsConcealed() &&
			    OtherUnitState.UnitBreaksConcealment(ThisUnitState) &&
				VisibilityInfoFromThisUnit.TargetCover == CT_None )
			{
				DoesUnitBreaksConcealmentIgnoringDistance = ThisUnitState.DoesUnitBreaksConcealmentIgnoringDistance();

				if( !DoesUnitBreaksConcealmentIgnoringDistance )
				{
					ConcealmentDetectionDistance = OtherUnitState.GetConcealmentDetectionDistance(ThisUnitState);
				}

				if( DoesUnitBreaksConcealmentIgnoringDistance ||
					VisibilityInfoFromThisUnit.DefaultTargetDist <= Square(ConcealmentDetectionDistance) )
				{
					OtherUnitState.BreakConcealment(ThisUnitState, true);

					// have to refresh the unit state after broken concealment
					OtherUnitState = XComGameState_Unit(History.GetGameStateForObjectID(OtherUnitState.ObjectID));
				}
			}

			// generate alert data for this unit about other units
			ThisUnitState.UnitASeesUnitB(ThisUnitState, OtherUnitState, GameState);
		}

		// only need to process visibility updates from the other unit if it is still alive
		if( OtherUnitState.IsAlive() )
		{
			VisibilityMgr.GetVisibilityInfo(OtherUnitState.ObjectID, ThisUnitState.ObjectID, VisibilityInfoFromOtherUnit);

			if( VisibilityInfoFromOtherUnit.bVisibleBasic )
			{
				// check if this unit is concealed and that concealment is broken by entering into an enemy's detection tile
				if( ThisUnitState.IsConcealed() && ThisUnitState.UnitBreaksConcealment(OtherUnitState) && class'ConcealmentRules'.static.IsVisible(ThisUnitState, OtherUnitState, VisibilityInfoFromOtherUnit) )
				{
					DoesUnitBreaksConcealmentIgnoringDistance = OtherUnitState.DoesUnitBreaksConcealmentIgnoringDistance();

					if (!DoesUnitBreaksConcealmentIgnoringDistance)
					{
						ConcealmentDetectionDistance = ThisUnitState.GetConcealmentDetectionDistance(OtherUnitState);
					}

					if( DoesUnitBreaksConcealmentIgnoringDistance ||
						VisibilityInfoFromOtherUnit.DefaultTargetDist <= Square(ConcealmentDetectionDistance) )
					{
						`LOG("Revealed by self-motion: cover = " @ String(VisibilityInfoFromOtherUnit.TargetCover) @ " steps = " @ String(numRevealedSteps));
						
						// break concealment if visible too long.  Also if starting from a concealment-breaking tile (numSteps == 0)
						bRevealedByMovement = true;
						if (numSteps == 0 || numRevealedSteps >= class'ConcealmentRules'.default.NumGraceTiles) {
							`LOG("Breaking concealment after step " @ String(numRevealedSteps) @ " with grace tiles = " @ String(class'ConcealmentRules'.default.NumGraceTiles));
							ThisUnitState.BreakConcealment(OtherUnitState);

							// have to refresh the unit state after broken concealment
							ThisUnitState = XComGameState_Unit(History.GetGameStateForObjectID(ThisUnitState.ObjectID));
						}
					}
				}

				// generate alert data for other units that see this unit
				if( VisibilityInfoFromOtherUnit.bVisibleBasic && !ThisUnitState.IsConcealed() )
				{
					//  don't register an alert if this unit is about to reflex
					AIGroupState = OtherUnitState.GetGroupMembership();
					if (AIGroupState == none || AIGroupState.EverSightedByEnemy)
						ThisUnitState.UnitASeesUnitB(OtherUnitState, ThisUnitState, GameState);
				}
			}
		}
	}

	// increment step counters.  These are reset when the unit move is finished
	if (bRevealedByMovement) {
		numRevealedSteps++;
	} else {
		//numRevealedSteps = 0; // reset
	}
	numSteps++;

	return ELR_NoInterrupt;
}

function EventListenerReturn OnUnitMoveFinished(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData) {
	local XComGameState_Unit OtherUnitState, ThisUnitState;
	local XComGameStateHistory History;
	local X2GameRulesetVisibilityManager VisibilityMgr;
	local GameRulesCache_VisibilityInfo VisibilityInfoFromOtherUnit;
	local XComGameState_AIGroup AIGroupState;

	VisibilityMgr = `TACTICALRULES.VisibilityMgr;
	
	History = `XCOMHISTORY;

	// reset step counter for the next move
	numRevealedSteps = 0;
	numSteps = 0;

	ThisUnitState = XComGameState_Unit(EventData);

	// don't activate from Gremlins etc
	if (ThisUnitState.GetMyTemplate().bIsCosmetic) { return ELR_NoInterrupt; }

	foreach History.IterateByClassType(class'XComGameState_Unit', OtherUnitState)
	{
		// don't process visibility against self
		if( OtherUnitState.ObjectID == ThisUnitState.ObjectID || !OtherUnitState.IsAlive())
		{
			continue;
		}

		VisibilityMgr.GetVisibilityInfo(OtherUnitState.ObjectID, ThisUnitState.ObjectID, VisibilityInfoFromOtherUnit);

		if( VisibilityInfoFromOtherUnit.bVisibleBasic )
		{
			// check if this unit is concealed and that concealment is broken by entering into an enemy's detection tile
			if( ThisUnitState.IsConcealed() && ThisUnitState.UnitBreaksConcealment(OtherUnitState) && class'ConcealmentRules'.static.IsVisible(ThisUnitState, OtherUnitState, VisibilityInfoFromOtherUnit) )
			{
				`LOG("Revealed by self-motion in final state: cover = " @ String(VisibilityInfoFromOtherUnit.TargetCover));
				ThisUnitState.BreakConcealment(OtherUnitState);

				// have to refresh the unit state after broken concealment
				ThisUnitState = XComGameState_Unit(History.GetGameStateForObjectID(ThisUnitState.ObjectID));

				// generate alert data for other units that see this unit
				if( !ThisUnitState.IsConcealed() )
				{
					//  don't register an alert if this unit is about to reflex
					AIGroupState = OtherUnitState.GetGroupMembership();
					if (AIGroupState == none || AIGroupState.EverSightedByEnemy)
						ThisUnitState.UnitASeesUnitB(OtherUnitState, ThisUnitState, GameState);
				}
			}

		}
	}

	return ELR_NoInterrupt;
}

defaultproperties {
	ScreenClass = UITacticalHUD
}