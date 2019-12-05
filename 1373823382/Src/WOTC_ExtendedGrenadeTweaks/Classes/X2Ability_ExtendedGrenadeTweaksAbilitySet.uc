class X2Ability_ExtendedGrenadeTweaksAbilitySet extends X2Ability;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;
	
	Templates.AddItem(CombatEngineer());
	Templates.AddItem(TandemWarheads());
    
	return Templates;
}

static function X2AbilityTemplate CombatEngineer()
{
	return PurePassive('EGT_CombatEngineer', "img:///UILibrary_EGT.LW_AbilityCombatEngineer");
}

static function X2AbilityTemplate TandemWarheads()
{
	return PurePassive('EGT_TandemWarheads', "img:///UILibrary_EGT.LW_AbilityTandemWarheads");
}