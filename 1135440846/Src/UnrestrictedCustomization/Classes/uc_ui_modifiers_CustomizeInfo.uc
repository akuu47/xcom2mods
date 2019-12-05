///
/// 
///
class uc_ui_modifiers_CustomizeInfo extends uc_ui_modifiers_ScreenModifier;

`define ClassName uc_ui_modifiers_CustomizeInfo
`include( UnrestrictedCustomization\Src\UnrestrictedCustomization\macros.uci )

//======================================================================================================================
// FIELDS

var private uc_ui_screens_BodyPartList BodyPartListMenu;

//======================================================================================================================
// METHODS

/*override*/ protected function Modify() {
	local UICustomize_Info _screen;
	local xmf_ui_ListWrapper _listWrapper;
	local UIMechaListItem _item;

	_screen = UICustomize_Info(Screen);
	_listWrapper = class'xmf_ui_ListWrapper'.static.CreateListWrapper(_screen.List);
	_item = _listWrapper.GetItemByLabel( _screen.m_strVoice );
	_item.UpdateDataValue( _screen.m_strVoice, class'uc_Customizer'.static.GetBodyPartLabel(uc_EBodyPartType_Voice), HandleVoiceClicked);
}

/*override*/ protected function bool RequiresModification() {
	local UIMechaListItem _item;
	local UICustomize_Info _screen;

	_screen = UICustomize_Info(Screen);
	_item = class'xmf_ui_ListWrapper'.static.CreateListWrapper(_screen.List).GetItemByLabel(_screen.m_strVoice);

	// have to cast to string because unrealscript is unable to compare function references...
	return string(_item.OnClickDelegate) != string(HandleVoiceClicked);
}

//======================================================================================================================
// HANDLERS

private function HandleVoiceClicked() {
	BodyPartListMenu = class'uc_ui_screens_BodyPartList'.static.CreateBodyPartList(uc_EBodyPartType_Voice);
	BodyPartListMenu.OnConfirmed.AddHandler(HandleVoiceSelectionConfirmed);
}

private function HandleVoiceSelectionConfirmed( Object _source ) {
	class'uc_VoicePlayer'.static.GetInstance().DisposeLoadedVoices();
	class'uc_Customizer'.static.SetBodyPart(
		uc_EBodyPartType_Voice,
		BodyPartListMenu.GetSelection().VanillaTemplate
	);
}

//======================================================================================================================
defaultProperties // '{' in separate line or defaultProperties will be ignored !
{
	BaseScreenClass = class'UICustomize_Info';
}
