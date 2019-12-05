class CAEventListener_StrategyListener extends X2EventListener;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	Templates.AddItem(CreateListenerTemplate());

	return Templates;
}

static function CAEventListenerTemplate CreateListenerTemplate()
{
	local CAEventListenerTemplate Template;

	`CREATE_X2TEMPLATE(class'WotC_Armory_GripFix_BattleRifles.CAEventListenerTemplate', Template, 'WotC_Armory_GripFix_BattleRiflesDummy');
	Template.RegisterInTactical = true;

	`log("Register Event WotC_Armory_GripFix_BattleRiflesDummy", class'X2DownloadableContentInfo_WotC_Armory_GripFix_BTR'.default.bLog, name("WotC_Armory_GripFix_BattleRifles" @ default.Class.name));

	return Template;
}
