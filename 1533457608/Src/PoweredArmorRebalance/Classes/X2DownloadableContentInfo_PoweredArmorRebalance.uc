class X2DownloadableContentInfo_PoweredArmorRebalance extends X2DownloadableContentInfo config(PoweredArmorRebalance);

var config int SHIELDWALL_COOLDOWN;
var config int SHIELDWALL_DURATION;
var config int SHIELDWALL_HP;

static event OnPostTemplatesCreated()
{
	local X2AbilityTemplateManager		AbilityManager;
	local array<X2AbilityTemplate>		TemplateAllDifficulties;
	local X2AbilityTemplate				Template;

	local X2AbilityCooldown				Cooldown;
	local X2Effect_EnergyShield			ShieldEffect;

	AbilityManager = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();
	AbilityManager.FindAbilityTemplateAllDifficulties('HighCoverGenerator', TemplateAllDifficulties);

	foreach TemplateAllDifficulties(Template)
	{
		Cooldown = new class'X2AbilityCooldown';
		Cooldown.iNumTurns = default.SHIELDWALL_COOLDOWN;
		Template.AbilityCooldown = Cooldown;

		ShieldEffect = new class'X2Effect_EnergyShield';
		ShieldEffect.BuildPersistentEffect(default.SHIELDWALL_DURATION, false, true, false, eGameRule_PlayerTurnBegin);
		ShieldEffect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, false, , Template.AbilitySourceName);
		ShieldEffect.AddPersistentStatChange(eStat_ShieldHP, default.SHIELDWALL_HP);
		ShieldEffect.EffectName='Shieldwall';
		Template.AddShooterEffect(ShieldEffect);
	}
}

static function bool AbilityTagExpandHandler(string InString, out string OutString)
{
	local name Type;

	Type = name(InString);
	switch(Type)
	{
		case 'SHIELDWALL_HP':
			OutString = string(class'X2DownloadableContentInfo_PoweredArmorRebalance'.default.SHIELDWALL_HP);
			return true;
	}
	return false;
}