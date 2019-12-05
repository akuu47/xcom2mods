//-----------------------------------------------------------
//	Class:	X2ReactionFireSequencerFix
//	Author: Mr. Nice
//	
//-----------------------------------------------------------


class X2ReactionFireSequencerFix extends X2ReactionFireSequencer;

var bool SEQUENCER_FIX;

`include(OverWatchLockUpFix\Src\ModConfigMenuAPI\MCM_API_CfgHelpers_ALT.uci);

//ShowReactionFireInstance() is private, so implement it in the two places it is called!
//One advantage: the callees know what the index is, so don't need to loop

function PushReactionFire(X2Action_ExitCover ExitCoverAction)
{
	local XComGameStateContext_Ability FiringAbilityContext;
	local ReactionFireInstance NewReactionFire;
	local XComGameState_Unit ShooterState;
	local XComGameState_Unit TargetState;
	local X2Camera_OTSReactionFireShooter ShooterCam;
	local X2Camera_Midpoint MeleeCam;
	local X2AbilityTemplate FiringAbilityTemplate;

	SEQUENCER_FIX=`GETMCMVAR(SEQUENCER_FIX);
	if (!SEQUENCER_FIX)
	{
		Super.PushReactionFire(ExitCoverAction);
		return;
	}

	++ReactionFireCount;

	if(History == none)
	{
		History = `XCOMHISTORY;
	}
	
	FiringAbilityContext = ExitCoverAction.AbilityContext;

	NewReactionFire.ShooterObjectID = FiringAbilityContext.InputContext.SourceObject.ObjectID;
	NewReactionFire.TargetObjectID = FiringAbilityContext.InputContext.PrimaryTarget.ObjectID;	
	NewReactionFire.ExitCoverAction = ExitCoverAction;
	ShooterState = XComGameState_Unit(History.GetGameStateForObjectID(NewReactionFire.ShooterObjectID, eReturnType_Reference, FiringAbilityContext.AssociatedState.HistoryIndex));

	FiringAbilityTemplate = class'XComGameState_Ability'.static.GetMyTemplateManager().FindAbilityTemplate(FiringAbilityContext.InputContext.AbilityTemplateName);
	if (FiringAbilityTemplate.IsMelee())
	{
		//Don't use an over-the-shoulder camera for melee reactions
		MeleeCam = new class'X2Camera_Midpoint';
		MeleeCam.AddFocusActor(ShooterState.GetVisualizer());
		MeleeCam.AddFocusActor(History.GetVisualizer(NewReactionFire.TargetObjectID));

		NewReactionFire.ShooterCam = MeleeCam;
	}
	else
	{
		ShooterCam = new class'X2Camera_OTSReactionFireShooter';
		ShooterCam.FiringUnit = XGUnit(ShooterState.GetVisualizer());
		ShooterCam.CandidateMatineeCommentPrefix = ShooterState.GetMyTemplate().strTargetingMatineePrefix;
		ShooterCam.ShouldBlend = true;
		ShooterCam.ShouldHideUI = true;
		ShooterCam.SetTarget(XGUnit(History.GetVisualizer(NewReactionFire.TargetObjectID)));

		NewReactionFire.ShooterCam = ShooterCam;
	}

	NewReactionFire.ShotDir = Normal(FiringAbilityContext.InputContext.ProjectileTouchEnd - FiringAbilityContext.InputContext.ProjectileTouchStart);
	InsertReactionFireInstance(NewReactionFire);

	if(ReactionFireCount == 1)
	{		
		TargetState = XComGameState_Unit(History.GetGameStateForObjectID(NewReactionFire.TargetObjectID));

		TargetCam = new class'X2Camera_OTSReactionFireTarget';
		TargetCam.FiringUnit = XGUnit(History.GetVisualizer(NewReactionFire.TargetObjectID));
		TargetCam.CandidateMatineeCommentPrefix = TargetState.GetMyTemplate().strTargetingMatineePrefix;
		TargetCam.ShouldBlend = true;
		TargetCam.ShouldHideUI = true;
		TargetCam.SetTarget(XGUnit(ShooterState.GetVisualizer()));

		StartReactionFireSequence(FiringAbilityContext);

		ReactionFireInstances[0].bStarted = true;
			
		AddedCameras.AddItem(NewReactionFire.ShooterCam);
		`CAMERASTACK.AddCamera(NewReactionFire.ShooterCam);			
	}
}

