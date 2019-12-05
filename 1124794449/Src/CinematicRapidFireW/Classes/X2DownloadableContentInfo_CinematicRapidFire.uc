//---------------------------------------------------------------------------------------
//  FILE:    X2DownloadableContentInfo_CinematicRapidFireW.uc
//  AUTHOR:  Mr. Nice
//           
//---------------------------------------------------------------------------------------


class X2DownloadableContentInfo_CinematicRapidFire extends X2DownloadableContentInfo config(CinematicRapidFire); 


`include(CinematicRapidFireW\Src\ModConfigMenuAPI\MCM_API_CfgHelpers_ALT.uci)

`define GETAB(ABNAME) abilities.FindAbilityTemplate(`ABNAME)

var config array<name> FIRST_SHOT;
var config array<name> SECOND_SHOT;

var CinescriptCut OTSCut;

static event OnPostTemplatesCreated()
{
	local X2AbilityTemplateManager abilities;
	local name AbilityName;
	local X2Camera_Cinescript CinescriptCDO;
	local array<AbilityCameraDefinition> StandardGunFiringDef, NewCameraTypeDef;
	local AbilityCameraDefinition CameraDef;
	local int i;

	abilities=class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();
	foreach default.FIRST_SHOT(AbilityName)
		SetCinematic(`GETAB(AbilityName), 1);
	foreach default.SECOND_SHOT(AbilityName)
		SetCinematic(`GETAB(AbilityName), 2);
	SetCinematic(`GETAB('BondmateDualStrikeFollowup'), 3);


	CinescriptCDO=X2Camera_Cinescript(class'engine'.static.FindClassDefaultObject("X2Camera_Cinescript"));

	for(i=CinescriptCDO.AbilityCameras.Find('AbilityCameraType', "StandardGunFiring"); i<CinescriptCDO.AbilityCameras.Length; i++)
	{
		if (CinescriptCDO.AbilityCameras[i].AbilityCameraType=="StandardGunFiring")
			StandardGunFiringDef.AddItem(CinescriptCDO.AbilityCameras[i]);
	}
	CreateNoExitDef(StandardGunFiringDef, "StandardRGunFiring", CinescriptCDO.AbilityCameras);

	for(i=0; i<StandardGunFiringDef.Length; i++)
	{
		CameraDef=StandardGunFiringDef[i];
		CameraDef.AbilityCameraType="StandardGunFiringLost";
		if (CameraDef.TargetTeam==CinescriptTargetTeam_TheLost && CameraDef.ShooterTeam==CinescriptShooterTeam_Either)
			CameraDef.ShooterTeam=CinescriptShooterTeam_Alien;
		CinescriptCDO.AbilityCameras.AddItem(CameraDef);
		NewCameraTypeDef.AddItem(CameraDef);
	}
	CreateNoExitDef(NewCameraTypeDef, "StandardRGunFiringLost", CinescriptCDO.AbilityCameras);

	for(i=0; i<NewCameraTypeDef.Length; i++)
	{
		CameraDef=NewCameraTypeDef[i];
		CameraDef.AbilityCameraType="StandardGunFiringLostF";
		if (CameraDef.ShooterTeam==CinescriptShooterTeam_XCom && CameraDef.TargetTeam==CinescriptTargetTeam_Any )
		{
			CinescriptCDO.AbilityCameras.AddItem(CameraDef);
			CameraDef.TargetTeam=CinescriptTargetTeam_TheLost;
			CameraDef.CameraCuts[0].DisableBlend=false;
			CameraDef.CameraCuts[0].ShouldAlwaysShow=true;
			NewCameraTypeDef.InsertItem(++i, CameraDef);
		}
		CinescriptCDO.AbilityCameras.AddItem(CameraDef);
	}
	CreateNoExitDef(NewCameraTypeDef, "StandardRGunFiringLostF", CinescriptCDO.AbilityCameras);

	//NewCameraTypeDef.Length=0;
	//for(i=0; i<StandardGunFiringDef.Length; i++)
	//{
		//CameraDef=StandardGunFiringDef[i];
		//CameraDef.AbilityCameraType="StandardDGunFiring";
		//if (CameraDef.ShooterTeam==CinescriptShooterTeam_XCom)
			//CameraDef.CameraCuts[0].ShouldAlwaysShow=true;
		//CinescriptCDO.AbilityCameras.AddItem(CameraDef);
		//NewCameraTypeDef.AddItem(CameraDef);
	//}
	//for(i=0; i<NewCameraTypeDef.Length; i++)
	//{
		//CameraDef=NewCameraTypeDef[i];
		//CameraDef.AbilityCameraType="StandardDGunFiringLost";
		//if (CameraDef.TargetTeam==CinescriptTargetTeam_TheLost && CameraDef.ShooterTeam==CinescriptShooterTeam_Either)
			//CameraDef.ShooterTeam=CinescriptShooterTeam_Alien;
		//CinescriptCDO.AbilityCameras.AddItem(CameraDef);
	//}

	NewCameraTypeDef.Length=0;
	for(i=0; i<StandardGunFiringDef.Length; i++)
	{
		CameraDef=StandardGunFiringDef[i];
		CameraDef.AbilityCameraType="StandardBGunFiring";
		if (CameraDef.ShooterTeam==CinescriptShooterTeam_XCom)
		{
			CameraDef.CameraCuts[0].DisableBlend=false;
			CameraDef.CameraCuts[0].ShouldAlwaysShow=true;
		}
		CinescriptCDO.AbilityCameras.AddItem(CameraDef);
		NewCameraTypeDef.AddItem(CameraDef);
	}
	CreateNoExitDef(NewCameraTypeDef, "StandardRBGunFiring", CinescriptCDO.AbilityCameras);

	for(i=0; i<NewCameraTypeDef.Length; i++)
	{
		NewCameraTypeDef[i].AbilityCameraType="StandardBGunFiringLost";
		if (NewCameraTypeDef[i].TargetTeam==CinescriptTargetTeam_TheLost && NewCameraTypeDef[i].ShooterTeam==CinescriptShooterTeam_Either)
			NewCameraTypeDef[i].ShooterTeam=CinescriptShooterTeam_Alien;
		CinescriptCDO.AbilityCameras.AddItem(NewCameraTypeDef[i]);
	}
	CreateNoExitDef(NewCameraTypeDef, "StandardRBGunFiringLost", CinescriptCDO.AbilityCameras);
	MCMUpdate();
}

