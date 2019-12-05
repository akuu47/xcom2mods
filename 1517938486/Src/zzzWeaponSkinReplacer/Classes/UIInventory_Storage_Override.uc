class UIInventory_Storage_Override extends UIInventory_Storage dependson(XComGameState_HiddenItems);

var localized string ConfirmExitTitle;
var localized string ConfirmExitBody;
var localized string ConfirmExitOK;
var localized string ConfirmExitCancel;

var XComGameState_HiddenItems HiddenItemsStateObject;
var XComGameState NewGameState;

const bLog = false;

simulated function XComGameState_HiddenItems GetOrCreateHiddenItemList()
{
	local XComGameState_HiddenItems NewStateObject;

	`LOG("Get or create Hidden Item List Object.", bLog, 'IRIHIDEITEMS');

	NewStateObject = XComGameState_HiddenItems(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_HiddenItems'));

	if (NewStateObject == none)
	{
		`LOG("It doesn't exist in history yet, creating new one.", bLog, 'IRIHIDEITEMS');
		NewStateObject = XComGameState_HiddenItems(NewGameState.CreateNewStateObject(class'XComGameState_HiddenItems'));

		return NewStateObject;
	}

	NewStateObject = XComGameState_HiddenItems(NewGameState.ModifyStateObject( class'XComGameState_HiddenItems', NewStateObject.ObjectID ));

	return NewStateObject;
}

/*
This class is responsible for building the list of items you see on the Engineering Inventory screen.
The override class is similar to the original.
The main differences are:
- We allow infinite items to be shown.
- We use a different class for individual list items with some new special functions.
- We use a new type of State Object to store the list of Hidden Items.
*/

simulated function PopulateData()
{
	local XComGameState_Item		Item;
	local X2ItemTemplate			ItemTemplate;
	local StateObjectReference		ItemRef;
	local UIInventory_ListItem_Extra		ListItem;
	local array<XComGameState_Item> InventoryItems;
	local XComGameStateHistory		LocHistory;
	local HiddenItem				sHiddenItem;

	//	Thanks, Xymanek
	//	Calling specifically the super from `UIInventory` prevents from building the list twice.
	super(UIInventory).PopulateData();

	LocHistory = `XCOMHISTORY;

	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("IRIDAR Removing unwanted weapons");
	HiddenItemsStateObject = GetOrCreateHiddenItemList();

	`LOG("Displaying inventory list.", bLog, 'IRIHIDEITEMS');

	//	Build a list of items currently in HQ Inventory.
	foreach XComHQ.Inventory(ItemRef)
	{
		Item = XComGameState_Item(LocHistory.GetGameStateForObjectID(ItemRef.ObjectID));
		if (Item == None || Item.GetMyTemplate() == None)
			continue;

		ItemTemplate = Item.GetMyTemplate();

		if(!Item.HasBeenModified() &&			// Only allow weapons without weapon upgrades
			!ItemTemplate.HideInInventory &&	// Only items that are not set to be hidden.
			ItemTemplate.HasDisplayData() &&	// Only items that have localization
			!XComHQ.IsTechResearched(ItemTemplate.HideIfResearched) &&	// Only items that are not supposed to be hidden due to research.
			!XComHQ.HasItemByName(ItemTemplate.HideIfPurchased))		// Only items that are not supposed to be hidden due to another item being purchased.
		{
			InventoryItems.AddItem(Item);
		}
	}

	//	Sort it.
	InventoryItems.Sort(SortItemsAlpha);

	//	Display it.
	foreach InventoryItems(Item)
	{
		//	Here we call a special UIInventory_ListItem_Extra instead of the usual UIInventory_ListItem.
		Spawn(class'UIInventory_ListItem_Extra', List.itemContainer).InitInventoryListItem_Extra(Item.GetMyTemplate(), Item.Quantity, Item.GetReference(), false);
	}

	//	Then display a list of Hidden items. 
	foreach HiddenItemsStateObject.HiddenItems(sHiddenItem)
	{
		//	Have to grab the Item State to get the Item Template from it. Templates stored in State Objects don't persist through Save/Load.
		Item = XComGameState_Item(LocHistory.GetGameStateForObjectID(sHiddenItem.ItemRef.ObjectID));

		Spawn(class'UIInventory_ListItem_Extra', List.itemContainer).InitInventoryListItem_Extra(Item.GetMyTemplate(), sHiddenItem.Quantity, sHiddenItem.ItemRef, true);
	}
	
	if(List.ItemCount > 0)
	{
		TitleHeader.SetText(m_strTitle, "");
		ListItem = UIInventory_ListItem_Extra(List.GetItem(0));
		PopulateItemCard(ListItem.ItemTemplate, ListItem.ItemRef);
	}
	else
	{
		TitleHeader.SetText(m_strTitle, m_strNoLoot);
		SetCategory("");
		SetBuiltLabel("");
	}
}

