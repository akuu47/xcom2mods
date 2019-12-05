//---------------------------------------------------------------------------------------
//  FILE:   XComDownloadableContentInfo_SkirmisherRebalance.uc                                    
//           
//	Use the X2DownloadableContentInfo class to specify unique mod behavior when the 
//  player creates a new campaign or loads a saved game.
//  
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class X2DownloadableContentInfo_SkirmisherRebalance extends X2DownloadableContentInfo config(SkirmRework);

// Set up our cooldown files in the config file
var config int WHIPLASH_COOLDOWN;
var config int INTERRUPT_COOLDOWN;
var config int BATTLELORD_COOLDOWN;

var config bool Rebalance;

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



// When the ability templates are created everytime you load the game, execute these three functions
static event OnPostTemplatesCreated()
{
	if(default.Rebalance)
	{
		UpdateSkirmisherAbilities();
	}
}

static function UpdateSkirmisherAbilities()
{
	UpdateWhiplash();
	UpdateInterrupt();
	UpdateBattlelord();
	UpdateReflex();
	UpdateParkour();
}

static function UpdateWhiplash()
{
	local X2AbilityTemplateManager			AbilityManager;
	local array<X2AbilityTemplate>			TemplateAllDifficulties;
	local X2AbilityTemplate					Template;

	local X2AbilityCost_ActionPoints        ActionCost;
	local X2AbilityCooldown					Cooldown;


	AbilityManager = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();
	AbilityManager.FindAbilityTemplateAllDifficulties('Whiplash', TemplateAllDifficulties);

	foreach TemplateAllDifficulties(Template)
	{
		Template.AbilityCosts.Length = 0;
		Template.AbilityCharges = none;

		ActionCost = new class'X2AbilityCost_ActionPoints';
		ActionCost.bConsumeAllPoints = true;   //  this will guarantee the unit has at least 1 action point
		ActionCost.bFreeCost = true;           //  ReserveActionPoints effect will take all action points away
		Template.AbilityCosts.AddItem(ActionCost);


		Cooldown = new class'X2AbilityCooldown';
		Cooldown.iNumTurns = default.WHIPLASH_COOLDOWN + 1;
		Template.AbilityCooldown = Cooldown;
	}
}

static function UpdateInterrupt()
{
	local X2AbilityTemplateManager			AbilityManager;
	local array<X2AbilityTemplate>			TemplateAllDifficulties;
	local X2AbilityTemplate					Template;

	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2AbilityCooldown					Cooldown;


	AbilityManager = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();
	AbilityManager.FindAbilityTemplateAllDifficulties('SkirmisherInterruptInput', TemplateAllDifficulties);

	foreach TemplateAllDifficulties(Template)
	{
		Template.AbilityCosts.Length = 0;
		Template.AbilityCharges = none;

		ActionPointCost = new class'X2AbilityCost_ActionPoints';
		ActionPointCost.bConsumeAllPoints = true;   //  this will guarantee the unit has at least 1 action point
		ActionPointCost.bFreeCost = true;           //  ReserveActionPoints effect will take all action points away
		ActionPointCost.DoNotConsumeAllEffects.Length = 0;
		ActionPointCost.DoNotConsumeAllSoldierAbilities.Length = 0;
		ActionPointCost.AllowedTypes.RemoveItem(class'X2CharacterTemplateManager'.default.SkirmisherInterruptActionPoint);
		Template.AbilityCosts.AddItem(ActionPointCost);

		Cooldown = new class'X2AbilityCooldown';
		Cooldown.iNumTurns = default.INTERRUPT_COOLDOWN + 1;
		Template.AbilityCooldown = Cooldown;
	}
}

static function UpdateBattlelord()
{
	local X2AbilityTemplateManager			AbilityManager;
	local array<X2AbilityTemplate>			TemplateAllDifficulties;
	local X2AbilityTemplate					Template;

	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2AbilityCooldown					Cooldown;


	AbilityManager = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();
	AbilityManager.FindAbilityTemplateAllDifficulties('Battlelord', TemplateAllDifficulties);

	foreach TemplateAllDifficulties(Template)
	{

		Template.AbilityCosts.Length = 0;
		Template.AbilityCharges = none;

		ActionPointCost = new class'X2AbilityCost_ActionPoints';
		ActionPointCost.iNumPoints = 1;
		ActionPointCost.bConsumeAllPoints = true;
		ActionPointCost.AllowedTypes.RemoveItem(class'X2CharacterTemplateManager'.default.SkirmisherInterruptActionPoint);
		Template.AbilityCosts.AddItem(ActionPointCost);

		Cooldown = new class'X2AbilityCooldown';
		Cooldown.iNumTurns = default.BATTLELORD_COOLDOWN + 1;
		Template.AbilityCooldown = Cooldown;
	}
}

static function UpdateReflex()
{
	local X2AbilityTemplateManager			AbilityManager;
	local array<X2AbilityTemplate>			TemplateAllDifficulties;
	local X2AbilityTemplate					Template;

	AbilityManager = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();
	AbilityManager.FindAbilityTemplateAllDifficulties('SkirmisherReflex', TemplateAllDifficulties);

	foreach TemplateAllDifficulties(Template)
	{
	class'X2Ability_ReflexEdit'.static.EditReflex(Template);
	}
}

static function UpdateParkour()
{
	local X2AbilityTemplateManager			AbilityManager;
	local array<X2AbilityTemplate>			TemplateAllDifficulties;
	local X2AbilityTemplate					Template;

	AbilityManager = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();
	AbilityManager.FindAbilityTemplateAllDifficulties('Parkour', TemplateAllDifficulties);

	foreach TemplateAllDifficulties(Template)
	{
	class'X2Ability_ReflexEdit'.static.EditParkour(Template);
	}
}