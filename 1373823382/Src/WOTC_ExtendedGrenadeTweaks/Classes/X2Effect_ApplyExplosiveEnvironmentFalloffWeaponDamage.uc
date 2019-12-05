class X2Effect_ApplyExplosiveEnvironmentFalloffWeaponDamage extends X2Effect_ApplyWeaponDamage config(ExtendedGrenadeTweaks);

var config array<name> ExplosiveDamageFalloffAbilityExclusions;
var config array<name> EnvironmentDamageFalloffAbilityExclusions;
var config array<DamageStep> EnvironmentDamageSteps;
var config int MAX_ENV_DAMAGE_RANGE_PCT;

// Does additional check to see if user has an ability listed in ExplosiveDamageFalloffAbilityExclusions
simulated function ApplyFalloff( out int WeaponDamage, Damageable Target, XComGameState_Item kSourceItem, XComGameState_Ability kAbility, XComGameState NewGameState )
{
    local XComGameState_Unit SourceUnit;
    local name AbilityExclusion;

    SourceUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(kSourceItem.OwnerStateObject.ObjectID));
    if(SourceUnit != none)
    {
        foreach default.ExplosiveDamageFalloffAbilityExclusions(AbilityExclusion)
	    {
            //`LOG("ApplyFalloff checking for " $ AbilityExclusion);

		    if(SourceUnit.HasSoldierAbility(AbilityExclusion))
			    return;

		    //additional check for aliens, checking character 
		    if(SourceUnit.FindAbility(AbilityExclusion).ObjectId > 0)
			    return;
	    }
        
        //`LOG("ExplosiveDamageFalloffAbilityExclusions not found on soldier, continuing to apply falloff damage");
    }

    super.ApplyFalloff(WeaponDamage, Target, kSourceItem, kAbility, NewGameState );
}

