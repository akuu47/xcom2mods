class X2Effect_LoadExtraAbilities extends X2Effect_Persistent;

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local XComGameState_Unit NewUnit;

	NewUnit = XComGameState_Unit(kNewTargetState);

	if (NewUnit == none)
		return;

	if (SkipForDirectMissionTransfer(ApplyEffectParameters))
		return;

	//Add extra abilities if they exist
	if(class'MNT_Utility'.static.GetExtraComponent(NewUnit) != none)
		AddExtraAbilities(NewUnit, NewGameState, NewEffectState);

}

simulated function AddExtraAbilities(XComGameState_Unit NewUnit, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local array <SoldierClassAbilityType> ToInitialize;
	local XComGameState_Unit_Additional ExtraState;
	local XComGameState_Item kWeapon;
	local int i;
	local X2AbilityTemplateManager AbilityTemplateMan;
	local X2AbilityTemplate AbilityTemplate;
	local name AbilityName;

	ExtraState = class'MNT_Utility'.static.GetExtraComponent(NewUnit);

	if (ExtraState == none)
		return;

	ToInitialize = ExtraState.GetAllPerksToInit();
	CheckForDuplicates(NewUnit, ToInitialize);

	AbilityTemplateMan = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();

	// Add all non-psionic perks
	for(i = 0; i < ToInitialize.Length; ++i)
	{
		AbilityName = ToInitialize[i].AbilityName;
		AbilityTemplate = AbilityTemplateMan.FindAbilityTemplate(AbilityName);

		switch(ToInitialize[i].ApplyToWeaponSlot){

			case eInvSlot_PrimaryWeapon:
				kWeapon = NewUnit.GetItemInSlot(eInvSlot_PrimaryWeapon);
				InitAbility(AbilityTemplate, NewUnit, NewGameState, kWeapon.GetReference());
				break;
			case eInvSlot_SecondaryWeapon:
				kWeapon = NewUnit.GetItemInSlot(eInvSlot_SecondaryWeapon);
				InitAbility(AbilityTemplate, NewUnit, NewGameState, kWeapon.GetReference());
				break;
			case eInvSlot_Unknown:
			default:
				InitAbility(AbilityTemplate, NewUnit, NewGameState);
				break;
		}
	}

	//if Psion, add psion abilities
	if(class'MNT_Utility'.static.IsPsion(NewUnit))
		AddPsiAbilities(NewUnit, NewGameState, NewEffectState);
}

simulated function AddPsiAbilities(XComGameState_Unit NewUnit, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local X2WeaponTemplate WeaponTemplate;
	local X2ItemTemplateManager ItemTemplateMgr;
	local X2ItemTemplate ItemTemplate;
	local XComGameState_Item ItemState;
	local X2AbilityTemplateManager AbilityTemplateMan;
	local X2AbilityTemplate AbilityTemplate;
	local name AbilityName;
	local XGUnit UnitVisualizer;
	local int i;
	local XComGameState_Unit_Additional ExtraState;

	ItemTemplateMgr = class'X2ItemTemplateManager'.static.GetItemTemplateManager();
	ItemTemplate = ItemTemplateMgr.FindItemTemplate('InvisiblePsiWeapon');
		
	WeaponTemplate = X2WeaponTemplate(ItemTemplate);

	// No items to merge with, so create the item
	ItemState = WeaponTemplate.CreateInstanceFromTemplate(NewGameState);
	//ItemState.Quantity = 0;  // Flag as not a real item

	// Temporarily turn off equipment restrictions so we can add the item to the unit's inventory
	NewUnit.bIgnoreItemEquipRestrictions = true;
	NewUnit.AddItemToInventory(ItemState, eInvSlot_Utility, NewGameState);
	NewUnit.bIgnoreItemEquipRestrictions = false;

	// Update the unit's visualizer to include the new item
	// Note: Normally this should be done in an X2Action, but since this effect is normally used in
	// a PostBeginPlay trigger, we just apply the change immediately.
	UnitVisualizer = XGUnit(NewUnit.GetVisualizer());
	UnitVisualizer.ApplyLoadoutFromGameState(NewUnit, NewGameState);

	NewEffectState.CreatedObjectReference = ItemState.GetReference();

	// Add psi abilities
	ExtraState = class'MNT_Utility'.static.GetExtraComponent(NewUnit);
	AbilityTemplateMan = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();

	//retrieve the Psion abilities from the Psion state and add em
	for(i = 0; i < ExtraState.PsionAbilities.Length; ++i)
	{
		AbilityName = ExtraState.PsionAbilities[i].AbilityName;
		AbilityTemplate = AbilityTemplateMan.FindAbilityTemplate(AbilityName);
		InitAbility(AbilityTemplate, NewUnit, NewGameState, ItemState.GetReference());
	}
}


