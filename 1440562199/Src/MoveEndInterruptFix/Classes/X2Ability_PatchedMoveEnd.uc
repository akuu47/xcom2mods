class X2Ability_PatchedMoveEnd extends X2Ability config(MovePatch);

var config array<name> AbilityToFix;

static function PatchedAbility_FillOutGameState(XComGameState NewGameState)
{
	local XComGameStateHistory History;
	local XComGameState_Ability ShootAbilityState;
	local X2AbilityTemplate AbilityTemplate;
	local XComGameStateContext_Ability AbilityContext;
	local int TargetIndex;	

	local XComGameState_BaseObject AffectedTargetObject_OriginalState;	
	local XComGameState_BaseObject AffectedTargetObject_NewState;
	local XComGameState_BaseObject SourceObject_OriginalState;
	local XComGameState_BaseObject SourceObject_NewState;
	local XComGameState_Item       SourceWeapon, SourceWeapon_NewState;
	local X2AmmoTemplate           AmmoTemplate;
	local X2GrenadeTemplate        GrenadeTemplate;
	local X2WeaponTemplate         WeaponTemplate;
	local EffectResults            MultiTargetEffectResults, EmptyResults;
	local EffectTemplateLookupType MultiTargetLookupType;
	local OverriddenEffectsByType OverrideEffects, EmptyOverride;

	History = `XCOMHISTORY;	

	//Build the new game state frame, and unit state object for the acting unit
	`assert(NewGameState != none);
	AbilityContext = XComGameStateContext_Ability(NewGameState.GetContext());
	ShootAbilityState = XComGameState_Ability(History.GetGameStateForObjectID(AbilityContext.InputContext.AbilityRef.ObjectID));	
	AbilityTemplate = ShootAbilityState.GetMyTemplate();
	SourceObject_OriginalState = History.GetGameStateForObjectID(AbilityContext.InputContext.SourceObject.ObjectID);	
	SourceWeapon = ShootAbilityState.GetSourceWeapon();
	ShootAbilityState = XComGameState_Ability(NewGameState.ModifyStateObject(ShootAbilityState.Class, ShootAbilityState.ObjectID));

	//Any changes to the shooter / source object are made to this game state
	SourceObject_NewState = NewGameState.ModifyStateObject(SourceObject_OriginalState.Class, AbilityContext.InputContext.SourceObject.ObjectID);

	if (SourceWeapon != none)
	{
		SourceWeapon_NewState = XComGameState_Item(NewGameState.ModifyStateObject(class'XComGameState_Item', SourceWeapon.ObjectID));
	}

	if (AbilityTemplate.bRecordValidTiles && AbilityContext.InputContext.TargetLocations.Length > 0)
	{
		AbilityTemplate.AbilityMultiTargetStyle.GetValidTilesForLocation(ShootAbilityState, AbilityContext.InputContext.TargetLocations[0], AbilityContext.ResultContext.RelevantEffectTiles);
	}

	//If there is a target location, generate a list of projectile events to use if a projectile is requested
	if(AbilityContext.InputContext.ProjectileEvents.Length > 0)
	{
		GenerateDamageEvents(NewGameState, AbilityContext);
	}

	//  Apply effects to shooter
	if (AbilityTemplate.AbilityShooterEffects.Length > 0)
	{
		AffectedTargetObject_OriginalState = SourceObject_OriginalState;
		AffectedTargetObject_NewState = SourceObject_NewState;				
			
		ApplyEffectsToTarget(
			AbilityContext, 
			AffectedTargetObject_OriginalState, 
			SourceObject_OriginalState, 
			ShootAbilityState, 
			AffectedTargetObject_NewState, 
			NewGameState, 
			AbilityContext.ResultContext.HitResult,
			AbilityContext.ResultContext.ArmorMitigation,
			AbilityContext.ResultContext.StatContestResult,
			AbilityTemplate.AbilityShooterEffects, 
			AbilityContext.ResultContext.ShooterEffectResults, 
			AbilityTemplate.DataName, 
			TELT_AbilityShooterEffects);
	}

	//  Apply effects to primary target
	if (AbilityContext.InputContext.PrimaryTarget.ObjectID != 0)
	{
		AffectedTargetObject_OriginalState = History.GetGameStateForObjectID(AbilityContext.InputContext.PrimaryTarget.ObjectID, eReturnType_Reference);
		AffectedTargetObject_NewState = NewGameState.ModifyStateObject(AffectedTargetObject_OriginalState.Class, AbilityContext.InputContext.PrimaryTarget.ObjectID);
		
		if (AbilityTemplate.AbilityTargetEffects.Length > 0)
		{
			if (ApplyEffectsToTarget(
				AbilityContext, 
				AffectedTargetObject_OriginalState, 
				SourceObject_OriginalState, 
				ShootAbilityState, 
				AffectedTargetObject_NewState, 
				NewGameState, 
				AbilityContext.ResultContext.HitResult,
				AbilityContext.ResultContext.ArmorMitigation,
				AbilityContext.ResultContext.StatContestResult,
				AbilityTemplate.AbilityTargetEffects, 
				AbilityContext.ResultContext.TargetEffectResults, 
				AbilityTemplate.DataName, 
				TELT_AbilityTargetEffects))

			{
				if (AbilityTemplate.bAllowAmmoEffects && SourceWeapon_NewState != none && SourceWeapon_NewState.HasLoadedAmmo())
				{
					AmmoTemplate = X2AmmoTemplate(SourceWeapon_NewState.GetLoadedAmmoTemplate(ShootAbilityState));
					if (AmmoTemplate != none && AmmoTemplate.TargetEffects.Length > 0)
					{
						ApplyEffectsToTarget(
							AbilityContext, 
							AffectedTargetObject_OriginalState, 
							SourceObject_OriginalState, 
							ShootAbilityState, 
							AffectedTargetObject_NewState, 
							NewGameState, 
							AbilityContext.ResultContext.HitResult,
							AbilityContext.ResultContext.ArmorMitigation,
							AbilityContext.ResultContext.StatContestResult,
							AmmoTemplate.TargetEffects, 
							AbilityContext.ResultContext.TargetEffectResults, 
							AmmoTemplate.DataName,  //Use the ammo template for TELT_AmmoTargetEffects
							TELT_AmmoTargetEffects);
					}
				}
				if (AbilityTemplate.bAllowBonusWeaponEffects && SourceWeapon_NewState != none)
				{
					WeaponTemplate = X2WeaponTemplate(SourceWeapon_NewState.GetMyTemplate());
					if (WeaponTemplate != none && WeaponTemplate.BonusWeaponEffects.Length > 0)
					{
						ApplyEffectsToTarget(
							AbilityContext,
							AffectedTargetObject_OriginalState, 
							SourceObject_OriginalState, 
							ShootAbilityState, 
							AffectedTargetObject_NewState, 
							NewGameState, 
							AbilityContext.ResultContext.HitResult,
							AbilityContext.ResultContext.ArmorMitigation,
							AbilityContext.ResultContext.StatContestResult,
							WeaponTemplate.BonusWeaponEffects, 
							AbilityContext.ResultContext.TargetEffectResults, 
							WeaponTemplate.DataName,
							TELT_WeaponEffects);
					}
				}
			}
		}

		if (AbilityTemplate.Hostility == eHostility_Offensive && AffectedTargetObject_NewState.CanEarnXp() && XComGameState_Unit(AffectedTargetObject_NewState).IsEnemyUnit(XComGameState_Unit(SourceObject_NewState)))
		{
			`TRIGGERXP('XpGetShotAt', AffectedTargetObject_NewState.GetReference(), SourceObject_NewState.GetReference(), NewGameState);
		}
	}

	if (AbilityTemplate.bUseLaunchedGrenadeEffects)
	{
		GrenadeTemplate = X2GrenadeTemplate(SourceWeapon.GetLoadedAmmoTemplate(ShootAbilityState));
		MultiTargetLookupType = TELT_LaunchedGrenadeEffects;
	}
	else if (AbilityTemplate.bUseThrownGrenadeEffects)
	{
		GrenadeTemplate = X2GrenadeTemplate(SourceWeapon.GetMyTemplate());
		MultiTargetLookupType = TELT_ThrownGrenadeEffects;
	}
	else
	{
		MultiTargetLookupType = TELT_AbilityMultiTargetEffects;
	}

	//  Apply effects to multi targets
	if( (AbilityTemplate.AbilityMultiTargetEffects.Length > 0 || GrenadeTemplate != none) && AbilityContext.InputContext.MultiTargets.Length > 0)
	{		
		for( TargetIndex = 0; TargetIndex < AbilityContext.InputContext.MultiTargets.Length; ++TargetIndex )
		{
			AffectedTargetObject_OriginalState = History.GetGameStateForObjectID(AbilityContext.InputContext.MultiTargets[TargetIndex].ObjectID, eReturnType_Reference);
			AffectedTargetObject_NewState = NewGameState.ModifyStateObject(AffectedTargetObject_OriginalState.Class, AbilityContext.InputContext.MultiTargets[TargetIndex].ObjectID);

			OverrideEffects = AbilityContext.ResultContext.MultiTargetEffectsOverrides.Length > TargetIndex ? AbilityContext.ResultContext.MultiTargetEffectsOverrides[TargetIndex] : EmptyOverride;
			
			MultiTargetEffectResults = EmptyResults;        //  clear struct for use - cannot pass dynamic array element as out parameter
			if (ApplyEffectsToTarget(
				AbilityContext, 
				AffectedTargetObject_OriginalState, 
				SourceObject_OriginalState, 
				ShootAbilityState, 
				AffectedTargetObject_NewState, 
				NewGameState, 
				AbilityContext.ResultContext.MultiTargetHitResults[TargetIndex],
				AbilityContext.ResultContext.MultiTargetArmorMitigation[TargetIndex],
				AbilityContext.ResultContext.MultiTargetStatContestResult[TargetIndex],
				AbilityTemplate.bUseLaunchedGrenadeEffects ? GrenadeTemplate.LaunchedGrenadeEffects : (AbilityTemplate.bUseThrownGrenadeEffects ? GrenadeTemplate.ThrownGrenadeEffects : AbilityTemplate.AbilityMultiTargetEffects), 
				MultiTargetEffectResults, 
				GrenadeTemplate == none ? AbilityTemplate.DataName : GrenadeTemplate.DataName, 
				MultiTargetLookupType ,
				OverrideEffects))
			{
				AbilityContext.ResultContext.MultiTargetEffectResults[TargetIndex] = MultiTargetEffectResults;  //  copy results into dynamic array
			}
		}
	}
	
	//Give all effects a chance to make world modifications ( ie. add new state objects independent of targeting )
	ApplyEffectsToWorld(AbilityContext, SourceObject_OriginalState, ShootAbilityState, NewGameState, AbilityTemplate.AbilityShooterEffects, AbilityTemplate.DataName, TELT_AbilityShooterEffects);
	ApplyEffectsToWorld(AbilityContext, SourceObject_OriginalState, ShootAbilityState, NewGameState, AbilityTemplate.AbilityTargetEffects, AbilityTemplate.DataName, TELT_AbilityTargetEffects);	
	if (GrenadeTemplate != none)
	{
		if (AbilityTemplate.bUseLaunchedGrenadeEffects)
		{
			ApplyEffectsToWorld(AbilityContext, SourceObject_OriginalState, ShootAbilityState, NewGameState, GrenadeTemplate.LaunchedGrenadeEffects, GrenadeTemplate.DataName, TELT_LaunchedGrenadeEffects);
		}
		else if (AbilityTemplate.bUseThrownGrenadeEffects)
		{
			ApplyEffectsToWorld(AbilityContext, SourceObject_OriginalState, ShootAbilityState, NewGameState, GrenadeTemplate.ThrownGrenadeEffects, GrenadeTemplate.DataName, TELT_ThrownGrenadeEffects);
		}
	}
	else
	{
		ApplyEffectsToWorld(AbilityContext, SourceObject_OriginalState, ShootAbilityState, NewGameState, AbilityTemplate.AbilityMultiTargetEffects, AbilityTemplate.DataName, TELT_AbilityMultiTargetEffects);
	}

	//Apply the cost of the ability
	AbilityTemplate.ApplyCost(AbilityContext, ShootAbilityState, SourceObject_NewState, SourceWeapon_NewState, NewGameState);
}

static function ClearFireVis(XComGameState VisualizeGameState)
{
	local XComGameStateHistory      History;
	local XComGameStateVisualizationMgr		VisualizationMgr;
	local X2Action_Fire FireAnim;
	local X2Action_FireNonAnim NonFire;
	local XComGameStateContext_Ability AbilityContext;
	local XComGameState_Ability ShootAbilityState;
	local X2AbilityTemplate AbilityTemplate;
	local Actor SourceVisualizer;
	local XComGameState_Unit SourceState;
	local X2Action WaitForAction, JoinAction;
	local X2Action_PlaySoundAndFlyOver		SoundAndFlyover;
	local VisualizationActionMetadata VisMeta;
	local array<X2Action> IterActions, ParentActions;
	local int i;

	History = `XCOMHISTORY;
	VisualizationMgr = `XCOMVISUALIZATIONMGR;
	AbilityContext = XComGameStateContext_Ability( VisualizeGameState.GetContext() );
	ShootAbilityState = XComGameState_Ability(History.GetGameStateForObjectID(AbilityContext.InputContext.AbilityRef.ObjectID));	
	AbilityTemplate = ShootAbilityState.GetMyTemplate();
	SourceState = XComGameState_Unit(History.GetGameStateForObjectID(AbilityContext.InputContext.SourceObject.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex));
	if( SourceState != None )
	{
		SourceVisualizer = History.GetVisualizer(SourceState.ObjectID);
		FireAnim = X2Action_Fire(VisualizationMgr.GetNodeOfType(VisualizationMgr.BuildVisTree, AbilityTemplate.ActionFireClass, SourceVisualizer));

		VisMeta = FireAnim.Metadata;
		SoundAndFlyOver = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyover'.static.AddToVisualizationTree(VisMeta, AbilityContext, false, FireAnim));
		SoundAndFlyOver.SetSoundAndFlyOverParameters(None, AbilityTemplate.LocFriendlyName @ "failed!", '', eColor_Bad);

		NonFire = X2Action_FireNonAnim(class'X2Action_FireNonAnim'.static.AddToVisualizationTree(VisMeta, AbilityContext, true, FireAnim));

		IterActions.Length = 0;
		VisualizationMgr.GetNodesOfType(VisualizationMgr.BuildVisTree, class'X2Action_WaitForAnotherAction', IterActions);

		foreach IterActions(WaitForAction)
		{
			if (X2Action_WaitForAnotherAction(WaitForAction).ActionToWaitFor == FireAnim)
			{
				`log("WaitForAction has been changed",, 'PatchMoveEnd');
				X2Action_WaitForAnotherAction(WaitForAction).ActionToWaitFor = NonFire;
			}
		}


		//IterActions.Length = 0;
		//VisualizationMgr.GetNodesOfType(VisualizationMgr.BuildVisTree, class'X2Action_MarkerNamed', IterActions);
//
		//foreach IterActions(JoinAction)
		//{
			//if (X2Action_MarkerNamed(JoinAction).MarkerName == 'Join' && 
				//XComGameStateContext_Ability(JoinAction.StateChangeContext).InputContext.SourceObject.ObjectID == AbilityContext.InputContext.SourceObject.ObjectID)
			//{
				//ParentActions = JoinAction.ParentActions;
//
				//`log("JoinAction has" @ ParentActions.Length @ "parents",, 'PatchMoveEnd');
				//for (i = 0; i < ParentActions.Length; i++)
				//{
					//`log(i @ "index action class is" @ ParentActions[i].class,, 'PatchMoveEnd');
					//if (ParentActions[i] == FireAnim || ParentActions[i] == JoinAction || FireAnim.ChildActions.Find(ParentActions[i]) != INDEX_NONE)
					//{
						//`log(i @ "index is related to fire animation, removing...",, 'PatchMoveEnd');
						//ParentActions.Remove(i, 1);
						//i--;
					//}
				//}
				//VisualizationMgr.DisconnectAction(JoinAction);
				//VisualizationMgr.ConnectAction(JoinAction, VisualizationMgr.BuildVisTree,,, ParentActions);
				//`log("JoinAction now has" @ JoinAction.ParentActions.Length @ "parents",, 'PatchMoveEnd');
				//`log("JoinAction should have" @ ParentActions.Length @ "parents",, 'PatchMoveEnd');
//
				////VisualizationMgr.DestroyAction(JoinAction);
			//}
		//}
		VisualizationMgr.DisconnectAction(NonFire);
		VisualizationMgr.ReplaceNode(NonFire, FireAnim);
	}
}

