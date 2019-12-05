//---------------------------------------------------------------------------------------
// PSION REROLLING
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class X2DownloadableContentInfo_MNT_StrategyLayer extends X2DownloadableContentInfo;

var localized string			str_DeltaStrike_Description, str_DeltaStrike_Tooltip;
var localized string			str_EarthsFinest_Description, str_EarthsFinest_Tooltip;

static event OnPostTemplatesCreated()
{
	UpdateSecondWaveOptionsList();
}

// Add the Delta Strike option to the Second Wave Advanced Options list
static function UpdateSecondWaveOptionsList()
{
	local array<Object>			UIShellDifficultyArray;
	local Object				ArrayObject;
	local UIShellDifficulty		UIShellDifficulty;
    local SecondWaveOption		DeltaStrike, EarthsFinest;
	
	DeltaStrike.ID = 'DeltaStrike';
	DeltaStrike.DifficultyValue = 0;

	EarthsFinest.ID = 'EarthsFinest';
	EarthsFinest.DifficultyValue = 0;

	UIShellDifficultyArray = class'XComEngine'.static.GetClassDefaultObjects(class'UIShellDifficulty');
	foreach UIShellDifficultyArray(ArrayObject)
	{
		UIShellDifficulty = UIShellDifficulty(ArrayObject);

		UIShellDifficulty.SecondWaveOptions.AddItem(DeltaStrike);
		UIShellDifficulty.SecondWaveDescriptions.AddItem(default.str_DeltaStrike_Description);
		UIShellDifficulty.SecondWaveToolTips.AddItem(default.str_DeltaStrike_Tooltip);

		UIShellDifficulty.SecondWaveOptions.AddItem(EarthsFinest);
		UIShellDifficulty.SecondWaveDescriptions.AddItem(default.str_EarthsFinest_Description);
		UIShellDifficulty.SecondWaveToolTips.AddItem(default.str_EarthsFinest_Tooltip);

	}
}


// force grants psi gift
exec function ForcePsiGift(string UnitName)
{
	local XComGameState NewGameState;
	local array<XComGameState_Unit> Soldiers;
	local XComGameState_Unit Unit, UpdatedUnit;
	local XComGameState_Unit_Additional ExtraState;
	local SoldierClassAbilityType Ability;
	local ClassAgnosticAbility NewPsionAbility;

	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Forcing Psi Gift");

	Soldiers = `XCOMHQ.GetSoldiers();
	foreach Soldiers(Unit)
	{
		if(Unit.GetFullName() == UnitName)
		{
			UpdatedUnit = XComGameState_Unit(NewGameState.CreateStateObject(class'XComGameState_Unit', Unit.ObjectID));
			UpdatedUnit.bHasPsiGift = true;
			UpdatedUnit.bRolledForPsiGift = true;

			ExtraState = class'MNT_Utility'.static.GetExtraComponent(Unit);

			if(ExtraState == none){
				//Add a LatentPsionic Component
				ExtraState = XComGameState_Unit_Additional(NewGameState.CreateStateObject(class'XComGameState_Unit_Additional'));
				ExtraState.InitComponent();
				UpdatedUnit.AddComponentObject(ExtraState);
			}

			//Make it more obvious on future looksiebacksies
			Ability.AbilityName = 'TheGift';
			Ability.ApplyToWeaponSlot = eInvSlot_Unknown;
			Ability.UtilityCat = '';
			NewPsionAbility.AbilityType = Ability;
			NewPsionAbility.iRank = 0;
			NewPsionAbility.bUnlocked = true;
			UpdatedUnit.AWCAbilities.AddItem(NewPsionAbility);
		}
	}

	NewGameState.AddStateObject(UpdatedUnit);
	NewGameState.AddStateObject(ExtraState);
	`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);
}

//Rerolls all non-psions
exec function ForcePsiGiftReroll()
{
	local XComGameState NewGameState;
	local array<XComGameState_Unit> Soldiers;
	local XComGameState_Unit Unit;

	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Psi Gift reroll");

	Soldiers = `XCOMHQ.GetSoldiers();
	foreach Soldiers(Unit)
	{
		if(!Unit.bHasPsiGift && Unit.GetSoldierRank() > 0)
			Unit.bRolledForPsiGift = false;
	}

	`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);

}

exec function FinishProjects()
{
	local XComGameState_HeadquartersProject Project;
	local int idx;
	local XComGameStateHistory History;
	local XComGameState_HeadquartersXCom XComHQ;

	XComHQ = class'UIUtilities_Strategy'.static.GetXComHQ();
	History = `XCOMHISTORY;

	for (idx = 0; idx < XComHQ.Projects.Length; idx++)
	{
		Project = XComGameState_HeadquartersProject(History.GetGameStateForObjectID(XComHQ.Projects[idx].ObjectID));

		Project.CompletionDateTime = `STRATEGYRULES.GameTime;
		Project.bInstant = true;
	}

}