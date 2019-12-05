class X2Cursor_Suppressable extends X2AbilityTarget_Cursor config(Game);

struct CursorEffectMod
{
	var float Factor;
	var float MeterMod;
	var bool ModPostFactor;
	var name EffectName;

	structdefaultproperties
	{
		Factor=1.0
		ModPostFactor=false
		MeterMod=0
	}
};

var config array<CursorEffectMod> EffectModifiers;


simulated function float GetCursorRangeMeters(XComGameState_Ability AbilityState)
{
	local XComGameState_Item SourceWeapon;
	local int RangeInTiles;
	local float RangeInMeters, RangeMod, FinalRangeMod;
	local XComGameStateHistory History;
	local XComGameState_Unit kUnit;
	local float RangeMult;
	local CursorEffectMod EffectMod;

	History = `XCOMHISTORY;

	kUnit = XComGameState_Unit(History.GetGameStateForObjectID(AbilityState.OwnerStateObject.ObjectID));

	RangeMult = 1.0;
	RangeMod = 0;
	FinalRangeMod = 0;

	foreach EffectModifiers(EffectMod)
	{
		if (kUnit.IsUnitAffectedByEffectName(EffectMod.EffectName))
		{
			RangeMult *= EffectMod.Factor;
			if (EffectMod.ModPostFactor)
			{
				FinalRangeMod += EffectMod.MeterMod;
			}
			else
			{
				RangeMod += EffectMod.MeterMod;
			}
		}
	}

	if (bRestrictToWeaponRange)
	{
		SourceWeapon = AbilityState.GetSourceWeapon();
		if (SourceWeapon != none)
		{
			RangeInTiles = SourceWeapon.GetItemRange(AbilityState);

			if (RangeInTiles < 0)
				return -1;

			if( RangeInTiles == 0 )
			{
				// This is melee range
				RangeInMeters = class'XComWorldData'.const.WORLD_Melee_Range_Meters;
			}
			else
			{
				RangeInMeters = `UNITSTOMETERS(`TILESTOUNITS(RangeInTiles));
			}

			return max((RangeInMeters + RangeMod) * RangeMult + FinalRangeMod, class'XComWorldData'.const.WORLD_Melee_Range_Meters);
		}
	}

	if (FixedAbilityRange == -1)
		return -1;

	return max((FixedAbilityRange + RangeMod) * RangeMult + FinalRangeMod, class'XComWorldData'.const.WORLD_Melee_Range_Meters);
}
