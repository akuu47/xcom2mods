
class uc_ui_ToolPanel extends xmf_ui_MiniPanel;

`define ClassName uc_ui_ToolPanel
`include( UnrestrictedCustomization\Src\UnrestrictedCustomization\macros.uci )

//======================================================================================================================
// CONST

const EUIAction_Accept = 'eUIAction_Accept';

//======================================================================================================================
// FIELDS

var private UiButton PasteBtn;

//======================================================================================================================
// Properties


//======================================================================================================================
// CTOR

///
/// Instantiates this class.
///
public static function uc_ui_ToolPanel CreateToolPanel(
	UiPanel _parent
) {
	return ToolPanel( class'uc_ui_ToolPanel', _parent );
}

///
/// Protected ctor used from chained construction.
///
protected static function uc_ui_ToolPanel ToolPanel(
	class<uc_ui_ToolPanel> _class,
	UiPanel _parent
) {
	local uc_ui_ToolPanel this;
	this = uc_ui_ToolPanel( MiniPanel(_class, _parent) );
	this.InitToolPanel();
	return this;
}

///
/// Ctor's impl.
///
private function InitToolPanel() {
	local UiButton _copyBtn, _randomizeBtn, _importFromCpBtn;//, _setToRookiesBtn, _setToAllArmorsBtn;
	local float _nextY, _buttonWidth, _buttonHeight;
	
	_nextY = 50 + Padding;
	_buttonWidth = 155;
	_buttonHeight = 35;

	_copyBtn = Spawn(class'UIButton', self).InitButton('', `Localize("Copy"), HandleCopyClicked );
	_copyBtn.SetSize( _buttonWidth, _buttonHeight );
	_copyBtn.SetPosition( Padding, _nextY );
	_nextY += _buttonHeight + Padding;

	PasteBtn = Spawn(class'UIButton', self).InitButton('', `Localize("Paste"), HandlePasteClicked );
	PasteBtn.SetSize( _buttonWidth, _buttonHeight );
	PasteBtn.SetDisabled( ! class'uc_Global'.static.GetInstance().AppearanceClipboardNotNull );
	PasteBtn.SetPosition( Padding, _nextY );
	_nextY += _buttonHeight + Padding;
	_nextY += Padding*4;

	_randomizeBtn = Spawn(class'UIButton', self).InitButton('', `Localize("Randomize"), HandleRandomizeClicked );
	_randomizeBtn.SetSize( _buttonWidth, _buttonHeight );
	_randomizeBtn.SetPosition( Padding, _nextY );
	_nextY += _buttonHeight + Padding;

	_importFromCpBtn = Spawn(class'UIButton', self).InitButton('', `Localize("ImportFromCharacterPool"), HandleImportFromCpClicked );
	_importFromCpBtn.SetSize( _buttonWidth, _buttonHeight );
	_importFromCpBtn.SetDisabled( class'uc_CharacterPoolUtil'.static.IsOpen(), `Localize("UnavailableWithinCharacterPool") );
	_importFromCpBtn.SetPosition( Padding, _nextY );
	_nextY += _buttonHeight + Padding;
	/*
	_setToAllArmorsBtn = InnerPanel.Spawn(class'UIButton', InnerPanel.InitButton('', `Localize("SetToAllArmors"), HandleSetToAllArmorsClicked );
	_setToAllArmorsBtn.SetSize( _buttonWidth, _buttonHeight );
	_setToAllArmorsBtn.SetDisabled( class'uc_CharacterPoolUtil'.static.IsOpen(), UnavailableWithinCharacterPool );
	_setToAllArmorsBtn.SetPosition( Padding, _nextY );
	_nextY += _buttonHeight + Padding;
	_nextY += Padding*4;
	*/
	/*
	_setToRookiesBtn = InnerPanel.Spawn(class'UIButton', InnerPanel).InitButton('', `Localize("SetToRookies"), HandleAssignAppearanceToRookiesClicked );
	_setToRookiesBtn.SetSize( _buttonWidth, _buttonHeight );
	_setToRookiesBtn.SetPosition( Padding, _nextY );
	_nextY += Padding*4;
	*/

	Header.SetText( `Localize("Outfit") ); // text cannot be changed after resize...
	SetSize(_buttonWidth+Padding, _nextY+Padding*3);
}

//======================================================================================================================
// HANDLERS

private function HandleCopyClicked( UIButton _button ) {
	local uc_Global _global;
	_global = class'uc_Global'.static.GetInstance();
	_global.AppearanceClipboard = class'uc_Customizer'.static.GetUnit().kAppearance;
	_global.AppearanceClipboardNotNull = true;
	PasteBtn.EnableButton();
	//TODO show notification
}


private function HandlePasteClicked( UIButton _button ) {
	OpenConfirmation( `Localize("PasteConfirmationText"), HandlePasteConfirmed );
}
private function HandlePasteConfirmed( object _source ) {
	class'uc_Customizer'.static.SetBodyAppearance( class'uc_Global'.static.GetInstance().AppearanceClipboard );
}


private function HandleRandomizeClicked( UIButton _button ) {
	class'uc_ui_screens_Randomize'.static.CreateRandomize();
}


private function HandleImportFromCpClicked( UIButton _button ) {
	class'uc_ui_screens_Import'.static.CreateImport();
}


private function HandleSetToRookiesClicked( UIButton _button ) {
	
}


private function HandleSetToAllArmorsClicked( UIButton _button ) {
	local TDialogueBoxData _dlgData;
	_dlgData.eType = eDialog_Alert;
	_dlgData.strTitle = `Localize("Alert");
	_dlgData.strText = `Localize("SetToAllArmorsConfirmationText");
	_dlgData.strAccept = class'UIUtilities_Text'.default.m_strGenericConfirm;
	_dlgData.strCancel = class'UIUtilities_Text'.default.m_strGenericCancel;
	_dlgData.fnCallback = HandleSetToAllArmorsConfirmed;
	Movie.Pres.UIRaiseDialog(_dlgData);
}
private function HandleSetToAllArmorsConfirmed( name _action ) {
	if( _action != 'eUIAction_Accept' ) return;
//	class'uc_Customizer'.static.SetAppearanceToAllArmors();
}



private function OpenConfirmation( string _msg, delegate<xmf_Signal.SignalHandler> _handler ) {
	local uc_Config _config;
	local uc_ui_CheckableDialogBox _msgbox;
	_config = class'uc_Config'.static.GetInstance();
	if( _config.ConfirmWholeAppearanceModification ) {
		_msgbox = class'uc_ui_CheckableDialogBox'.static.CreateCheckableDialogBox(self, _msg);
		_msgbox.OnConfirmed.AddHandler(_handler);
		_msgbox.OnDontAskAgainChecked.AddHandler(HandleDontAskAgainChecked);
	}else {
		_handler(none);
	}
}


private function HandleDontAskAgainChecked( object _source ) {
	local uc_Config _config;
	`LogInfo("disabling ConfirmWholeAppearanceModification...");
	_config = class'uc_Config'.static.GetInstance();
	_config.SetConfirmWholeAppearanceModification(false);
}
