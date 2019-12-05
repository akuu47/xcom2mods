//CORPSES

class X2Item_MutonEliteLoot extends X2Item;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Resources;

	Resources.AddItem(CreateCorpseMutonElite());

	return Resources;
}

static function X2DataTemplate CreateCorpseMutonElite()
{
	local X2ItemTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ItemTemplate', Template, 'CorpseMutonElite');

	//Template.strImage = "img:///UILibrary_StrategyImages.CorpseIcons.Corpse_Muton";
	Template.strImage = "img:///MutonEliteAutopsy.LW_Corpse_Bluton"; 	
	Template.ItemCat = 'resource';
	Template.TradingPostValue = 15;
	Template.MaxQuantity = 1;
	Template.LeavesExplosiveRemains = true;

	return Template;
}