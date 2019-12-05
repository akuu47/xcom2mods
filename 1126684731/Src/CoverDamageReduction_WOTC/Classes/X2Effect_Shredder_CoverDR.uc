class X2Effect_Shredder_CoverDR extends X2Effect_Shredder;

simulated function int CalculateDamageAmount(const out EffectAppliedData ApplyEffectParameters, out int ArmorMitigation, out int NewRupture, out int NewShred, out array<Name> AppliedDamageTypes, out int bAmmoIgnoresShields, out int bFullyImmune, out array<DamageModifierInfo> SpecialDamageMessages, optional XComGameState NewGameState)
{
	local int iDamage;

	iDamage = Super.CalculateDamageAmount(ApplyEffectParameters, ArmorMitigation, NewRupture, NewShred, AppliedDamageTypes, bAmmoIgnoresShields, bFullyImmune, SpecialDamageMessages, NewGameState);

	if (!bIgnoreBaseDamage) {
		class'CoverDR_Impl'.static.ApplyCoverDR(iDamage, ApplyEffectParameters, ArmorMitigation, self);
	}

	return iDamage;
}

simulated function AddX2ActionsForVisualization(XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata, name EffectApplyResult)
{
	local X2Action_DisplayCoverDR UnitAction;
	local Array<X2Action> ParentArray;

	if( ActionMetadata.StateObject_NewState.IsA('XComGameState_Unit') )
	{		
		if ((HideVisualizationOfResults.Find(EffectApplyResult) != INDEX_NONE) ||
			(HideVisualizationOfResultsAdditional.Find(EffectApplyResult) != INDEX_NONE))
		{
			return;
		}

		UnitAction = X2Action_DisplayCoverDR(class'X2Action_DisplayCoverDR'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext(),,, ParentArray));//auto-parent to damage initiating action
		UnitAction.OriginatingEffect = self;
	}

	Super.AddX2ActionsForVisualization(VisualizeGameState, ActionMetadata, EffectApplyResult);
}
