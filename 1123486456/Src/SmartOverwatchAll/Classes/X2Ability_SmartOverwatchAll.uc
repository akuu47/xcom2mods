class X2Ability_SmartOverwatchAll extends X2Ability;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	Templates.AddItem(CreateSmartOverwatchAllAbility('SmartOverwatchAll', false, false));
	Templates.AddItem(CreateSmartOverwatchAllAbility('SmartOverwatchAll_Commander', true, false));
	Templates.AddItem(CreateSmartOverwatchAllAbility('SmartOverwatchOthers', false, true));

	return Templates;
}

static function X2DataTemplate CreateSmartOverwatchAllAbility(name TemplateName, bool bCommanderAbility, bool bOverwatchOthers)
{
	local X2AbilityTemplate Template;
	local X2AbilityCost_ActionPoints ActionPointCost;
	local X2Condition_UnitProperty ShooterCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);
	Template.IconImage = bOverwatchOthers ? "img:///UISmartOverwatchAll.UIPerk_SmartOverwatchOthers" : "img:///UISmartOverwatchAll.UIPerk_SmartOverwatchAll";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.PLACE_EVAC_PRIORITY + 1;
	Template.ConcealmentRule = eConceal_Always;
	Template.bCommanderAbility = bCommanderAbility;
    Template.AbilitySourceName = 'eAbilitySource_Commander';
    Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	ActionPointCost.bFreeCost = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;

	ShooterCondition = new class'X2Condition_UnitProperty';
	ShooterCondition.ExcludeDead = true;
	Template.AbilityShooterConditions.AddItem(ShooterCondition);

	// Template.bCommanderAbility = true;
	Template.BuildNewGameStateFn = bOverwatchOthers ? SmartOverwatchOthers_BuildGameState : SmartOverwatchAll_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.bSkipFireAction = true;

	Template.bDontDisplayInAbilitySummary = true;

	return Template;
}

simulated function XComGameState SmartOverwatchAll_BuildGameState( XComGameStateContext Context )
{
	local XComGameState_Unit SourceState;
	local XComGameState_Unit UnitState;
	local XComGameStateHistory History;
	local XComGameState NewGameState;

	History = `XCOMHISTORY;
	NewGameState = History.CreateNewGameState(true, Context);

	SourceState = XComGameState_Unit(History.GetGameStateForObjectID(XComGameStateContext_Ability(Context).InputContext.SourceObject.ObjectID));

	foreach History.IterateByClassType(class'XComGameState_Unit', UnitState)
	{
		if (UnitState.ControllingPlayer.ObjectID == SourceState.ControllingPlayer.ObjectID && !UnitState.bRemovedFromPlay && UnitState.IsAlive())
		{
			UnitState.AutoRunBehaviorTree('SmartOverwatchAll', UnitState.ActionPoints.Length);
		}
	}

	return NewGameState;
}

simulated function XComGameState SmartOverwatchOthers_BuildGameState( XComGameStateContext Context )
{
	local XComGameState_Unit SourceState;
	local XComGameState_Unit UnitState;
	local XComGameStateHistory History;
	local XComGameState NewGameState;

	History = `XCOMHISTORY;
	NewGameState = History.CreateNewGameState(true, Context);

	SourceState = XComGameState_Unit(History.GetGameStateForObjectID(XComGameStateContext_Ability(Context).InputContext.SourceObject.ObjectID));

	foreach History.IterateByClassType(class'XComGameState_Unit', UnitState)
	{
		if (UnitState.ControllingPlayer.ObjectID == SourceState.ControllingPlayer.ObjectID && UnitState.ObjectID != SourceState.ObjectID && !UnitState.bRemovedFromPlay && UnitState.IsAlive())
		{
			UnitState.AutoRunBehaviorTree('SmartOverwatchAll', UnitState.ActionPoints.Length);
		}
	}

	return NewGameState;
}
