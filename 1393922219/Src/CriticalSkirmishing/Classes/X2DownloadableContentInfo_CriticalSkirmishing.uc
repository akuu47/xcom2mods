class X2DownloadableContentInfo_CriticalSkirmishing extends X2DownloadableContentInfo config(CriticalSkirmishing);

var config int WHIPLASH_CRIT_BONUS;

static event OnPostTemplatesCreated()
{
	local X2AbilityTemplateManager			AbilityManager;
	local array<X2AbilityTemplate>			TemplateAllDifficulties;
	local X2AbilityTemplate					Template;

	local X2AbilityToHitCalc_StandardAim    StandardAim;

	AbilityManager = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();
	AbilityManager.FindAbilityTemplateAllDifficulties('Whiplash', TemplateAllDifficulties);

	foreach TemplateAllDifficulties(Template)
	{
		StandardAim = new class'X2AbilityToHitCalc_StandardAim';
		StandardAim.BuiltInCritMod = default.WHIPLASH_CRIT_BONUS;
		Template.AbilityToHitCalc = StandardAim;
	}
}