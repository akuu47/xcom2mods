class X2WeaponSetTemplate extends X2PairedWeaponTemplate;

var array<EInventorySlot> PairedSlots;
var array<name> PairedTemplateNames;

function SetEquipped(XComGameState_Item ItemState, XComGameState_Unit UnitState, XComGameState NewGameState)
{
	local X2ItemTemplate PairedItemTemplate;
	local XComGameState_Item PairedItem, RemoveItem;
	local int i;

	for (i = 0; i < PairedTemplateNames.Length; i++)
	{
		//`LOG("index:" @ i,,'USSWOTC');
		if (PairedTemplateNames[i] != '')
		{
			//`LOG("PairedTemplateNames[" $ i $ "]:" @ PairedTemplateNames[i],,'USSWOTC');
			RemoveItem = UnitState.GetItemInSlot(PairedSlots[i], NewGameState);
			if (RemoveItem != none)
			{
				if (UnitState.RemoveItemFromInventory(RemoveItem, NewGameState))
				{
					NewGameState.RemoveStateObject(RemoveItem.ObjectID);
				}
				else
				{
					`RedScreen("Unable to remove item" @ RemoveItem.GetMyTemplateName() @ "in PairedSlot" @ PairedSlot @ "so paired item equip will fail -jbouscher / @gameplay");
				}
			}
			PairedItemTemplate = class'X2ItemTemplateManager'.static.GetItemTemplateManager().FindItemTemplate(PairedTemplateNames[i]);
			//`LOG("PairedItemTemplate.DataName:" @ PairedItemTemplate.DataName,,'USSWOTC');
			if (PairedItemTemplate != none)
			{
				PairedItem = PairedItemTemplate.CreateInstanceFromTemplate(NewGameState);
				//NewGameState.AddStateObject(PairedItem);
				PairedItem.WeaponAppearance = ItemState.WeaponAppearance; // Copy appearance data
				//`LOG("Attempting to shove" @ PairedItem.GetMyTemplateName() @ "which belongs in slot" @ X2EquipmentTemplate(PairedItem.GetMyTemplate()).InventorySlot @ "into slot" @ PairedSlots[i],,'USSWOTC');
				UnitState.AddItemToInventory(PairedItem, PairedSlots[i], NewGameState);
				if (UnitState.GetItemInSlot(PairedSlots[i], NewGameState, true).ObjectID != PairedItem.ObjectID)
				{
					//`LOG("Tried to add" @ PairedItem.GetMyTemplateName() @ "with ObjectID" @ PairedItem.ObjectID @ "to" @ PairedSlots[i] @ "but" @ UnitState.GetItemInSlot(PairedSlots[i], NewGameState, true).GetMyTemplateName() @ "with ObjectID" @ UnitState.GetItemInSlot(PairedSlots[i], NewGameState, true).ObjectID @ "was already there.",,'USSWOTC');
					`RedScreen("Created a paired item ID" @ PairedItem.ObjectID @ "but we could not add it to the unit's inventory, destroying it instead -jbouscher / @gameplay");
					NewGameState.PurgeGameStateForObjectID(PairedItem.ObjectID);
				}
			}
		}
	}
}

function SetUnEquipped(XComGameState_Item ItemState, XComGameState_Unit UnitState, XComGameState NewGameState)
{
	local XComGameState_Item PairedItem;
	local XGWeapon VisWeapon;
	local int i;

	for (i = 0; i < PairedTemplateNames.Length; i++)
	{
		PairedItem = UnitState.GetItemInSlot(PairedSlots[i], NewGameState);
		if (PairedItem != none && PairedItem.GetMyTemplateName() == PairedTemplateNames[i])
		{
			if (UnitState.RemoveItemFromInventory(PairedItem, NewGameState))
			{
				VisWeapon = XGWeapon(PairedItem.GetVisualizer());
				if (VisWeapon != none && VisWeapon.UnitPawn != none)
				{
					VisWeapon.UnitPawn.DetachItem(VisWeapon.GetEntity().Mesh);
				}
				NewGameState.RemoveStateObject(PairedItem.ObjectID);
			}
			else
			{
				`assert(false);
			}
		}
	}
}

DefaultProperties
{
	OnEquippedFn = SetEquipped;
	OnUnequippedFn = SetUnEquipped;
}