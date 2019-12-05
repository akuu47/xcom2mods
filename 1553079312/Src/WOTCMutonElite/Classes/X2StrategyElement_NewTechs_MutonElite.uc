class X2StrategyElement_NewTechs_MutonElite extends X2StrategyElement config(GameData);


static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Techs;

	Techs.AddItem(CreateAutopsyMutonEliteTemplate());

	return Techs;
}

static function X2DataTemplate CreateAutopsyMutonEliteTemplate()
{
	local X2TechTemplate Template;
	local ArtifactCost Artifacts;

	`CREATE_X2TEMPLATE(class'X2TechTemplate', Template, 'AutopsyMutonElite');
	Template.bAutopsy = true;
	Template.PointsToComplete = 4200;
	Template.SortingTier = 2;
	Template.bCheckForceInstant = true;

	Template.TechStartedNarrative = "LWNarrativeMoments_Bink.Strategy.Autopsy_MutonM3_LW";

	Template.strImage = "img:///MutonEliteAutopsy.IC_AutopsyMutonElite"; 

	Template.Requirements.RequiredTechs.AddItem('AutopsyMuton');
	
	// Instant Requirements. Will become the Cost if the tech is forced to Instant.
	Artifacts.ItemTemplateName = 'CorpseMutonElite';
	Artifacts.Quantity = 10;
	Template.InstantRequirements.RequiredItemQuantities.AddItem(Artifacts);

	// Cost
	Artifacts.ItemTemplateName = 'CorpseMutonElite';
	Artifacts.Quantity = 1;
	Template.Cost.ArtifactCosts.AddItem(Artifacts);

	return Template;
}