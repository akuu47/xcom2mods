class X2Effect_MeleeAbilityCost extends X2Effect_Persistent;

var const array<name> MELEE_ABILITIES;

function bool PostAbilityCostPaid(XComGameState_Effect EffectState, XComGameStateContext_Ability AbilityContext, XComGameState_Ability kAbility, XComGameState_Unit SourceUnit, XComGameState_Item AffectWeapon, XComGameState NewGameState, const array<name> PreCostActionPoints, const array<name> PreCostReservePoints)
{
	local XComGameState_Unit	TargetUnit;
	local XComWorldData			WorldData;
	local vector				StartLoc, TargetLoc;
	local int					TileDistance;
	local int j;

	if ((`CHEATMGR != none && `CHEATMGR.bUnlimitedActions)) return true;
	
	if (default.MELEE_ABILITIES.Find(kAbility.GetMyTemplateName()) != INDEX_NONE)
	{
		TargetUnit = XComGameState_Unit(NewGameState.GetGameStateForObjectID(AbilityContext.InputContext.PrimaryTarget.ObjectID));
		if (TargetUnit != None)
		{
			WorldData = `XWORLD;
			StartLoc = WorldData.GetPositionFromTileCoordinates(SourceUnit.TurnStartLocation);
			TargetLoc = WorldData.GetPositionFromTileCoordinates(TargetUnit.TileLocation);
			TileDistance = VSize(StartLoc - TargetLoc) / WorldData.WORLD_StepSize;

			//`LOG("Activating " @ kAbility.GetMyTemplateName() @ "from" @ SourceUnit.GetFullName() @ "against" @ TargetUnit.GetFullName() @ "tile distance:" @ TileDistance,,'IRIDAR');
				
			if (TileDistance <= 1)
			{
				//	restore all action points
				//`LOG("Restoring action points",,'IRIDAR');
				SourceUnit.ActionPoints = PreCostActionPoints;
				SourceUnit.ReserveActionPoints = PreCostReservePoints;

				//	remove one action point 
				//	Check for Run'n'Gun AP first
				for (j=0; j < SourceUnit.ActionPoints.Length; j++)
				{
					if (SourceUnit.ActionPoints[j] == class'X2CharacterTemplateManager'.default.RunAndGunActionPoint)
					{
						SourceUnit.ActionPoints.Remove(j, 1);
						return true;
					}
				}

				for (j=0; j < SourceUnit.ActionPoints.Length; j++)
				{
					if (SourceUnit.ActionPoints[j] == class'X2CharacterTemplateManager'.default.StandardActionPoint)
					{			
						//`LOG("Removing one action point.",,'IRIDAR');				
						SourceUnit.ActionPoints.Remove(j, 1);
						return true;
					}
				}
			}
			//`LOG("Tile distance check not passed, no changes to AP.",,'IRIDAR');	
		}
	}
	return false;
}

defaultproperties
{	
	MELEE_ABILITIES[0] = "IRI_Punch_Ability"
	MELEE_ABILITIES[1] = "IRI_Kick_Ability"
	MELEE_ABILITIES[2] = "IRI_Stockstrike_Ability"
	MELEE_ABILITIES[3] = "IRI_Melee_Ability"
}