static function CreateNoExitDef(out array<AbilityCameraDefinition> NewCameraTypeDef, string AbilityCameraType, out array<AbilityCameraDefinition> outArray)
{
	local AbilityCameraDefinition CameraDef;
	local int i, j;

	for(i=0; i<NewCameraTypeDef.Length; i++)
	{
		CameraDef=NewCameraTypeDef[i];
		CameraDef.AbilityCameraType=AbilityCameraType;
		if (CameraDef.ShooterTeam==CinescriptShooterTeam_XCom)
			for(j=CameraDef.CameraCuts.Length-1; j>=0; j--)	
		{
			if(CameraDef.CameraCuts[j].NewCameraType==CinescriptCameraType_Exit)
				CameraDef.CameraCuts.Remove(j, 1);
			else if(CameraDef.CameraCuts[j].NewCameraType==CinescriptCameraType_Matinee
				&& CameraDef.CameraCuts[j].PopWhenFinished)
			{
				if(j+1<CameraDef.CameraCuts.Length && CameraDef.CameraCuts[j+1].CutAfterPrevious)
					CameraDef.CameraCuts[j+1].ShouldAlwaysShow=True;
				else
					CameraDef.CameraCuts.InsertItem(j+1, default.OTSCut);
			}
		}
		outArray.AddItem(CameraDef);
	}
}

