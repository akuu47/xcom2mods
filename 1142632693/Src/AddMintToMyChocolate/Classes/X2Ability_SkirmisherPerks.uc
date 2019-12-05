class X2Ability_SkirmisherPerks extends XMBAbility config(GameData_SoldierSkills);

var config WeaponDamageValue MASTER_OF_ARMS_DMG;


static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	Templates.AddItem(PurePassive('MNT_RapidRappel', "img:///UILibrary_PerkIcons.UIPerk_item_wraith", true, 'eAbilitySource_Perk'));
	Templates.AddItem(TacticalProfile());

	Templates.AddItem(FirstBlood());

	Templates.AddItem(MomentumSwing());
	
	Templates.AddItem(ChaseBullet());
	Templates.AddItem(ChaseShot());

	Templates.AddItem(PurePassive('MNT_MasterOfArms', "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_HolyWarrior", true, 'eAbilitySource_Perk'));


	return Templates;
}

// Tactical Profile - doubles cover bonuses with a height advantage
static function X2AbilityTemplate TacticalProfile()
{
	local X2Effect_CoverBonus			DefModifier;

	DefModifier = new class 'X2Effect_CoverBonus';
	
	return Passive('MNT_TacticalProfile', "img:///UILibrary_PerkIcons.UIPerk_flush", true, DefModifier);

}

//Momentum Swing - resets grapple cooldown on kills
static function X2AbilityTemplate MomentumSwing()
{
	local X2Effect_ReduceCooldowns		Effect;
	
	// Create an effect that completely resets the Bull Rush cooldown
	Effect = new class'X2Effect_ReduceCooldowns';
	Effect.AbilitiesToTick.AddItem('SkirmisherGrapple');
	Effect.ReduceAll = true;

	// Create a triggered ability that activates when the unit takes damage
	return SelfTargetTrigger('MNT_MomentumSwing', "img:///UILibrary_PerkIcons.UIPerk_chryssalid_chargeandslash", false, Effect, 'KillMail');
}


//First Blood - bonus damage and crit if both target and Skirmisher unharmed
static function X2AbilityTemplate FirstBlood()
{
	local XMBEffect_ConditionalBonus Effect;
	local X2Condition_UnitStatCheck Condition;

	Condition = new class'X2Condition_UnitStatCheck';
	Condition.AddCheckStat(eStat_HP, 100, eCheck_Exact,,, true);

	Effect = new class'XMBEffect_ConditionalBonus';
	Effect.AddDamageModifier(1, eHit_Success);
	Effect.AddToHitModifier(15, eHit_Crit);

	// The effect only applies while both you and target are unharmed
	Effect.AbilityTargetConditions.AddItem(Condition);
	Effect.AbilityShooterConditions.AddItem(Condition);
	Effect.AbilityTargetConditionsAsTarget.AddItem(Condition);
	
	// Create the template using a helper function
	return Passive('MNT_FirstBlood', "img:///UILibrary_PerkIcons.UIPerk_adrenalneurosympathy", true, Effect);
}



// Chase Bullet - Followup all attacks with a guaranteed shot that can crit.
static function X2AbilityTemplate ChaseBullet()
{
	local X2AbilityTemplate             Template;
	local X2Effect_ReserveActionPoints  Effect;

	Effect = new class'X2Effect_ReserveActionPoints';
	Effect.ReserveType = 'MNT_ChaseBullet';

	Template = SelfTargetActivated('MNT_ChaseBullet', "img:///UILibrary_PerkIcons.UIPerk_deathblossom", true, Effect, class'UIUtilities_Tactical'.const.CLASS_COLONEL_PRIORITY, eCost_WeaponConsumeAll);
	Template.AdditionalAbilities.AddItem('MNT_ChaserShot');
	Template.ActivationSpeech = 'Battlelord';

	AddCharges(Template, 1);
	
	return Template;
}

// The actual shot
static function X2AbilityTemplate ChaseShot()
{
	local X2AbilityTemplate							Template;
	local X2AbilityToHitCalc_StandardAim			ToHit;
	local X2AbilityCost_ReserveActionPoints			ReserveActionPointCost;
	local X2AbilityCost_Ammo						AmmoCost;
	local X2Condition_Visibility					TargetVisibilityCondition;
	//local X2AbilityTrigger_Chaser					EventListener;

	Template = Attack('MNT_ChaserShot', "img:///UILibrary_PerkIcons.UIPerk_aimcover", false, none, class'UIUtilities_Tactical'.const.CLASS_SERGEANT_PRIORITY, eCost_None);
	
	Template.AbilityCosts.Length = 0;
	Template.AbilityTriggers.Length = 0;

	AmmoCost = new class'X2AbilityCost_Ammo';
	AmmoCost.iAmmo = 0;
	Template.AbilityCosts.AddItem(AmmoCost);

	ReserveActionPointCost = new class'X2AbilityCost_ReserveActionPoints';
	ReserveActionPointCost.iNumPoints = 1;
	ReserveActionPointCost.bFreeCost = true;
	ReserveActionPointCost.AllowedTypes.AddItem('MNT_ChaseBullet');
	Template.AbilityCosts.AddItem(ReserveActionPointCost);

	Template.AbilityTargetConditions.AddItem(default.LivingHostileUnitDisallowMindControlProperty);
	TargetVisibilityCondition = new class'X2Condition_Visibility';
	TargetVisibilityCondition.bRequireGameplayVisible = true;
	TargetVisibilityCondition.bDisablePeeksOnMovement = true;
	TargetVisibilityCondition.bAllowSquadsight = true;
	Template.AbilityTargetConditions.AddItem(TargetVisibilityCondition);

	Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());
	Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.ShredderDamageEffect());

	HidePerkIcon(Template);

	
	// XMBAbilityTrigger_EventListener doesn't use ListenerData.EventFn
	//EventListener = new class'X2AbilityTrigger_Chaser';
	//EventListener.ListenerData.Deferral = ELD_OnStateSubmitted;
	//EventListener.ListenerData.EventID = 'UnitTakeEffectDamage';
	//EventListener.ListenerData.EventFn = ChaseBulletListener;
	//EventListener.ListenerData.Filter = eFilter_None;
	//EventListener.bSelfTarget = false;
	//Template.AbilityTriggers.AddItem(EventListener);
	

	ToHit = new class'X2AbilityToHitCalc_StandardAim';
	ToHit.bReactionFire = true;
	ToHit.bAllowCrit = true;
	ToHit.bGuaranteedHit = true;
	Template.AbilityToHitCalc = ToHit;
	AddPerTargetCooldown(Template, 1);

	return Template;
}

/*
function EventListenerReturn ChaseBulletListener(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
	local XComGameState_Unit DamagedUnit;
	local X2TacticalGameRuleset Ruleset;
	local GameRulesCache_VisibilityInfo VisInfo;
	local XComGameState_Ability SourceAbilityState;

	`LOG("SOMETHING WAS DAMAGED DAMNIT.");
	DamagedUnit = XComGameState_Unit(EventData);

	if (DamagedUnit.GetTeam() == eTeam_Alien)
	{
		`LOG("AND IT WAS AN ALIEN");
		SourceAbilityState = XComGameState_Ability(CallbackData);
		SourceAbilityState = XComGameState_Ability(`XCOMHISTORY.GetGameStateForObjectID(SourceAbilityState.ObjectID));
		if (SourceAbilityState == none)
			return ELR_NoInterrupt;
		
		`LOG("IT TRIGGERS PLS");
		SourceAbilityState.AbilityTriggerAgainstSingleTarget(DamagedUnit.GetReference(), false);

	}

	return ELR_NoInterrupt;
}
*/