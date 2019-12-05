class X2Ability_RedFogAbilities extends XMBAbility config(RedFog);

var config array<eCharStatType> StatList;
var config array<name> FriendlyName;
var config array<float> LightEffect;
var config array<float> ModerateEffect;
var config array<float> SevereEffect;
var config int LightBreakpoint;
var config int ModerateBreakpoint;
var config int SevereBreakpoint;
var config int NumBreakPoints;
var config array<bool> bPercentage;

//Get the breakpoints min for each range
//With BreakPoints[0] being 0.99 and being the first in the array
static function array<float> GetBreakPoints()
{
	local array<float> BreakPoints;
	local float BreakPoint, x;
	local int i;

	//Need to add plus 1 to the array for the minimum at 0
	for (i=0;i<default.NumBreakPoints+1;i++)
	{
		x = i;
		Breakpoint = 99 - x / default.NumBreakPoints * 99;
		BreakPoints.InsertItem(i,Breakpoint); 
		//`log("Inserted Breakpoint No.: "$i$" Value: "$Breakpoint,,'ComplicatedRedFog');
	}
	return BreakPoints;
}

//For multiplicative aka percentage red fog, Calculates the stat effect for the breakpoint specified for each stat type that uses percentage
//Looks up the severe effect from the config
static function float GetStatMultiplicativeEffect(int StatIdx, float BreakpointNo)
{
	local float StatEffect;

	StatEffect = 1 - ((BreakpointNo+1) * (1 - default.SevereEffect[StatIdx]) / default.NumBreakPoints);

	//`log("Inserted Stat Effect for "$BreakpointNo$" "$ default.FriendlyName[StatIdx] $ " Value: "$StatEffect,,'ComplicatedRedFog');

	return StatEffect;
}

//For addition red fog, Calculates the stat effect for the breakpoint specified  for each stat type that uses addition
//Looks up the severe effect from the config
static function float GetStatAdditionEffect(int StatIdx, float BreakpointNo)
{
	local float StatEffect;

	StatEffect = Round((BreakpointNo+1) / default.NumBreakPoints * default.SevereEffect[StatIdx]);

	//`log("Inserted Stat Effect for "$BreakpointNo$" "$ default.FriendlyName[StatIdx] $ " Value: "$StatEffect,,'ComplicatedRedFog');

	return StatEffect;
}

//create the passive red fog abilities
Static Function array<X2AbilityTemplate> CreateRedFog()
{
	local array<float> BreakPoints;
	local array<X2AbilityTemplate> RedFog;
	local XMBEffect_ConditionalStatChange Effect;
	local X2Condition_UnitStatCheck Condition;
	local int idx, i;

	BreakPoints = GetBreakPoints();

	for (i=0;i<default.NumBreakPoints;i++)
	{
		Condition = new class'X2Condition_UnitStatCheck';
		Condition.AddCheckStat(eStat_HP, BreakPoints[i], eCheck_LessThanOrEqual,,, true);
		Condition.AddCheckStat(eStat_HP, BreakPoints[i+1], eCheck_GreaterThan,,, true);

		Effect = new class'XMBEffect_ConditionalStatChange';
		for(idx=0;idx<default.StatList.Length;idx++)
		{
			if(!default.bPercentage[idx])
				Effect.AddPersistentStatChange(default.StatList[idx], GetStatAdditionEffect(Idx, i));
			else
				Effect.AddPersistentStatChange(default.StatList[idx], GetStatMultiplicativeEffect(Idx, i), MODOP_Multiplication);
		}
	
		// The effect only applies while wounded
		Effect.Conditions.AddItem(Condition);
		
		// Create the template using a helper function
		RedFog.AddItem(Passive(name("RedFog" $ i+1), "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_mountainmist", true, Effect, true, true));
	}
	return RedFog;
}

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;
	local array<X2AbilityTemplate> RedFog;
	local X2AbilityTemplate RedFogEffect;

	RedFog = CreateRedFog();

	foreach RedFog(RedFogEffect)
	{
		Templates.AddItem(RedFogEffect);
	}
	
	if(default.StatList.Length != default.SevereEffect.Length)
	{
		`log("Array length mismatch, check for config errors.",,'ComplicatedRedFog');
	}
	
	return Templates;
}