static function XComGameState PatchedMoveEndAbility_BuildGameState(XComGameStateContext Context)
{
	local XComGameState NewGameState;
	local XComGameStateContext_Ability AbilityContext;
	local XComGameState_Ability ShootAbilityState;
	local X2AbilityTemplate AbilityTemplate;
	local XComGameState_BaseObject SourceObject_NewState;
	local XComGameState_Item       SourceWeapon_NewState;

	NewGameState = `XCOMHISTORY.CreateNewGameState(true, Context);
	AbilityContext = XComGameStateContext_Ability(Context);

	// finalize the movement portion of the ability
	class'X2Ability_DefaultAbilitySet'.static.MoveAbility_FillOutGameState(NewGameState, false); //Do not apply costs at this time.

	// Final validation, can the unit STILL use the ability?
	if (!AbilityContext.Validate())
	{
		`log("Unit can no longer continue using ability, something happened!",, 'PatchMoveEnd');
		// Still consume action points because you shouldn't cheat.

		SourceObject_NewState = `XCOMHISTORY.GetGameStateForObjectID(AbilityContext.InputContext.SourceObject.ObjectID);
		SourceObject_NewState = NewGameState.ModifyStateObject(SourceObject_NewState.Class, AbilityContext.InputContext.SourceObject.ObjectID);
		
		SourceWeapon_NewState = XComGameState_Item(`XCOMHISTORY.GetGameStateForObjectID(AbilityContext.InputContext.SourceObject.ObjectID));
		if (SourceWeapon_NewState != none)
		{
			SourceWeapon_NewState = XComGameState_Item(NewGameState.ModifyStateObject(class'XComGameState_Item', SourceWeapon_NewState.ObjectID));
		}
		ShootAbilityState = XComGameState_Ability(`XCOMHISTORY.GetGameStateForObjectID(AbilityContext.InputContext.AbilityRef.ObjectID));	
		AbilityTemplate = ShootAbilityState.GetMyTemplate();
		AbilityTemplate.ApplyCost(AbilityContext, ShootAbilityState, SourceObject_NewState, SourceWeapon_NewState, NewGameState);
		AbilityContext.bSkipValidation = false;
		AbilityContext.PostBuildVisualizationFn.AddItem(ClearFireVis);

		return NewGameState;
	}

	// build the "fire" animation for the slash
	PatchedAbility_FillOutGameState(NewGameState); //Costs applied here.

	return NewGameState;
}

static function XComGameState PatchedAbility_BuildInterruptGameState(XComGameStateContext Context, int InterruptStep, EInterruptionStatus InterruptionStatus)
{
	//  This "typical" interruption game state allows the ability to be interrupted with no game state changes.
	//  Upon resume from the interrupt, the ability will attempt to build a new game state like normal.

	local XComGameState NewGameState;
	local XComGameStateContext_Ability AbilityContext;
	local XComGameState_Ability AbilityState;

	AbilityContext = XComGameStateContext_Ability(Context);
	if (AbilityContext != none)
	{
		if (InterruptionStatus == eInterruptionStatus_Resume)
		{
			AbilityState = XComGameState_Ability(`XCOMHISTORY.GetGameStateForObjectID(AbilityContext.InputContext.AbilityRef.ObjectID));
			NewGameState = AbilityState.GetMyTemplate().BuildNewGameStateFn(Context);
			AbilityContext = XComGameStateContext_Ability(NewGameState.GetContext());
			AbilityContext.SetInterruptionStatus(InterruptionStatus);
			AbilityContext.ResultContext.InterruptionStep = InterruptStep;
		}		
		else if (InterruptStep == 0)
		{
			NewGameState = `XCOMHISTORY.CreateNewGameState(true, Context);
			AbilityContext = XComGameStateContext_Ability(NewGameState.GetContext());
			AbilityContext.SetInterruptionStatus(InterruptionStatus);
			AbilityContext.ResultContext.InterruptionStep = InterruptStep;
		}				
	}
	return NewGameState;
}

static function XComGameState PatchedMoveEndAbility_BuildInterruptGameState(XComGameStateContext Context, int InterruptStep, EInterruptionStatus InterruptionStatus)
{
	local XComGameStateContext_Ability AbilityContext;
	local XComGameState NewGameState;
	local int MovingUnitIndex, NumMovementTiles;
	local XComGameState_Unit SourceUnit;

	AbilityContext = XComGameStateContext_Ability(Context);
	AbilityContext.bSkipValidation = true; // DO NOT VALIDATE CONTEXT - we will be validating the context manually here
	`assert(AbilityContext != None);

	if (AbilityContext.InputContext.MovementPaths.Length == 0) //No movement - use the trivial case in TypicalAbility_BuildInterruptGameState
	{
		return PatchedAbility_BuildInterruptGameState(Context, InterruptStep, InterruptionStatus);
	}
	else //Movement - MoveAbility_BuildInterruptGameState can handle
	{
		NewGameState = class'X2Ability_DefaultAbilitySet'.static.MoveAbility_BuildInterruptGameState(Context, InterruptStep, InterruptionStatus);
		if (NewGameState == none && InterruptionStatus == eInterruptionStatus_Interrupt)
		{
			//  all movement has processed interruption, now allow the ability to be interrupted for the attack
			for(MovingUnitIndex = 0; MovingUnitIndex < AbilityContext.InputContext.MovementPaths.Length; ++MovingUnitIndex)
			{
				NumMovementTiles = Max(NumMovementTiles, AbilityContext.InputContext.MovementPaths[MovingUnitIndex].MovementTiles.Length);
			}
			//  only interrupt when movement is completed, and not again afterward
			if(InterruptStep == (NumMovementTiles - 1))			
			{
				NewGameState = `XCOMHISTORY.CreateNewGameState(true, AbilityContext);
				AbilityContext = XComGameStateContext_Ability(NewGameState.GetContext());
				//  setup game state as though movement is fully completed so that the unit state's location is up to date
				class'X2Ability_DefaultAbilitySet'.static.MoveAbility_FillOutGameState(NewGameState, false); //Do not apply costs at this time.
				AbilityContext.SetInterruptionStatus(InterruptionStatus);
				AbilityContext.ResultContext.InterruptionStep = InterruptStep;
			}
		}

		SourceUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(AbilityContext.InputContext.SourceObject.ObjectID));
		if (SourceUnit != none && (SourceUnit.IsDead() || SourceUnit.IsIncapacitated() || SourceUnit.IsUnconscious() || SourceUnit.ActionPoints.Length == 0 ))
		{
			`log("Unit can no longer move, disabling rest of movement",, 'PatchMoveEnd');
			AbilityContext.bSkipValidation = false; // Since our guy is dead/have all AP removed, release the validation and stop him from moving
		}

		return NewGameState;
	}
}

static function PatchMoveEndAbility(name AbilityName)
{
	local X2AbilityTemplate AbTemplate;

	AbTemplate = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager().FindAbilityTemplate('StunLance');

	AbTemplate.BuildNewGameStateFn = PatchedMoveEndAbility_BuildGameState;
	AbTemplate.BuildInterruptGameStateFn = PatchedMoveEndAbility_BuildInterruptGameState;

	`log(AbilityName @ "was patched", AbTemplate != none, 'PatchMoveEnd');
}