function bool AttemptStartReactionFire(X2Action_ExitCover ExitCoverAction)
{
	local int Index;

	if (!SEQUENCER_FIX)
		return Super.AttemptStartReactionFire(ExitCoverAction);

	if(ReactionFireInstances.Length == 0)
	{
		return true; //Something has gone wrong, abort
	}

	if(ReactionFireInstances[0].ExitCoverAction == ExitCoverAction &&
	   ReactionFireInstances[0].bStarted)
	{
		return true; //The party has already begun
	}

	for(Index = 1; Index < ReactionFireInstances.Length; ++Index)
	{
		if(Index > 0 && !ReactionFireInstances[Index - 1].bReadyForNext)
		{
			break;
		}		

		if(ReactionFireInstances[Index].ExitCoverAction == ExitCoverAction &&
		   !ReactionFireInstances[Index].bStarted)
		{
			ReactionFireInstances[Index].bStarted = true;
			
			AddedCameras.AddItem(ReactionFireInstances[Index].ShooterCam);
			`CAMERASTACK.RemoveCamera(ReactionFireInstances[Index - 1].ShooterCam);
			`CAMERASTACK.AddCamera(ReactionFireInstances[Index].ShooterCam);			
			return true;
		}
	}

	return false;
}

//Bloody private functions....
function StartReactionFireSequence(XComGameStateContext_Ability FiringAbilityContext)
{
	local float NumReactions;
	local float WorldSloMoRate;
	local int NumTilesVisibleToShooters;
	local XComGameStateVisualizationMgr VisualizationMgr;

	History = `XCOMHISTORY;
	VisualizationMgr = `XCOMVISUALIZATIONMGR;

	TargetVisualizer = History.GetVisualizer(FiringAbilityContext.InputContext.PrimaryTarget.ObjectID);
	TargetVisualizerInterface = X2VisualizerInterface(TargetVisualizer);

	//Force the slomo rate to be a reasonable value
	WorldSloMoRate = FMax(FMin(ReactionFireWorldSloMoRate, 1.0f), 0.33f);

	//See how many reaction fires there will be
	NumReactions = FMax(float(GetNumRemainingReactionFires(FiringAbilityContext, , NumTilesVisibleToShooters)), 1.0f);

	//Decide between a standard overwatch sequence and a more dynamic one. For the more dynamic one we let the character run faster while the
	//shooter tracks and shoots at them. This has several requirements relating to how many shooters and the number of tiles left in the path
	//that are visible. If the unit was killed or didn't resume from the shot NumTilesVisibleToShooters will be 0
	if(NumReactions == 1.0f && NumTilesVisibleToShooters > 6)
	{		
		WorldInfo.Game.SetGameSpeed(WorldSloMoRate);				
		VisualizationMgr.SetInterruptionSloMoFactor(TargetVisualizer, ReactionFireTargetSloMoRate*2.0f);
		bFancyOverwatchActivated = true;
	}
	else
	{
		WorldInfo.Game.SetGameSpeed(WorldSloMoRate);				
		VisualizationMgr.SetInterruptionSloMoFactor(TargetVisualizer, ReactionFireTargetSloMoRate);
	}
	
	PlayAkEvent(SlomoStartSound);
}

function MarkReactionFireInstanceDone(XComGameStateContext_Ability FiringAbilityContext)
{
	local int Index;
	local XComGameStateVisualizationMgr VisualizationMgr;
	local XComGameStateContext_Ability OutNextReactionFire;
	local int NextReactionFireRunIndex;

	VisualizationMgr = `XCOMVISUALIZATIONMGR;

	for(Index = 0; Index < ReactionFireInstances.Length; ++Index)
	{
		if(ReactionFireInstances[Index].ShooterObjectID == FiringAbilityContext.InputContext.SourceObject.ObjectID &&
		   ReactionFireInstances[Index].TargetObjectID == FiringAbilityContext.InputContext.PrimaryTarget.ObjectID &&
		   !ReactionFireInstances[Index].bReadyForNext)
		{
			// if the next shooter is the same as the current shooter (specialist ability guardian)
			// ignore the completion and wait for the pop to occur on fire action completion.
			if (Index + 1 < ReactionFireInstances.Length &&
				ReactionFireInstances[Index + 1].ShooterObjectID == ReactionFireInstances[Index].ShooterObjectID)
			{
				return;
			}

			ReactionFireInstances[Index].bReadyForNext = true;

			//Only do this if there is more reaction fire waiting
			if(GetNumRemainingReactionFires(FiringAbilityContext, OutNextReactionFire) > 0)
			{
				NextReactionFireRunIndex = OutNextReactionFire.VisualizationStartIndex == -1 ? (OutNextReactionFire.AssociatedState.HistoryIndex - 1) : OutNextReactionFire.VisualizationStartIndex;
				VisualizationMgr.ManualPermitNextVisualizationBlockToRun(NextReactionFireRunIndex);
			}
			break;
		}
	}
}
