class TemplateEdits_Items extends X2DownloadableContentInfo config(GameData_SoldierSkills);

static event OnPostTemplatesCreated()
{
	local X2ItemTemplateManager				ItemTemplateManager;
	local array<X2DataTemplate>				TemplateAllDifficulties;
	local X2DataTemplate					DiffTemplate;
	local X2ItemTemplate					Template;
	local X2GrenadeTemplate					GrenadeTemplate;
	local ArtifactCost						Resources;

	local X2Effect_SmokeGrenade_Regen		SmokeEffect;

	ItemTemplateManager = class'X2ItemTemplateManager'.static.GetItemTemplateManager();
	ItemTemplateManager.FindDataTemplateAllDifficulties('SmokeGrenade', TemplateAllDifficulties);
	foreach TemplateAllDifficulties(DiffTemplate)
	{
		GrenadeTemplate = X2GrenadeTemplate(DiffTemplate);

		SmokeEffect = new class'X2Effect_SmokeGrenade_Regen';
		SmokeEffect.BuildPersistentEffect(class'X2Effect_ApplySmokeGrenadeToWorld'.default.Duration + 1, false, false, false, eGameRule_PlayerTurnBegin);
		SmokeEffect.DuplicateResponse = eDupe_Refresh;

		GrenadeTemplate.ThrownGrenadeEffects.AddItem(SmokeEffect);
		GrenadeTemplate.LaunchedGrenadeEffects = GrenadeTemplate.ThrownGrenadeEffects;
	}

	ItemTemplateManager.FindDataTemplateAllDifficulties('SmokeGrenadeMk2', TemplateAllDifficulties);
	foreach TemplateAllDifficulties(DiffTemplate)
	{
		GrenadeTemplate = X2GrenadeTemplate(DiffTemplate);

		SmokeEffect = new class'X2Effect_SmokeGrenade_Regen';
		SmokeEffect.BuildPersistentEffect(class'X2Effect_ApplySmokeGrenadeToWorld'.default.Duration + 1, false, false, false, eGameRule_PlayerTurnBegin);
		SmokeEffect.DuplicateResponse = eDupe_Refresh;

		GrenadeTemplate.ThrownGrenadeEffects.AddItem(SmokeEffect);
		GrenadeTemplate.LaunchedGrenadeEffects = GrenadeTemplate.ThrownGrenadeEffects;
	}

	ItemTemplateManager.FindDataTemplateAllDifficulties('HazmatVest', TemplateAllDifficulties);
	foreach TemplateAllDifficulties(DiffTemplate)
	{
		Template = X2ItemTemplate(DiffTemplate);

		Template.CanBeBuilt = true;

		Template.Requirements.RequiredTechs.AddItem('AutopsyAdventPurifier');
		Template.Requirements.RequiredTechs.AddItem('AutopsyViper');
		Template.Requirements.RequiredTechs.AddItem('AutopsyAdventShieldbearer');

		// Cost
		Resources.ItemTemplateName = 'NanofiberVest';
		Resources.Quantity = 1;
		Template.Cost.ResourceCosts.AddItem(Resources);

		Resources.ItemTemplateName = 'Supplies';
		Resources.Quantity = 25;
		Template.Cost.ResourceCosts.AddItem(Resources);

		Resources.ItemTemplateName = 'AlienAlloy';
		Resources.Quantity = 5;
		Template.Cost.ResourceCosts.AddItem(Resources);
	}

	ItemTemplateManager.FindDataTemplateAllDifficulties('PlatedVest', TemplateAllDifficulties);
	foreach TemplateAllDifficulties(DiffTemplate)
	{
		Template = X2ItemTemplate(DiffTemplate);
		Template.CanBeBuilt = true;

		Template.Requirements.RequiredTechs.AddItem('AutopsyAdventShieldbearer');

		// Cost
		Resources.ItemTemplateName = 'NanofiberVest';
		Resources.Quantity = 2;
		Template.Cost.ResourceCosts.AddItem(Resources);

		Resources.ItemTemplateName = 'AlienAlloy';
		Resources.Quantity = 5;
		Template.Cost.ResourceCosts.AddItem(Resources);
	}

	ItemTemplateManager.FindDataTemplateAllDifficulties('StasisVest', TemplateAllDifficulties);
	foreach TemplateAllDifficulties(DiffTemplate)
	{
		Template = X2ItemTemplate(DiffTemplate);
		Template.CanBeBuilt = true;

		Template.Requirements.RequiredTechs.AddItem('AutopsyAdventShieldbearer');
		Template.Requirements.RequiredTechs.AddItem('AutopsyAdventPriest');

		// Cost
		Resources.ItemTemplateName = 'NanofiberVest';
		Resources.Quantity = 1;
		Template.Cost.ResourceCosts.AddItem(Resources);

		Resources.ItemTemplateName = 'Elerium';
		Resources.Quantity = 5;
		Template.Cost.ResourceCosts.AddItem(Resources);
	}


}
					