simulated function ApplyEffectToWorld(const out EffectAppliedData ApplyEffectParameters, XComGameState NewGameState)
{
	local XComGameStateHistory History;
	local XComGameState_EnvironmentDamage DamageEvent;
	local XComGameState_Ability AbilityStateObject;
	local XComGameState_Unit SourceStateObject;
	local XComGameState_Item SourceItemStateObject;
	local X2WeaponTemplate WeaponTemplate;
	local float AbilityRadius;
	local vector DamageDirection;
	local vector SourceUnitPosition;
	local XComGameStateContext_Ability AbilityContext;
	local int DamageAmount;
	local int PhysicalImpulseAmount;
	local name DamageTypeTemplateName;
	local XGUnit SourceUnit;
	local int OutCoverIndex;
	local UnitPeekSide OutPeekSide;
	local int OutRequiresLean;
	local int bOutCanSeeFromDefault;
	local X2AbilityTemplate AbilityTemplate;	
	local XComGameState_Item LoadedAmmo, SourceAmmo;	
	local Vector HitLocation;	
	local int i, HitLocationCount, HitLocationIndex, RandRoll;
	local float DamageChange;
	local array<vector> HitLocationsArray;
	local bool bLinearDamage;
	local X2AbilityMultiTargetStyle TargetStyle;

	local int StepIdx, StepEnvironmentDamage;
	local bool bShouldApplyStepDamage;
    local GameRulesCache_VisibilityInfo OutVisibilityInfo;
    local XComLWTuple ModifyEnvironmentDamageTuple;

	//If this damage effect has an associated position, it does world damage
	if( ApplyEffectParameters.AbilityInputContext.TargetLocations.Length > 0 || ApplyEffectParameters.AbilityResultContext.ProjectileHitLocations.Length > 0 )
	{
		History = `XCOMHISTORY;
		SourceStateObject = XComGameState_Unit(History.GetGameStateForObjectID(ApplyEffectParameters.SourceStateObjectRef.ObjectID));
		SourceItemStateObject = XComGameState_Item(History.GetGameStateForObjectID(ApplyEffectParameters.ItemStateObjectRef.ObjectID));	
		if (SourceItemStateObject != None)
			WeaponTemplate = X2WeaponTemplate(SourceItemStateObject.GetMyTemplate());
		AbilityStateObject = XComGameState_Ability(History.GetGameStateForObjectID(ApplyEffectParameters.AbilityStateObjectRef.ObjectID));
		AbilityContext = XComGameStateContext_Ability(NewGameState.GetContext());

		if( (SourceStateObject != none && AbilityStateObject != none) && (SourceItemStateObject != none || EnvironmentalDamageAmount > 0) )
		{	
			AbilityTemplate = AbilityStateObject.GetMyTemplate();
			if( AbilityTemplate != None )
			{
				TargetStyle = AbilityTemplate.AbilityMultiTargetStyle;

				if( TargetStyle != none && TargetStyle.IsA('X2AbilityMultiTarget_Line') )
				{
					bLinearDamage = true;
				}
			}
			AbilityRadius = AbilityStateObject.GetAbilityRadius();

			//Here, we want to use the target location as the input for the direction info since a miss location might possibly want a different step out
			SourceUnit = XGUnit(History.GetVisualizer(SourceStateObject.ObjectID));
			SourceUnit.GetDirectionInfoForPosition(ApplyEffectParameters.AbilityInputContext.TargetLocations[0], OutVisibilityInfo, OutCoverIndex, OutPeekSide, bOutCanSeeFromDefault, OutRequiresLean);
			SourceUnitPosition = SourceUnit.GetExitCoverPosition(OutCoverIndex, OutPeekSide);	
			SourceUnitPosition.Z += 8.0f;
			
			DamageAmount = EnvironmentalDamageAmount;
			if ((SourceItemStateObject != none) && !bIgnoreBaseDamage)
			{
				SourceAmmo = AbilityStateObject.GetSourceAmmo();
				if (SourceAmmo != none)
				{
					DamageAmount += SourceAmmo.GetItemEnvironmentDamage();
				}
				else if(SourceItemStateObject.HasLoadedAmmo())
				{
					LoadedAmmo = XComGameState_Item(History.GetGameStateForObjectID(SourceItemStateObject.LoadedAmmo.ObjectID));
					if(LoadedAmmo != None)
					{	
						DamageAmount += LoadedAmmo.GetItemEnvironmentDamage();
					}
				}
				
				DamageAmount += SourceItemStateObject.GetItemEnvironmentDamage();				
				
			}

			if (WeaponTemplate != none)
			{
				PhysicalImpulseAmount = WeaponTemplate.iPhysicsImpulse;
				DamageTypeTemplateName = WeaponTemplate.DamageTypeTemplateName;
			}
			else
			{
				PhysicalImpulseAmount = 0;

				if( EffectDamageValue.DamageType != '' )
				{
					// If the damage effect's damage type is filled out, use that
					DamageTypeTemplateName = EffectDamageValue.DamageType;
				}
				else if( DamageTypes.Length > 0 )
				{
					// If there is at least one DamageType, use the first one (may want to change
					// in the future to make a more intelligent decision)
					DamageTypeTemplateName = DamageTypes[0];
				}
				else
				{
					// Default to explosive
					DamageTypeTemplateName = 'Explosion';
				}
			}
			
            // Issue #200 Start, allow listeners to modify environment damage
			ModifyEnvironmentDamageTuple = new class'XComLWTuple';
			ModifyEnvironmentDamageTuple.Id = 'ModifyEnvironmentDamage';
			ModifyEnvironmentDamageTuple.Data.Add(3);
			ModifyEnvironmentDamageTuple.Data[0].kind = XComLWTVBool;
			ModifyEnvironmentDamageTuple.Data[0].b = false;  // override? (true) or add? (false)
			ModifyEnvironmentDamageTuple.Data[1].kind = XComLWTVInt;
			ModifyEnvironmentDamageTuple.Data[1].i = 0;  // override/bonus environment damage
			ModifyEnvironmentDamageTuple.Data[2].kind = XComLWTVObject;
			ModifyEnvironmentDamageTuple.Data[2].o = AbilityStateObject;  // ability being used

			`XEVENTMGR.TriggerEvent('ModifyEnvironmentDamage', ModifyEnvironmentDamageTuple, self, NewGameState);
			
			if(ModifyEnvironmentDamageTuple.Data[0].b)
			{
				DamageAmount = ModifyEnvironmentDamageTuple.Data[1].i;
			}
			else
			{
				DamageAmount += ModifyEnvironmentDamageTuple.Data[1].i;
			}

			// Issue #200 End

			// Randomize damage
			if (default.MAX_ENV_DAMAGE_RANGE_PCT > 0 && !bLinearDamage && AbilityRadius > 0.0f && DamageAmount > 0)
			{
				RandRoll = `SYNC_RAND((default.MAX_ENV_DAMAGE_RANGE_PCT * 2) + 1) - default.MAX_ENV_DAMAGE_RANGE_PCT;
				//`LOG ("DAMAGE AMOUNT BEFORE:" @ string (DamageAmount) @ "RandRoll" @ string (RandRoll));
				DamageChange = float(DamageAmount) * (float (RandRoll) / 100);
				//`LOG ("DAMAGE CHANGE:" @ string (DamageChange));
				DamageAmount += int (DamageChange);
				//`LOG ("DAMAGE AMOUNT AFTER:" @ string (DamageAmount));
			}

			if( ( bLinearDamage || AbilityRadius > 0.0f || AbilityContext.ResultContext.HitResult == eHit_Miss) && DamageAmount > 0 )
			{
				// Loop here over projectiles if needed. If not single hit and use the first index.
				if(ApplyEffectParameters.AbilityResultContext.ProjectileHitLocations.Length > 0)
				{
					HitLocationsArray = ApplyEffectParameters.AbilityResultContext.ProjectileHitLocations;
				}
				else
				{
					HitLocationsArray = ApplyEffectParameters.AbilityInputContext.TargetLocations;
				}

				HitLocationCount = 1;
				if( bApplyWorldEffectsForEachTargetLocation )
				{
					HitLocationCount = HitLocationsArray.Length;
				}

				bShouldApplyStepDamage = ShouldApplyEnvironmentDamageFalloff(SourceStateObject);  // exclusions for abilities
				for( HitLocationIndex = 0; HitLocationIndex < HitLocationCount; ++HitLocationIndex )
				{
					HitLocation = HitLocationsArray[HitLocationIndex];

					//`LOG("Explosive Envir Falloff: bShouldApplyStepDamage=" $ bShouldApplyStepDamage $ ", BaseEnvironmentalDamage=" $ DamageAmount);

					//submit multiple environment damage gamestates for each hit location -- one for each step in damage
					for(StepIdx = 0; StepIdx < default.EnvironmentDamageSteps.Length; StepIdx++)
					{
						DamageEvent = XComGameState_EnvironmentDamage(NewGameState.CreateStateObject(class'XComGameState_EnvironmentDamage'));	
						DamageEvent.DEBUG_SourceCodeLocation = "UC: X2Effect_ApplyWeaponDamage:ApplyEffectToWorld";
						DamageEvent.DamageTypeTemplateName = DamageTypeTemplateName;
						DamageEvent.HitLocation = HitLocation;
						DamageEvent.Momentum = (AbilityRadius == 0.0f) ? DamageDirection : vect(0,0,0);
						DamageEvent.PhysImpulse = PhysicalImpulseAmount;
						if(bShouldApplyStepDamage)
						{
							StepEnvironmentDamage = int(float(DamageAmount) * default.EnvironmentDamageSteps[StepIdx].DamageRatio);
							DamageEvent.DamageAmount = StepEnvironmentDamage; // adjust for the current step
							//`LOG("Explosive Envir Falloff: Step=" $ StepIdx $ ", Damage=" $ StepEnvironmentDamage);
						}
						else
						{
							DamageEvent.DamageAmount = DamageAmount; // Use the base amount everywhere
						}

						if( bLinearDamage )
						{
							TargetStyle.GetValidTilesForLocation(AbilityStateObject, DamageEvent.HitLocation, DamageEvent.DamageTiles);
						}
						else if (AbilityRadius > 0.0f)
						{
							if(bShouldApplyStepDamage)
								TargetStyle.GetValidTilesForLocation(AbilityStateObject, DamageEvent.HitLocation, DamageEvent.DamageTiles);  // explicitly mark tiles even for radius so we can break them into steps
							else
								DamageEvent.DamageRadius = AbilityRadius;
						}
						else
						{					
							DamageEvent.DamageTiles.AddItem(`XWORLD.GetTileCoordinatesFromPosition(DamageEvent.HitLocation));
						}

						if( X2AbilityMultiTarget_Cone(TargetStyle) != none )
						{
							DamageEvent.bAffectFragileOnly = AbilityTemplate.bFragileDamageOnly;
							//DamageEvent.CosmeticConeEndDiameter = X2AbilityMultiTarget_Cone(TargetStyle).ConeEndDiameter;
                            DamageEvent.CosmeticConeEndDiameter = X2AbilityMultiTarget_Cone(TargetStyle).GetConeEndDiameter(AbilityStateObject);
							DamageEvent.CosmeticConeLength = X2AbilityMultiTarget_Cone(TargetStyle).GetConeLength(AbilityStateObject);
							DamageEvent.CosmeticConeLocation = SourceUnitPosition;
							DamageEvent.CosmeticDamageShape = SHAPE_CONE;

							if (AbilityTemplate.bCheckCollision)
							{
								for (i = 0; i < AbilityContext.InputContext.VisibleTargetedTiles.Length; i++)
								{
									DamageEvent.DamageTiles.AddItem( AbilityContext.InputContext.VisibleTargetedTiles[i] );
								}

								for (i = 0; i < AbilityContext.InputContext.VisibleNeighborTiles.Length; i++)
								{
									DamageEvent.DamageTiles.AddItem( AbilityContext.InputContext.VisibleNeighborTiles[i] );
								}
							}
						}

						if(bShouldApplyStepDamage)
						{
							//`LOG("Explosive Envir Falloff: Step=" $ StepIdx $ ",PreFilterTiles=" $ DamageEvent.DamageTiles.Length);
							FilterTilesByStep(StepIdx, DamageEvent.HitLocation, AbilityRadius, DamageEvent.DamageTiles);  // filter out all tiles not in the current step
							//`LOG("Explosive Envir Falloff: Step=" $ StepIdx $ ",PostFilterTiles=" $ DamageEvent.DamageTiles.Length);
						}
						DamageEvent.DamageCause = SourceStateObject.GetReference();
						DamageEvent.DamageSource = DamageEvent.DamageCause;
						DamageEvent.bRadialDamage = AbilityRadius > 0;
						NewGameState.AddStateObject(DamageEvent);

						if(!bShouldApplyStepDamage) // only loop once, since all tiles are affected
							break;
					}
				}
			}
		}
	}
}

