class X2Item_LostResources  extends X2Item_XpackResources;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Resources;

	Resources.AddItem(CreateCorpseTheLost());
	Resources.AddItem(CreateVintagePoster001());
	Resources.AddItem(CreateVintagePoster002());
	Resources.AddItem(CreateVintagePoster003());
	Resources.AddItem(CreateVintagePoster004());
	Resources.AddItem(CreateVintagePoster005());
	Resources.AddItem(CreateVintagePoster006());
	Resources.AddItem(CreateVintagePoster007());
	Resources.AddItem(CreateVintagePoster008());
	Resources.AddItem(CreateVintagePoster009());
	Resources.AddItem(CreateVintagePoster010());
	Resources.AddItem(CreateVintagePoster011());
	Resources.AddItem(CreateVintagePoster012());
	Resources.AddItem(CreateVintagePoster013());
	Resources.AddItem(CreateVintagePoster014());
	Resources.AddItem(CreateVintagePoster015());
	Resources.AddItem(CreateGamePosterCrumbledDirty());
	Resources.AddItem(CreateGamePosterPristine());

	return Resources;
}

static function X2DataTemplate CreateCorpseTheLost()
{
	local X2ItemTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ItemTemplate', Template, 'CorpseTheLost');

	Template.strImage = "img:///UILibrary_XPACK_StrategyImages.Corpse_Lost";
	Template.ItemCat = 'resource';
	Template.TradingPostValue = 1;
	Template.MaxQuantity = 1;
	Template.LeavesExplosiveRemains = true;

	return Template;
}

static function X2DataTemplate CreateVintagePoster001()
{
	local X2ItemTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ItemTemplate', Template, 'VintagePoster001');

	Template.strImage = "img:///CX_Extra_Lost_UIFlair.VintagePosters.VintagePoster001";
	Template.ItemCat = 'resource';
	Template.TradingPostValue = 1;
	Template.MaxQuantity = 1;

	return Template;
}

static function X2DataTemplate CreateVintagePoster002()
{
	local X2ItemTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ItemTemplate', Template, 'VintagePoster002');

	Template.strImage = "img:///CX_Extra_Lost_UIFlair.VintagePosters.VintagePoster002";
	Template.ItemCat = 'resource';
	Template.TradingPostValue = 1;
	Template.MaxQuantity = 1;

	return Template;
}

static function X2DataTemplate CreateVintagePoster003()
{
	local X2ItemTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ItemTemplate', Template, 'VintagePoster003');

	Template.strImage = "img:///CX_Extra_Lost_UIFlair.VintagePosters.VintagePoster003";
	Template.ItemCat = 'resource';
	Template.TradingPostValue = 1;
	Template.MaxQuantity = 1;

	return Template;
}

static function X2DataTemplate CreateVintagePoster004()
{
	local X2ItemTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ItemTemplate', Template, 'VintagePoster004');

	Template.strImage = "img:///CX_Extra_Lost_UIFlair.VintagePosters.VintagePoster004";
	Template.ItemCat = 'resource';
	Template.TradingPostValue = 1;
	Template.MaxQuantity = 1;

	return Template;
}

static function X2DataTemplate CreateVintagePoster005()
{
	local X2ItemTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ItemTemplate', Template, 'VintagePoster005');

	Template.strImage = "img:///CX_Extra_Lost_UIFlair.VintagePosters.VintagePoster005";
	Template.ItemCat = 'resource';
	Template.TradingPostValue = 1;
	Template.MaxQuantity = 1;

	return Template;
}

static function X2DataTemplate CreateVintagePoster006()
{
	local X2ItemTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ItemTemplate', Template, 'VintagePoster006');

	Template.strImage = "img:///CX_Extra_Lost_UIFlair.VintagePosters.VintagePoster006";
	Template.ItemCat = 'resource';
	Template.TradingPostValue = 1;
	Template.MaxQuantity = 1;

	return Template;
}

static function X2DataTemplate CreateVintagePoster007()
{
	local X2ItemTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ItemTemplate', Template, 'VintagePoster007');

	Template.strImage = "img:///CX_Extra_Lost_UIFlair.VintagePosters.VintagePoster007";
	Template.ItemCat = 'resource';
	Template.TradingPostValue = 1;
	Template.MaxQuantity = 1;

	return Template;
}

