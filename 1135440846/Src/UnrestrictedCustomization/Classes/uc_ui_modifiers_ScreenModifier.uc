///
/// 
///
/*abstract*/ class uc_ui_modifiers_ScreenModifier extends UIScreenListener;

`define ClassName uc_ui_modifiers_ScreenModifier
`include( UnrestrictedCustomization\Src\UnrestrictedCustomization\macros.uci )

//======================================================================================================================
// FIELDS

var protected class<UIScreen> BaseScreenClass;
var protected UIScreen Screen;
var protected float UpdateRate;

//======================================================================================================================
// METHODS

/*abstract*/ protected function bool RequiresModification() {
	`assert(false); // pure virtual
	return false;
}


/*abstract*/ protected function Modify() {
	`assert(false); // pure virtual
}


protected function UpdateNavigation() {
	local UICustomize _screen;
	local xmf_ui_ListWrapper _listWrapper;
	local UiPanel _child;

	_screen = UICustomize(Screen);
	if( _screen != none ) {
		_listWrapper = class'xmf_ui_ListWrapper'.static.CreateListWrapper( _screen.List );
		_listWrapper.List.Navigator.Clear();
		foreach _listWrapper.List.ItemContainer.ChildPanels(_child) {
			_listWrapper.List.Navigator.AddControl(_child);
		}
	}
}

//======================================================================================================================
// HANDLERS

event OnInit( UIScreen _uncastedScreen ) {
	if( ! ClassIsChildOf(_uncastedScreen.Class, BaseScreenClass) ) return;
	Screen = _uncastedScreen;
	Screen.SetTimer( UpdateRate, false, nameof(Modify_Delayed), self );
}
event OnReceiveFocus( UIScreen _uncastedScreen ) {
	if( ! ClassIsChildOf(_uncastedScreen.Class, BaseScreenClass) ) return;
	Screen = _uncastedScreen;
	Screen.SetTimer( UpdateRate, false, nameof(Modify_Delayed), self );
}
event OnRemoved( UIScreen _uncastedScreen ) {
	if( ! ClassIsChildOf(_uncastedScreen.Class, BaseScreenClass) ) return;
	_uncastedScreen.ClearTimer( nameof(Modify_Delayed), self );
}

private function Modify_Delayed() {
	if( RequiresModification() ) Modify();
	Screen.SetTimer( UpdateRate, false, nameof(Modify_Delayed), self );
}

//======================================================================================================================
defaultProperties // '{' in separate line or defaultProperties will be ignored !
{
	ScreenClass=none;
	UpdateRate=0.3;
}
