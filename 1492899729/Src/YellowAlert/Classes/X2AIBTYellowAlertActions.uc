class X2AIBTYellowAlertActions extends X2AIBTDefaultActions;

static event bool FindBTActionDelegate(name strName, optional out delegate<BTActionDelegate> dOutFn, optional out name NameParam, optional out name MoveProfile)
{
	dOutFn = None;

	switch( strName )
	{
		case 'DoNoiseAlert':
			dOutFn = CustomDoNoiseAlert;
			return true;
		break;
	}
	return super.FindBTActionDelegate(strName, dOutFn, NameParam, MoveProfile);
}

function bt_status CustomDoNoiseAlert() // contents basically stolen from SeqAct_DropAlert
{
	local XComGameStateHistory History;
	local XComGameState NewGameState;
	local AlertAbilityInfo AlertInfo;
	local XComGameState_Unit kUnitState;
	local XComGameState_AIUnitData NewUnitAIState, kAIData;
	local array<StateObjectReference> AliensInRange; // LWS Added
	local bool CleanupAIData; // LWS Added

	History = `XCOMHISTORY;

	// Kick off mass alert to location.
	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState( "BehaviorTree - DoNoiseAlert" );

	AlertInfo.AlertTileLocation = m_kUnitState.TileLocation;
	AlertInfo.AlertRadius = 799;
	AlertInfo.AlertUnitSourceID = m_kUnitState.ObjectID;
	AlertInfo.AnalyzingHistoryIndex = History.GetCurrentHistoryIndex( ); //NewGameState.HistoryIndex; <- this value is -1.

	// LWS added: Gather the units in sound range of this civvy.
	class'HelpersYellowAlert'.static.GetAlienUnitsInRange(m_kUnitState.TileLocation, 27, AliensInRange);

	foreach History.IterateByClassType( class'XComGameState_AIUnitData', kAIData )
	{
		kUnitState = XComGameState_Unit( History.GetGameStateForObjectID( kAIData.m_iUnitObjectID ) );
		if (kUnitState != None && kUnitState.IsAlive( ))
		{
			// LWS Add: Skip units outside of sound range
			if (AliensInRange.Find('ObjectID', kUnitState.ObjectID) < 0)
				continue;
			CleanupAIData = false;
			// LWS: Check to see if we already have ai data for this unit in this game state (alert may already have been propagated to
			// group members).
			NewUnitAIState = XComGameState_AIUnitData(NewGameState.GetGameStateForObjectID(kAIData.ObjectID));
			if (NewUnitAIState == none)
			{
				NewUnitAIState = XComGameState_AIUnitData( NewGameState.CreateStateObject( kAIData.Class, kAIData.ObjectID ) );
				// LWS: This unit will need cleanup if we fail to add the alert.
				CleanupAIData = true;
			}
			if( NewUnitAIState.AddAlertData( kAIData.m_iUnitObjectID, eAC_AlertedByYell, AlertInfo, NewGameState ) )
			{
				NewGameState.AddStateObject(NewUnitAIState);
			}
			else
			{
				// LWS Add: Don't cleanup this AI unit data unless we created it.
				if (CleanupAIData)
				{
					NewGameState.PurgeGameStateForObjectID(NewUnitAIState.ObjectID);
				}
			}
		}
	}

	if( NewGameState.GetNumGameStateObjects() > 0 )
	{
		`GAMERULES.SubmitGameState(NewGameState);
	}
	else
	{
		History.CleanupPendingGameState(NewGameState);
	}

	return BTS_SUCCESS;
}

//Setup action to g
defaultproperties
{
}