// from SPECTRUM GREEN

class X2Effect_ShowLaunchGrenade extends X2Effect_Persistent;

simulated function bool OnEffectTicked(const out EffectAppliedData ApplyEffectParameters, XComGameState_Effect kNewEffectState, XComGameState NewGameState, bool FirstApplication, XComGameState_Player Player)
{
	local XComGameStateHistory History;
	local XComGameState_Unit UnitState;
	local array<XComGameState_Item> ItemStates;
	local XComGameState_Item InventoryItem, WeaponState;
	local XComGameState_BattleData BattleData;
	local X2AbilityTemplateManager AbilityManager;
	local X2AbilityTemplate AbilityTemplate;
			
	AbilityManager = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();
	AbilityTemplate = AbilityManager.FindAbilityTemplate('LaunchGrenade');

	History = `XCOMHISTORY;

	// Check all of the unit's inventory items
	UnitState = XComGameState_Unit(History.GetGameStateForObjectID(ApplyEffectParameters.TargetStateObjectRef.ObjectID));
	ItemStates = UnitState.GetAllInventoryItems(NewGameState);
	WeaponState = UnitState.GetItemInSlot(eInvSlot_SecondaryWeapon);

	BattleData = XComGameState_BattleData(History.GetSingleGameStateObjectForClass(class'XComGameState_BattleData'));

	if(!BattleData.DirectTransferInfo.IsDirectMissionTransfer)
	{

		foreach ItemStates(InventoryItem) {
			if (InventoryItem.bMergedOut) 
				continue;

			if (X2GrenadeTemplate(InventoryItem.GetMyTemplate()) != none)
			{ 
				`TACTICALRULES.InitAbilityForUnit(AbilityTemplate, UnitState, NewGameState, WeaponState.GetReference(), InventoryItem.GetReference());
			}
		}
	}
	return false;
}