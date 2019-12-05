class X2Ability_SuppressionPlus extends X2Ability config(Suppression);

var localized string m_opportunist;

var config bool DISABLE_FLANK_CRIT;
var config bool IGNOREVIS;
var config bool REACTION_PENALTY;
var config bool ALLOW_SUPPRESSION_CRIT;

var config array<name> SuppressionAbility;
var config array<name> SuppressionShotAbility;

static function PatchSuppressionNoFlank(optional name TemplateName='Suppression')
{
	local X2AbilityTemplate                 Template;	
	local X2Effect_SetUnitValue				SetConcealed;
	local X2Effect_Persistent				OpportunistEffect;

	Template = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager().FindAbilityTemplate(TemplateName);
	
	Template.AdditionalAbilities.AddItem('SuppressionFlankPenalty');

	if (!default.REACTION_PENALTY && class'XComModOptions'.default.ActiveMods.Find("EUAimRollsWOTC") == INDEX_NONE)
	{
		SetConcealed = new class'X2Effect_SetUnitValue';
		SetConcealed.UnitName = class'X2Ability_DefaultAbilitySet'.default.ConcealedOverwatchTurn;
		SetConcealed.CleanupType = eCleanup_BeginTurn;
		SetConcealed.NewValueToSet = 1;
		Template.AddShooterEffect(SetConcealed);
	}
	else
	{
		OpportunistEffect = new class'X2Effect_Persistent';
		OpportunistEffect.BuildPersistentEffect(1, false, true, false, eGameRule_PlayerTurnBegin);
		OpportunistEffect.EffectName = 'SuppressionOpportunist';
		OpportunistEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.LocLongDescription, Template.IconImage, false,,Template.AbilitySourceName);
		Template.AddShooterEffect(OpportunistEffect);
	}
}

static function PatchSuppressionPlusShot(optional name TemplateName='SuppressionShot')
{
	local X2AbilityTemplate                 Template;
	local X2Condition_Visibility			VisCond;
	local int i;

	Template = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager().FindAbilityTemplate(TemplateName);

	if (default.IGNOREVIS)
	{
		for (i = 0; i < Template.AbilityTargetConditions.Length; i ++)
		{
			VisCond = X2Condition_Visibility(Template.AbilityTargetConditions[i]);
			if (VisCond != none)
			{
				Template.AbilityTargetConditions.Remove(i, 1);
				i--;
			}
		}
	}
}