class X2EnemyForces_IterConfig extends X2ChallengeElement config(EncounterLists);

var config array<name> AdditionalEncounters;

static function array<X2DataTemplate> CreateTemplates( )
{
	local array<X2DataTemplate> Templates;
	local name TemplateName;

	foreach default.AdditionalEncounters(TemplateName)
	{
		Templates.AddItem( class'X2EnemyForcesFixedList'.static.CreateEnemyForce(TemplateName) );
	}

	return Templates;
}