Class YellowAlert_XGAIPlayer extends XGAIPlayer config(YellowAlert);

var config bool VISIBLE_ENEMIES_STOP_MOVING;

// Update - green alert units and units that have not yet revealed should do their patrol movement.
function bool ShouldUnitPatrol( XComGameState_Unit UnitState )
{
	if( IsMindControlled(UnitState) )
	{
		return false;
	}
	if( (UnitState.IsUnrevealedAI() ||  !VISIBLE_ENEMIES_STOP_MOVING ) && !IsScampering(UnitState.ObjectID) )
	{
		// For now only allow group leaders to direct movement when unrevealed.
		if( UnitState.GetGroupMembership().m_arrMembers[0].ObjectID == UnitState.ObjectID )
		{
			return true;
		}
	}
	return false;
}

simulated function GatherUnitsToMove()
{
	local XComGameState_Unit UnitState;
	local XComGameStateHistory History;
	local GameRulesCache_Unit DummyCachedActionData;
	local array<GameRulesCache_Unit> arrGreenPatrollers;
	local array<GameRulesCache_Unit> arrOthers;
	local array<GameRulesCache_Unit> arrToSkip;
	local array<GameRulesCache_Unit> ScamperSetup;
	local array<GameRulesCache_Unit> Scampering;
	local array<int> OrderPriorityList;
	local XComTacticalCheatManager kCheatMgr;
	local XGAIBehavior kBehavior;
	//local XComGameState_AIPlayerData kAIPlayerData;
	local bool bDead, bGroupUnitAdded;
	local X2AIBTBehaviorTree BTMgr;
	local XComGameState_AIGroup AIGroupState;
	local StateObjectReference UnitStateObjRef;
	local X2CharacterTemplate CharTemplate;

	//kAIPlayerData = XComGameState_AIPlayerData(`XCOMHISTORY.GetGameStateForObjectID(GetAIDataID()));

	kCheatMgr = `CHEATMGR;
	BTMgr = `BEHAVIORTREEMGR;

	if (m_bSkipAI || (`CHEATMGR != None && `CHEATMGR.bAllowSelectAll) || (CurrentAIGroupRef.ObjectID <= 0))
		return;
	History = `XCOMHISTORY;

	AIGroupState = XComGameState_AIGroup(History.GetGameStateForObjectID(CurrentAIGroupRef.ObjectID));
	if (self.IsA('XGAIPlayer_TheLost') && HasGroupAlreadyMovedThisTurn(CurrentAIGroupRef.ObjectID)
		&& (AIGroupState.EncounterID != class'XGAIPlayer_TheLost'.const.MAIN_LOST_GROUP_ID)) // Main group excluded from this check.
	{
		// For TheLost groups, we only need to add one unit to process per group.  
		// The one unit per Lost group will kick off a mass move and mass attack.
		bGroupUnitAdded = true;
	}
	`assert(AIGroupState != None);

	//Loop through every unit, if it is ours, add it to the list
	foreach AIGroupState.m_arrMembers(UnitStateObjRef)
	{
		UnitState = XComGameState_Unit(History.GetGameStateForObjectID(UnitStateObjRef.ObjectID));

		// Initialize dummy cached action data.  This isn't actually updated until just before the unit begins its turn.
		DummyCachedActionData.UnitObjectRef.ObjectID = UnitState.ObjectID;
		bDead = UnitState.IsDead();
		if (kCheatMgr != None)
		{
			kCheatMgr.AIStringsAddUnit(UnitState.ObjectID, bDead);
		}

		kBehavior = (XGUnit(UnitState.GetVisualizer())).m_kBehavior;

		// Check if this unit has already moved this turn.  (Compare init history index to last turn start) 
		// Also skip units that have currently no action points available.   They shouldn't be added to any lists.
		//Yellow Alert - removed a check that Compare init history index to last turn start - this allows for reflex actions
		//action points are a good enough test here
		if(bDead || UnitState.bRemovedFromPlay || UnitState.NumAllActionPoints() == 0 || kBehavior == None )
		{
			continue;
		}

		if (self.IsA('XGAIPlayer_TheLost') && bGroupUnitAdded )
		{
			arrToSkip.AddItem(DummyCachedActionData);
			kCheatMgr.AIStringsUpdateString(UnitState.ObjectID, "Additional Lost units in AI Group- Skipping.");
			continue;
		}


		// Add units to scamper setup list.
		if( m_arrWaitForScamper.Find(UnitState.ObjectID) != INDEX_NONE )
		{
			ScamperSetup.AddItem(DummyCachedActionData);
			kCheatMgr.AIStringsUpdateString(UnitState.ObjectID, "ScamperSetup");
			bGroupUnitAdded = true;
		}
		else if( BTMgr.IsQueued(UnitState.ObjectID) )
		{
			Scampering.AddItem(DummyCachedActionData);
			kCheatMgr.AIStringsUpdateString(UnitState.ObjectID, "Scampering");
			bGroupUnitAdded = true;
		}
		else if( UnitIsFallingBack(UnitState) )
		{
			arrGreenPatrollers.InsertItem(0,DummyCachedActionData); // Fallback units get priority to move first.
			kCheatMgr.AIStringsUpdateString(UnitState.ObjectID, "Falling Back");
			bGroupUnitAdded = true;
		}
		else if (ShouldUnitPatrol(UnitState)) // && m_kNav.IsPatrol(UnitState.ObjectID))
		{
			arrGreenPatrollers.AddItem(DummyCachedActionData);
			kCheatMgr.AIStringsUpdateString(UnitState.ObjectID, "Green Alert Patrol");
			bGroupUnitAdded = true;
		}
		else if (UnitState.GetCurrentStat(eStat_AlertLevel)>0 || IsMindControlled(UnitState))
		{
			CharTemplate = UnitState.GetMyTemplate();
			AddToOrderedCharacterList(arrOthers, DummyCachedActionData, OrderPriorityList, CharTemplate.AIOrderPriority);
			bGroupUnitAdded = true;
		}
		else
		{
			arrToSkip.AddItem(DummyCachedActionData);
			kCheatMgr.AIStringsUpdateString(UnitState.ObjectID, "Green Alert non-patrol- Skipping.");
		}
	}

	if( IsScampering() )
	{
		if( WaitingForScamperSetup() )
		{
			if( m_ePhase != eAAP_ScamperSetUp )
			{
				m_ePhase = eAAP_ScamperSetUp;
				`LogAI(" AI Player : Entering phase ScamperSetup");
			}
			UnitsToMove = ScamperSetup;
		}
		else
		{
			if( m_ePhase != eAAP_Scampering )
			{
				m_ePhase = eAAP_Scampering;
				`LogAI(" AI Player : Entering phase Scampering");
			}
			UnitsToMove = Scampering;
		}
	}
	else
	{
		if( arrGreenPatrollers.Length > 0 )
		{
			if(m_ePhase != eAAP_GreenPatrolMovement )
			{
				m_ePhase = eAAP_GreenPatrolMovement;
				`LogAI(" AI Player : Entering phase GreenPatrolMovement");
			}
			UnitsToMove = arrGreenPatrollers;
		}
		else
		{
			if( m_ePhase != eAAP_SequentialMovement )
			{
				m_ePhase = eAAP_SequentialMovement;
				`LogAI(" AI Player : Entering phase Sequential Movement");
			}
			// TODO: Sort units to move here.
			UnitsToMove = arrOthers;
		}
	}
	`logAI(self$"::GatherUnitsToMove found "@UnitsToMove.Length@" units to move.");
	if (arrToSkip.Length > 0)
	{
		`logAI(self$"::GatherUnitsToMove found "@arrToSkip.Length@" units to skip.");
	}
}