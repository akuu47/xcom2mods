class UISL_SkulljackFix extends UIScreenListener;

var bool hasRefreshed;

event OnInit(UIScreen Screen)
{
	//Ensure soldiers have ability
	local X2AbilityTemplateManager AbilityTemplateManager;
	local X2AbilityTemplate CurrentTemplate;

	if (hasRefreshed)
	{
		return;
	}
	
	AbilityTemplateManager = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();

	CurrentTemplate = AbilityTemplateManager.FindAbilityTemplate('SKULLOuch');

	CurrentTemplate.BuildNewGameStateFn = SkulljackFeedback_BuildGameState;
	`log("Skulljack ability patched!",, 'SkulljackFix');
	hasRefreshed = true;
}

static function XComGameState SkulljackFeedback_BuildGameState(XComGameStateContext Context)
{
	local XComGameState NewGameState;
	local XComGameStateContext_Ability AbilityContext;
	local XComGameState_Unit UnitState;

	NewGameState = class'X2Ability'.static.TypicalAbility_BuildGameState(Context);
	AbilityContext = XComGameStateContext_Ability(Context);
	UnitState = XComGameState_Unit(NewGameState.CreateStateObject(class'XComGameState_Unit', AbilityContext.InputContext.SourceObject.ObjectID));
	UnitState.Abilities.RemoveItem(AbilityContext.InputContext.AbilityRef);
	NewGameState.AddStateObject(UnitState);

	return NewGameState;
}

defaultproperties
{
	ScreenClass=none;
	hasRefreshed = false;
}