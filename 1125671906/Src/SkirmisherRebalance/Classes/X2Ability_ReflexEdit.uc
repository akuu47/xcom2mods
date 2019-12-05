class X2Ability_ReflexEdit extends X2AbilityTemplate;


static function EditReflex(X2AbilityTemplate Template)
{
	local X2AbilityTemplate									AbilityTemplate;
	local X2Effect_CoveringFire                 CoveringEffect;
	local X2Effect_Persistent					PersistentEffect;

	AbilityTemplate = Template;
	AbilityTemplate.AbilityTargetEffects.Length = 0;
	//AbilityTemplate = PurePassive('SkirmisherReflex', "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_reflex", false, 'eAbilitySource_Perk', true);
	//AbilityTemplate.RemoveTemplateAvailablility(Template.BITFIELD_GAMEAREA_Multiplayer);

	//  This is a dummy effect so that an icon shows up in the UI.
	PersistentEffect = new class'X2Effect_Persistent';
	PersistentEffect.BuildPersistentEffect(1, true, false);
	PersistentEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.LocLongDescription, Template.IconImage, true,, Template.AbilitySourceName);
	AbilityTemplate.AddTargetEffect(PersistentEffect);


	CoveringEffect = new class'X2Effect_CoveringFire';
	CoveringEffect.BuildPersistentEffect(1, true, false, false);
	CoveringEffect.AbilityToActivate = 'SkirmisherReflexTrigger';
	//CoveringEffect.GrantActionPoint = class'X2CharacterTemplateManager'.default.SkirmisherInterruptActionPoint; //hopefully this won't break anything
	CoveringEffect.bPreEmptiveFire = false;
	CoveringEffect.bDirectAttackOnly = true;
	CoveringEffect.bOnlyDuringEnemyTurn = true;
	CoveringEffect.bUseMultiTargets = false;
	CoveringEffect.bSelfTargeting = true;
	CoveringEffect.EffectName = 'ReflexWatchEffect';
	AbilityTemplate.AddTargetEffect(CoveringEffect);

	AbilityTemplate.AdditionalAbilities.AddItem('SkirmisherReflexTrigger');


}


static function EditParkour(X2AbilityTemplate Template)
{
	local X2AbilityTemplate									AbilityTemplate;
	local X2Effect_TurnStartActionPoints					ThreeActionPoints;
	local X2AbilityTrigger						Trigger;

	AbilityTemplate = Template;
	AbilityTemplate.AbilityTargetEffects.Length = 0;
	//AbilityTemplate = PurePassive('SkirmisherReflex', "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_reflex", false, 'eAbilitySource_Perk', true);
	//AbilityTemplate.RemoveTemplateAvailablility(Template.BITFIELD_GAMEAREA_Multiplayer);

	//  This is a dummy effect so that an icon shows up in the UI.

	AbilityTemplate.AbilityTriggers.Length = 0;

	Trigger = new class'X2AbilityTrigger_UnitPostBeginPlay';
	AbilityTemplate.AbilityTriggers.AddItem(Trigger);


	// Add 3rd action point per turn
	ThreeActionPoints = new class'X2Effect_TurnStartActionPoints';
	ThreeActionPoints.ActionPointType = class'X2CharacterTemplateManager'.default.MoveActionPoint;
	ThreeActionPoints.NumActionPoints = 1;
	ThreeActionPoints.bInfiniteDuration = true;
	AbilityTemplate.AddTargetEffect(ThreeActionPoints);


}