// Check for ability overrides and additional abilities before initializing
simulated function InitAbility(X2AbilityTemplate AbilityTemplate, XComGameState_Unit NewUnit, XComGameState NewGameState, optional StateObjectReference ItemRef, optional StateObjectReference AmmoRef)
{
	local XComGameState_Ability OtherAbility;
	local StateObjectReference AbilityRef;
	local XComGameStateHistory History;
	local X2AbilityTemplateManager AbilityTemplateMan;
	local name AdditionalAbility;

	History = `XCOMHISTORY;
	AbilityTemplateMan = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();

	// Check for ability overrides
	foreach NewUnit.Abilities(AbilityRef)
	{
		OtherAbility = XComGameState_Ability(History.GetGameStateForObjectID(AbilityRef.ObjectID));

		if (OtherAbility.GetMyTemplate().OverrideAbilities.Find(AbilityTemplate.DataName) != INDEX_NONE)
			return;
	}
	
	AbilityRef = `TACTICALRULES.InitAbilityForUnit(AbilityTemplate, NewUnit, NewGameState, ItemRef, AmmoRef);

	// Add additional abilities
	foreach AbilityTemplate.AdditionalAbilities(AdditionalAbility)
	{
		AbilityTemplate = AbilityTemplateMan.FindAbilityTemplate(AdditionalAbility);

		// Check for overrides of the additional abilities
		foreach NewUnit.Abilities(AbilityRef)
		{
			OtherAbility = XComGameState_Ability(History.GetGameStateForObjectID(AbilityRef.ObjectID));

			if (OtherAbility.GetMyTemplate().OverrideAbilities.Find(AbilityTemplate.DataName) != INDEX_NONE)
				return;
		}

		AbilityRef = `TACTICALRULES.InitAbilityForUnit(AbilityTemplate, NewUnit, NewGameState, ItemRef, AmmoRef);
	}
}

simulated function OnEffectRemoved(const out EffectAppliedData ApplyEffectParameters, XComGameState NewGameState, bool bCleansed, XComGameState_Effect RemovedEffectState)
{
	if (RemovedEffectState.CreatedObjectReference.ObjectID > 0)
		NewGameState.RemoveStateObject(RemovedEffectState.CreatedObjectReference.ObjectID);
}

function UnitEndedTacticalPlay(XComGameState_Effect EffectState, XComGameState_Unit UnitState)
{
	local XComGameState NewGameState;

	NewGameState = UnitState.GetParentGameState();

	if (EffectState.CreatedObjectReference.ObjectID > 0)
		NewGameState.RemoveStateObject(EffectState.CreatedObjectReference.ObjectID);
}

simulated function bool SkipForDirectMissionTransfer(const out EffectAppliedData ApplyEffectParameters)
{
	local XComGameState_Ability AbilityState;
	local XComGameStateHistory History;
	local XComGameState_BattleData BattleData;
	local int Priority;

	History = `XCOMHISTORY;

	BattleData = XComGameState_BattleData(History.GetSingleGameStateObjectForClass(class'XComGameState_BattleData'));
	if (!BattleData.DirectTransferInfo.IsDirectMissionTransfer)
		return false;

	AbilityState = XComGameState_Ability(History.GetGameStateForObjectID(ApplyEffectParameters.AbilityStateObjectRef.ObjectID));
	if (!AbilityState.IsAbilityTriggeredOnUnitPostBeginTacticalPlay(Priority))
		return false;

	return true;
}

// make sure we're not reinstantiating something already in the perk tree
simulated function CheckForDuplicates(XComGameState_Unit Unit, array<SoldierClassAbilityType> ToInit){

	local array <SoldierClassAbilityType> Earned;
	local SoldierClassAbilityType a, ab;

	Earned = Unit.GetEarnedSoldierAbilities();

	foreach Earned(a){
		foreach ToInit(ab){
			if(a.AbilityName == ab.AbilityName)
				ToInit.RemoveItem(ab);
		}
	}

}