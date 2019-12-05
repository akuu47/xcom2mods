// This is an Unreal Script
class PeekFixUtility extends Object;

static function MakeConcealmentMarkers(XComPathingPawn PathingPawn, out array<TTile> ConcealmentMarkers) {
	local int i;
	local XComGameState_Unit ActiveUnitState, EnemyUnit;
    local array<XComGameState_Unit> RevealedEnemies;
	local bool alwaysShowEnemies;
	local TTile Tile;
	local UIUnitFlagManager_GA UnitFlagManager;
	local LOSValues UnitLOSValues;
	local XComGameStateHistory History;
	local XComWorldData WorldData;
	local XComGameState_InteractiveObject InteractiveObjectState;
	local Vector CurrentPosition, TestPosition;
	local int SightRange;
	local GameRulesCache_VisibilityInfo VisInfo;

	local bool bVisibleAtThisTile, RequireHighCover;
	local int NumTilesVisible;

	// HOOOOOOOOOOOOOO time to break encapsulation
	UnitFlagManager = UIUnitFlagManager_GA(XComPresentationLayer(XComPlayerController(class'WorldInfo'.static.GetWorldInfo().GetALocalPlayerController()).Pres).m_kUnitFlagManager);
	History = `XCOMHISTORY;
	WorldData = `XWORLD;

	// inherit this setting for always showing concealment breakage, it's in the same spirit
	alwaysShowEnemies = class'WOTCGotchaAgainSettings'.default.bAlwaysShowPodActivation;

	ActiveUnitState = XComGameState_Unit(History.GetGameStateForObjectID(PathingPawn.LastActiveUnit.ObjectID));
	RevealedEnemies = UnitFlagManager.CacheUtilityInstance.GetRevealedEnemiesOfUnit(ActiveUnitState, alwaysShowEnemies);

	for (i = 0; i < PathingPawn.PathTiles.Length; i++) {
		// check this tile
		Tile = PathingPawn.PathTiles[i];

		bVisibleAtThisTile = false;

		foreach RevealedEnemies(EnemyUnit) {
			SightRange = ActiveUnitState.GetConcealmentDetectionDistance(EnemyUnit);

			// use all of Gotcha's reliability tricks to figure out LOS, but with range = detection distance instead of sight range.
			UnitLOSValues = UnitFlagManager.LOSUtilityInstance.GetLOSValues(EnemyUnit.TileLocation, 
													Tile, 
													EnemyUnit, 
													ActiveUnitState, 
													Square(SightRange) + 1, // Concealment breaking uses <= instead of <
													VisInfo, 
													!EnemyUnit.CanTakeCover());
			/*if (WorldData.CanSeeTileToTile(Tile, EnemyUnit.TileLocation, VisInfo) && VisInfo.DefaultTargetDist <= Square(SightRange)) {
				ConcealmentMarkers.AddItem(Tile);
				return;
			}*/
			
			if (UnitLOSValues.bClearLOS && UnitLOSValues.bWithinRegularRange) {
				// get cover value from the enemy unit to the tile
				bVisibleAtThisTile = true;
				
				// apply concealment rules based on configuration
				if (class'ConcealmentRules'.default.HideWithHeightAdvantage && Tile.Z >= (EnemyUnit.TileLocation.Z + class'X2TacticalGameRuleset'.default.UnitHeightAdvantage)) {
					RequireHighCover = false;
				} else if (class'ConcealmentRules'.default.HideInHighCover) {
					RequireHighCover = true;
				} else {
					break; // No hiding.
				}

				// check cover state allowing for peeking
				if (HasCoverFromEnemyToTile(UnitFlagManager.LOSUtilityInstance, RequireHighCover, EnemyUnit, ActiveUnitState, Tile, VisInfo)) {
					bVisibleAtThisTile = false;
				}
			}

			if (bVisibleAtThisTile) { break; }
		}

		// interactive objects, eg. lamp posts
		foreach History.IterateByClassType(class'XComGameState_InteractiveObject', InteractiveObjectState)
		{
			if (InteractiveObjectState.DetectionRange > 0.0 && !InteractiveObjectState.bHasBeenHacked)
			{
				CurrentPosition = WorldData.GetPositionFromTileCoordinates(Tile);
				TestPosition = WorldData.GetPositionFromTileCoordinates(InteractiveObjectState.TileLocation);

				if (VSizeSq(TestPosition - CurrentPosition) <= Square(InteractiveObjectState.DetectionRange))
				{
					ConcealmentMarkers.AddItem(Tile);
					return;
				}
			}
		}

		if (bVisibleAtThisTile) {
			NumTilesVisible++;

			if (NumTilesVisible > class'ConcealmentRules'.default.NumGraceTiles || i == PathingPawn.PathTiles.Length - 1 || i == 0) {
				ConcealmentMarkers.AddItem(Tile);
				return;
			}
		}
	}
}

