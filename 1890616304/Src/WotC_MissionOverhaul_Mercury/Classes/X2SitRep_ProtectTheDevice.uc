class X2SitRep_ProtectTheDevice extends X2SitRepEffect;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	// Ability Granting Effects
	Templates.AddItem(CreateAddTurretEffectTemplate());

	// Pod Sizing and Force level
	Templates.AddItem(CreateForceLevelDecreaseByTwoEffectTemplate());
	Templates.AddItem(CreatePodSizeDecreaseToThreeEffectTemplate());

	//Kismet stuff
	Templates.AddItem(CreateWMO_StrongPodAllRNFChance_EasyEffectTemplate());
	Templates.AddItem(CreateWMO_StrongPodAllRNFChance_EasyEffectTemplate());
				
	return Templates;
}

static function X2SitRepEffectTemplate CreateAddTurretEffectTemplate()
{
	local X2SitRepEffect_GrantAbilities Template;

	`CREATE_X2TEMPLATE(class'X2SitRepEffect_GrantAbilities', Template, 'PtD_GiveTurret_Effect');

	Template.AbilityTemplateNames.AddItem('Interactive_PlaceTurretObject');
	Template.GrantToSoldiers = true;

	return Template;
}

static function X2SitRepEffectTemplate CreateForceLevelDecreaseByTwoEffectTemplate()
{
	local X2SitRepEffect_ModifyForceLevel Template;

	`CREATE_X2TEMPLATE(class'X2SitRepEffect_ModifyForceLevel', Template, 'ForceLevelDecreasedbyTwoEffect');

	Template.ForceLevelModification = -2;
	Template.MaxForceLevel = 9999;

	return Template;
}


static function X2SitRepEffectTemplate CreatePodSizeDecreaseToThreeEffectTemplate()
{
	local X2SitRepEffect_ModifyPodSize Template;

	`CREATE_X2TEMPLATE(class'X2SitRepEffect_ModifyPodSize', Template, 'PodSizeMaxThreeEffect');

	Template.MaxPodSize = 3;

	return Template;
}

static function X2SitRepEffectTemplate CreateWMO_StrongPodAllRNFChance_EasyEffectTemplate()
{
	local X2SitRepEffect_ModifyKismetVariable Template;

	`CREATE_X2TEMPLATE(class'X2SitRepEffect_ModifyKismetVariable', Template, 'WMO_StrongPodAllRNFChance_Easy');

	Template.VariableNames.AddItem("RNF.ChanceSpawnStrongPod");
	Template.MinValue = 10; // Min = 10%
	Template.MaxValue = 15; // Max = 15%

	return Template;
}

static function X2SitRepEffectTemplate CreateWMO_OpenPodAllRNFChance_EasyEffectTemplate()
{
	local X2SitRepEffect_ModifyKismetVariable Template;

	`CREATE_X2TEMPLATE(class'X2SitRepEffect_ModifyKismetVariable', Template, 'WMO_OpenPodRNFChance_Easy');

	Template.VariableNames.AddItem("RNF.ChanceSpawnStrongPod");
	Template.MinValue = 25; // Min = 10%
	Template.MaxValue = 33; // Max = 15%

	return Template;
}
