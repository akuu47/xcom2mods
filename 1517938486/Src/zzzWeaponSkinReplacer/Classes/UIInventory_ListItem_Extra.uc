class UIInventory_ListItem_Extra extends UIInventory_ListItem;	

var localized string DeleteButtonText;
var localized string UndeleteButtonText;

var bool bShouldDelete;

/*
This class is responsible for creating each individual List Item in the Engineering's Inventory List.
It has some differences from the original:
- It has a new bShouldDelete variable for tracking whether this List Item is marked for deletion or not.
- Some of the `InitInventoryListItem` functions are changed, since this List Item class is custom built only for the Engineering Inventory, and nothing else.
*/

simulated function UIInventory_ListItem InitInventoryListItem_Extra(X2ItemTemplate InitTemplate, 
															  int InitQuantity, 
															  StateObjectReference InitItemRef,
															  bool InitShouldDelete)
{
	// Set data before calling super, so that it's available in the initialization. 
	ItemTemplate = InitTemplate;
	Quantity = InitQuantity;
	ItemRef = InitItemRef;
	bShouldDelete = InitShouldDelete;
	InitListItem();

	//	If the item was already marked as Hidden before
	if (bShouldDelete)
	{
		// Add green "UNHIDE" button.
		SetConfirmButtonStyle(eUIConfirmButtonStyle_Default, default.UndeleteButtonText, 40, 0, OnSingleclickConfirmButton, OnDoubleclickConfirmButton);
		ConfirmButton.SetBad(false);
	}
	else
	{	
		//	Add red "HIDE" button.
		SetConfirmButtonStyle(eUIConfirmButtonStyle_Default, default.DeleteButtonText, 40, 0, OnSingleclickConfirmButton, OnDoubleclickConfirmButton);
		ConfirmButton.SetBad(true);	//	Make the "DELETE" button red.
	}
	
	//Create all of the children before realizing, to be sure they can receive info. 
	RealizeGoodState();
	RealizeAttentionState();
	RealizeBadState();
	RealizeDisabledState();

	return self;
}

// These two functions are called when the player clicks or double clicks the "DELETE" button.
simulated function OnSingleclickConfirmButton(UIButton Button)
{
	//`LOG("Single click: " @ ItemTemplate.FriendlyName,, 'WSR1');

	ButtonClicked(Button);
}

simulated function OnDoubleclickConfirmButton(UIButton Button)
{
	//`LOG("Double click: " @ ItemTemplate.FriendlyName,, 'WSR1');

	ButtonClicked(Button);
}

//	This function is called whenever the player clicks on the "DELETE" button.
//	It flips the "bShouldDelete" value, changes the color of the button and its text, so that the button functions like a toggle.
simulated function ButtonClicked(UIButton Button)
{
	if (bShouldDelete) 
	{
		`LOG("Item no longer marked: " @ ItemTemplate.FriendlyName,, 'IRIHIDEITEMS');
		bShouldDelete = false;
		ConfirmButton.SetText(default.DeleteButtonText);
		ConfirmButton.SetBad(true);
		RefreshConfirmButtonVisibility();
	}
	else 
	{	
		`LOG("Item marked: " @ ItemTemplate.FriendlyName,, 'IRIHIDEITEMS');
		bShouldDelete = true;
		ConfirmButton.SetText(default.UndeleteButtonText);
		ConfirmButton.SetBad(false);
		RefreshConfirmButtonVisibility();
	}
	//`XSTRATEGYSOUNDMGR.PlaySoundEvent("BuildItem");
	`XSTRATEGYSOUNDMGR.PlaySoundEvent("Play_MenuSelect");
}

//	This function refreshes the "DELETE" button whenever the player clicks on it.
simulated function RefreshConfirmButtonVisibility()
{
    if( ConfirmButton != none )
    {
        if( bIsFocused )
        {
            // initially it seems as though the visible flag gets stuck to true when it hasn't displayed yet. Turn off and on again.
            ConfirmButton.SetVisible(false);
            ConfirmButton.SetVisible(!bIsBad && !bDisabled);
            if( bIsBad || bDisabled )
            {
                SetRightColPadding( AttentionIconPadding + ConfirmButtonStoredRightCol );
            }
            else
            {
                SetRightColPadding(ConfirmButton.Width + ConfirmButtonArrowWidth + AttentionIconPadding + ConfirmButtonStoredRightCol);
            }
            if( `ISCONTROLLERACTIVE )
            {
                ConfirmButton.OnReceiveFocus();
            }
        }
        else
        {
			//	This is the only difference from the original: we keep the button visible even if the player is not hovering over the List Item
			//	But only if the List Item is marked for deletion.
			if (bShouldDelete) ConfirmButton.SetVisible(true);
			else ConfirmButton.SetVisible(false);

            SetRightColPadding(ConfirmButtonStoredRightCol + AttentionIconPadding);
            if( `ISCONTROLLERACTIVE )
            {
                ConfirmButton.OnLoseFocus();
            }
        }
    }
    else
    {
        SetRightColPadding(ConfirmButtonStoredRightCol + AttentionIconPadding);
    }

}

//	This function triggers when the list item is "removed", which naturally happens when the player leaves the Engineering Inventory Screen.
/*
simulated event Removed()
{	
	//`LOG("Removed triggered for" @ ItemTemplate.FriendlyName @ " Item Disabled: " @ bShouldDelete,, 'WSR1');

	//	Delete the item from HQ inventory if it was marked for deleteion.
	if (bShouldDelete) DeleteThisItemFromInventory();
}*/
/*
simulated function DeleteThisItemFromInventory()
{
	local XComGameState						NewGameState;
	local XComGameStateHistory				LocHistory;
	local XComGameState_HeadquartersXCom	XComHQ_Local;
	local bool								RemovedSomethingThisTime;
	local bool								bWasInfiniteItem;
	
	//`LOG("Removing item from HQ Inventory: " @ LocItemTemplate.FriendlyName,, 'WSR1');

	LocHistory = `XCOMHISTORY;
	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("IRIDAR Removing unwanted weapons");
	XComHQ_Local = XComGameState_HeadquartersXCom(LocHistory.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
	XComHQ_Local = XComGameState_HeadquartersXCom(NewGameState.CreateStateObject(class'XComGameState_HeadquartersXCom', XComHQ_Local.ObjectID));
	NewGameState.AddStateObject(XComHQ_Local);

	//	Infinite items cannot be deleted from HQ inventory through normal means.
	//	So as a hack, we make the item not infinite before deleting it.
	if (ItemTemplate.bInfiniteItem)
	{
		ItemTemplate.bInfiniteItem = false;
		bWasInfiniteItem = true;
	}

	RemovedSomethingThisTime = XComHQ_Local.RemoveItemFromInventory(NewGameState, ItemRef, Quantity);

	//	Don't actually wanna break anything, so make the item infinite again, if it was before.
	if (bWasInfiniteItem)
	{
		ItemTemplate.bInfiniteItem = true;
	}

	if (RemovedSomethingThisTime) `XCOMGAME.GameRuleset.SubmitGameState(NewGameState); //LocHistory.AddGameStateToHistory(NewGameState);
	else LocHistory.CleanupPendingGameState(NewGameState);	//	otherwise scrap the newly created gamestate
}*/