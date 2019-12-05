class X2Item_MutonElite_Xcom_PersonalShield extends X2Item;


static function array<X2DataTemplate> CreateTemplates()
{
    local array<X2DataTemplate> Templates;

    Templates.AddItem(PersonalShield_Xcom());
    return Templates;
}

static function X2DataTemplate PersonalShield_Xcom()
{
	local X2EquipmentTemplate Template;
	local ArtifactCost Resources;
	local ArtifactCost Artifacts;

	`CREATE_X2TEMPLATE(class'X2EquipmentTemplate', Template, 'PersonalShield_Xcom');
	Template.ItemCat = 'defense';
	Template.InventorySlot = eInvSlot_Utility;
	Template.strImage = "img:///MutonEliteAutopsy.X2InventoryIcons.Inv_Personal_Shield";	
	Template.EquipSound = "StrategyUI_Vest_Equip";
	Template.Abilities.AddItem('PersonalShield_Xcom');
	Template.Abilities.AddItem('ShieldPasive_Xcom');
	
	Template.CanBeBuilt = true;
	Template.TradingPostValue = 12;
	Template.PointsToComplete = 0;
	Template.Tier = 2;

	Template.SetUIStatMarkup(class'XLocalizedData'.default.HealthLabel, eStat_HP, 2);

	// Requirements
	Template.Requirements.RequiredTechs.AddItem('AutopsyMutonElite');

	// Cost
	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = 125;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Artifacts.ItemTemplateName = 'CorpseMutonElite';
	Artifacts.Quantity = 2;
	Template.Cost.ArtifactCosts.AddItem(Artifacts);
	
	return Template;
}
