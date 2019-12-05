class Musashi_ConditionInvSlot extends X2Condition;

var EInventorySlot InventorySlot;

event name CallAbilityMeetsCondition(XComGameState_Ability kAbility, XComGameState_BaseObject kTarget)
{
	local XComGameState_Item SourceWeapon;

	SourceWeapon = kAbility.GetSourceWeapon();

	//`LOG("Musashi_ConditionInvSlot checking slot" @ SourceWeapon.InventorySlot,, 'TacticalSuppressors');
	
	if (!IsCorrectWeaponType(SourceWeapon)){
		//`LOG("Musashi_ConditionInvSlot wrong inventory slot" @ SourceWeapon.InventorySlot,, 'TacticalSuppressors');
		return 'AA_NoTargets';
	}

	return 'AA_Success'; 
}

function bool IsCorrectWeaponType(XComGameState_Item SourceWeapon) {
	if ( SourceWeapon == none ) { return false; }
	return (SourceWeapon.InventorySlot == InventorySlot);
}

DefaultProperties
{
	InventorySlot=eInvSlot_PrimaryWeapon
}