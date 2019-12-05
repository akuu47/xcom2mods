class CoverDR_Impl extends Object config (CoverDR);

var config float HALFCOVER_DMG_REDUCTION;
var config float FULLCOVER_DMG_REDUCTION;

var config float HALFCOVER_DMG_REDUCTION_MULT;
var config float FULLCOVER_DMG_REDUCTION_MULT;

var config float HALFCOVER_DMG_REDUCTION_MAX;
var config float FULLCOVER_DMG_REDUCTION_MAX;

var config bool EXPLOSIVE_DMG_REDUCTION;
var config bool USE_EXPLOSION_LOCATION;

var localized string MitigationMessage;

static function ApplyCoverDR(out int iDamage, const out EffectAppliedData ApplyEffectParameters, out int ArmorMitigation, X2Effect_ApplyWeaponDamage SourceDamage)
{
	local XComGameStateHistory History;
	local XComGameState_Unit kSourceUnit;
	local Damageable kTarget;
	local XComGameState_Unit TargetUnit;
	local GameRulesCache_VisibilityInfo VisInfo;
	local ECoverType TargetCover;
	local WeaponDamageValue BaseDamageValue;
	local XComGameState_Item kSourceItem;
	local XComGameState_Ability kAbility;

	local int iReduction;
	local float fReduction;
	local int iRoll;

	local Array<Vector> HitLocations;
	local Vector TargetVector;

	local float AbilityRadius, Distance;

	iRoll = `SYNC_RAND_STATIC(100);

	History = `XCOMHISTORY;
	kSourceUnit = XComGameState_Unit(History.GetGameStateForObjectID(ApplyEffectParameters.SourceStateObjectRef.ObjectID));
	kTarget = Damageable(History.GetGameStateForObjectID(ApplyEffectParameters.TargetStateObjectRef.ObjectID));

	TargetUnit = XComGameState_Unit(kTarget);

	// find the base damage spec, if it's armor piercing, don't add DR
	kAbility = XComGameState_Ability(History.GetGameStateForObjectID(ApplyEffectParameters.AbilityStateObjectRef.ObjectID));
	if (kAbility.SourceAmmo.ObjectID > 0)
		kSourceItem = XComGameState_Item(History.GetGameStateForObjectID(kAbility.SourceAmmo.ObjectID));		
	else
		kSourceItem = XComGameState_Item(History.GetGameStateForObjectID(ApplyEffectParameters.ItemStateObjectRef.ObjectID));		

	if (kSourceItem != none)
	{
		kSourceItem.GetBaseWeaponDamageValue(XComGameState_BaseObject(kTarget), BaseDamageValue);
		if (BaseDamageValue.Pierce >= 1 || SourceDamage.bIgnoreArmor) {
			return; // Back out if base is armor piercing (eg. combat protocol) or if the source ignores armor, eg. Schism
		}
	}

	// Can the target even take cover?
	if (TargetUnit.CanTakeCover())
	{

		TargetCover = CT_None;
		// Determine cover state and visibility
		if (`TACTICALRULES.VisibilityMgr.GetVisibilityInfo(kSourceUnit.ObjectID, TargetUnit.ObjectID, VisInfo))
		{
			TargetCover = VisInfo.TargetCover;
		}

		// grenade handling
		if (kAbility != none)
		{
			AbilityRadius = kAbility.GetAbilityRadius();

			if (AbilityRadius > 0 && kSourceItem != None && kSourceItem.GetItemEnvironmentDamage() == 0 && SourceDamage.EnvironmentalDamageAmount == 0) {
				// ignore DR for AP grenades (no env damage) like gas, fire, etc.
				`LOG("Ignoring DR for radius ability without environment damage.");
				TargetCover = CT_None;
			} else if (AbilityRadius > 0) {
				HitLocations = ApplyEffectParameters.AbilityInputContext.TargetLocations;

				if (HitLocations.Length == 1) {
					// visibility check from projectile to target - apply DR if obscured
					if (default.EXPLOSIVE_DMG_REDUCTION == false) {
						TargetCover = CT_None;
					} else if (default.USE_EXPLOSION_LOCATION) {
						TargetVector = class'XComWorldData'.static.GetWorldData().GetPositionFromTileCoordinates(TargetUnit.TileLocation);
						TargetCover = class'XComWorldData'.static.GetWorldData().GetCoverTypeForTarget(HitLocations[0], TargetVector, VisInfo.TargetCoverAngle);
					}
				}
			}
		}

		switch( TargetCover )
		{  
		case CT_MidLevel: // half cover
			fReduction = fmin(default.HALFCOVER_DMG_REDUCTION + default.HALFCOVER_DMG_REDUCTION_MULT * iDamage, default.HALFCOVER_DMG_REDUCTION_MAX);
		break;
		case CT_Standing: // full cover
			fReduction = fmin(default.FULLCOVER_DMG_REDUCTION + default.FULLCOVER_DMG_REDUCTION_MULT * iDamage, default.FULLCOVER_DMG_REDUCTION_MAX);
		break;
		default:
			fReduction = 0.0;
		break;
		}

		// don't affect 0 damage or less (fix for Fortress etc.)
		if (iDamage <= 0) {
			return;
		}

		iReduction = int(fReduction);
		// extra DR chance (floating point DR)
		if ((fReduction - iReduction) * 100 > iRoll) { 
			iReduction++; 
		}

		`LOG("Apply Cover DR: dmg=" @ iDamage @ " reduction " @ iReduction @ " with float value " @ fReduction @ ", roll=" @ iRoll);
		iDamage -= iReduction;
		// always do at least 1 damage, like with armor
		if (iDamage < 1) {
			iDamage = 1;
		}

		ArmorMitigation += iReduction;
	}
}

static function bool IsTargetVisible(Vector Location, XComGameState_Unit TargetUnit) {
	local TTile TargetTile;
	local VoxelRaytraceCheckResult VisInfo;

	TargetTile = `XWORLD.GetTileCoordinatesFromPosition( Location );

	`LOG("Tile check: " @ TargetTile.X @ " " @ TargetTile.Y @ " " @ TargetTile.Z @ " vs " @ TargetUnit.TileLocation.X @ " " @ TargetUnit.TileLocation.Y @ " " @ TargetUnit.TileLocation.Z);
	return !`XWORLD.VoxelRaytrace_Tiles( TargetTile, TargetUnit.TileLocation, VisInfo );
}