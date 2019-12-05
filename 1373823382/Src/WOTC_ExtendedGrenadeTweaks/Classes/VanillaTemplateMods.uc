class VanillaTemplateMods extends X2StrategyElement config(ExtendedGrenadeTweaks);

var config bool bEnableDebugLogging;
var config array<name> ExplosiveFalloffAbility_Exclusions;
var config array<name> ExplosiveFalloffAbility_Inclusions;
var config array<name> ExplosiveFalloffItem_Exclusions;

static function array<X2DataTemplate> CreateTemplates()
{
    local array<X2DataTemplate> Templates;

	Templates.AddItem(CreateSwapExplosiveDamageFalloff());

    return Templates;
}

static function X2LWTemplateModTemplate CreateSwapExplosiveDamageFalloff()
{
    local X2LWTemplateModTemplate Template;

    `CREATE_X2TEMPLATE(class'X2LWTemplateModTemplate', Template, 'SwapExplosiveDamageFalloff');

    // We need to modify grenade items and ability templates
    Template.ItemTemplateModFn = SwapExplosiveFalloffItem;
    Template.AbilityTemplateModFn = SwapExplosiveFalloffAbility;
    return Template;
}

function SwapExplosiveFalloffItem(X2ItemTemplate Template, int Difficulty)
{
	local X2GrenadeTemplate								        GrenadeTemplate;
	local X2Effect_ApplyWeaponDamage					        ThrownDamageEffect, LaunchedDamageEffect;
	local X2Effect_ApplyExplosiveEnvironmentFalloffWeaponDamage	FalloffDamageEffect;
	local X2Effect										        GrenadeEffect;

	if (Template == none)
	{
		return;
	}

	ConfigurableLog("Testing Item " $ Template.DataName);

	if (!ValidExplosiveFalloffItem(Template))
	{
		return;
	}


	GrenadeTemplate = X2GrenadeTemplate(Template);
	if(GrenadeTemplate == none)
	{
		ConfigurableLog("Item " $ Template.DataName $ " : Not Valid because it is not a grenade");
		return;
	}

	foreach GrenadeTemplate.ThrownGrenadeEffects(GrenadeEffect)
	{
		ThrownDamageEffect = X2Effect_ApplyWeaponDamage(GrenadeEffect);
		if (ThrownDamageEffect != none)
		{
			break;
		}
	}

	foreach GrenadeTemplate.LaunchedGrenadeEffects(GrenadeEffect)
	{
		LaunchedDamageEffect = X2Effect_ApplyWeaponDamage(GrenadeEffect);
		if (LaunchedDamageEffect != none)
		{
			break;
		}
	}

	if (ThrownDamageEffect != none || LaunchedDamageEffect != none)
	{
		FalloffDamageEffect = new class'X2Effect_ApplyExplosiveEnvironmentFalloffWeaponDamage' (ThrownDamageEffect);

		if (ThrownDamageEffect != none)
		{
			ConfigurableLog("Swapping ThrownGrenade DamageEffect for item " $ Template.DataName $ ", Difficulty=" $ Difficulty);
			GrenadeTemplate.ThrownGrenadeEffects.RemoveItem(ThrownDamageEffect);
			GrenadeTemplate.ThrownGrenadeEffects.AddItem(FalloffDamageEffect);
		}

		if (LaunchedDamageEffect != none)
		{
			ConfigurableLog("Swapping LaunchedGrenade DamageEffect for item " $ Template.DataName $ ", Difficulty=" $ Difficulty);
			GrenadeTemplate.LaunchedGrenadeEffects.RemoveItem(ThrownDamageEffect);
			GrenadeTemplate.LaunchedGrenadeEffects.AddItem(FalloffDamageEffect);
		}
	}
	else
	{
		ConfigurableLog("Item " $ GrenadeTemplate.DataName $ " : Not Valid because it does not have any thrown or launched grenade effects");
	}
}

function bool ValidExplosiveFalloffItem(X2ItemTemplate Template)
{
	//check for specific exclusions
	if(default.ExplosiveFalloffItem_Exclusions.Find(Template.DataName) != -1)
	{
		ConfigurableLog("Item " $ Template.DataName $ " : Explicitly Excluded");
		return false;
	}

	return true;
}

function SwapExplosiveFalloffAbility(X2AbilityTemplate Template, int Difficulty)
{
	local X2Effect_ApplyWeaponDamage					        DamageEffect;
	local X2Effect_ApplyExplosiveEnvironmentFalloffWeaponDamage	FalloffDamageEffect;
	local X2Effect										        MultiTargetEffect;

	if (Template == none)
	{
		return;
	}

	ConfigurableLog("Testing Ability " $ Template.DataName);

	foreach Template.AbilityMultiTargetEffects(MultiTargetEffect)
	{
		DamageEffect = X2Effect_ApplyWeaponDamage(MultiTargetEffect);
		if (DamageEffect != none)
		{
			break;
		}
	}
	if (DamageEffect != none && ValidExplosiveFalloffAbility(Template, DamageEffect))
	{
		FalloffDamageEffect = new class'X2Effect_ApplyExplosiveEnvironmentFalloffWeaponDamage' (DamageEffect);

		ConfigurableLog("Swapping AbilityMultiTargetEffects DamageEffect for item " $ Template.DataName);
		Template.AbilityMultiTargetEffects.RemoveItem(DamageEffect);
		Template.AbilityMultiTargetEffects.AddItem(FalloffDamageEffect);
	}
	else
	{
		ConfigurableLog("Ability " $ Template.DataName $ " : Not Valid");
	}
}

function bool ValidExplosiveFalloffAbility(X2AbilityTemplate Template, X2Effect_ApplyWeaponDamage DamageEffect)
{
	//check for specific exclusions
	if(default.ExplosiveFalloffAbility_Exclusions.Find(Template.DataName) != -1)
	{
		ConfigurableLog("Ability " $ Template.DataName $ " : Explicitly Excluded");
		return false;
	}
	//exclude any psionic ability
	if(Template.AbilitySourceName == 'eAbilitySource_Psionic')
	{
		ConfigurableLog("Ability " $ Template.DataName $ " : Excluded Because Psionic Source");
		return false;
	}
	//check for MultiTargetRadius
	if(ClassIsChildOf(Template.AbilityMultiTargetStyle.Class, class'X2AbilityMultiTarget_Radius'))
	{
		if(DamageEffect.bExplosiveDamage)
			return true;
		else
			ConfigurableLog("Ability " $ Template.DataName $ " : Not bExplosiveDamage");

		if(DamageEffect.EffectDamageValue.DamageType == 'Explosion')
			return true;
		else
			ConfigurableLog("Ability " $ Template.DataName $ " : DamageType Not Explosion");

	}
	//check for specific inclusions
	if(default.ExplosiveFalloffAbility_Inclusions.Find(Template.DataName) != -1)
	{
		return true;
	}

	ConfigurableLog("Ability " $ Template.DataName $ " : Excluded By Default");
	return false;
}

static function ConfigurableLog(string text)
{
    if(default.bEnableDebugLogging)
    {
        `LOG("[WOTC] Extended Grenade Tweaks: " $ text);
    }
}