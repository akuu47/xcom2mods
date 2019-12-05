class X2Condition_ValidWeapon extends X2Condition;

// Variables to pass into the condition check:
var array<name>		ExcludedWeaponCategories;
var array<name>		AllowedWeaponCategories;

event name CallAbilityMeetsCondition(XComGameState_Ability kAbility, XComGameState_BaseObject kTarget)
{
	local XComGameStateHistory	History;
	local XComGameState_Unit	SourceUnit;
	local XComGameState_Item	InventoryItem;
	local EInventorySlot		InventorySlot;
	local X2WeaponTemplate		WeaponTemplate;
	local name					WeaponCategory;

	History = `XCOMHISTORY;
	SourceUnit = XComGameState_Unit(History.GetGameStateForObjectID(kAbility.OwnerStateObject.ObjectID));
	InventoryItem = XComGameState_Item(History.GetGameStateForObjectID(kAbility.SourceWeapon.ObjectID));
	InventorySlot = InventoryItem.InventorySlot;

	InventoryItem = SourceUnit.GetItemInSlot(InventorySlot);
	if (InventoryItem == none)
		return 'AA_WeaponIncompatible';

	WeaponTemplate = X2WeaponTemplate(InventoryItem.GetMyTemplate());
	if (WeaponTemplate == none)
		return 'AA_WeaponIncompatible';
	
	WeaponCategory = WeaponTemplate.WeaponCat;
	if (ExcludedWeaponCategories.Length > 0 && ExcludedWeaponCategories.find(WeaponCategory) != INDEX_NONE)
		return 'AA_WeaponIncompatible';
	
	if (AllowedWeaponCategories.Length > 0 && AllowedWeaponCategories.find(WeaponCategory) == INDEX_NONE)
		return 'AA_WeaponIncompatible';
	
	return 'AA_Success';
}
