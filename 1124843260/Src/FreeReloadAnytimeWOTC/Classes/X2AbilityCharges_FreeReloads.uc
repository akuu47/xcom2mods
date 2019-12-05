class X2AbilityCharges_FreeReloads extends X2AbilityCharges;

function int GetInitialCharges(XComGameState_Ability Ability, XComGameState_Unit Unit)
{
	local XComGameState_Item SrcWeapon;
	local array<X2WeaponUpgradeTemplate> WeaponUpgradeTemplates;
	local X2WeaponUpgradeTemplate WeaponUpgradeTemplate;
	local int TotalCharges;

	TotalCharges = InitialCharges;
	SrcWeapon = Ability.GetSourceWeapon();
	if (SrcWeapon != none)
	{
		WeaponUpgradeTemplates = SrcWeapon.GetMyWeaponUpgradeTemplates();
		foreach WeaponUpgradeTemplates(WeaponUpgradeTemplate)
		{
			if (WeaponUpgradeTemplate.NumFreeReloads > 0)
			{
				TotalCharges += WeaponUpgradeTemplate.GetBonusAmountFn(WeaponUpgradeTemplate);
			}
			else if (WeaponUpgradeTemplate.NumFreeReloads < 0)
			{
				TotalCharges = 999;
				break;
			}
		}
	}

	return TotalCharges;
}

DefaultProperties
{
	InitialCharges = 0
}