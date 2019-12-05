//---------------------------------------------------------------------------------------
//  CLASS:   X2Effect_ReaperAWC
//  AUTHOR:  Mr. Nice
//           
//---------------------------------------------------------------------------------------

class X2Effect_ReaperAWC extends X2Effect_Reaper;

`include(AWCCostFixW\Src\ModConfigMenuAPI\MCM_API_CfgHelpers.uci)

function RegisterForEvents(XComGameState_Effect EffectGameState)
{
	local X2EventManager EventMgr;
	local Object EffectObj;

	EventMgr = `XEVENTMGR;

	EffectObj = EffectGameState;


	EventMgr.RegisterForEvent(EffectObj, 'AbilityActivated', EffectGameState.ReaperActivatedCheck, ELD_OnStateSubmitted);

	if (`GETMCMVAR(FIX_REAPER_MOMENTUM))
	{
		EventMgr.RegisterForEvent(EffectObj, 'UnitDied', ReaperKillCheck, ELD_OnStateSubmitted,,,, EffectGameState);
		EventMgr.RegisterForEvent(EffectObj, 'RendActivated', MomentumCheck, ELD_OnStateSubmitted,, `XCOMHISTORY.GetGameStateForObjectID(EffectGameState.ApplyEffectParameters.SourceStateObjectRef.ObjectID));
	}
	else
		EventMgr.RegisterForEvent(EffectObj, 'UnitDied', EffectGameState.ReaperKillCheck, ELD_OnStateSubmitted);
}

static function EventListenerReturn MomentumCheck(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
	local XComGameState_Unit UnitState;
	//local X2AbilityTemplate AbilityTemplate;
	local XComGameState NewGameState;

	if(XComGameState_Unit(GameState.GetGameStateForObjectID(XComGameStateContext_Ability(GameState.GetContext()).InputContext.PrimaryTarget.ObjectID)).IsAlive())
	{
			UnitState=XComGameState_Unit(EventSource);
			NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState(string(GetFuncName()));
			XComGameStateContext_ChangeContainer(NewGameState.GetContext()).BuildVisualizationFn = MomentumVisualization;
			UnitState = XComGameState_Unit(NewGameState.ModifyStateObject(UnitState.Class, UnitState.ObjectID));
			UnitState.ActionPoints.AddItem('Momentum');
			`TACTICALRULES.SubmitGameState(NewGameState);
	}
	return ELR_NoInterrupt;
}

static function EventListenerReturn ReaperKillCheck(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
	local XComGameStateContext_Ability AbilityContext;
	local XComGameState_Unit UnitState;
	local X2AbilityTemplate AbilityTemplate;
	local XComGameState NewGameState;
	local UnitValue ReaperKillCount;
	local XComGameState_Effect EffectGameState;

	EffectGameState=XComGameState_Effect(CallbackData);
	AbilityContext = XComGameStateContext_Ability(GameState.GetContext());

	//  was this a melee kill made by the reaper unit? if so, grant an action point
	if (AbilityContext != None && EffectGameState.ApplyEffectParameters.SourceStateObjectRef == AbilityContext.InputContext.SourceObject)
	{
		AbilityTemplate = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager().FindAbilityTemplate(AbilityContext.InputContext.AbilityTemplateName);
		if (AbilityTemplate != none && AbilityTemplate.IsMelee())
		{
			UnitState = XComGameState_Unit(GameState.GetGameStateForObjectID(EffectGameState.ApplyEffectParameters.SourceStateObjectRef.ObjectID));
			if (UnitState == None)
				UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectGameState.ApplyEffectParameters.SourceStateObjectRef.ObjectID));
			`assert(UnitState != None);
			UnitState.GetUnitValue(class'X2Effect_Reaper'.default.ReaperKillName, ReaperKillCount);
			NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState(string(GetFuncName()));
			XComGameStateContext_ChangeContainer(NewGameState.GetContext()).BuildVisualizationFn = EffectGameState.ReaperKillVisualizationFn;
			UnitState = XComGameState_Unit(NewGameState.ModifyStateObject(UnitState.Class, UnitState.ObjectID));
			UnitState.SetUnitFloatValue(class'X2Effect_Reaper'.default.ReaperKillName, ReaperKillCount.fValue + 1, eCleanup_BeginTurn);
			UnitState.ActionPoints.AddItem('Reaper');
			`TACTICALRULES.SubmitGameState(NewGameState);
		}
	}

	return ELR_NoInterrupt;
}

static function MomentumVisualization(XComGameState VisualizeGameState)
{
	local XComGameState_Unit UnitState;
	local X2Action_PlaySoundAndFlyOver SoundAndFlyOver;
	local VisualizationActionMetadata ActionMetadata;
	local XComGameStateHistory History;
	local X2AbilityTemplate AbilityTemplate;

	History = `XCOMHISTORY;
	foreach VisualizeGameState.IterateByClassType(class'XComGameState_Unit', UnitState)
	{
		History.GetCurrentAndPreviousGameStatesForObjectID(UnitState.ObjectID, ActionMetadata.StateObject_OldState, ActionMetadata.StateObject_NewState, , VisualizeGameState.HistoryIndex);
		ActionMetadata.StateObject_NewState = UnitState;
		ActionMetadata.VisualizeActor = UnitState.GetVisualizer();

		AbilityTemplate = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager().FindAbilityTemplate('Momentum');

		SoundAndFlyOver = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext(), false, ActionMetadata.LastActionAdded));
		SoundAndFlyOver.SetSoundAndFlyOverParameters(None, AbilityTemplate.LocFlyOverText, '', eColor_Good, AbilityTemplate.IconImage);

		
		break;
	}
}