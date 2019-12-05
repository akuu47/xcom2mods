class Musashi_Effect_VoidStrikeReaper extends X2Effect_Persistent
	config(GameData_SoldierSkills);


function RegisterForEvents(XComGameState_Effect EffectGameState)
{
	local X2EventManager EventMgr;
	local Object EffectObj;

	EventMgr = `XEVENTMGR;

	EffectObj = EffectGameState;

	EventMgr.RegisterForEvent(EffectObj, 'UnitDied', class'Musashi_Effect_VoidStrikeReaper'.static.VoidReaperKillCheck, ELD_OnStateSubmitted);
}

static function EventListenerReturn VoidReaperKillCheck(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object Callback)
{
	local XComGameStateContext_Ability AbilityContext;
	local XComGameState_Unit UnitState;
	local X2AbilityTemplate AbilityTemplate;
	local XComGameState NewGameState;
	local UnitValue UnitVal;

	AbilityContext = XComGameStateContext_Ability(GameState.GetContext());
	UnitState = XComGameState_Unit(AbilityContext.AssociatedState.GetGameStateForObjectID(AbilityContext.InputContext.SourceObject.ObjectID));
	if (UnitState == None)
		UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(AbilityContext.InputContext.SourceObject.ObjectID));
	`assert(UnitState != None);
	UnitState.GetUnitValue('Reaper_SuperKillCheck', UnitVal);

	`LOG("Is reaper active " @ bool(UnitVal.fValue),, 'VoidStrike');

	//  was this a melee kill made by the reaper unit? if so, grant an action point
	if (AbilityContext != None && UnitVal.fValue == 1)
	{
		AbilityTemplate = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager().FindAbilityTemplate(AbilityContext.InputContext.AbilityTemplateName);
		if (AbilityTemplate != none && AbilityTemplate.IsMelee() && AbilityTemplate.DataName == 'MusashiVoidStrike')
		{
			`LOG("Add additionl AP for reaper",, 'VoidStrike');
			NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState(string(GetFuncName()));
			UnitState = XComGameState_Unit(NewGameState.CreateStateObject(UnitState.Class, UnitState.ObjectID));
			UnitState.ActionPoints.AddItem(class'X2CharacterTemplateManager'.default.StandardActionPoint);
			NewGameState.AddStateObject(UnitState);
			`TACTICALRULES.SubmitGameState(NewGameState);
		}
	}

	return ELR_NoInterrupt;
}

DefaultProperties
{
	DuplicateResponse = eDupe_Ignore
}