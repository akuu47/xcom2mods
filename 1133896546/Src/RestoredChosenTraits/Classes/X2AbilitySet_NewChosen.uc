//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class X2AbilitySet_NewChosen extends X2Ability;


static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	Templates.AddItem(CreateEnviroWeakness());

	return Templates;
}

static function X2AbilityTemplate CreateEnviroWeakness()
{
	local X2AbilityTemplate Template;

	Template = PurePassive('ChosenWeakEnviro', "img:///UILibrary_XPACK_Common.PerkIcons.weak_weaktopoison", false, 'eAbilitySource_Perk', true);
	Template.RemoveTemplateAvailablility(Template.BITFIELD_GAMEAREA_Multiplayer);
	
	Template.AdditionalAbilities.AddItem('ChosenWeakFire');
	Template.AdditionalAbilities.AddItem('ChosenWeakPoison');
	Template.AdditionalAbilities.AddItem('ChosenWeakAcid');

	Template.ChosenExcludeTraits.AddItem('ChosenImmuneEnvironmental');

	return Template;
}
