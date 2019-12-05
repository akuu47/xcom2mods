class X2DownloadableContentInfo_ChosenWeaponryFix extends X2DownloadableContentInfo;

static event OnPostTemplatesCreated()
{
	AddDisruptorRifleCrit('ChosenRifle_CV');
	AddDisruptorRifleCrit('ChosenRifle_MG');
	AddDisruptorRifleCrit('ChosenRifle_BM');
	AddDisruptorRifleCrit('ChosenRifle_T4');
	UpdatePartingSilk();
}

static function AddDisruptorRifleCrit(name BaseTemplateName)
{
	local X2ItemTemplateManager			ItemTemplateMgr;
	local array<X2DataTemplate>			DataTemplates;
	local X2WeaponTemplate				WeaponTemplate;
	local int							i;
	
	ItemTemplateMgr = class'X2ItemTemplateManager'.static.GetItemTemplateManager();
	ItemTemplateMgr.FindDataTemplateAllDifficulties(BaseTemplateName, DataTemplates);
	
	for (i = 0; i < DataTemplates.Length; ++i)
	{
		WeaponTemplate = X2WeaponTemplate(DataTemplates[i]);
		if (WeaponTemplate != none)
		{
			WeaponTemplate.Abilities.AddItem('DisruptorRifleCrit');
		}
	}
}

static function UpdatePartingSilk()
{
	local X2AbilityTemplateManager		AbilityManager;
	local array<X2AbilityTemplate>		TemplateAllDifficulties;
	local X2AbilityTemplate				Template;

	local X2Condition_UnitProperty		UnitPropertyCondition;
	local X2Condition_Visibility		MeleeVisibilityCondition;

	AbilityManager = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();
	AbilityManager.FindAbilityTemplateAllDifficulties('PartingSilk', TemplateAllDifficulties);

	foreach TemplateAllDifficulties(Template)
	{
		Template.AbilityTargetConditions.Length = 0;

		UnitPropertyCondition = new class'X2Condition_UnitProperty';
		UnitPropertyCondition.ExcludeTurret = false;
		UnitPropertyCondition.ExcludeRobotic = false;
		UnitPropertyCondition.ExcludeAlien = false;
		UnitPropertyCondition.ExcludeFriendlyToSource = true;
		UnitPropertyCondition.FailOnNonUnits = true;
		UnitPropertyCondition.RequireUnitSelectedFromHQ = false;
		Template.AbilityTargetConditions.AddItem(UnitPropertyCondition);

		MeleeVisibilityCondition = new class'X2Condition_Visibility';
		MeleeVisibilityCondition.bRequireGameplayVisible = true;
		Template.AbilityTargetConditions.AddItem(MeleeVisibilityCondition);
	}
}