// This class modifies templates to extend vision range of aliens, if desired.
// This is a UIListener so that it can apply to mod templates even if it's earlier in the load order.
class UIScreenListener_ExchangeTemplates extends UIScreenListener;

var bool isPatched;

event OnInit(UIScreen Screen) {
	if (isPatched) return;

	isPatched = true;

	if (class'ConcealmentRules'.default.ExtraDetectionRange != 0) {
		`LOG("Altering templates to add vision modifier...");

		ModifyTemplates();

		`XCOMHISTORY.ResetHistory(); // remove difficulty effects
	}
}

//Code from: http://forums.nexusmods.com/index.php?/topic/3839560-template-modification-without-screenlisteners/
//Used to set a difficulty level during start up, because the templates we want to modify have difficulty variants
//These variants can only be accessed when the gamestate is in the corresponding difficulty
static function XComGameState_CampaignSettings GameStateMagic(){
	local XComGameStateHistory History;
	local XComGameStateContext_StrategyGameRule StrategyStartContext;
	local XComGameState StartState;
	local XComGameState_CampaignSettings GameSettings;

	History = `XCOMHISTORY;

	StrategyStartContext = XComGameStateContext_StrategyGameRule(class'XComGameStateContext_StrategyGameRule'.static.CreateXComGameStateContext());
	StrategyStartContext.GameRuleType = eStrategyGameRule_StrategyGameStart;
	StartState = History.CreateNewGameState(false, StrategyStartContext);
	History.AddGameStateToHistory(StartState);

	GameSettings = new class'XComGameState_CampaignSettings'; // Do not use CreateStateObject() here
	StartState.AddStateObject(GameSettings);

	return GameSettings;
}

function ModifyTemplates() {
	local X2CharacterTemplateManager TemplateManager;
	local X2CharacterTemplate CharTemplate;
	local X2DataTemplate Template;

	local XComGameState_CampaignSettings Settings;
	local int difficulty;

	Settings = GameStateMagic();

	// patch all difficulties at once
	for(difficulty = `MIN_DIFFICULTY_INDEX; difficulty <= `MAX_DIFFICULTY_INDEX; ++difficulty)
	{
		Settings.SetDifficulty(difficulty);

		TemplateManager = class'X2CharacterTemplateManager'.static.GetCharacterTemplateManager();

		foreach TemplateManager.IterateTemplates (Template, None) {
			CharTemplate = X2CharacterTemplate(Template);

			if (CharTemplate == None) continue;
			class'ConcealmentRules'.static.ModifyTemplate(CharTemplate);
		}
	}
}

defaultproperties
{
	isPatched = false;
    ScreenClass = none;
}