simulated function FilterTilesByStep(int StepIdx, vector SourceLocation, float AbilityRadius, out array<TTile> ValidTiles)
{
	local XComWorldData World;
	local TTile Tile;
	local vector TileLocation;
	local float LowerBound, UpperBound, DistanceRatio, Distance;
	//local int CheckTileCount, RemoveTileCount, KeepTileCount;
	local array<TTile> RemoveTiles;

	if(AbilityRadius <= 0)
		return;

	World = `XWORLD;
	
	if(StepIdx == 0)
		LowerBound = 0.0;
	else
		LowerBound = default.EnvironmentDamageSteps[StepIdx-1].DistanceRatio;

	UpperBound = default.EnvironmentDamageSteps[StepIdx].DistanceRatio;

	foreach ValidTiles(Tile)
	{
		//CheckTileCount++;
		TileLocation = World.GetPositionFromTileCoordinates(Tile);
		//Distance = FClamp(VSize(SourceLocation - TileLocation), 0.0, AbilityRadius);
		Distance = VSize(SourceLocation - TileLocation);
		DistanceRatio = Distance / AbilityRadius;

		if((DistanceRatio >= UpperBound) || (DistanceRatio < LowerBound))
		{
			//RemoveTileCount++;
			RemoveTiles.AddItem(Tile);
		}
		else
		{
			//KeepTileCount++;
		}
	}
	//`LOG ("Explosive Envir Falloff: Step=" $ StepIdx $ ", Processed " $ CheckTileCount $ " tiles. Removed " $ RemoveTileCount $ ", kept " $ KeepTileCount $ " Tiles.");
	foreach RemoveTiles(Tile)
	{
		ValidTiles.RemoveItem(Tile);
	}
}

simulated function bool ShouldApplyEnvironmentDamageFalloff(XComGameState_Unit SourceUnit)
{
	local name AbilityExclusion;

    if(default.EnvironmentDamageFalloffAbilityExclusions.Length == 0)
    {
        //`LOG("EnvironmentDamageFalloffAbilityExclusions is empty!");
    }

	foreach default.EnvironmentDamageFalloffAbilityExclusions(AbilityExclusion)
	{
        //`LOG("EnvironmentDamageFalloffAbilityExclusions checking for " $ AbilityExclusion);

		if(SourceUnit.HasSoldierAbility(AbilityExclusion))
			return false;

		//additional check for aliens, checking character 
		if(SourceUnit.FindAbility(AbilityExclusion).ObjectId > 0)
			return false;
	}

    //`LOG("EnvironmentDamageFalloffAbilityExclusions not found on soldier, returning true");
	return true;
}