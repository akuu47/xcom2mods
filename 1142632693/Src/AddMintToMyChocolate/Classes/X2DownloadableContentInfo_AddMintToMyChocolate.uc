//---------------------------------------------------------------------------------------
// RESPEC AHOY
//  
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class X2DownloadableContentInfo_AddMintToMyChocolate extends X2DownloadableContentInfo;

var config array<name> DeprecatedPerk;

/// <summary>
/// This method is run if the player loads a saved game that was created prior to this DLC / Mod being installed, and allows the 
/// DLC / Mod to perform custom processing in response. This will only be called once the first time a player loads a save that was
/// create without the content installed. Subsequent saves will record that the content was installed.
/// </summary>
static event OnLoadedSavedGame()
{
}

/// <summary>
/// Called when the player starts a new campaign while this DLC / Mod is installed
/// </summary>
static event InstallNewCampaign(XComGameState StartState)
{}


static event OnLoadedSavedGameToStrategy()
{
	if (SaveFileOfferRespec())
	{
		EnableDLCContentPopup();
	}
}

static event OnPostTemplatesCreated()
{}

simulated function EnableDLCContentPopupCallback_Ex(Name eAction)
{
	local XComGameState NewGameState;
	local array<XComGameState_Unit> Soldiers;
	local XComGameState_Unit Unit;
	local int idx, SoldierRank;
	local name SoldierClass;

	super.EnableDLCContentPopupCallback_Ex(eAction);

	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("MINT Mass Respec");

	if (eAction == 'eUIAction_Accept')
	{
		Soldiers = `XCOMHQ.GetSoldiers();
		foreach Soldiers(Unit)
		{
			if(Unit.GetSoldierClassTemplateName() == 'Operative_Mint' || SoldierNeedsRespec(Unit))
			{
				SoldierRank = Unit.GetRank();
				SoldierClass = Unit.GetSoldierClassTemplateName();

				if(SoldierClass == 'PsiOperative_Mint')
					SoldierClass = 'Operative_Mint';

				Unit.AbilityPoints = 0;
				Unit.ResetSoldierRank(); // Clear their rank
				Unit.ResetSoldierAbilities(); // Clear their current abilities

				for (idx = 0; idx < SoldierRank; idx++)
					Unit.RankUpSoldier(NewGameState, SoldierClass); // The class template name
			}	}	}

	`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);
}

// #######################################################################################
// -------------------- HELPERS ------------------------------------------------------
// #######################################################################################

//Checks if a midcampaign save needs to be offered a respec
static function bool SaveFileOfferRespec(){

	local array<XComGameState_Unit> Soldiers;
	local XComGameState_Unit Unit;
	Soldiers = `XCOMHQ.GetSoldiers();
	foreach Soldiers(Unit)
	{
		if(SoldierNeedsRespec(Unit))
			return true;
	}

	return false;
}

//Checks if a unit needs to be respec'd
static function bool SoldierNeedsRespec(XComGameState_Unit Unit){

	local name Perk;

	if(Unit.GetSoldierClassTemplateName() == 'PsiOperative_Mint')
		return true;

	foreach default.DeprecatedPerk(Perk){
		if(Unit.HasSoldierAbility(Perk))
			return true;
	}

	return false;
}


// #######################################################################################
// -------------------- CHEATS ------------------------------------------------------
// #######################################################################################

//Respec soldier
exec function RespecSoldier(string UnitName)
{
	local XComGameState NewGameState;
	local array<XComGameState_Unit> Soldiers;
	local XComGameState_Unit Unit;
	local int idx, SoldierRank;
	local name SoldierClass;

	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Respec Barracks");

	Soldiers = `XCOMHQ.GetSoldiers();
	foreach Soldiers(Unit)
	{
		if(Unit.GetFullName() == UnitName)
		{
			SoldierRank = Unit.GetRank();
			SoldierClass = Unit.GetSoldierClassTemplateName();

			Unit.AbilityPoints = 0;
			Unit.ResetSoldierRank(); // Clear their rank
			Unit.ResetSoldierAbilities(); // Clear their current abilities

			for (idx = 0; idx < SoldierRank; idx++)
				Unit.RankUpSoldier(NewGameState, SoldierClass); // The class template name
		}
	}
	`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);
}

// this respecs everyone
exec function RespecBarracks()
{
	local XComGameState NewGameState;
	local array<XComGameState_Unit> Soldiers;
	local XComGameState_Unit Unit;
	local int idx, SoldierRank;
	local name SoldierClass;

	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Respec Barracks");

	Soldiers = `XCOMHQ.GetSoldiers();
	foreach Soldiers(Unit)
	{
		if(Unit.GetRank() > 0) // don't do this for rookies obviously
		{
			SoldierRank = Unit.GetRank();
			SoldierClass = Unit.GetSoldierClassTemplateName();

			Unit.ResetSoldierRank(); // Clear their rank
			Unit.ResetSoldierAbilities(); // Clear their current abilities

			Unit.AbilityPoints = 0;
			Unit.StartingRank = SoldierRank; //Resets current rank

			for (idx = 0; idx < SoldierRank; idx++)
				Unit.RankUpSoldier(NewGameState, SoldierClass); // The class template name
		}
	}
	`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);
}

//combat intelligence
exec function Smartify(string UnitName)
{
	local XComGameState NewGameState;
	local array<XComGameState_Unit> Soldiers;
	local XComGameState_Unit Unit;

	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Improving someone's combat IQ");

	Soldiers = `XCOMHQ.GetSoldiers();
	foreach Soldiers(Unit)
	{
		if(Unit.GetFullName() == UnitName)
		{
			Unit.ImproveCombatIntelligence();
		}
	}
	`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);
}