static function MCMUpdate()
{
	local X2AbilityTemplateManager abilities;
	local X2DataTemplate Template;
	local X2AbilityTemplate Ability;
	local name AbilityName;
	local X2CharacterTemplateManager Characters;
	local bool LOST_OTS, DUAL_OTS, LOST_CINEMATIC, DUAL_CINEMATIC, SHOW_ACTIVATION;
	local string LostPostFix;

	abilities=class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();

	LOST_CINEMATIC=`GETMCMVAR(LOST_CINEMATIC);
	LostPostFix=LOST_CINEMATIC ? "Lost" : "";

	DUAL_CINEMATIC=`GETMCMVAR(DUAL_CINEMATIC);

	Ability=`GETAB('BondmateDualStrike');
	if (Ability!=none)
	{
		DUAL_OTS=`GETMCMVAR(DUAL_OTS);
		Ability.bUsesFiringCamera=DUAL_OTS;
		Ability.TargetingMethod = DUAL_OTS ? class'X2TargetingMethod_OverTheShoulder' : class'X2TargetingMethod_TopDown';
		Ability.CinescriptCameraType=DUAL_CINEMATIC ? (DUAL_OTS ? "StandardGunFiring" : "StandardBGunFiring" $ LostPostFix) : "";
	}

	SHOW_ACTIVATION=`GETMCMVAR(SHOW_ACTIVATION);
	Ability=`GETAB('BondmateDualStrikeFollowup');
	if (Ability!=none)
	{
		Ability.bShowActivation=DUAL_CINEMATIC && SHOW_ACTIVATION;
		Ability.CinescriptCameraType=DUAL_CINEMATIC ? "StandardBGunFiring" $ LostPostFix : "";
	}

	LOST_OTS=`GETMCMVAR(LOST_OTS);
	LostPostFix=LOST_CINEMATIC ? ("Lost" $ LOST_OTS ? "" :"F") : "";
	foreach Abilities.IterateTemplates(Template)
		if(InStr(X2AbilityTemplate(Template).CinescriptCameraType, "StandardGunFiring")!=INDEX_NONE)
			X2AbilityTemplate(Template).CinescriptCameraType="StandardGunFiring" $ LostPostFix;
	
	LostPostFix=LOST_CINEMATIC ? "Lost" : "";
	foreach default.SECOND_SHOT(AbilityName)
	{
		Ability=`GETAB(AbilityName);
		if (Ability!=none)
		{
			Ability.bShowActivation=SHOW_ACTIVATION;
			Ability.CinescriptCameraType="StandardGunFiring" $ LostPostFix;
		}
	}

	Characters=class'X2CharacterTemplateManager'.static.GetCharacterTemplateManager();
	foreach Characters.IterateTemplates(Template)
		if(X2CharacterTemplate(Template).CharacterGroupName == 'TheLost')
			X2CharacterTemplate(Template).bDontUseOTSTargetingCamera = !LOST_OTS;

	class'X2Action_MoveTurnCRF'.default.Tolerance=Cos(DegToRad * `GETMCMVAR(TURN_ANGLE));
	`log(`showvar(class'X2Action_MoveTurnCRF'.default.Tolerance));
}

static function SetCinematic(X2AbilityTemplate ability, int Shot)
{
	if (ability!=None)
	{
		//ability.FrameAbilityCameraType=eCameraFraming_Never;
		switch (Shot)
		{
			case 1:
				ability.CinescriptCameraType = "StandardGunFiring";
				ability.bUsesFiringCamera=true;
				ability.TargetingMethod = class'X2TargetingMethod_OverTheShoulder';
				break;
			case 2:
				//ability.bUsesFiringCamera=true;
				ability.MergeVisualizationFn = static.SequentialShot_MergeVisualizationCRF;
				break;
			case 3:
				Ability.MergeVisualizationFn=static.DualStrike_MergeVisualization;
		}
	}
}

static function UndoCinematic(X2AbilityTemplate ability)
{
	if (ability!=None)
	{
		ability.CinescriptCameraType = "";
		ability.bUsesFiringCamera=false;
		ability.TargetingMethod = class'X2TargetingMethod_TopDown';
	}
}

static simulated function DualStrike_MergeVisualization(X2Action BuildTree, out X2Action VisualizationTree)
{
	local XComGameStateVisualizationMgr VisMgr;
	local Array<X2Action> arrActions;
	local X2Action_MarkerTreeInsertBegin MarkerStart;
	local X2Action_MarkerNamed MarkerNamed, JoinMarker;
	local int i;

	VisMgr = `XCOMVISUALIZATIONMGR;
	ReplaceAction(VisMgr.GetNodeOfType(VisualizationTree, class'X2Action_EnterCover'),
		class'X2Action_CRFShotSpeak', VisualizationTree);
	FixUpCinescriptCamera(VisualizationTree, XComGameStateContext_Ability(BuildTree.StateChangeContext).InputContext.SourceObject);

	MarkerStart = X2Action_MarkerTreeInsertBegin(VisMgr.GetNodeOfType(BuildTree, class'X2Action_MarkerTreeInsertBegin'));
	VisMgr.GetNodesOfType(VisualizationTree, class'X2Action_MarkerNamed', arrActions);

	//	get the last Join marker
	for (i = arrActions.Length - 1; i >= 0; --i)
	{
		MarkerNamed = X2Action_MarkerNamed(arrActions[i]);
		if (MarkerNamed.MarkerName == 'Join')
		{
			JoinMarker = MarkerNamed;
			break;
		}
	}

	`assert(JoinMarker != none);
	VisMgr.ConnectAction(MarkerStart, VisualizationTree, true, JoinMarker);
}

static function SequentialShot_MergeVisualizationCRF(X2Action BuildTree, out X2Action VisualizationTree)
{
	local XComGameStateVisualizationMgr VisMgr;
	local Array<X2Action> arrActions;
	local X2Action_MarkerTreeInsertBegin MarkerStart;
	local X2Action_MarkerNamed MarkerNamed, JoinMarker, TrackerMarker;
	local X2Action_ExitCover ExitCoverAction, FirstExitCoverAction;
	local X2Action EnterCoverAction;
	local X2Action_CRFShotSpeak SpeakAction;
	local X2Action_MoveTurn MoveTurnAction;
	local X2Action_WaitForAnotherAction WaitAction;
	local VisualizationActionMetadata ActionMetadata;
	local XComGameStateContext_Ability AbilityContext;
	local int i;
	// Variable for Issue #20
	local int iBestHistoryIndex, iBestHistoryIndex2;
	local array<GameRulesCache_VisibilityInfo> VisibilityInfos;
	local TTile FiringTile;

	VisMgr = `XCOMVISUALIZATIONMGR;

	AbilityContext = XComGameStateContext_Ability(BuildTree.StateChangeContext);
	FixUpCinescriptCamera(VisualizationTree, AbilityContext.InputContext.SourceObject);
	MarkerStart = X2Action_MarkerTreeInsertBegin(VisMgr.GetNodeOfType(BuildTree, class'X2Action_MarkerTreeInsertBegin'));
	// Start Issue #20
	// This function breaks 3+ subsequent shots. Somehow, the actions filled out by GetNodesOfType are sorted so that our
	// "get the last join marker" actually sometimes finds us the FIRST join marker. This causes all these shot contexts to
	// try and visualize themselves alongside each other, which is definitely not intended.
	// Further investigations made it seem that the additional parameter bSortByHistoryIndex=true does not seem to have the desired effect
	// but generally push it *somewhat* in the right direction
	VisMgr.GetNodesOfType(VisualizationTree, class'X2Action_MarkerNamed', arrActions, , , true);
	`log(`showvar(arrActions.Length));
	// End Issue #20

	//	get the last Join marker
	// Start Issue #20
	// GetNodesOfType() does not seem to produce a consistent ordering
	// We will just manually get the "latest" one by comparing history indices
	iBestHistoryIndex = -1;
	iBestHistoryIndex2 = -1;
	for (i = 0; i < arrActions.Length; ++i)
	{
		MarkerNamed = X2Action_MarkerNamed(arrActions[i]);
		if (MarkerNamed.MarkerName == 'Join' && MarkerNamed.CurrentHistoryIndex > iBestHistoryIndex)
		{
			iBestHistoryIndex = MarkerNamed.CurrentHistoryIndex;
			// End Issue #20
			JoinMarker = MarkerNamed;
		}
		else if (MarkerNamed.MarkerName == 'SequentialShotTracker' && MarkerNamed.Metadata.StateObjectRef == MarkerStart.Metadata.StateObjectRef && MarkerNamed.CurrentHistoryIndex > iBestHistoryIndex2)
		{
			iBestHistoryIndex2 = MarkerNamed.CurrentHistoryIndex;
			TrackerMarker = MarkerNamed;
		}
		// Comment out for Issue #20
		// We can't bail out early because we may need to compare more join markers :(
		//if (JoinMarker != none && TrackerMarker != none)
		//	break;
	}

	`assert(JoinMarker != none);

	ExitCoverAction = X2Action_ExitCover(VisMgr.GetNodeOfType(BuildTree, class'X2Action_ExitCover'));
	//	all other enter cover actions need to skip entering cover	
	VisMgr.GetNodesOfType(VisualizationTree, class'X2Action_EnterCover', arrActions, ExitCoverAction.Metadata.VisualizeActor,, true);
	iBestHistoryIndex = -1;
	for (i = 0; i < arrActions.Length; ++i)
	{
		//	@TODO - Ideally we need to check our ExitCover action to see if the step out it wants (from our original
		//			location) is different from the previous ExitCover, in which case we'd need to go ahead
		//			and allow the EnterCover to run, as well as not skip our ExitCover.
		if (arrActions[i].CurrentHistoryIndex>iBestHistoryIndex)
		{
			EnterCoverAction = arrActions[i];
			iBestHistoryIndex = EnterCoverAction.CurrentHistoryIndex;
		}
	}
	SpeakAction = X2Action_CRFShotSpeak(ReplaceAction(EnterCoverAction,	class'X2Action_CRFShotSpeak'));
	SpeakAction.Verbosity=`GETMCMVAR(SHOT_VERBOSITY);
	LeafNodes(class'X2Action_ApplyWeaponDamageToTerrain', VisualizationTree, iBestHistoryIndex);

	if (XComGameStateContext_Ability(SpeakAction.StateChangeContext).InputContext.PrimaryTarget == AbilityContext.InputContext.PrimaryTarget)
	{
		//	have our exit cover not visualize since the unit is already out from the first shot
		MakeIntoLeaf(SpeakAction, VisualizationTree);
		SpeakAction.bSkipEnterCover = true;
		ExitCoverAction.bSkipExitCoverVisualization = true;
	}
	else
	{
		//LeafNodes(class'X2Action_ApplyWeaponDamageToUnit', VisualizationTree, iBestHistoryIndex);
		if(TrackerMarker != none)
		{
			for(i=0;i<TrackerMarker.ParentActions.Length;i++)
			{
				if (X2Action_ExitCover(TrackerMarker.ParentActions[i])!=none)
				{
					FirstExitCoverAction = X2Action_ExitCover(TrackerMarker.ParentActions[i]);
					break;
				}
			}
		}
		else
		{
			VisMgr.GetNodesOfType(VisualizationTree, class'X2Action_ExitCover', arrActions, ExitCoverAction.Metadata.VisualizeActor);
			FirstExitCoverAction = X2Action_ExitCover(arrActions[0]);
		}
		FirstExitCoverAction.Init();
		FiringTile = FirstExitCoverAction.GetTileFiringFrom();
		FirstExitCoverAction.Unit.CurrentExitAction=none;
		`TACTICALRULES.VisibilityMgr.GetAllViewersOfLocation(FiringTile, VisibilityInfos, class'XComGameState_Unit', ExitCoverAction.CurrentHistoryIndex-1);
		for(i=0;i<VisibilityInfos.Length;i++)
		{
			if(VisibilityInfos[i].SourceID == AbilityContext.InputContext.PrimaryTarget.ObjectID)
			{
				if(VisibilityInfos[i].bVisibleToDefault)
				{
					MakeIntoLeaf(SpeakAction, VisualizationTree);
					SpeakAction.bSkipEnterCover = true;
					ExitCoverAction.bSkipExitCoverVisualization = true;
					ActionMetadata = ExitCoverAction.Metadata;
					MoveTurnAction = X2Action_MoveTurn(class'X2Action_MoveTurnCRF'.static.CreateVisualizationAction(AbilityContext));
					MoveTurnAction.SetMetadata(ActionMetadata);
					MoveTurnAction.m_vFacePoint = AbilityContext.InputContext.TargetLocations[0];
					VisMgr.InsertSubtree(MoveTurnAction, MoveTurnAction, ExitCoverAction);
				}
				else i = VisibilityInfos.Length;
				break;
			}
		}
		if(i==VisibilityInfos.Length)
		{
			SpeakAction.bInstantEnterCover = true;
			TrackerMarker = none;
			FirstExitCoverAction = ExitCoverAction;
		}
	}

	//	now we have to make sure there's a wait parented to the first exit cover, which waits for the last enter cover
	//	this will prevent the idle state machine from taking over and putting the unit back in cover
		
	if (TrackerMarker == none)
	{
		if(FirstExitCoverAction==none)
		{
			VisMgr.GetNodesOfType(VisualizationTree, class'X2Action_ExitCover', arrActions, ExitCoverAction.Metadata.VisualizeActor);
			FirstExitCoverAction = X2Action_ExitCover(arrActions[0]);
		}
		`assert(FirstExitCoverAction != none);
		ActionMetadata = FirstExitCoverAction.Metadata;
		TrackerMarker = X2Action_MarkerNamed(class'X2Action_MarkerNamed'.static.AddToVisualizationTree(ActionMetadata, FirstExitCoverAction.StateChangeContext, , FirstExitCoverAction));
		TrackerMarker.SetName("SequentialShotTracker");
		WaitAction = X2Action_WaitForAnotherAction(class'X2Action_WaitForAnotherAction'.static.AddToVisualizationTree(ActionMetadata, FirstExitCoverAction.StateChangeContext, , TrackerMarker));
	}
	else
	{
		arrActions = TrackerMarker.ChildActions;
		for (i = 0; i < arrActions.Length; ++i)
		{
			WaitAction = X2Action_WaitForAnotherAction(arrActions[i]);
			if (WaitAction != none)
				break;
		}
		`assert(WaitAction != none);		//	should have been created along with the marker action
	}

	WaitAction.ActionToWaitFor = VisMgr.GetNodeOfType(BuildTree, class'X2Action_EnterCover');

	VisMgr.ConnectAction(MarkerStart, VisualizationTree, true, JoinMarker);
}

static function X2Action ReplaceAction(X2Action OldAction, class<X2Action> NewActionClass, optional X2Action Tree)
{
	local X2Action NewAction;
	local VisualizationActionMetadata ActionMetadata;

	if(Tree != none) MakeIntoLeaf(OldAction, Tree);
	NewAction=NewActionClass.static.CreateVisualizationAction(OldAction.StateChangeContext);
	ActionMetadata=OldAction.Metadata;
	NewAction.SetMetaData(ActionMetaData);
	`XCOMVISUALIZATIONMGR.ReplaceNode(NewAction, OldAction);
	return NewAction;
}

static function MakeIntoLeaf(X2Action Action, X2Action Tree)
{
	local array<X2Action> ParentActions, ChildActions;
	local X2Action ChildAction;
	local XComGameStateVisualizationMgr VisMgr;

	VisMgr = `XCOMVISUALIZATIONMGR;
	ChildActions=Action.ChildActions;
	foreach ChildActions(ChildAction)
	{
		ParentActions=ChildAction.ParentActions;
		ParentActions.RemoveItem(Action);
		VisMgr.DisconnectAction(ChildAction);
		if (ParentActions.Length != 0)
			VisMgr.ConnectAction(ChildAction, Tree,,, ParentActions);
		VisMgr.ConnectAction(ChildAction, Tree,,, Action.ParentActions);
	}
}

static function LeafNodes(class<X2Action> ActionClass, out X2Action Tree, optional int HistoryIndex = -1)
{
	local array<X2Action> arrActions;
	local int i;

	`XCOMVISUALIZATIONMGR.GetNodesOfType(Tree, ActionClass, arrActions);
	for (i =  arrActions.Length-1; i>=0 ; --i)
	{
		if ((HistoryIndex == -1 || arrActions[i].CurrentHistoryIndex == HistoryIndex)
			&& arrActions[i].ChildActions.Length!=0)
		{
			MakeIntoLeaf(arrActions[i], Tree);
			break;
		}
	}
}

static simulated function FixUpCinescriptCamera(out X2Action Tree, StateObjectReference SourceRef)
{
	local XComGameStateVisualizationMgr VisMgr;
	local Array<X2Action> arrActions;
	local X2Action_StartCinescriptCamera ActionStart;
	local X2Action_EndCinescriptCamera ActionEnd;
	local int i;
	local string PreviousCinescriptCameraType;
	local X2AbilityTemplateManager AbilityManager;
	local X2AbilityTemplate AbilityTemplate;
	local XComGameStateContext_Ability AbilityContext;
	local X2Camera_Cinescript CinescriptCamera;

	AbilityManager=class'XComGameState_Ability'.static.GetMyTemplateManager();
	VisMgr = `XCOMVISUALIZATIONMGR;
	VisMgr.GetNodesOfType(Tree, class'X2Action_StartCinescriptCamera', arrActions, , , true);
	for (i =arrActions.Length-1; i >=0 ; --i)
	{
		AbilityContext=XComGameStateContext_Ability(arrActions[i].StateChangeContext);
		if (AbilityContext.InputContext.SourceObject==SourceRef)
		{
			AbilityTemplate = AbilityManager.FindAbilityTemplate(AbilityContext.InputContext.AbilityTemplateName);
			if(InStr(AbilityTemplate.CinescriptCameraType, "StandardGunFiring")!=INDEX_NONE
				|| InStr(AbilityTemplate.CinescriptCameraType, "StandardBGunFiring")!=INDEX_NONE)
			{
				ActionStart=X2Action_StartCinescriptCamera(arrActions[i]);
				break;
			}
		}
	}

	if(ActionStart==none) return;

	VisMgr.GetNodesOfType(Tree, class'X2Action_EndCinescriptCamera', arrActions, , , true);
	for (i =arrActions.Length-1; i >=0 ; --i)
	{
		if (arrActions[i].StateChangeContext == AbilityContext)
		{
			ActionEnd = X2Action_EndCinescriptCamera(arrActions[i]);
			break;
		}
	}
	if (ActionEnd==none) return;

	PreviousCinescriptCameraType = AbilityTemplate.CinescriptCameraType;
	AbilityTemplate.CinescriptCameraType=Repl(AbilityTemplate.CinescriptCameraType, "Standard", "StandardR");
	CinescriptCamera = class'X2Camera_Cinescript'.static.CreateCinescriptCameraForAbility(AbilityContext);
	ActionStart.CinescriptCamera=CinescriptCamera;
	ActionEnd.CinescriptCamera=CinescriptCamera;
	AbilityTemplate.CinescriptCameraType=PreviousCinescriptCameraType;
}

/*
static function RemoveAction(X2Action Action, X2Action Tree)
{
	local X2Action ChildAction;
	local XComGameStateVisualizationMgr VisMgr;

	VisMgr = `XCOMVISUALIZATIONMGR;

	foreach Action.ChildActions(ChildAction)
		VisMgr.ConnectAction(ChildAction, Tree, false,, Action.ParentActions);

	VisMgr.DestroyAction(Action);
}
*/
DefaultProperties
{
	OTSCut={(
		CutAfterPrevious=True,
		ShouldAlwaysShow=True,
		NewCameraType=CinescriptCameraType_OverTheShoulder,
		MatineeCommentPrefix="CIN_Soldier_FF_StartPos"
	)}
}