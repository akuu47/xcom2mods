///
/// 
///
class uc_ui_modifiers_CustomizeMenu extends uc_ui_modifiers_ScreenModifier dependson(xmf_Signal);

`define ClassName uc_ui_modifiers_CustomizeMenu
`include( UnrestrictedCustomization\Src\UnrestrictedCustomization\macros.uci )

//======================================================================================================================
// FIELDS

var private xmf_ui_ListItem PasteBtn;

//======================================================================================================================
// METHODS

/*override*/ protected function Modify() {
	local xmf_ui_ListWrapper _listWrapper;

	_listWrapper = class'xmf_ui_ListWrapper'.static.CreateListWrapper( UICustomize(Screen).List );
	
	_listWrapper.RemoveItems( `Localize("CopyOutfit") );
	_listWrapper.RemoveItems( `Localize("PasteOutfit") );
	_listWrapper.RemoveItems( `Localize("RandomizeOutfit") );
	_listWrapper.RemoveItems( `Localize("ImportOutfit") );

	_listWrapper.CreateSimpleButton( `Localize("CopyOutfit"), "", `Localize("CopyOutfitDescr"), HandleCopyClicked );
	PasteBtn = _listWrapper.CreateSimpleButton( `Localize("PasteOutfit"), "", `Localize("PasteOutfitDescr"), HandlePasteClicked );
	PasteBtn.SetDisabled(true);
	PasteBtn.SetDisabled(false);
	PasteBtn.SetDisabled( ! class'uc_Global'.static.GetInstance().AppearanceClipboardNotNull );
	_listWrapper.CreateSimpleButton( `Localize("RandomizeOutfit"), "", `Localize("RandomizeOutfitDescr"), HandleRandomizeClicked );
	_listWrapper.CreateSimpleButton( `Localize("ImportOutfit"), "", `Localize("ImportOutfitDescr"), HandleImportFromCpClicked );

	UpdateNavigation();
}


/*override*/ protected function bool RequiresModification() {
	local xmf_ui_ListWrapper _list;
	local UIMechaListItem _item;
	local string _label;
	_list = class'xmf_ui_ListWrapper'.static.CreateListWrapper( UICustomize(Screen).List );
	_label = `Localize("CopyOutfit");
	_item = _list.GetItemByLabel(_label);
	return _item == none || !_item.bIsVisible;
}


//======================================================================================================================
// HANDLERS

private function HandleCopyClicked() {
	local uc_Global _global;
	_global = class'uc_Global'.static.GetInstance();
	_global.AppearanceClipboard = class'uc_Customizer'.static.GetUnit().kAppearance;
	_global.AppearanceClipboardNotNull = true;
	PasteBtn.SetDisabled(false);
	//TODO show notification
}


private function HandlePasteClicked() {
	OpenConfirmation( `Localize("PasteConfirmationText"), HandlePasteConfirmed );
}
private function HandlePasteConfirmed( object _source ) {
	class'uc_Customizer'.static.SetBodyAppearance( class'uc_Global'.static.GetInstance().AppearanceClipboard );
}


private function HandleRandomizeClicked() {
	class'uc_ui_screens_Randomize'.static.CreateRandomize();
}


private function HandleImportFromCpClicked() {
	class'uc_ui_screens_Import'.static.CreateImport();
}


private function HandleSetToRookiesClicked() {
	
}


private function HandleSetToAllArmorsClicked() {
	local TDialogueBoxData _dlgData;
	_dlgData.eType = eDialog_Alert;
	_dlgData.strTitle = `Localize("Alert");
	_dlgData.strText = `Localize("SetToAllArmorsConfirmationText");
	_dlgData.strAccept = class'UIUtilities_Text'.default.m_strGenericConfirm;
	_dlgData.strCancel = class'UIUtilities_Text'.default.m_strGenericCancel;
	_dlgData.fnCallback = HandleSetToAllArmorsConfirmed;
	Screen.Movie.Pres.UIRaiseDialog(_dlgData);
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
		_msgbox = class'uc_ui_CheckableDialogBox'.static.CreateCheckableDialogBox(Screen, _msg);
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

//======================================================================================================================
defaultProperties // '{' in separate line or defaultProperties will be ignored !
{
	BaseScreenClass = class'UICustomize_Menu';
}
