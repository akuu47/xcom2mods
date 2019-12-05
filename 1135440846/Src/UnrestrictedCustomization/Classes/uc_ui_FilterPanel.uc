///
/// checkboxes are used as radio button
///
class uc_ui_FilterPanel extends xmf_ui_MiniPanel;

`define ClassName uc_ui_FilterPanel
`include( UnrestrictedCustomization\Src\UnrestrictedCustomization\macros.uci )

//======================================================================================================================
// SIGNALS

var privatewrite xmf_Signal OnChanged;

//======================================================================================================================
// FIELDS

const FilterHeight = 35;
const ButtonWidth = 250;
const ButtonHeight = 40;

var private bool UseRadioButtons;

var private string Title;
var private float NextY;
var private array<xmf_ui_Checkbox> Filters;

//======================================================================================================================
// CTOR

///
/// Instantiates this class.
///
public static function uc_ui_FilterPanel CreateFilterPanel(
	UiPanel _parent,
	string _title,
	bool _useRadioButtons
) {
	return FilterPanel( class'uc_ui_FilterPanel', _parent, _title, _useRadioButtons );
}

protected static function uc_ui_FilterPanel FilterPanel(
	class<uc_ui_FilterPanel> _class,
	UiPanel _parent,
	string _title, 
	bool _useRadioButtons
) {
	local uc_ui_FilterPanel this;
	this = uc_ui_FilterPanel( MiniPanel(_class, _parent) );
	this.InitFilterPanel(_title, _useRadioButtons);
	return this;
}

private function InitFilterPanel( string _title, bool _useRadioButtons ) {
	local UIButton _btn;

	UseRadioButtons = _useRadioButtons;
	Title = _title;
	OnChanged = class'xmf_Signal'.static.CreateSignal();

	Header.SetText( _title ); // text cannot be changed after resize...
	NextY = 50 + Padding;
	
	if( _useRadioButtons ) {
		_btn = Spawn(class'UIButton', self).InitButton('', `Localize("All/None"), HandleAllNoneClicked );
		_btn.SetSize( ButtonWidth, ButtonHeight );
		_btn.SetPosition( Padding+10, NextY );
		NextY += ButtonHeight + Padding*2;
	}
}

//======================================================================================================================
// METHODS

public function xmf_ui_Checkbox AddFilter( string _filterLabel, bool _checked, bool _disabled=false ) {
	local xmf_ui_NavigationNode _navNode;
	local xmf_ui_Checkbox _checkbox;

	_checkbox = class'xmf_ui_Checkbox'.static.CreateCheckbox(self);
	_checkbox.OnCheckedChanged.AddHandler( HandleFilterChanged );
	_checkbox.SetText(_filterLabel);
	_checkbox.SetChecked(_checked);
	_checkbox.SetDisabled(_disabled);
	_checkbox.SetPosition(0, NextY);

	Filters.AddItem(_checkbox);

	NextY += FilterHeight + Padding;

	if( Height < NextY ) {
		SetHeight(NextY);
	}
	
	// create navnode for new checkbox
	_navNode = class'xmf_ui_NavigationNode'.static.CreateNavigationNode(_checkbox);
	_navNode.Parent = NavigationNode;

	_navNode.TopNode = NavigationNode.LastFocusedChild;
	if( NavigationNode.LastFocusedChild != none ) NavigationNode.LastFocusedChild.BottomNode = _navNode;
	NavigationNode.LastFocusedChild = _navNode;


	return _checkbox;
}

//======================================================================================================================
// HANDLERS

private function HandleAllNoneClicked( UIButton _source ) {
	local xmf_ui_Checkbox _checkbox;
	local bool _check;

	// check all if at least one filter is unchecked ; uncheck all otherwise

	_check = false;
	foreach Filters(_checkbox) {
		if( ! _checkbox.bIsDisabled && ! _checkbox.bChecked ) _check = true;
	}

	foreach Filters(_checkbox) {
		if( ! _checkbox.bIsDisabled ) _checkbox.SetChecked(_check);
	}

	OnChanged.Dispatch(self);

	XComHQPresentationLayer(Movie.Pres).GetCamera().Move( vect(0,0,-10) );
	XComHQPresentationLayer(Movie.Pres).GetCamera().SetZoom(2);
}


private function HandleFilterChanged( Object _source ) {
	local xmf_ui_Checkbox _checkbox;

	if( UseRadioButtons ) {
		// uncheck others
		foreach Filters(_checkbox) {
			if( ! _checkbox.bIsDisabled && _checkbox!=_source ) {
				_checkbox.SetChecked(false, false);
			}
		}
		// check clicked
		xmf_ui_Checkbox(_source).SetChecked(true, false);
	}

	OnChanged.Dispatch(self);
}