class X2SoldierGTSUnlockTemplate extends X2SoldierUnlockTemplate;

var name AbilityName;
var EInventorySlot InventorySlot;

function OnSoldierUnlockPurchased(XComGameState NewGameState)
{
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameStateHistory History;
	local StateObjectReference CrewRef;
	local XComGameState_Unit UnitState, NewUnitState;

	History = `XCOMHISTORY;
	XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
	foreach XComHQ.Crew(CrewRef)
	{
		UnitState = XComGameState_Unit(History.GetGameStateForObjectID(CrewRef.ObjectID));
	    if (UnitState != none && UnlockAppliesToUnit(UnitState))
		{
			NewUnitState = XComGameState_Unit(NewGameState.ModifyStateObject(UnitState.Class, UnitState.ObjectID));
			UnlockGTSUnit(NewUnitState);
		}
	}
}

function OnSoldierAddedToCrew(XComGameState_Unit NewUnitState)
{
	if (UnlockAppliesToUnit(NewUnitState))
		UnlockGTSUnit(NewUnitState);
}

function UnlockGTSUnit(XComGameState_Unit UnitState)
{
	local SoldierClassAbilityType Unlock;
	local XComGameState_Unit UpdatedUnit;
	local XComGameState_Unit_Additional ExtraState;
	local XComGameState UpdateState;
	local XComGameStateContext_ChangeContainer ChangeContainer;

	Unlock.AbilityName = AbilityName;
	Unlock.ApplyToWeaponSlot = InventorySlot;
	Unlock.UtilityCat = '';

	ChangeContainer = class'XComGameStateContext_ChangeContainer'.static.CreateEmptyChangeContainer("GTS ability unlocked");
	UpdateState = `XCOMHISTORY.CreateNewGameState(true, ChangeContainer);
	UpdatedUnit = XComGameState_Unit(UpdateState.CreateStateObject(class'XComGameState_Unit', UnitState.ObjectID));

	ExtraState = class'MNT_Utility'.static.GetExtraComponent(UnitState);
	
	if(ExtraState == none)
	{
		//Add a Component
		ExtraState = XComGameState_Unit_Additional(UpdateState.CreateStateObject(class'XComGameState_Unit_Additional'));
		ExtraState.InitComponent();
		UpdatedUnit.AddComponentObject(ExtraState);
	}
	else
		ExtraState = XComGameState_Unit_Additional(UpdateState.CreateStateObject(class'XComGameState_Unit_Additional', ExtraState.ObjectID));

	ExtraState.GTSAbilities.AddItem(Unlock);

	UpdateState.AddStateObject(UpdatedUnit);
	UpdateState.AddStateObject(ExtraState);
	`GAMERULES.SubmitGameState(UpdateState);
}