// Here be monsters.  Some code adapted from LOSUtility_GA but we're looking in the opposite direction here (source unit fixed, target variable)
// We also return the cover type rather than a boolean
// This is some messed up shit and I can't believe Gotcha Again actually managed to work with all this hell
static function bool HasCoverFromEnemyToTile(LOSUtility_GA LOSUtility, bool RequireHighCover, XComGameState_Unit EnemyUnit, XComGameState_Unit TargetUnit, const out TTile Tile, GameRulesCache_VisibilityInfo VisibilityInfo) {
	local Vector SourceVector, TargetVector;
	local ECoverType TargetCover;
	local XComWorldData WorldData;
	local float TargetCoverAngle;
	local array<int> CoverDirectionsToCheck;
	local CachedCoverAndPeekData PeekData;
	local int i;

	WorldData = `XWORLD;

	SourceVector = WorldData.GetPositionFromTileCoordinates(EnemyUnit.TileLocation);
	TargetVector = WorldData.GetPositionFromTileCoordinates(Tile);
	TargetCover = WorldData.GetCoverTypeForTarget(SourceVector, TargetVector, TargetCoverAngle); // TargetCoverAngle is an out parameter! It is never used...

	if (TargetCover == CT_None) { return false; }
	if (TargetCover == CT_MidLevel && RequireHighCover) { return false; }

	// Now we have to check whether the enemy can see this tile by stepping out.  The hell begins here.
    CoverDirectionsToCheck = GetPotentialCoverDirections(SourceVector, TargetVector);
	PeekData = WorldData.GetCachedCoverAndPeekData(EnemyUnit.TileLocation);

    // PeekSide seem to be reliable when it is not eNoPeek... let's hope that it actually is!
    switch(VisibilityInfo.PeekSide) {
        case ePeekLeft:
            foreach CoverDirectionsToCheck(i) {
                if(PeekData.CoverDirectionInfo[i].bHasCover == 1 && 
                   PeekData.CoverDirectionInfo[i].LeftPeek.bHasPeekaround == 1) {
                    if(!HasCoverFromPeekTile(LOSUtility, RequireHighCover, PeekData.CoverDirectionInfo[i].LeftPeek, Tile, TargetVector, TargetUnit, EnemyUnit)) return false;
                }
            }
            break;

        case ePeekRight:
            foreach CoverDirectionsToCheck(i) {
                if(PeekData.CoverDirectionInfo[i].bHasCover == 1 && 
                   PeekData.CoverDirectionInfo[i].RightPeek.bHasPeekaround == 1) {
                    if(!HasCoverFromPeekTile(LOSUtility, RequireHighCover, PeekData.CoverDirectionInfo[i].RightPeek, Tile, TargetVector, TargetUnit, EnemyUnit)) return false;
                }
            }
            break;

        case eNoPeek:
            // We don't know which side we're peeking to (eNoPeek ought to mean we're not, but it doesn't... WTF?!)
            // Check both sides
            foreach CoverDirectionsToCheck(i) {
                if(PeekData.CoverDirectionInfo[i].bHasCover == 1) {
                    if(PeekData.CoverDirectionInfo[i].LeftPeek.bHasPeekaround == 1) {
                        if(!HasCoverFromPeekTile(LOSUtility, RequireHighCover, PeekData.CoverDirectionInfo[i].LeftPeek, Tile, TargetVector, TargetUnit, EnemyUnit, true)) return false;
                    }
                    if(PeekData.CoverDirectionInfo[i].RightPeek.bHasPeekaround == 1) {
                        if(!HasCoverFromPeekTile(LOSUtility, RequireHighCover, PeekData.CoverDirectionInfo[i].RightPeek, Tile, TargetVector, TargetUnit, EnemyUnit, true)) return false;
                    }
                }
            }
            break;
    }

	return true;
}

private static function array<int> GetPotentialCoverDirections(const out vector SourceVector, const out vector TargetVector) {     // out parameters to pass-by-ref
    local vector PeekFromCoverInDirection;
    local array<int> CoverDirections;

    PeekFromCoverInDirection = TargetVector - SourceVector;
    if(PeekFromCoverInDirection.X < 0) CoverDirections.AddItem(2);
    if(PeekFromCoverInDirection.X > 0) CoverDirections.AddItem(3);
    if(PeekFromCoverInDirection.Y < 0) CoverDirections.AddItem(1);
    if(PeekFromCoverInDirection.Y > 0) CoverDirections.AddItem(0);
    return CoverDirections;
}

private static function bool HasCoverFromPeekTile(LOSUtility_GA LOSUtility, bool RequireHighCover, const out PeekAroundInfo PeekData, TTile TargetTile, vector TargetVector, XComGameState_Unit TargetUnit, XComGameState_Unit SourceUnit, optional bool CheckVisibility = false) {
    local float CoverAngle; // Is not used, but GetCoverTypeForTarget needs an out parameter
	local ECoverType CoverType;

    // We only check visibility in certain cases (when PeekSide is noPeek), since shots can be taken from a tile being peeked to even though there
    // is no visibility from that tile. Hopefully that will not be needed when PeekSide is noPeek...
    // Do not allow visibility from a stepout from this tile and don't care about range, so just pass 0 as sightrange.
    if(CheckVisibility && !LOSUtility.GetLOSValues(PeekData.PeekTile, 
                                        TargetTile, 
                                        SourceUnit, 
                                        TargetUnit, 
                                        0, 
                                        , 
                                        true).bClearLOS) return true;

    CoverType = class'XComWorldData'.static.GetWorldData().GetCoverTypeForTarget(PeekData.PeekaroundLocation, TargetVector, CoverAngle);
	if (RequireHighCover) {
		return CoverType == CT_Standing;
	}

	return CoverType != CT_None;
}