/*

var UIButton CancelConstructionButton;

CancelConstructionButton = Spawn(class'UIButton', self);
CancelConstructionButton.bIsNavigable = false;
CancelConstructionButton.InitButton('OverlayCancelConstructionButton', strButton, OnCancelConstruction, eUIButtonStyle_BUTTON_WHEN_MOUSE);
CancelConstructionButton.Hide(); // start off hidden
CancelConstructionButton.SetTooltipText(TooltipCancelConstruction);
Movie.Pres.m_kTooltipMgr.TextTooltip.SetUsePartialPath(CancelConstructionButton.CachedTooltipId, true);
CancelConstructionButton.OnMouseEventDelegate = OnChildMouseEvent;

*/

simulated function CloseScreen()
{	
	local UIInventory_ListItem_Extra		ListItem;
	local UIPanel							Panel;
	local XComGameState_HeadquartersXCom	XComHQ_Local;
	local XComGameStateHistory				LocHistory;
	local bool								bWasInfiniteItem;
	local XComGameState_Item				ItemState;
	local bool								bChangedSomething;

	`LOG("Exiting inventory screen.", bLog, 'IRIHIDEITEMS');
	LocHistory = `XCOMHISTORY;

	XComHQ_Local = XComGameState_HeadquartersXCom(NewGameState.ModifyStateObject(class'XComGameState_HeadquartersXCom', `XCOMHQ.ObjectID));
	//XComHQ_Local = XComGameState_HeadquartersXCom(NewGameState.CreateStateObject(class'XComGameState_HeadquartersXCom', XComHQ_Local.ObjectID));
						
	//	Go through each individual List Item that was on the screen
	foreach List.ItemContainer.ChildPanels(Panel)
	{
		ListItem = UIInventory_ListItem_Extra(Panel);

		if (ListItem != none)
		{
			//	Hide items that were newly marked as Hidden
			if (ListItem.bShouldDelete && !HiddenItemsStateObject.IsHiddenItem(ListItem.ItemRef))
			{
				`LOG("New item marked and should be hidden: " @ ListItem.ItemTemplate.FriendlyName, bLog, 'IRIHIDEITEMS');

				//	Infinite items don't seem to be removing from the inventory properly
				//	so as a hack I make them not infinite before removing them.
				bWasInfiniteItem = false;
				if (ListItem.ItemTemplate.bInfiniteItem)
				{
					ListItem.ItemTemplate.bInfiniteItem = false;
					bWasInfiniteItem = true;
				}

				if (XComHQ_Local.RemoveItemFromInventory(NewGameState, ListItem.ItemRef, ListItem.Quantity))
				{
					`LOG("Removed the item successfully:" @ ListItem.ItemTemplate.FriendlyName @ ListItem.Quantity, bLog, 'IRIHIDEITEMS');
					HiddenItemsStateObject.AddHiddenItem(ListItem.ItemTemplate.DataName, ListItem.ItemRef, ListItem.Quantity);
					bChangedSomething = true;
				}
				//	Restore infinite status.
				if (bWasInfiniteItem)
				{
					ListItem.ItemTemplate.bInfiniteItem = true;
				}
			}
			//	Unhide items that are not supposed to be hidden
			if (!ListItem.bShouldDelete && HiddenItemsStateObject.IsHiddenItem(ListItem.ItemRef))
			{
				`LOG("This item was hidden and now should be unhidden: " @ ListItem.ItemTemplate.FriendlyName, bLog, 'IRIHIDEITEMS');

				ItemState = XComGameState_Item(LocHistory.GetGameStateForObjectID(ListItem.ItemRef.ObjectID));
				ItemState = XComGameState_Item(NewGameState.ModifyStateObject(class'XComGameState_Item', ItemState.ObjectID));

				ItemState.Quantity = HiddenItemsStateObject.GetHiddenItemQuantity(ListItem.ItemRef);

				XComHQ_Local.AddItemToHQInventory(ItemState);
				bChangedSomething = true;

				`LOG("Added item to inventory:" @ ListItem.ItemTemplate.FriendlyName @ ListItem.Quantity, bLog, 'IRIHIDEITEMS');
				HiddenItemsStateObject.RemoveHiddenItem(ListItem.ItemRef);
			}
		}
	}
	if (bChangedSomething) `XCOMGAME.GameRuleset.SubmitGameState(NewGameState);
	else LocHistory.CleanupPendingGameState(NewGameState);

	super.CloseScreen();
}
/*
//	This function triggers whenever the player presses some button.
simulated function bool OnUnrealCommand(int cmd, int arg)
{
	local bool bHandled;

	// Only pay attention to presses or repeats; ignoring other input types
	// NOTE: Ensure repeats only occur with arrow keys
	if ( !CheckInputIsReleaseOrDirectionRepeat(cmd, arg) )
		return false;

	bHandled = true;
	switch( cmd )
	{
		case class'UIUtilities_Input'.const.FXS_BUTTON_B:
		case class'UIUtilities_Input'.const.FXS_KEY_ESCAPE:
		case class'UIUtilities_Input'.const.FXS_R_MOUSE_DOWN:
			//The origianl function would exist the screen here, but we show a popup instead.
			//OnCancel();
			ShowConfirmExitPopup();
			break;
		case class'UIUtilities_Input'.const.FXS_BUTTON_START:
			`HQPRES.UIPauseMenu( ,true );
			break;
		default:
			bHandled = false;
			break;
	}

	return bHandled || super.OnUnrealCommand(cmd, arg);
}*/
/*
simulated function UpdateNavHelp()
{
	local UINavigationHelp	NavHelp;

	NavHelp = `HQPRES.m_kAvengerHUD.NavHelp;

	NavHelp.ClearButtonHelp();
	NavHelp.bIsVerticalHelp = `ISCONTROLLERACTIVE;
	//NavHelp.AddBackButton(CloseScreen);
	//	Click the "back arrow" nav button in the lower left corner of screen would normally
	//	cause us to exit the screen, but we show a popup instead.
	NavHelp.AddBackButton(ShowConfirmExitPopup);
}*/
/*
private function ShowConfirmExitPopup()
{
    local TDialogueBoxData dialog;
	local int iItemsToDelete;

	//	Check how many List Items are marked for deletion, if any.
//	iItemsToDelete = CalculateNumItemsToDelete();
	if (iItemsToDelete > 0)
	{
		//	Generate the popup window.
		dialog.eType = eDialog_Warning;
		dialog.strTitle = default.ConfirmExitTitle;
		dialog.strText = default.ConfirmExitBody $ iItemsToDelete;
		dialog.strAccept = default.ConfirmExitOK;
		dialog.strCancel = default.ConfirmExitCancel;
		dialog.fnCallback = DialogCallback;

		//	And show it.
		`HQPRES.UIRaiseDialog(dialog);
	}
	else OnCancel();
}

//	This function triggers when the player clicks one of the buttons in the popup window.
simulated private function DialogCallback(Name eAction)
{
    if (eAction == 'eUIAction_Accept')
    {
		//	If player clicked "OK", we call the original function for exiting the screen.
        OnCancel();
    }
    else
    {
        // do nothing
    }
}*/
/*
simulated function int CalculateNumItemsToDelete()
{
	local UIInventory_ListItem_Extra	ListItem;
	local UIPanel						Panel;
	local int							iItemsToDelete;

	//	Go through each individual List Item
	foreach List.ItemContainer.ChildPanels(Panel)
	{
		ListItem = UIInventory_ListItem_Extra(Panel);

		//	Increase the counter if it's marked for deletion.
		if (ListItem != none && ListItem.bShouldDelete)
		{
			iItemsToDelete++;
		}
	}
	return iItemsToDelete;
}*/