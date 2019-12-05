///
/// 
///
class xmf_ui_ListItem extends UIMechaListItem;

`define ClassName xmf_ui_ListItem
`include( UnrestrictedCustomization\Src\UnrestrictedCustomization\macros.uci )

//======================================================================================================================
// FIELDS

var private UiList List;

var private bool RightButtonFocused;

var privatewrite xmf_ui_NavigationNode NavigationNode;

//======================================================================================================================
// PROPERTIES

public function xmf_ui_ListItem SetLabel( string _value ) {
	Desc.htmlText = _value;
	return self;
}

//======================================================================================================================
// CTOR

///
/// Instantiates this class.
///
public static function xmf_ui_ListItem CreateListItem(
	UiList _parentList
) {
	return ListItem( class'xmf_ui_ListItem', _parentList);
}

protected static function xmf_ui_ListItem ListItem(
	class<xmf_ui_ListItem> _class,
	UiList _parentList
) {
	local xmf_ui_ListItem this;
	this = _parentList.Spawn( _class, _parentList.ItemContainer );
	this.InitListItem2(_parentList);
	return this;
}

private function InitListItem2( UiList _parentList ) {
	List = _parentList;
	NavigationNode = class'xmf_ui_NavigationNode'.static.CreateNavigationNode(self);
	super.InitListItem('', List.Width);
}

//======================================================================================================================
// HANDLERS / CALLBACKS

/*override*/ simulated function OnReceiveFocus() {
	if( bIsFocused ) return;
	super.OnReceiveFocus();
	NavigationNode.HandlePanelReceivedFocus();
	List.SetSelectedItem(self);
}

/*override*/ simulated function OnLoseFocus() {
	//local UiButton _oldButton;
	if( Button != none ) {
		Button.OnLoseFocus();
		/*
		// replace the button because
		// when clicked, button goes in stupid highlighted state than cannot be disabled...
		_oldButton = Button;
		_oldButton.Remove();
		Button = Spawn(class'UIButton', self);
		Button.bAnimateOnInit = false;
		Button.bIsNavigable = false;
		Button.InitButton('ButtonMC', "", OnButtonClickDelegate);
		Button.SetX(width - 150);
		Button.SetY(0);
		Button.SetHeight(34);
		Button.MC.SetNum("textY", 2);
		Button.OnSizeRealized = UpdateButtonX;
		Button.SetText(_oldButton.Text);
		*/
	}
	RightButtonFocused = false;
	super.OnLoseFocus();
}



public function EnsureVisible() {
	//local float _itemY; // relative to screen
	local float _scrollPercent;

	/*
	// leave if visible
	if( List.Scrollbar == none ) return;
	_itemY = Y + List.ItemContainer.Y;
	if( _itemY >= List.Mask.Y && _itemY+Height <= List.Mask.Y+List.Mask.Height ) return;

	// leave if mouse on (we don't want to scroll when use is trying to point the item...)
	if( class'xmf_ui_Util'.static.IsUnderMouse(self) ) return;
	*/

	_scrollPercent = float( List.GetItemIndex(self) ) / float( List.ItemCount-1 );
	List.Scrollbar.SetThumbAtPercent(_scrollPercent);
}


/*override*/ simulated function bool HandleCustomControls(int _cmd, int _arg) {
	switch(Type) {
		case EUILineItemType_Button: return HandleDoubleButtonControls(_cmd, _arg);
		case EUILineItemType_Dropdown: return Dropdown.OnUnrealCommand(_cmd, _arg);
		case EUILineItemType_Checkbox: return Checkbox.OnUnrealCommand(_cmd, _arg);
		case EUILineItemType_Slider: return Slider.OnUnrealCommand(_cmd, _arg);
		case EUILineItemType_Spinner: return Spinner.OnUnrealCommand(_cmd, _arg);
		case EUILineItemType_SpinnerAndButton: return Spinner.OnUnrealCommand(_cmd, _arg);
	}
	return false; // do not call super
}
private function bool HandleDoubleButtonControls( int _cmd, int _arg ) {
	switch(_cmd) {
		case class'UIUtilities_Input'.const.FXS_ARROW_LEFT:
		case class'UIUtilities_Input'.const.FXS_DPAD_LEFT:
		case class'UIUtilities_Input'.const.FXS_VIRTUAL_LSTICK_LEFT:
			if( RightButtonFocused ) {
				RightButtonFocused = false;
				Button.OnLoseFocus();
			}
			return true;
		case class'UIUtilities_Input'.const.FXS_ARROW_RIGHT:
		case class'UIUtilities_Input'.const.FXS_DPAD_RIGHT:
		case class'UIUtilities_Input'.const.FXS_VIRTUAL_LSTICK_RIGHT:
			if( ! RightButtonFocused ) {
				RightButtonFocused = true;
				Button.OnReceiveFocus();
			}
			return true;
	}
	return false;
}

/*override*/ simulated function bool HandleClickableControls( int _cmd, int _arg ) {
	switch(_cmd) {
		case class'UIUtilities_Input'.const.FXS_KEY_ENTER:
		case class'UIUtilities_Input'.const.FXS_KEY_SPACEBAR:
		case class'UIUtilities_Input'.const.FXS_BUTTON_A:
			if( RightButtonFocused ) {
				OnButtonClickedCallback(Button);
			}else {
				Click();
			}
			return true;
	}
	return false; // do not call super
}

//======================================================================================================================
defaultProperties // '{' in separate line or defaultProperties will be ignored !
{
	bAnimateOnInit = false;
	bIsNavigable = false;
}