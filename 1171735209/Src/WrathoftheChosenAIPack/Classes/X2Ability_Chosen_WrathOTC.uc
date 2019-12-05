class X2Ability_Chosen_WrathOTC extends X2Ability_Chosen config(GameData_SoldierSkills);

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;
	
	Templates.AddItem(CreateChosen3APAbility());

	return Templates;
}

static function X2AbilityTemplate CreateChosen3APAbility() {
   local X2AbilityTemplate                 Template;
   local X2Effect_TurnStartActionPoints    ThreeActionPoints;

   Template =  PurePassive('Chosen3APAbilityPassive', "img:///UILibrary_XPACK_Common.PerkIcons.str_agile");

   Template.AbilitySourceName = 'eAbilitySource_Perk';
   Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
   
   ThreeActionPoints = new class'X2Effect_TurnStartActionPoints';
   ThreeActionPoints.ActionPointType = class'X2CharacterTemplateManager'.default.StandardActionPoint;
   ThreeActionPoints.NumActionPoints = 1;
   ThreeActionPoints.bInfiniteDuration = true;
   ThreeActionPoints.SetDisplayInfo(ePerkBuff_Passive, "Chosen 3AP", "The Chosen gets 3 APs per turn.", Template.IconImage, , , Template.AbilitySourceName);
   Template.AddTargetEffect(ThreeActionPoints);

   return Template;
}