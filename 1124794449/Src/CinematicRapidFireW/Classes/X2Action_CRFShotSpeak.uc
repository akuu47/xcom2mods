//---------------------------------------------------------------------------------------
//  FILE:    X2Action_CRFShotSpeak.uc
//  AUTHOR:  Mr. Nice
//           
//---------------------------------------------------------------------------------------

class X2Action_CRFShotSpeak extends X2Action_EnterCover;

var protected CustomAnimParams AnimParams;
var protected float AmmoDelay, SleepDelay;
var bool AmmoCheck;
var int Verbosity;

simulated state Executing
{
	function RestoreFOW()
	{
		if (Unit != None)
		{
			Unit.SetForceVisibility(eForceNone);
			UnitPawn.UpdatePawnVisibility();
		}
	}
Begin:
	//log("X2Action_EnterCover::Begin -"@Unit.IdleStateMachine.GetStateName()@UnitPawn@Unit.ObjectID, , 'XCom_Filtered');
	if (!bSkipEnterCover)
	{
		//Unit.GetVisualizedGameState().HasSoldierBond(BondmateRef);
		//XComTacticalController(GetALocalPlayerController()).Visualizer_SelectUnit(XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(BondmateRef.ObjectID)));
		UnitPawn.EnableLeftHandIK(false);

		//Play an enter cover animation if we exited cover
		//The order of operations in here are very sensitive, alter at your own risk
		//******************************************************

		//Exit cover animations generally used root motion, get the RMA systems ready
		UnitPawn.EnableRMAInteractPhysics(true);
		UnitPawn.EnableRMA(true, true);

		if(Verbosity != 0 && RespondToShotSpeak() && !bInstantEnterCover)
		{
			SleepDelay=0.75;
			AmmoDelay=1;
		}
		else if(!bInstantEnterCover)
		{
			CheckAmmoUnitSpeak(0.0);
		}
		if (Verbosity == 2) Unit.m_arrRecentSpeech.length=0;

		EndCrouching();

		if (Unit.CanUseCover() && Unit.bSteppingOutOfCover)
		{
			SleepDelay=0;
			Unit.bShouldStepOut = false;
			AnimParams = default.AnimParams;
			AnimParams.PlayRate = GetNonCriticalAnimationSpeed();

			AnimParams.DesiredEndingAtoms.Add(1);
			AnimParams.DesiredEndingAtoms[0].Translation = Unit.RestoreLocation;
			AnimParams.DesiredEndingAtoms[0].Rotation = QuatFromRotator(Rotator(Unit.RestoreHeading));
			AnimParams.DesiredEndingAtoms[0].Scale = 1.0f;
			
			switch (Unit.m_eCoverState)
			{
			case eCS_LowLeft:
			case eCS_HighLeft:
				AnimParams.AnimName = 'HL_StepIn';
				break;
			case eCS_LowRight:
			case eCS_HighRight:
				AnimParams.AnimName = 'HR_StepIn';
				break;
			case eCS_None:
				AnimParams.AnimName = 'NO_IdleGunUp';
				break;
			}

			SeqToPlay = UnitPawn.GetAnimTreeController().PlayFullBodyDynamicAnim(AnimParams);
			FinishAnim(SeqToPlay);
			if (VSizeSq(UnitPawn.Location - Unit.RestoreLocation) > 16 * 16)
			{
				`RedScreen("X2Action_EnterCover::ERROR! Unit not at unit restore point! : - Josh"$AnimParams.AnimName@UnitPawn@Unit.ObjectID@UnitPawn.Location@Unit.RestoreLocation);

		// Forcefully set location to restore location
		UnitPawn.SetLocation(Unit.RestoreLocation);
			}
		}
		else
		{
			AnimParams = default.AnimParams;
			AnimParams.PlayRate = GetNonCriticalAnimationSpeed();

			AnimParams.DesiredEndingAtoms.Add(1);
			AnimParams.DesiredEndingAtoms[0].Translation = Unit.RestoreLocation;
			AnimParams.DesiredEndingAtoms[0].Rotation = QuatFromRotator(Rotator(Unit.RestoreHeading));
			AnimParams.DesiredEndingAtoms[0].Scale = 1.0f;

			switch (Unit.m_eCoverState)
			{
			case eCS_LowLeft:
			case eCS_LowRight:
				AnimParams.AnimName = 'LL_FireStop';
				break;
			case eCS_HighLeft:
			case eCS_HighRight:
				AnimParams.AnimName = 'HL_FireStop';
				break;
			case eCS_None:
				AnimParams.AnimName = 'NO_FireStop';
				break;
			}
			if (UnitPawn.GetAnimTreeController().CanPlayAnimation(AnimParams.AnimName))
			{
				SeqToPlay = UnitPawn.GetAnimTreeController().PlayFullBodyDynamicAnim(AnimParams);
				FinishAnim(SeqToPlay);
				if (VSizeSq(UnitPawn.Location - Unit.RestoreLocation) > 16 * 16)
				{
					`RedScreen("X2Action_EnterCover::ERROR! Unit not at unit restore point! : - Josh"$AnimParams.AnimName@UnitPawn@Unit.ObjectID@UnitPawn.Location@Unit.RestoreLocation);

					// Forcefully set location to restore location
					UnitPawn.SetLocation(Unit.RestoreLocation);
				}
			}
			else
			{
				// No animation to play so manually get rid of the aim
				if ((UseWeapon == none) || XComWeapon(UseWeapon.m_kEntity).WeaponAimProfileType != WAP_Unarmed)
				{
					UnitPawn.SetAiming(false, 0.5f);
				}

				// Since we aren't playing an animation to get the correct location/facing do it manually
				if (VSizeSq(Unit.RestoreLocation - UnitPawn.Location) >= class'XComWorldData'.const.WORLD_StepSizeSquared)
				{
					UnitPawn.SetLocationNoOffset(Unit.RestoreLocation);
					`Warn("X2Action_EnterCover: Attempting to restore "$UnitPawn$" to location more than a tile away!"@ `ShowVar(UnitPawn.Location)@ `ShowVar(Unit.RestoreLocation));
				}

				Unit.IdleStateMachine.ForceHeading(Unit.RestoreHeading);
				if (!ShouldPlayZipMode())
				{
					while (Unit.IdleStateMachine.IsEvaluatingStance())
					{
						Sleep(0.0f);
					}
				}
			}
		}

		//Reset RMA systems
		UnitPawn.bSkipIK = false;
		UnitPawn.EnableFootIK(true);

		Unit.bSteppingOutOfCover = false;

		Unit.UpdateInteractClaim();

		Unit.IdleStateMachine.CheckForStanceUpdateOnIdle();

		Unit.IdleStateMachine.PlayIdleAnim();

		if (AmmoDelay!=0)
		{
			if(SleepDelay!=0)
				Sleep(SleepDelay * GetDelayModifier()); // let the audio finish playing. 
			CheckAmmoUnitSpeak(AmmoDelay);
		}

		Unit.IdleStateMachine.bTargeting = false;

		if (PrimaryTarget != none)
			PrimaryTarget.IdleStateMachine.bTargeting = false;


		RestoreFOW();
	}
	else
	{
		if (Verbosity != 0)
		{
			RespondToShotSpeak();
			if (Verbosity == 2) unit.m_arrRecentSpeech.length=0;
		}
	}
	CompleteAction();
}

defaultproperties
{
	Verbosity = 1;
}