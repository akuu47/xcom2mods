///
/// 
///
class xmf_ui_ListWrapper extends Object;

`define ClassName xmf_ui_ListWrapper
`include( UnrestrictedCustomization\Src\UnrestrictedCustomization\macros.uci )

//======================================================================================================================
// FIELDS

var privatewrite UiList List;

//======================================================================================================================
// CTOR

///
/// Instantiates this class.
///
public static function xmf_ui_ListWrapper CreateListWrapper( UiList _list) {
	return ListWrapper(class'xmf_ui_ListWrapper', _list);
}

protected static function xmf_ui_ListWrapper ListWrapper( class<xmf_ui_ListWrapper> _class, UiList _list ) {
	local xmf_ui_ListWrapper this;
	this = new _class;
	this.InitListWrapper(_list);
	return this;
}

private function InitListWrapper( UiList _list ) {
	`assert( _list != none );
	List = _list;
	_list.DisableNavigation();
}

//======================================================================================================================
// METHODS

///
///
///
public function UIMechaListItem GetItemByLabel( string _label ) {
	local UiPanel _child;
	local UIMechaListItem _listItem;

	foreach List.ItemContainer.ChildPanels( _child ) {
		_listItem = UIMechaListItem(_child);
		if( _listItem.Desc.htmlText == _label ) {
			return _listItem;
		}
	}
	return none;
}


public function xmf_ui_ListItem GetItemAt( int _index ) {
	return xmf_ui_ListItem( List.ItemContainer.GetChildAt(_index) );
}


///
///
///
public function RemoveItem( string _label ) {
	local UiPanel _item;
	_item = GetItemByLabel(_label);
	if( _item != none ) {
		_item.Remove();
		List.Navigator.RemoveControl(_item);
	}
}

///
///
///
public function RemoveItems( string _label ) {
	local UiPanel _child;
	local UIMechaListItem _listItem;

	foreach List.ItemContainer.ChildPanels( _child ) {
		_listItem = UIMechaListItem(_child);
		if( _listItem.Desc.htmlText == _label ) {
			_listItem.Remove();
			List.Navigator.RemoveControl(_listItem);
		}
	}
}

//======================================================================================================================
// Create items METHODS

///
///
///
public function xmf_ui_ListItem CreateSimpleButton(
	string _label,
	coerce string _value,
	string _tooltip,
	delegate<UIMechaListItem.OnClickDelegate> _onClicked
) {
	local xmf_ui_ListItem _item;
	_item = class'xmf_ui_ListItem'.static.CreateListItem(List);
	_item.UpdateDataDescription( _label, _onClicked );
	class'xmf_ui_Util'.static.SetTooltip(_item.BG, _tooltip);
	return _item;
}

///
///
///
public function xmf_ui_ListItem CreateValueButton(
	string _label,
	coerce string _value,
	string _tooltip,
	delegate<UIMechaListItem.OnClickDelegate> _onClicked
) {
	local xmf_ui_ListItem _item;
	_item = class'xmf_ui_ListItem'.static.CreateListItem(List);
	_item.UpdateDataValue(
		_label,
		class'UIUtilities_Text'.static.GetSizedText(_value, class'UIUtilities_Text'.const.BODY_FONT_SIZE_3D),
		_onClicked
	);
	class'xmf_ui_Util'.static.SetTooltip(_item.BG, _tooltip);
	return _item;
}

///
///
///
public function xmf_ui_ListItem CreateDoubleButton(
	string _label,
	string _buttonLabel,
	string _tooltip,
	delegate<UIMechaListItem.OnClickDelegate> _onLeftButtonClicked,
	delegate<UIMechaListItem.OnButtonClickedCallback> _onRightButtonClicked
) {
	local xmf_ui_ListItem _item;
	_item = class'xmf_ui_ListItem'.static.CreateListItem(List);
	_item.UpdateDataButton( _label, _buttonLabel, _onRightButtonClicked, _onLeftButtonClicked );
	class'xmf_ui_Util'.static.SetTooltip(_item.BG, _tooltip);
	return _item;
}

///
///
///
public function xmf_ui_ListItem CreateSpinner(
	string _label,
	string _tooltip,
	delegate<UIMechaListItem.OnSpinnerChangedCallback> _callback,
	coerce string _value,
	int _width = 50
) {
	local xmf_ui_ListItem _item;

	_item = class'xmf_ui_ListItem'.static.CreateListItem(List);
	_item.UpdateDataSpinner( _label, _value, _callback );
	_item.Spinner.SetValueWidth(_width, true);
	_item.Desc.SetWidth( _item.Width-80 - _item.Spinner.Width );
	_item.Spinner.SetX( _item.Desc.Width );

	class'xmf_ui_Util'.static.SetTooltip(_item.BG, _tooltip);

	return _item;
}

///
///
///
public function xmf_ui_ListItem CreateSlider(
	string _label,
	string _tooltip,
	delegate<UiSlider.OnChangedCallback> _callback,
	float _value,
	float _stepSize = 0.1
) {
	local xmf_ui_ListItem _item;

	_item = class'xmf_ui_ListItem'.static.CreateListItem(List);
	_item.UpdateDataSlider( _label, "");

	_item.Slider.SetPercent( _value*100.0 );
	_item.Slider.SetStepSize( _stepSize*100.0 );
	_item.Slider.OnChangedDelegate = _callback;

	_item.Desc.SetWidth( _item.Desc.Width + 200 );

	class'xmf_ui_Util'.static.SetTooltip(_item.BG, _tooltip);

	return _item;
}

///
///
///
public function xmf_ui_ListItem CreateCheckbox(
	string _label,
	string _tooltip,
	delegate<UICheckbox.OnChangedCallback> _callback,
	bool _value
) {
	local xmf_ui_ListItem _item;

	_item = class'xmf_ui_ListItem'.static.CreateListItem(List);
	_item.UpdateDataCheckbox( _label, "", _value, _callback);
	class'xmf_ui_Util'.static.SetTooltip(_item.BG, _tooltip);

	return _item;
}
