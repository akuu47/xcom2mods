
class uc_ui_CheckableDialogBox extends UIDialogueBox;

`define ClassName uc_ui_CheckableDialogBox
`include( UnrestrictedCustomization\Src\UnrestrictedCustomization\macros.uci )

//======================================================================================================================
// SIGNALS

var privatewrite xmf_Signal OnConfirmed;

var privatewrite xmf_Signal OnCancelled;

var privatewrite xmf_Signal OnDontAskAgainChecked;

//======================================================================================================================
// FIELDS

var private UICheckbox Checkbox;

//======================================================================================================================
// CTOR

///
/// Instantiates this class.
///
public static function uc_ui_CheckableDialogBox CreateCheckableDialogBox(
	UiPanel _parent,
	string _msg
) {
	return CheckableDialogBox( class'uc_ui_CheckableDialogBox', _parent, _msg );
}

///
/// Protected ctor used from chained construction.
///
protected static function uc_ui_CheckableDialogBox CheckableDialogBox(
	class<uc_ui_CheckableDialogBox> _class,
	UiPanel _parent,
	string _msg
) {
	local uc_ui_CheckableDialogBox this;
	this = _parent.Spawn( _class, _parent.Movie.Pres );
	this.InitCheckableDialogBox(_parent, _msg);
	return this;
}

///
/// Ctor's impl.
///
private function InitCheckableDialogBox(
	UiPanel _parent,
	string _msg
) {
	local TDialogueBoxData _dlgData;

	OnConfirmed = new class'xmf_Signal';
	OnCancelled = new class'xmf_Signal';
	OnDontAskAgainChecked = new class'xmf_Signal';
	

	InitScreen( XComPlayerController(_parent.Movie.Pres.Owner), _parent.Movie );
	_parent.Movie.LoadScreen(self);

	_dlgData.eType = eDialog_Alert;
	_dlgData.strTitle = `Localize("ConfirmationTitle");
	_dlgData.strText = _msg;
	_dlgData.strAccept = class'UIUtilities_Text'.default.m_strGenericConfirm;
	_dlgData.strCancel = class'UIUtilities_Text'.default.m_strGenericCancel;
	_dlgData.fnCallback = HandleAction;
	AddDialog( _dlgData );

	Checkbox = Spawn(class'UICheckbox', self);
	Checkbox.InitCheckbox('', `Localize("DoNotAskAgain"), false, HandleCheckboxChanged );
	Checkbox.SetTextStyle( class'UICheckbox'.const.STYLE_TEXT_ON_THE_RIGHT ); 
	//Checkbox.SetPosition(890, 485);
	Checkbox.SetPosition(890, 385);
}

//======================================================================================================================
// HANDLERS

private function HandleAction( name _action ) {
	switch(_action) {
		case 'eUIAction_Accept':
			OnConfirmed.Dispatch(self);
			break;
		default:
			OnCancelled.Dispatch(self);
			break;
	}
}


private function HandleCheckboxChanged( UICheckbox checkboxControl ) {
	`LogInfo("checked");
	OnDontAskAgainChecked.Dispatch(self);
}
