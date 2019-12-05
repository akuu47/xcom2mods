class X2DownloadableContentInfo_TempestCombat extends X2DownloadableContentInfo config(TempestCombat);

var config int PILLAR_AP;
var config int STUNSTRIKE_KNOCKBACK_DISTANCE;
var config int STUNSTRIKE_STUN_DURATION;
var config int STUNSTRIKE_STUN_CHANCE;

static event OnPostTemplatesCreated()
{
	UpdatePillar();
	UpdateStunStrike();
}

static function UpdatePillar()
{
	local X2AbilityTemplateManager		AbilityManager;
	local array<X2AbilityTemplate>		TemplateAllDifficulties;
	local X2AbilityTemplate				Template;

	local X2AbilityCost_ActionPoints	ActionPointCost;

	AbilityManager = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();
	AbilityManager.FindAbilityTemplateAllDifficulties('Pillar', TemplateAllDifficulties);

	foreach TemplateAllDifficulties(Template)
	{
		Template.AbilityCosts.Length = 0;

		Template.AbilityCosts.AddItem(new class'X2AbilityCost_Focus');

		ActionPointCost = new class'X2AbilityCost_ActionPoints';
		ActionPointCost.iNumPoints = default.PILLAR_AP;
		ActionPointCost.bFreeCost = true;
		ActionPointCost.AllowedTypes.AddItem('Momentum');
		Template.AbilityCosts.AddItem(ActionPointCost);
	}
}

static function UpdateStunStrike()
{
	local X2AbilityTemplateManager		AbilityManager;
	local array<X2AbilityTemplate>		TemplateAllDifficulties;
	local X2AbilityTemplate				Template;

	local X2Effect_Knockback			KnockbackEffect;
	local X2Effect_Stunned				StunnedEffect;

	AbilityManager = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();
	AbilityManager.FindAbilityTemplateAllDifficulties('StunStrike', TemplateAllDifficulties);

	foreach TemplateAllDifficulties(Template)
	{
		KnockbackEffect = new class'X2Effect_Knockback';
		KnockbackEffect.KnockbackDistance = default.STUNSTRIKE_KNOCKBACK_DISTANCE;

		StunnedEffect = class'X2StatusEffects'.static.CreateStunnedStatusEffect(default.STUNSTRIKE_STUN_DURATION, default.STUNSTRIKE_STUN_CHANCE, false);
		Template.AddTargetEffect(StunnedEffect);
	}
}


static function bool AbilityTagExpandHandler(string InString, out string OutString)
{
	local name Type;

	Type = name(InString);
	switch(Type)
	{
		case 'STUNSTRIKE_STUN_CHANCE':
			OutString = string(class'X2DownloadableContentInfo_TempestCombat'.default.STUNSTRIKE_STUN_CHANCE);
			return true;
	}
	return false;
}