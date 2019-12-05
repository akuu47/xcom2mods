class XComGameState_HiddenItems extends XComGameState_BaseObject;

//	This is a new class of a State Object. 
//	It contains the array of items that have been removed from the HQ inventory, and also stores what quantity they had before being removed.
//	This way we can preserve the list of Removed Items in the game's saves.

struct HiddenItem
{
	var name					TemplateName;
	var StateObjectReference	ItemRef;
	var int						Quantity;
};
var public array<HiddenItem> HiddenItems;

simulated public function AddHiddenItem(name TemplateName, StateObjectReference ItemRef, int Quantity)
{
	local HiddenItem NewHiddenItem;

	NewHiddenItem.TemplateName = TemplateName;
	NewHiddenItem.ItemRef = ItemRef;
	NewHiddenItem.Quantity = Quantity;

	HiddenItems.AddItem(NewHiddenItem);
}

simulated public function array<name> GetHiddenItemNames()
{
	local int i;
	local array<Name> ReturnArray;

	for (i = 0; i < HiddenItems.Length; i++)
	{
		ReturnArray.AddItem(HiddenItems[i].TemplateName);
	}
	return ReturnArray;
}

simulated public function bool RemoveHiddenItem(StateObjectReference ItemRef)
{
	local int i;
	for (i = 0; i < HiddenItems.Length; i++)
	{
		if (HiddenItems[i].ItemRef.ObjectID == ItemRef.ObjectID)
		{
			HiddenItems.Remove(i, 1);
			return true;
		}
	}
	return false;
}

simulated public function bool IsHiddenItem(StateObjectReference ItemRef)
{
	local int i;
	for (i = 0; i < HiddenItems.Length; i++)
	{
		if (HiddenItems[i].ItemRef.ObjectID == ItemRef.ObjectID)
		{
			return true;
		}
	}
	return false;
}

simulated public function int GetHiddenItemQuantity(StateObjectReference ItemRef)
{
	local int i;
	for (i = 0; i < HiddenItems.Length; i++)
	{
		if (HiddenItems[i].ItemRef.ObjectID == ItemRef.ObjectID)
		{
			return HiddenItems[i].Quantity;
		}
	}
	return -1;
}