class X2DownloadableContentInfo_ConsistentElectricalDamage extends X2DownloadableContentInfo config(ConsistentElectricalDamage);

var config bool BUFF_LIGHTNING_FIELD;

static event OnPostTemplatesCreated()
{
	local X2AbilityTemplateManager		AbilityManager;
	local array<X2AbilityTemplate>		TemplateAllDifficulties;
	local X2AbilityTemplate				Template;

	local X2Condition_UnitProperty		UnitProperty;

	AbilityManager = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();
	AbilityManager.FindAbilityTemplateAllDifficulties('SectopodLightningField', TemplateAllDifficulties);

	foreach TemplateAllDifficulties(Template)
	{
		if (default.BUFF_LIGHTNING_FIELD)
		{
			Template.AbilityMultiTargetConditions.Length = 0;

			UnitProperty = new class'X2Condition_UnitProperty';
			UnitProperty.ExcludeFriendlyToSource = false;
			UnitProperty.ExcludeDead = true;
			Template.AbilityMultiTargetConditions.AddItem(UnitProperty);
		}
	}
}