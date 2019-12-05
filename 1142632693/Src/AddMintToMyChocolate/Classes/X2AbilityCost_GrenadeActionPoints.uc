class X2AbilityCost_GrenadeActionPoints extends X2AbilityCost_ActionPoints config(GameData_SoldierSkills);

var config array<name> SmokeGrenadeTemplates;
var config array<name> FlashbangTemplates;

simulated function int GetPointCost(XComGameState_Ability AbilityState, XComGameState_Unit AbilityOwner)
{
	//if (AbilityOwner.IsUnitAffectedByEffectName('MNT_RapidDeployment'))
	//	return 0;

	return super.GetPointCost(AbilityState, AbilityOwner);
}

simulated function bool ConsumeAllPoints(XComGameState_Ability AbilityState, XComGameState_Unit AbilityOwner)
{
	local XComGameState_Item ItemState;
	local int i;
	local bool bHasSmokeAndMirrors, bHasFlashOut;

	ItemState = AbilityState.GetSourceAmmo();

	if (ItemState == none)
		ItemState = AbilityState.GetSourceWeapon();

	bHasSmokeAndMirrors = AbilityOwner.HasSoldierAbility('MNT_SmokeAndMirrors');
	bHasFlashOut = AbilityOwner.HasSoldierAbility('MNT_FlashOut');

	if (ItemState != none)
	{
		if (default.SmokeGrenadeTemplates.Find(ItemState.GetMyTemplateName()) != INDEX_NONE && bHasSmokeAndMirrors)
			return false;
		if (default.FlashbangTemplates.Find(ItemState.GetMyTemplateName()) != INDEX_NONE && bHasFlashOut)
			return false;
	}
	else
		`RedScreen("No ItemState for" @ AbilityState.GetMyTemplateName());

	if (bConsumeAllPoints)
	{
		for (i = 0; i < DoNotConsumeAllEffects.Length; ++i)
		{
			if (AbilityOwner.IsUnitAffectedByEffectName(DoNotConsumeAllEffects[i]))
				return false;
		}
		for (i = 0; i < DoNotConsumeAllSoldierAbilities.Length; ++i)
		{
			if (DoNotConsumeAllSoldierAbilities[i] == 'MNT_SmokeAndMirrors')
				continue;
			if (DoNotConsumeAllSoldierAbilities[i] == 'MNT_Flashout')
				continue;
			if (AbilityOwner.HasSoldierAbility(DoNotConsumeAllSoldierAbilities[i]))
				return false;
		}

		if (AbilityOwner.IsUnitAffectedByEffectName('DLC_3Overdrive'))
			return false;
	}

	return bConsumeAllPoints;
}

