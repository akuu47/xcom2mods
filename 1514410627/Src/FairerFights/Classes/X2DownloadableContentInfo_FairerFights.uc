class X2DownloadableContentInfo_FairerFights extends X2DownloadableContentInfo config(FairerFights);

var config bool BASTION_REMOVES_FREEZE;
var config int PRIEST_STASIS_AP;
var config bool PRIEST_STASIS_ENDS_TURN;
var config bool VIPER_BOLTCASTER_CAN_BE_DODGED;
var config int VIPER_BOLTCASTER_AIM;
var config int VIPER_BOLTCASTER_STUN_CHANCE;

static event OnPostTemplatesCreated()
{
	UpdateBastion();
	UpdatePriestStasis();
	UpdateSpark('SparkSoldier');
	UpdateSpark('LostTowersSpark');
	UpdateXCOMTurret('XCOMTurretM1');
	UpdateXCOMTurret('XCOMTurretM2');
	UpdateViperBoltCaster('ViperNeonate_WPN');
	UpdateViperBoltCaster('ViperKing_WPN');
}

static function UpdateBastion()
{
	local X2AbilityTemplateManager		AbilityManager;
	local array<X2AbilityTemplate>		TemplateAllDifficulties;
	local X2AbilityTemplate				Template;

	local X2Effect_RemoveEffects		FortressRemoveEffect;
	local X2Condition_UnitProperty		FriendCondition;

	AbilityManager = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();
	AbilityManager.FindAbilityTemplateAllDifficulties('LW2WotC_Bastion_Cleanse', TemplateAllDifficulties);

	foreach TemplateAllDifficulties(Template)
	{
		if (default.BASTION_REMOVES_FREEZE)
		{
			FortressRemoveEffect = new class'X2Effect_RemoveEffects';
			FortressRemoveEffect.EffectNamesToRemove.AddItem(class'X2Effect_DLC_Day60Freeze'.default.EffectName);
			FriendCondition = new class'X2Condition_UnitProperty';
			FriendCondition.ExcludeFriendlyToSource = false;
			FriendCondition.ExcludeHostileToSource = true;
			FortressRemoveEffect.TargetConditions.AddItem(FriendCondition);
			Template.AddTargetEffect(FortressRemoveEffect);
		}
	}
}

static function UpdatePriestStasis()
{
	local X2AbilityTemplateManager		AbilityManager;
	local array<X2AbilityTemplate>		TemplateAllDifficulties;
	local X2AbilityTemplate				Template;

	local X2AbilityCost_ActionPoints	ActionPointCost;

	AbilityManager = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();
	AbilityManager.FindAbilityTemplateAllDifficulties('PriestStasis', TemplateAllDifficulties);

	foreach TemplateAllDifficulties(Template)
	{
		Template.AbilityCosts.Length = 0;

		ActionPointCost = new class'X2AbilityCost_ActionPoints';
		ActionPointCost.iNumPoints = default.PRIEST_STASIS_AP;
		ActionPointCost.bConsumeAllPoints = default.PRIEST_STASIS_ENDS_TURN;
		Template.AbilityCosts.AddItem(ActionPointCost);
	}
}

static function UpdateSpark(name BaseTemplateName)
{
	local X2CharacterTemplateManager	CharacterMgr;
	local array<X2DataTemplate>			TemplateAllDifficulties;
	local X2DataTemplate				Template;

	local X2CharacterTemplate			CharacterTemplate;

	CharacterMgr = class'X2CharacterTemplateManager'.static.GetCharacterTemplateManager();
	CharacterMgr.FindDataTemplateAllDifficulties(BaseTemplateName, TemplateAllDifficulties);

	foreach TemplateAllDifficulties(Template)
	{
		CharacterTemplate = X2CharacterTemplate(Template);
		CharacterTemplate.strHackIconImage = "UILibrary_Common.TargetIcons.Hack_robot_icon";
	}
}

static function UpdateXCOMTurret(name BaseTemplateName)
{
	local X2CharacterTemplateManager	CharacterMgr;
	local array<X2DataTemplate>			TemplateAllDifficulties;
	local X2DataTemplate				Template;

	local X2CharacterTemplate			CharacterTemplate;

	CharacterMgr = class'X2CharacterTemplateManager'.static.GetCharacterTemplateManager();
	CharacterMgr.FindDataTemplateAllDifficulties(BaseTemplateName, TemplateAllDifficulties);

	foreach TemplateAllDifficulties(Template)
	{
		CharacterTemplate = X2CharacterTemplate(Template);
		CharacterTemplate.strHackIconImage = "UILibrary_Common.TargetIcons.Hack_turret_icon";
	}
}

static function UpdateViperBoltCaster(name BaseTemplateName)
{
	local X2ItemTemplateManager			ItemTemplateMgr;
	local array<X2DataTemplate>			TemplateAllDifficulties;
	local X2DataTemplate				Template;

	local X2WeaponTemplate				WeaponTemplate;
	
	ItemTemplateMgr = class'X2ItemTemplateManager'.static.GetItemTemplateManager();
	ItemTemplateMgr.FindDataTemplateAllDifficulties(BaseTemplateName, TemplateAllDifficulties);
	
	foreach TemplateAllDifficulties(Template)
	{
		WeaponTemplate = X2WeaponTemplate(Template);
		WeaponTemplate.bCanBeDodged = default.VIPER_BOLTCASTER_CAN_BE_DODGED;
		WeaponTemplate.Aim = default.VIPER_BOLTCASTER_AIM;

		WeaponTemplate.BonusWeaponEffects.AddItem(class'X2StatusEffects'.static.CreateStunnedStatusEffect(2, default.VIPER_BOLTCASTER_STUN_CHANCE, false));

		WeaponTemplate.fKnockbackDamageAmount = 5.0f;
		WeaponTemplate.fKnockbackDamageRadius = 0.0f;

		WeaponTemplate.SetUIStatMarkup(class'XLocalizedData'.default.StunChanceLabel, , default.VIPER_BOLTCASTER_STUN_CHANCE, , , "%");
	}
}