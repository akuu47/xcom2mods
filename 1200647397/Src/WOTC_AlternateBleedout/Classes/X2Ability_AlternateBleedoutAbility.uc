// Implements the ability that overrides the Bleedout chance:
class X2Ability_AlternateBleedoutAbility extends X2Ability;


static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;
	
	Templates.AddItem(AlternateBleedoutAbility());

	return Templates;
}


static function X2AbilityTemplate AlternateBleedoutAbility()
{
    local X2AbilityTemplate					Template;
    local X2Effect_AlternateBleedoutEffect	Effect;

    `CREATE_X2ABILITY_TEMPLATE (Template, 'AlternateBleedoutAbility');
    Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	Template.bDontDisplayInAbilitySummary = true;
	Template.bCrossClassEligible = false;
	Template.bIsPassive = true;

	Effect = new class'X2Effect_AlternateBleedoutEffect';
	Effect.BuildPersistentEffect(1, true, true, false);
    Template.AddTargetEffect(Effect);

    Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
    return Template;
}