static function X2DataTemplate CreateVintagePoster008()
{
	local X2ItemTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ItemTemplate', Template, 'VintagePoster008');

	Template.strImage = "img:///CX_Extra_Lost_UIFlair.VintagePosters.VintagePoster008";
	Template.ItemCat = 'resource';
	Template.TradingPostValue = 1;
	Template.MaxQuantity = 1;

	return Template;
}

static function X2DataTemplate CreateVintagePoster009()
{
	local X2ItemTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ItemTemplate', Template, 'VintagePoster009');

	Template.strImage = "img:///CX_Extra_Lost_UIFlair.VintagePosters.VintagePoster009";
	Template.ItemCat = 'resource';
	Template.TradingPostValue = 1;
	Template.MaxQuantity = 1;

	return Template;
}

static function X2DataTemplate CreateVintagePoster010()
{
	local X2ItemTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ItemTemplate', Template, 'VintagePoster010');

	Template.strImage = "img:///CX_Extra_Lost_UIFlair.VintagePosters.VintagePoster010";
	Template.ItemCat = 'resource';
	Template.TradingPostValue = 1;
	Template.MaxQuantity = 1;

	return Template;
}

static function X2DataTemplate CreateVintagePoster011()
{
	local X2ItemTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ItemTemplate', Template, 'VintagePoster011');

	Template.strImage = "img:///CX_Extra_Lost_UIFlair.VintagePosters.VintagePoster011";
	Template.ItemCat = 'resource';
	Template.TradingPostValue = 1;
	Template.MaxQuantity = 1;

	return Template;
}

static function X2DataTemplate CreateVintagePoster012()
{
	local X2ItemTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ItemTemplate', Template, 'VintagePoster012');

	Template.strImage = "img:///CX_Extra_Lost_UIFlair.VintagePosters.VintagePoster012";
	Template.ItemCat = 'resource';
	Template.TradingPostValue = 1;
	Template.MaxQuantity = 1;

	return Template;
}

static function X2DataTemplate CreateVintagePoster013()
{
	local X2ItemTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ItemTemplate', Template, 'VintagePoster013');

	Template.strImage = "img:///CX_Extra_Lost_UIFlair.VintagePosters.VintagePoster013";
	Template.ItemCat = 'resource';
	Template.TradingPostValue = 1;
	Template.MaxQuantity = 1;

	return Template;
}

static function X2DataTemplate CreateVintagePoster014()
{
	local X2ItemTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ItemTemplate', Template, 'VintagePoster014');

	Template.strImage = "img:///CX_Extra_Lost_UIFlair.VintagePosters.VintagePoster014";
	Template.ItemCat = 'resource';
	Template.TradingPostValue = 1;
	Template.MaxQuantity = 1;

	return Template;
}

static function X2DataTemplate CreateVintagePoster015()
{
	local X2ItemTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ItemTemplate', Template, 'VintagePoster015');

	Template.strImage = "img:///CX_Extra_Lost_UIFlair.VintagePosters.VintagePoster015";
	Template.ItemCat = 'resource';
	Template.TradingPostValue = 1;
	Template.MaxQuantity = 1;

	return Template;
}

static function X2DataTemplate CreateGamePosterCrumbledDirty()
{
	local X2ItemTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ItemTemplate', Template, 'GamePosterCrumbledDirty');

	Template.strImage = "img:///CX_Extra_Lost_Sport.GamePosters.GamePoster_CrumbledDirty";
	Template.ItemCat = 'resource';
	Template.TradingPostValue = 5;
	Template.MaxQuantity = 1;

	return Template;
}

static function X2DataTemplate CreateGamePosterPristine()
{
	local X2ItemTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ItemTemplate', Template, 'GamePosterPristine');

	Template.strImage = "img:///CX_Extra_Lost_Sport.GamePosters.GamePoster_Prestine";
	Template.ItemCat = 'resource';
	Template.TradingPostValue = 15;
	Template.MaxQuantity = 1;

	return Template;
}