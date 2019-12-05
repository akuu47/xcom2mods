///
/// 
///
class xmf_ui_Checkbox extends UICheckbox;

`define ClassName xmf_ui_Checkbox
`include( UnrestrictedCustomization\Src\UnrestrictedCustomization\macros.uci )

//======================================================================================================================
// EVENTS

///
/// Dispatched when checked or unchecked.
///
var privatewrite xmf_Signal OnCheckedChanged;

//======================================================================================================================
// CTOR

///
/// Instantiates this class.
///
public static function xmf_ui_Checkbox CreateCheckbox(
	UiPanel _parent
) {
	return Checkbox( class'xmf_ui_Checkbox', _parent);
}

protected static function xmf_ui_Checkbox Checkbox(
	class<xmf_ui_Checkbox> _class,
	UiPanel _parent
) {
	local xmf_ui_Checkbox this;
	this = _parent.Spawn(_class, _parent);
	this.InitCheckbox();
	return this;
}

/*override*/ simulated function UICheckbox InitCheckbox(optional name InitName, optional string initText, optional bool bInitChecked, optional delegate<OnChangedCallback> statusChangedDelegate, optional bool bInitReadOnly) {
	super.InitCheckbox(InitName, initText, bInitChecked, statusChangedDelegate, bInitReadOnly);
	
	OnCheckedChanged = class'xmf_Signal'.static.CreateSignal();
	SetTextStyle( class'UICheckbox'.const.STYLE_TEXT_ON_THE_RIGHT );
	OnChangedDelegate = HandleChanged;
	
	return self;
}

//======================================================================================================================
// HANDLERS

private function HandleChanged( UICheckbox _source ) {
	OnCheckedChanged.Dispatch(self);
}

/*
/*override*/ simulated function bool OnUnrealCommand( int _cmd, int _arg ) {
	if( _arg == class'UIUtilities_Input'.const.FXS_ACTION_RELEASE ) {
		switch( _cmd ) {
			case class'UIUtilities_Input'.const.FXS_KEY_ENTER:
			case class'UIUtilities_Input'.const.FXS_KEY_SPACEBAR:
			case class'UIUtilities_Input'.const.FXS_BUTTON_A:
				SetChecked( ! IsChecked() );
				return true;
		}
	}
	return super.OnUnrealCommand( _cmd, _arg );
}
*/