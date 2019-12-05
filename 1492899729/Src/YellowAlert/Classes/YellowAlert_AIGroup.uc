Class YellowAlert_AIGroup extends XComGameState_AIGroup config(YellowAlert);

var config bool ENEMIES_AUTO_INTERCEPT;
var config bool ENEMIES_CHASE_PLAYER_POSITION;

//remove enemy move cheats
//add fix for unit movement locations out of bounds and causing turn to be skipped in green alert
function bool ShouldMoveToIntercept(out Vector TargetInterceptLocation, XComGameState NewGameState, XComGameState_AIPlayerData PlayerData)
{
	local XComGameState_BattleData BattleData;
	local Vector CurrentGroupLocation;
	local EncounterZone MyEncounterZone;
	local XComAISpawnManager SpawnManager;
	local XComTacticalMissionManager MissionManager;
	local MissionSchedule ActiveMissionSchedule;
	local array<Vector> EncounterCorners;
	local int CornerIndex;
	local XComGameState_AIGroup NewGroupState;
	local XComGameStateHistory History;
	local Vector CurrentXComLocation;
	local XComWorldData World;
	local TTile Tile;

	World = `XWORLD;
	History = `XCOMHISTORY;
	BattleData = XComGameState_BattleData(History.GetSingleGameStateObjectForClass(class'XComGameState_BattleData'));

	if( (XComSquadMidpointPassedGroup() && ENEMIES_AUTO_INTERCEPT) && !BattleData.bKismetDisabledInterceptMovement )
	{
		if( !GetNearestEnemyLocation(GetGroupMidpoint(), TargetInterceptLocation) )
		{
			// If for some reason the nearest enemy can't be found, send these units to the objective.
			TargetInterceptLocation = BattleData.MapData.ObjectiveLocation;
		}
		return true;
	}

	// This flag is turned on if XCom is unengaged, and the SeqAct_CompleteMissionObjective has fired, and this is the closest group -or cheatmgr setting bAllPodsConvergeOnMissionComplete is on.
	if( bInterceptObjectiveLocation )
	{
		TargetInterceptLocation = BattleData.MapData.ObjectiveLocation;
		return true;
	}

	// TODO: otherwise, try to patrol around within the current encounter zone
	CurrentGroupLocation = GetGroupMidpoint();
	Tile = World.GetTileCoordinatesFromPosition(CurrentTargetLocation);
	if( PlayerData.StatsData.TurnCount - TurnCountForLastDestination > MAX_TURNS_BETWEEN_DESTINATIONS || 
		World.IsTileOutOfRange(Tile) ||
	   VSizeSq(CurrentGroupLocation - CurrentTargetLocation) < DESTINATION_REACHED_SIZE_SQ )
	{
		// choose new target location
		SpawnManager = `SPAWNMGR;
		MissionManager = `TACTICALMISSIONMGR;
		MissionManager.GetActiveMissionSchedule(ActiveMissionSchedule);
		if (ENEMIES_CHASE_PLAYER_POSITION) 
		{
			CurrentXComLocation = SpawnManager.GetCurrentXComLocation();
		}
		else 
		{
			CurrentXComLocation = BattleData.MapData.SoldierSpawnLocation;
		}
		MyEncounterZone = SpawnManager.BuildEncounterZone(
			BattleData.MapData.ObjectiveLocation,
			CurrentXComLocation,
			MyEncounterZoneDepth,
			MyEncounterZoneWidth,
			MyEncounterZoneOffsetFromLOP,
			MyEncounterZoneOffsetAlongLOP,
			MyEncounterZoneVolumeTag);

		EncounterCorners[0] = SpawnManager.CastVector(MyEncounterZone.Origin);
		EncounterCorners[0].Z = CurrentGroupLocation.Z;
		EncounterCorners[1] = EncounterCorners[0] + SpawnManager.CastVector(MyEncounterZone.SideA);
		EncounterCorners[2] = EncounterCorners[1] + SpawnManager.CastVector(MyEncounterZone.SideB);
		EncounterCorners[3] = EncounterCorners[0] + SpawnManager.CastVector(MyEncounterZone.SideB);

		for( CornerIndex = EncounterCorners.Length - 1; CornerIndex >= 0; --CornerIndex )
		{
			//LWS: Ensure the potential patrol locations are on-map, otherwise the alert will fail to set.
            EncounterCorners[CornerIndex] = World.FindClosestValidLocation(EncounterCorners[CornerIndex], false, false);
			if( VSizeSq(CurrentGroupLocation - EncounterCorners[CornerIndex]) < DESTINATION_REACHED_SIZE_SQ )
			{
				EncounterCorners.Remove(CornerIndex, 1);
			}
		}

		if( EncounterCorners.Length > 0 )
		{
			TargetInterceptLocation = EncounterCorners[`SYNC_RAND_STATIC(EncounterCorners.Length)];
			Tile = World.GetTileCoordinatesFromPosition(TargetInterceptLocation);
			if (World.IsTileOutOfRange(Tile))
			{
				World.ClampTile(Tile);
				TargetInterceptLocation = World.GetPositionFromTileCoordinates(Tile);
			}

			NewGroupState = XComGameState_AIGroup(NewGameState.ModifyStateObject(class'XComGameState_AIGroup', ObjectID));
			NewGroupState.CurrentTargetLocation = TargetInterceptLocation;
			NewGroupState.TurnCountForLastDestination = PlayerData.StatsData.TurnCount;

			return true;
		}
	}

	return false;
}