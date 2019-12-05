class X2EnemyForcesFixedList extends X2ChallengeEnemyForces config(EncounterLists) perobjectconfig;

var config name LeaderEncounterName;
var config name FollowerEncounterName;
var config bool DisableBosses;

function DefaultSelector( X2ChallengeEnemyForces Selector, XComGameState_MissionSite MissionSite, XComGameState_BattleData BattleData, XComGameState StartState )
{
	local XComGameState_ChallengeData ChallengeData;

	foreach StartState.IterateByClassType( class'XComGameState_ChallengeData', ChallengeData )
	{
		break;
	}

	if (ChallengeData != none) // we're in PerRunner mode. Use regular enemies.
	{
		ChallengeData.DefaultLeaderListOverride = LeaderEncounterName;
		ChallengeData.DefaultFollowerListOverride = FollowerEncounterName;
	}
	else
	{
		BattleData.DefaultLeaderListOverride = LeaderEncounterName;
		BattleData.DefaultFollowerListOverride = FollowerEncounterName;
	}
}

static function X2EnemyForcesFixedList CreateEnemyForce(name EnemyForceName)
{
	local X2EnemyForcesFixedList Template;

	`CREATE_X2TEMPLATE(class'X2EnemyForcesFixedList', Template, EnemyForceName);

	Template.Weight = 1;
	Template.SelectEnemyForcesFn = Template.DefaultSelector;
	if (Template.DisableBosses)
	{
		Template.AdditionalTacticalGameplayTags.AddItem('DisableBossEncounters');
	}

	return Template;
}
