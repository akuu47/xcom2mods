class X2DownloadableContentInfo_StandardMelee extends X2DownloadableContentInfo config(StandardMelee);

var config bool MELEE_WHILE_DISORIENTED;
var config bool MELEE_WHILE_BURNING;
var config array<name> STANDARD_MELEE_ABILITIES;
var config array<name> STANDARD_MELEE_EXCLUSIONS;

static function OnPostTemplatesCreated()
{
	local X2AbilityTemplateManager			AbilityManager;
	local X2DataTemplate					Template;
	local X2AbilityTemplate					AbilityTemplate;
	local bool								Excluded;
	local name								AbilityName;

	local X2Condition_UnitProperty			UnitPropertyCondition;
	local array<name>						SkipExclusions;

	AbilityManager = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();

	foreach AbilityManager.IterateTemplates(Template)
	{
		AbilityTemplate = X2AbilityTemplate(Template);
		Excluded = false;

		foreach default.STANDARD_MELEE_EXCLUSIONS(AbilityName)
		{
			if (AbilityTemplate.DataName == AbilityName)
			{
				`log("StandardMelee has excluded"@AbilityTemplate.DataName);
				Excluded = true;
			}
		}

		if (AbilityTemplate.isMelee() && !Excluded)
		{
			AbilityTemplate.AbilityShooterConditions.Length = 0;

			UnitPropertyCondition = new class'X2Condition_UnitProperty';
			UnitPropertyCondition.ExcludeDead = true;
			AbilityTemplate.AbilityShooterConditions.AddItem(UnitPropertyCondition);
			
			if (default.MELEE_WHILE_DISORIENTED)
			{
				SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
			}
			if (default.MELEE_WHILE_BURNING)
			{
				SkipExclusions.AddItem(class'X2StatusEffects'.default.BurningName);
			}
			AbilityTemplate.AddShooterEffectExclusions(SkipExclusions);

			`log("StandardMelee has modified"@AbilityTemplate.DataName);
		}
	}

	foreach default.STANDARD_MELEE_ABILITIES(AbilityName)
	{
		AbilityTemplate = AbilityManager.FindAbilityTemplate(AbilityName);

		if (AbilityTemplate != none)
		{
			AbilityTemplate.AbilityShooterConditions.Length = 0;

			UnitPropertyCondition = new class'X2Condition_UnitProperty';
			UnitPropertyCondition.ExcludeDead = true;
			AbilityTemplate.AbilityShooterConditions.AddItem(UnitPropertyCondition);
			
			if (default.MELEE_WHILE_DISORIENTED)
			{
				SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
			}
			if (default.MELEE_WHILE_BURNING)
			{
				SkipExclusions.AddItem(class'X2StatusEffects'.default.BurningName);
			}
			AbilityTemplate.AddShooterEffectExclusions(SkipExclusions);

			`log("StandardMelee has modified"@AbilityTemplate.DataName);
		}
	}
}