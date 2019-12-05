//---------------------------------------------------------------------------------------
//  FILE:   XComDownloadableContentInfo_RevivalProtocolFixes.uc                                    
//           
//	Use the X2DownloadableContentInfo class to specify unique mod behavior when the 
//  player creates a new campaign or loads a saved game.
//  
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class X2DownloadableContentInfo_RevivalProtocolFixes extends X2DownloadableContentInfo;

/// <summary>
/// This method is run if the player loads a saved game that was created prior to this DLC / Mod being installed, and allows the 
/// DLC / Mod to perform custom processing in response. This will only be called once the first time a player loads a save that was
/// create without the content installed. Subsequent saves will record that the content was installed.
/// </summary>
static event OnLoadedSavedGame()
{}

/// <summary>
/// Called when the player starts a new campaign while this DLC / Mod is installed
/// </summary>
static event InstallNewCampaign(XComGameState StartState)
{}


static event OnPostTemplatesCreated()
{
	EditVanillaAbilities();
}

static function EditVanillaAbilities()
 {
	local X2AbilityTemplateManager							AbilityManager;
	local X2AbilityTemplate									AbilityTemplate;
	local RM_RevivalCondition									RevivalCondition;
	local X2Effect_RestoreActionPoints      RestoreEffect;
	local X2Effect_RemoveEffects            RemoveEffects, RemoveStunned;

	AbilityManager = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();

	AbilityTemplate = AbilityManager.FindAbilityTemplate('RevivalProtocol');
	AbilityTemplate.AbilityTargetConditions.Length = 0;

	RevivalCondition = new class'RM_RevivalCondition';
	AbilityTemplate.AbilityTargetConditions.AddItem(RevivalCondition);
	AbilityTemplate.AddTargetEffect(RemoveStunnedEffect());
	AbilityTemplate.AddTargetEffect(class'X2StatusEffects'.static.CreateStunRecoverEffect());

	AbilityTemplate = AbilityManager.FindAbilityTemplate('RestorativeMist');

	RestoreEffect = new class'X2Effect_RestoreActionPoints';
	RestoreEffect.TargetConditions.AddItem(new class'RM_RevivalCondition');
	AbilityTemplate.AddMultiTargetEffect(RestoreEffect);

	RemoveEffects = RemoveAdditionalEffectsForRevivalProtocolAndRestorativeMist();
	RemoveEffects.TargetConditions.AddItem(new class'RM_RevivalCondition');
	AbilityTemplate.AddMultiTargetEffect(RemoveEffects);
	AbilityTemplate.AddMultiTargetEffect(RemoveAllEffectsByDamageType());

	RemoveStunned = RemoveStunnedEffect();
	RemoveStunned.TargetConditions.AddItem(new class'RM_RevivalCondition');
	AbilityTemplate.AddMultiTargetEffect(RemoveStunned);
	AbilityTemplate.AddMultiTargetEffect(class'X2StatusEffects'.static.CreateStunRecoverEffect());
}

static function X2Effect_RemoveEffects RemoveStunnedEffect()
{
	local X2Effect_RemoveEffects RemoveEffects;
	RemoveEffects = new class'X2Effect_RemoveEffects';
	RemoveEffects.EffectNamesToRemove.AddItem(class'X2AbilityTemplateManager'.default.StunnedName);
	return RemoveEffects;
}

static function X2Effect_RemoveEffectsByDamageType RemoveAllEffectsByDamageType()
{
	local X2Effect_RemoveEffectsByDamageType RemoveEffectTypes;
	local name HealType;

	RemoveEffectTypes = new class'X2Effect_RemoveEffectsByDamageType';
	foreach class'X2Ability_DefaultAbilitySet'.default.MedikitHealEffectTypes(HealType)
	{
		RemoveEffectTypes.DamageTypesToRemove.AddItem(HealType);
	}
	return RemoveEffectTypes;
}

static function X2Effect_RemoveEffects RemoveAdditionalEffectsForRevivalProtocolAndRestorativeMist()
{
	local X2Effect_RemoveEffects RemoveEffects;
	RemoveEffects = new class'X2Effect_RemoveEffects';
	RemoveEffects.EffectNamesToRemove.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
	RemoveEffects.EffectNamesToRemove.AddItem(class'X2AbilityTemplateManager'.default.PanickedName);
	RemoveEffects.EffectNamesToRemove.AddItem(class'X2StatusEffects'.default.UnconsciousName);
	return RemoveEffects;
}