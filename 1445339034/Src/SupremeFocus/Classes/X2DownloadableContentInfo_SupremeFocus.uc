class X2DownloadableContentInfo_SupremeFocus extends X2DownloadableContentInfo config(SupremeFocus);

var config int SCORCH_DISORIENT_PERCENT_CHANCE;

static event OnPostTemplatesCreated()
{
	local X2AbilityTemplateManager			AbilityManager;
	local array<X2AbilityTemplate>			TemplateAllDifficulties;
	local X2AbilityTemplate					Template;

	local X2Condition_AbilityProperty		AbilityCondition;
	local X2Effect_PersistentStatChange		DisorientedEffect;

	AbilityManager = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();
	AbilityManager.FindAbilityTemplateAllDifficulties('Volt', TemplateAllDifficulties);

	foreach TemplateAllDifficulties(Template)
	{
		AbilityCondition = new class'X2Condition_AbilityProperty';
		AbilityCondition.OwnerHasSoldierAbilities.AddItem('Scorch');
		DisorientedEffect = class'X2StatusEffects'.static.CreateDisorientedStatusEffect(, , false);
		DisorientedEffect.ApplyChance = default.SCORCH_DISORIENT_PERCENT_CHANCE;
		DisorientedEffect.TargetConditions.AddItem(AbilityCondition);
		Template.AddTargetEffect(DisorientedEffect);
		Template.AddMultiTargetEffect(DisorientedEffect);
	}
}

static function bool AbilityTagExpandHandler(string InString, out string OutString)
{
	local name Type;

	Type = name(InString);
	switch(Type)
	{
		case 'FOCUS4MOBILITY':
			OutString = string(class'X2Ability_TemplarAbilitySet_SupremeFocus'.default.FOCUS4MOBILITY);
			return true;
		case 'FOCUS4DODGE':
			OutString = string(class'X2Ability_TemplarAbilitySet_SupremeFocus'.default.FOCUS4DODGE);
			return true;
		case 'FOCUS4RENDDAMAGE':
			OutString = string(class'X2Ability_TemplarAbilitySet_SupremeFocus'.default.FOCUS4RENDDAMAGE);
			return true;
		case 'FOCUS5MOBILITY':
			OutString = string(class'X2Ability_TemplarAbilitySet_SupremeFocus'.default.FOCUS5MOBILITY);
			return true;
		case 'FOCUS5DODGE':
			OutString = string(class'X2Ability_TemplarAbilitySet_SupremeFocus'.default.FOCUS5DODGE);
			return true;
		case 'FOCUS5RENDDAMAGE':
			OutString = string(class'X2Ability_TemplarAbilitySet_SupremeFocus'.default.FOCUS5RENDDAMAGE);
			return true;
		case 'FOCUS6MOBILITY':
			OutString = string(class'X2Ability_TemplarAbilitySet_SupremeFocus'.default.FOCUS6MOBILITY);
			return true;
		case 'FOCUS6DODGE':
			OutString = string(class'X2Ability_TemplarAbilitySet_SupremeFocus'.default.FOCUS6DODGE);
			return true;
		case 'FOCUS6RENDDAMAGE':
			OutString = string(class'X2Ability_TemplarAbilitySet_SupremeFocus'.default.FOCUS6RENDDAMAGE);
			return true;
		case 'FOCUS7MOBILITY':
			OutString = string(class'X2Ability_TemplarAbilitySet_SupremeFocus'.default.FOCUS7MOBILITY);
			return true;
		case 'FOCUS7DODGE':
			OutString = string(class'X2Ability_TemplarAbilitySet_SupremeFocus'.default.FOCUS7DODGE);
			return true;
		case 'FOCUS7RENDDAMAGE':
			OutString = string(class'X2Ability_TemplarAbilitySet_SupremeFocus'.default.FOCUS7RENDDAMAGE);
			return true;
		case 'FOCUS8MOBILITY':
			OutString = string(class'X2Ability_TemplarAbilitySet_SupremeFocus'.default.FOCUS8MOBILITY);
			return true;
		case 'FOCUS8DODGE':
			OutString = string(class'X2Ability_TemplarAbilitySet_SupremeFocus'.default.FOCUS8DODGE);
			return true;
		case 'FOCUS8RENDDAMAGE':
			OutString = string(class'X2Ability_TemplarAbilitySet_SupremeFocus'.default.FOCUS8RENDDAMAGE);
			return true;
		case 'FOCUS9MOBILITY':
			OutString = string(class'X2Ability_TemplarAbilitySet_SupremeFocus'.default.FOCUS9MOBILITY);
			return true;
		case 'FOCUS9DODGE':
			OutString = string(class'X2Ability_TemplarAbilitySet_SupremeFocus'.default.FOCUS9DODGE);
			return true;
		case 'FOCUS9RENDDAMAGE':
			OutString = string(class'X2Ability_TemplarAbilitySet_SupremeFocus'.default.FOCUS9RENDDAMAGE);
			return true;
		case 'FOCUS10MOBILITY':
			OutString = string(class'X2Ability_TemplarAbilitySet_SupremeFocus'.default.FOCUS10MOBILITY);
			return true;
		case 'FOCUS10DODGE':
			OutString = string(class'X2Ability_TemplarAbilitySet_SupremeFocus'.default.FOCUS10DODGE);
			return true;
		case 'FOCUS10RENDDAMAGE':
			OutString = string(class'X2Ability_TemplarAbilitySet_SupremeFocus'.default.FOCUS10RENDDAMAGE);
			return true;
		case 'SCORCH_DISORIENT_PERCENT_CHANCE':
			OutString = string(class'X2DownloadableContentInfo_SupremeFocus'.default.SCORCH_DISORIENT_PERCENT_CHANCE);
			return true;
	}
	return false;
}