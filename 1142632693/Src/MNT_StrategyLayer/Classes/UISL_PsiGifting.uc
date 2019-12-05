//---------------------------------------------------------------------------------------
//  FILE:    UISL_PsiGifting.uc
//  AUTHOR:  Ziodyne
//  PURPOSE: Handles rolling for Psi Gift upon entering the Psi Labs
//           
//---------------------------------------------------------------------------------------
class UISL_PsiGifting extends UIScreenListener config(Mint_StrategyOverhaul);

var config int PsiGiftChance;
var config name PsiPerkName;
var config array<name> NonEligibleClasses;

event OnInit(UIScreen Screen)
{
	class'MNT_Utility'.static.GCandValidationChecks();
	StartScreen(Screen);
}
// --------------------------------------------------------------------------
event OnReceiveFocus(UIScreen Screen)
{
	StartScreen(Screen);
}

// --------------------------------------------------------------------------

function StartScreen(UIScreen Screen){

	local array<XComGameState_Unit> Soldiers;
	local XComGameState_Unit Unit;

	Soldiers = `XCOMHQ.GetSoldiers();
	foreach Soldiers(Unit)
	{
		if (default.NonEligibleClasses.Find(Unit.GetSoldierClassTemplateName()) != INDEX_NONE)
			continue;
		if(!Unit.bRolledForPsiGift && Unit.GetSoldierRank() > 0)
			CheckForTheGift(Unit);
	}

}

function CheckForTheGift(XComGameState_Unit Unit){

	local XComGameStateHistory History;
	local XComGameState_Unit UpdatedUnit;
	local XComGameState_Unit_Additional ExtraState;
	local XComGameStateContext_ChangeContainer ChangeContainer;
	local XComGameState UpdateState;
	local int PsiRoll;
	local SoldierClassAbilityType Ability;
	local ClassAgnosticAbility NewPsionAbility;

	// This unit hasn't rolled for the Gift yet and isn't a rookie
	History = `XCOMHISTORY;
	ChangeContainer = class'XComGameStateContext_ChangeContainer'.static.CreateEmptyChangeContainer("Testing for Psionic capability");
	UpdateState = History.CreateNewGameState(true, ChangeContainer);
	UpdatedUnit = XComGameState_Unit(UpdateState.CreateStateObject(class'XComGameState_Unit', Unit.ObjectID));

	//Set the Gift to false in case someone else was messing with it...?
	UpdatedUnit.bHasPsiGift = false;
	UpdatedUnit.bRolledForPsiGift = false;

	//ROLL!
	PsiRoll = `SYNC_RAND(100);

	//TA-DA! Psionically capable!
	if(PsiRoll < default.PsiGiftChance)
	{
		UpdatedUnit.bHasPsiGift = true;

		//Make it more obvious on future looksiebacksies
		Ability.AbilityName = PsiPerkName;
		Ability.ApplyToWeaponSlot = eInvSlot_Unknown;
		Ability.UtilityCat = '';
		NewPsionAbility.AbilityType = Ability;
		NewPsionAbility.iRank = 0;
		NewPsionAbility.bUnlocked = true;
		UpdatedUnit.AWCAbilities.AddItem(NewPsionAbility);

		ExtraState = class'MNT_Utility'.static.GetExtraComponent(Unit);

		if(ExtraState == none)
		{
			//Add a LatentPsionic Component
			ExtraState = XComGameState_Unit_Additional(UpdateState.CreateStateObject(class'XComGameState_Unit_Additional'));
			ExtraState.InitComponent();
			UpdatedUnit.AddComponentObject(ExtraState);
		}
		else
			ExtraState = XComGameState_Unit_Additional(UpdateState.CreateStateObject(class'XComGameState_Unit_Additional', ExtraState.ObjectID));

		
	}

	//Either way, set psi roll to true and add the states
	UpdatedUnit.bRolledForPsiGift = true;
	UpdateState.AddStateObject(UpdatedUnit);
	
	if(UpdatedUnit.bHasPsiGift){
		UpdateState.AddStateObject(ExtraState);
		UIPsiTestingComplete(UpdatedUnit);
	}

	`GAMERULES.SubmitGameState(UpdateState);
}


simulated function UIPsiTestingComplete(XComGameState_Unit Unit)
{
	local XComHQPresentationLayer HQPres;
	local UIAlert_IsPsionic Alert;

	HQPres = `HQPRES;

	Alert = HQPres.Spawn(class'UIAlert_IsPsionic', `HQPres);
	Alert.UnitState = Unit;
	Alert.eAlertName = 'eAlert_SoldierShakenRecovered';
	HQPres.ScreenStack.Push(Alert);
}



defaultproperties
{
	ScreenClass = UIFacility_PsiLab;
}