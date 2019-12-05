class X2Effect_StrongParry extends X2Effect_Parry;

function bool ChangeHitResultForTarget(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit TargetUnit, XComGameState_Ability AbilityState, bool bIsPrimaryTarget, const EAbilityHitResult CurrentResult, out EAbilityHitResult NewHitResult)
{
	local UnitValue ParryUnitValue;

	`log("X2Effect_Parry::ChangeHitResultForTarget" @ EAbilityHitResult(CurrentResult), , 'TemplarParry');
	//	check for parry - if the unit value is set, then a parry is guaranteed
	if (TargetUnit.GetUnitValue('Parry', ParryUnitValue) && TargetUnit.IsAbleToAct())
	{
		if (CurrentResult < eHit_Miss)
		{
			if (ParryUnitValue.fValue > 0)
			{
				`log("Parry available - using!", , 'TemplarParry');
				NewHitResult = eHit_Parry;
				TargetUnit.SetUnitFloatValue('Parry', ParryUnitValue.fValue - 1);
				return true;
			}
		}
		else
		{
			`log("Shot missed, don't parry.", , 'TemplarParry');
			return false;
		}
	}
	
	`log("Parry not available.", , 'TemplarParry');
	return false;
}