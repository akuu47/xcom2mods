class X2Ability_ChosenSniper_ChosenWeaponryFix extends X2Ability_ChosenSniper;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	Templates.AddItem(PurePassive('Farsight', "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_farsight", false, 'eAbilitySource_Perk', true));

	return Templates;
}