class X2Action_FireNonAnim extends X2Action_Fire;

simulated state Executing
{
	simulated function BeginState(name PrevStateName)
	{
		super(X2Action).BeginState(PrevStateName);

		Unit.CurrentFireAction = self;
	}

	simulated event Tick( float fDeltaT )
	{	
		NotifyTargetTimer -= fDeltaT;		

		if( bUseAnimToSetNotifyTimer && !bNotifiedTargets && NotifyTargetTimer < 0.0f )
		{
			NotifyTargetsAbilityApplied();
		}

		UpdateAim(fDeltaT);
	}

Begin:
	//Per Jake, the primary target should never be fogged
	if ((XGUnit(PrimaryTarget) != none))
	{
		HideFOW();
	}

	//Run at full speed if we are interrupting
	VisualizationMgr.SetInterruptionSloMoFactor(Unit, 1.0f);
	
	UnitPawn.EnableRMA(true, true);
	UnitPawn.EnableRMAInteractPhysics(true);

	// Skip animation here

	//Signal that we are done with our fire animation
	`XEVENTMGR.TriggerEvent('Visualizer_AnimationFinished', self, self);

	//Failure case handling! We failed to notify our targets that damage was done. Notify them now.
	SetTargetUnitDiscState();

	if( FOWViewer != none )
	{
		`XWORLD.DestroyFOWViewer(FOWViewer);

		if( XGUnit(PrimaryTarget).IsAlive() )
		{
			XGUnit(PrimaryTarget).SetForceVisibility(eForceNone);
			XGUnit(PrimaryTarget).GetPawn().UpdatePawnVisibility();
		}
		else
		{
			//Force dead bodies visible
			XGUnit(PrimaryTarget).SetForceVisibility(eForceVisible);
			XGUnit(PrimaryTarget).GetPawn().UpdatePawnVisibility();
		}
	}

	if( SourceFOWViewer != none )
	{
		`XWORLD.DestroyFOWViewer(SourceFOWViewer);

		Unit.SetForceVisibility(eForceNone);
		Unit.GetPawn().UpdatePawnVisibility();
	}

	while ( ShouldWaitToComplete() )
	{
		Sleep(0.0f);
	}

	CompleteAction();
	
	//reset to false, only during firing would the projectile be able to overwrite aim
	UnitPawn.ProjectileOverwriteAim = false;
}