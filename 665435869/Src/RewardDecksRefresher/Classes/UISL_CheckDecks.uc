class UISL_CheckDecks extends UIScreenListener;

var bool checkedThisSession;

event OnInit(UIScreen Screen)
{
	local X2StrategyElementTemplateManager StrMgr;
	local array<X2StrategyElementTemplate> StrTemplates;
	local X2StrategyElementTemplate Template;
	local X2TechTemplate TechTemplate;

	if (checkedThisSession)
		return;

	StrMgr = class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager();

	StrTemplates = StrMgr.GetAllTemplatesOfClass(class'X2TechTemplate');

	foreach StrTemplates(Template)
	{
		TechTemplate = X2TechTemplate(Template);
		if (TechTemplate != none)
		{
			RefreshTechTemplate(TechTemplate.RewardDeck);
		}
	}

	checkedThisSession = true;
}

function RefreshTechTemplate(name DeckName)
{
	local X2CardManager CardStack;
	local X2ItemTemplateManager ItemMgr;
	local X2DataTemplate DataTemplate;
	local X2ItemTemplate Template;
	local array<string> Cards;
	local string Card;

	if (string(DeckName) == "")
		return;

	ItemMgr = class'X2ItemTemplateManager'.static.GetItemTemplateManager();
	CardStack = class'X2CardManager'.static.GetCardManager();
	`log("Checking deck " @ DeckName,, 'RewardDecksRefresh');

	CardStack.GetAllCardsInDeck(DeckName, Cards);

	foreach ItemMgr.IterateTemplates(DataTemplate, none)
	{
		Template = X2ItemTemplate(DataTemplate);
		if (Template != none && Template.RewardDecks.Find(DeckName) != INDEX_NONE)
		{
			if (Cards.Find(string(Template.DataName)) != INDEX_NONE)
			{
				Cards.RemoveItem(string(Template.DataName));
			}
			else
			{
				CardStack.AddCardToDeck(DeckName, string(Template.DataName));
				`log(Template.DataName @ "not found in deck, adding to deck",, 'RewardDecksRefresh');
			}
		}
	}

	foreach Cards(Card)
	{
		CardStack.RemoveCardFromDeck(DeckName, Card);
		`log(Card @ "not found in item templates, removing from deck",, 'RewardDecksRefresh');
	}
}

defaultproperties
{
	ScreenClass = class'UIAvengerHUD';
	checkedThisSession = false;
}