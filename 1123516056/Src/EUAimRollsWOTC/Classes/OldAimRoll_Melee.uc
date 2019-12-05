class OldAimRoll_Melee extends X2AbilityToHitCalc_StandardMelee;

// I have to copy paste the whole code due to possible overwrite problems if the class inherits a mod class


function InternalRollForAbilityHit(XComGameState_Ability kAbility, AvailableTarget kTarget, bool bIsPrimaryTarget, const out AbilityResultContext ResultContext, out EAbilityHitResult Result, out ArmorMitigationResults ArmorMitigated, out int HitChance)
{
	class'OldAimRoll'.static.StaticInternalRollForAbilityHit(self, kAbility, kTarget, bIsPrimaryTarget, ResultContext, Result, ArmorMitigated, HitChance);
	// If EU aim rolls are disabled, roll everything again with old system
	//if (!class'OldAimRoll'.default.ENABLE_EU_AIM_ROLLS)
	//	super.InternalRollForAbilityHit(kAbility, kTarget, ResultContext, Result, ArmorMitigated, HitChance);
}

function int GetModifiedHitChanceForCurrentDifficulty(XComGameState_Player Instigator, XComGameState_Unit TargetState, int BaseHitChance)
{
	return class'OldAimRoll'.static.StaticGetModifiedHitChanceForCurrentDifficulty(self, Instigator, TargetState, BaseHitChance);
}

function float GetReactionAdjust(XComGameState_Unit Shooter, XComGameState_Unit Target)
{
	local XComGameStateHistory History;
	local XComGameState_Unit OldTarget;
	local UnitValue ConcealedValue;
	local bool bOpportunist;
	local name OpportunistEffect;

	History = `XCOMHISTORY;

	//  No penalty if the shooter went into Overwatch while concealed.
	if (Shooter.GetUnitValue(class'X2Ability_DefaultAbilitySet'.default.ConcealedOverwatchTurn, ConcealedValue))
	{
		if (ConcealedValue.fValue > 0)
			return 0;
	}

	foreach class'OldAimRoll'.default.OPPORTUNIST_EFFECTS(OpportunistEffect)
	{
		if (Shooter.AffectedByEffectNames.Find(OpportunistEffect) != INDEX_NONE)
		{
			bOpportunist = true;
			break;
		}
	}

	OldTarget = XComGameState_Unit(History.GetGameStateForObjectID(Target.ObjectID, eReturnType_Reference, History.GetCurrentHistoryIndex() - 1));
	`assert(OldTarget != none);

	//  Add penalty if the target was dashing. Look for the target changing position and spending more than 1 action point as a simple check.
	if (OldTarget.TileLocation != Target.TileLocation)
	{
		if (OldTarget.NumAllActionPoints() > 1 && Target.NumAllActionPoints() == 0)
		{		
			if (bOpportunist)
				return 1 - ((1 - default.REACTION_DASHING_FINALMOD) / ( 1 - default.REACTION_FINALMOD));
			else
				return default.REACTION_DASHING_FINALMOD;
		}
	}
	if (bOpportunist)
		return 0;
	return default.REACTION_FINALMOD;
}