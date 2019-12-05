//-----------------------------------------------------------
//	Class:	X2AbilityCost_ImplacableFixPre
//	Author: Mr. Nice
//	
//-----------------------------------------------------------


class X2AbilityCost_ImplacableFixPre extends X2AbilityCost;

`include(AWCCostFixW\Src\ModConfigMenuAPI\MCM_API_CfgHelpers.uci)

var X2AbilityCost_ImplacableFixPost PostFix;
var X2AbilityCost_ActionPoints APCost;

simulated function ApplyCost(XComGameStateContext_Ability AbilityContext, XComGameState_Ability kAbility, XComGameState_BaseObject AffectState, XComGameState_Item AffectWeapon, XComGameState NewGameState)
{
	local XComGameState_Unit ModifiedUnitState;
	local int i, iPointsToTake, PathIndex, FarthestTile;
	local UnitValue ImplacableValue, UsedValue;

	ModifiedUnitState = XComGameState_Unit(AffectState);
	if (!`GETMCMVAR(FIX_IMPLACABLE_CONSUMPTION) || ModifiedUnitState.GetMyTemplate().bIsCosmetic || (`CHEATMGR != none && `CHEATMGR.bUnlimitedActions))
	return;
	ModifiedUnitState.GetUnitValue(class'X2Effect_Implacable'.default.ImplacableThisTurnValue, ImplacableValue);
	ModifiedUnitState.GetUnitValue('ImplacableUsedUp', UsedValue);
	if (
		ImplacableValue.fValue == 0
		|| UsedValue.fValue == 1
		|| !APCost.ConsumeAllPoints(kAbility, ModifiedUnitState)
		)
	{
		return;
	}

	if (ModifiedUnitState.ActionPoints.Find('move')!=INDEX_NONE)
	{
		if (X2AbilityTarget_MovingMelee(kAbility.GetMyTemplate().AbilityTargetStyle)!=none)
		{
			PathIndex = AbilityContext.GetMovePathIndex(ModifiedUnitState.ObjectID);
			iPointsToTake = 1;
			
			for(i = AbilityContext.InputContext.MovementPaths[PathIndex].MovementTiles.Length - 1; i >= 0; --i)
			{
				if(AbilityContext.InputContext.MovementPaths[PathIndex].MovementTiles[i] == ModifiedUnitState.TileLocation)
				{
					FarthestTile = i;
					break;
				}
			}
			for (i = 0; i < AbilityContext.InputContext.MovementPaths[PathIndex].CostIncreases.Length; ++i)
			{
				if (AbilityContext.InputContext.MovementPaths[PathIndex].CostIncreases[i] <= FarthestTile)
					iPointsToTake++;
			}
		}
		if(iPointsToTake<ModifiedUnitState.NumAllActionPoints())
		{
			PostFix.RestoreMoveAP=true;
			return;
		}
	}
	ModifiedUnitState.SetUnitFloatValue('ImplacableUsedUp', 1);
}

