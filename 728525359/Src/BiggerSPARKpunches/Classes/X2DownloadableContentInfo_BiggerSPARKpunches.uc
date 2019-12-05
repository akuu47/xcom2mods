//---------------------------------------------------------------------------------------
//  FILE:   XComDownloadableContentInfo_BiggerSPARKpunches.uc                                    
//           
//	Use the X2DownloadableContentInfo class to specify unique mod behavior when the 
//  player creates a new campaign or loads a saved game.
//  
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class X2DownloadableContentInfo_BiggerSPARKpunches extends X2DownloadableContentInfo config(GameData);

var config int KnockbackDistance;
var config int DestroyAOE;
var config int DestroyIntensity;

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
	local X2AbilityTemplate Template;
	local X2Effect Effect;
	local X2Effect_Knockback KnockBack;
	local X2Effect_DLC_3StrikeDamage PhysicalDamageEffect;
	local X2AbilityMultiTarget_Radius RadiusMultiTarget;

	Template = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager().FindAbilityTemplate('Strike');
	foreach Template.AbilityTargetEffects(Effect)
	{
		Knockback = X2Effect_Knockback(Effect);
		if (Knockback != none)
		{
			Knockback.KnockbackDistance = default.KnockbackDistance;
			`log("Spark Strike Patched to" @ default.KnockbackDistance);
			Knockback.bKnockbackDestroysNonFragile = true;
		}
	}
	foreach Template.AbilityTargetEffects(Effect)
	{
		PhysicalDamageEffect = X2Effect_DLC_3StrikeDamage(Effect);
		if (PhysicalDamageEffect != none)
		{
			PhysicalDamageEffect.EnvironmentalDamageAmount = default.DestroyIntensity;
			RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
			RadiusMultiTarget.fTargetRadius = default.DestroyAOE;
			Template.AbilityMultiTargetStyle = RadiusMultiTarget;
		}
	}

	`log("Spark Strike Patched");
}