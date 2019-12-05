class Musashi_ConditionSniper extends X2Condition config(TacticalSuppressors);

var config array<name> SniperClassTemplates;
var config array<name> AllowIfSoldierHasAbility;

event name CallMeetsCondition(XComGameState_BaseObject kTarget) 
{ 
	local XComGameState_Unit UnitState;
	local XComGameState_Item PrimaryWeapon;
	local int NumPoints;
	local name Ability, WeaponCategory;

	UnitState = XComGameState_Unit(kTarget);
	
	if (UnitState == none)
		return 'AA_NotAUnit';

	foreach default.AllowIfSoldierHasAbility(Ability)
	{
		if (UnitState.HasSoldierAbility(Ability))
			return 'AA_Success';
	}

	NumPoints = UnitState.NumActionPoints(class'X2CharacterTemplateManager'.default.StandardActionPoint);
	
	PrimaryWeapon = UnitState.GetPrimaryWeapon();
	WeaponCategory = PrimaryWeapon.GetWeaponCategory();

	if (WeaponCategory == 'sniper_rifle' && NumPoints < 2)
	{
		`LOG("Musashi_ConditionSniper matches",, 'TacticalSuppressors');
		return 'AA_CannotAfford_ActionPoints';
	}
	return 'AA_Success'; 
}