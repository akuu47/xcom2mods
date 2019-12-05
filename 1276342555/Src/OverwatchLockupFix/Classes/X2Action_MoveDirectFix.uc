// This is an Unreal Script

class X2Action_MoveDirectFix extends X2Action_MoveDirect;

`include(OverWatchLockUpFix\Src\ModConfigMenuAPI\MCM_API_CfgHelpers_ALT.uci);

var bool MOVE_SKIPANIM;

function Init()
{
	MOVE_SKIPANIM=`GETMCMVAR(MOVE_SKIPANIM);
	Super.Init();
}	


simulated state Executing
{
Begin:
	if( ReachedDestination() )
	{
		//Make sure the character is in a good animation state if we pass through this code block
		if (bShouldUseWalkAnim)
		{
			Unit.IdleStateMachine.PlayIdleAnim();
		}
		else
		{
			DoStopMoveAnimCheck();
		}

		CompleteAction();
	}

	if( UnitPawn.bIsFemale ) //Enable left hand IK for females per direction from Hector
	{
		UnitPawn.EnableLeftHandIK(true);
	}

	SwitchAnimation(eAnimRun);
	bNoChangeRMA = true;	
	
	while (!ReachedDestination() && !IsTimedOut() && SwitchAnimNodeSequence.AnimSeq != None)
	{
		if (bNoChangeRMA)
		{
			if (UnitPawn.Mesh.RootMotionMode==RMM_Ignore)
			{
				`Warn("XGAction_Mode_Direct should be in Run Animation but RootMotionMode was set to RMM_Ignore!  Resetting Anim.");
				CurrentAnimState=eAnimNone; // Force animation change.
				SwitchAnimation( eAnimRun );
			}
		}

		if (UnitPawn.Physics == PHYS_None)
		{
			// This is bad, lets try to fix it
			UnitPawn.SetPhysics(PHYS_Walking);
			`log("Physics was none in Move_direct, fixing it back up",,'DevAnim');
		}

		if (DoTurnAnimCheck())
		{
			FinishAnim(SwitchAnimNodeSequence);
			SwitchAnimation(eAnimRun);
		}

		if( bNextMoveIsEndMove || bShouldSkipStop ) // If we are skipping the stop for an attack then our next move is not an end move
		{
			if (DoStopMoveAnimCheck())
			{
				FinishAnim(SwitchAnimNodeSequence);
			}
		}

		SetMoveDirectionAndFocalPoint();

		Sleep(0.0f);		
	}
	if(ReachedDestination() && bShouldUseWalkAnim)
	{
		// Since we are walking make sure we start our idle anim here.
		Unit.IdleStateMachine.PlayIdleAnim();
	}

	if( !ReachedDestination() && SwitchAnimNodeSequence.AnimSeq == None )
	{
		`RedScreen("X2Action_MoveDirect tried to play" @ SwitchAnimNodeSequence.AnimSeqName @ "but" @ UnitPawn.Name @ "can't play it.");
	}

	//If we timed out, see if we had an interrupt, and call it before we exit
	if(ExecutingTime >= TimeoutSeconds) 
	{
		`log("WARNING!!!!!! X2Action_MoveDirect timed out! Movement has gone off the rails and the unit had to be teleported to its correct location!");
		//Stop running Forrest. The move end node should take care of teleporting this lost unit to its destination.
		SwitchAnimation(eAnimStopping);
		FinishAnim(SwitchAnimNodeSequence);
	}
	SetMoveDirectionAndFocalPoint();

	if (!bSpawnForcedWalkIn)
	{
		//Adjust the destination Z so that units do not teleport to points higher than the ground ( looking at you ladder traversals )
		Destination.Z = `XWORLD.GetFloorZForPosition(Destination, true) + UnitPawn.CollisionHeight + class'XComWorldData'.const.Cover_BufferDistance;
	}
	
	UnitPawn.m_fDistanceMovedAlongPath = Distance;

	Sleep(0);

	if( UnitPawn.bIsFemale ) //Enable left hand IK for females per direction from Hector
	{
		UnitPawn.EnableLeftHandIK(false);
	}
	CompleteAction();
}
