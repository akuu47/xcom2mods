///
/// Class to add new buttons to UiCustomizeBody menu.
///
class uc_ui_modifiers_CustomizeBody extends uc_ui_modifiers_ScreenModifier;

`define ClassName uc_ui_modifiers_CustomizeBody
`include( UnrestrictedCustomization\Src\UnrestrictedCustomization\macros.uci )

//======================================================================================================================
// FIELDS

var private uc_EBodyPartType CurrentlyModifiedPartType;

var private uc_ui_screens_BodyPartList BodyPartListMenu;

//======================================================================================================================
// HANDLERS

event OnInit( UIScreen _uncastedScreen ) {
	if( UiCustomize_Body(_uncastedScreen) == none ) return;
	super.OnInit(_uncastedScreen);
}

event OnRemoved( UIScreen _uncastedScreen ) {
	if( UiCustomize_Body(_uncastedScreen) == none ) return;
	super.OnRemoved(_uncastedScreen);
}

//======================================================================================================================
// METHODS

/*override*/ protected function Modify() {
	local UiCustomize_Body _screen;
	local xmf_ui_ListWrapper _listWrapper;

	_screen = UiCustomize_Body(Screen);
	_listWrapper = class'xmf_ui_ListWrapper'.static.CreateListWrapper(_screen.List);

	_listWrapper.RemoveItems( _screen.m_strArms );
	_listWrapper.RemoveItems( _screen.m_strLeftArm );
	_listWrapper.RemoveItems( _screen.m_strRightArm );
	_listWrapper.RemoveItems( _screen.m_strLeftArmDeco );
	_listWrapper.RemoveItems( _screen.m_strRightArmDeco );
	_listWrapper.RemoveItems( _screen.m_strLeftForearm );
	_listWrapper.RemoveItems( _screen.m_strRightForearm );
	_listWrapper.RemoveItems( _screen.m_strTorso );
	_listWrapper.RemoveItems( _screen.m_strTorsoDeco );
	_listWrapper.RemoveItems( _screen.m_strLegs );
	_listWrapper.RemoveItems( _screen.m_strThighs );
	_listWrapper.RemoveItems( _screen.m_strShins );

	_listWrapper.CreateValueButton( _screen.m_strArms, class'uc_Customizer'.static.GetBodyPartLabel(uc_EBodyPartType_Arms), "", HandleArmsClicked );
	_listWrapper.CreateValueButton( _screen.m_strLeftArm, class'uc_Customizer'.static.GetBodyPartLabel(uc_EBodyPartType_LeftArm), "", HandleLeftArmClicked );
	_listWrapper.CreateValueButton( _screen.m_strRightArm, class'uc_Customizer'.static.GetBodyPartLabel(uc_EBodyPartType_RightArm), "", HandleRightArmClicked );
	_listWrapper.CreateValueButton( _screen.m_strLeftArmDeco, class'uc_Customizer'.static.GetBodyPartLabel(uc_EBodyPartType_LeftArmDeco), "", HandleLeftArmDecoClicked );
	_listWrapper.CreateValueButton( _screen.m_strRightArmDeco, class'uc_Customizer'.static.GetBodyPartLabel(uc_EBodyPartType_RightArmDeco), "", HandleRightArmDecoClicked );
	_listWrapper.CreateValueButton( _screen.m_strLeftForearm, class'uc_Customizer'.static.GetBodyPartLabel(uc_EBodyPartType_LeftForearm), "", HandleLeftForearmClicked );
	_listWrapper.CreateValueButton( _screen.m_strRightForearm, class'uc_Customizer'.static.GetBodyPartLabel(uc_EBodyPartType_RightForearm), "", HandleRightForearmClicked );
	_listWrapper.CreateValueButton( _screen.m_strTorso, class'uc_Customizer'.static.GetBodyPartLabel(uc_EBodyPartType_Torso), "", HandleTorsoClicked );
	_listWrapper.CreateValueButton( _screen.m_strTorsoDeco, class'uc_Customizer'.static.GetBodyPartLabel(uc_EBodyPartType_TorsoDeco), "", HandleTorsoDecoClicked );
	_listWrapper.CreateValueButton( _screen.m_strLegs, class'uc_Customizer'.static.GetBodyPartLabel(uc_EBodyPartType_Legs), "", HandleLegsClicked );
	_listWrapper.CreateValueButton( _screen.m_strThighs, class'uc_Customizer'.static.GetBodyPartLabel(uc_EBodyPartType_Thighs), "", HandleThighsClicked );
	_listWrapper.CreateValueButton( _screen.m_strShins, class'uc_Customizer'.static.GetBodyPartLabel(uc_EBodyPartType_Shins), "", HandleShinsClicked );

	UpdateNavigation();
}


/*override*/ protected function bool RequiresModification() {
	local UIMechaListItem _item;
	local UICustomize_Body _screen;

	_screen = UICustomize_Body(Screen);
	_item = class'xmf_ui_ListWrapper'.static.CreateListWrapper(_screen.List).GetItemByLabel(_screen.m_strArms);

	// have to cast to string because unrealscript is unable to compare function references...
	return _item == none || ! _item.bIsVisible || string(_item.OnClickDelegate) != string(HandleArmsClicked);
}

//======================================================================================================================
// HANDLERS

private function HandleTorsoClicked() { HandlePartClickedImpl( uc_EBodyPartType_Torso ); }
private function HandleTorsoDecoClicked() { HandlePartClickedImpl( uc_EBodyPartType_TorsoDeco ); }
private function HandleLegsClicked() { HandlePartClickedImpl( uc_EBodyPartType_Legs ); }
private function HandleThighsClicked() { HandlePartClickedImpl( uc_EBodyPartType_Thighs ); }
private function HandleShinsClicked() { HandlePartClickedImpl( uc_EBodyPartType_Shins ); }
private function HandleArmsClicked() { HandlePartClickedImpl( uc_EBodyPartType_Arms ); }
private function HandleLeftArmClicked() { HandlePartClickedImpl( uc_EBodyPartType_LeftArm ); }
private function HandleRightArmClicked() { HandlePartClickedImpl( uc_EBodyPartType_RightArm ); }
private function HandleLeftArmDecoClicked() { HandlePartClickedImpl( uc_EBodyPartType_LeftArmDeco ); }
private function HandleRightArmDecoClicked() { HandlePartClickedImpl( uc_EBodyPartType_RightArmDeco ); }
private function HandleLeftForearmClicked() { HandlePartClickedImpl( uc_EBodyPartType_LeftForearm ); }
private function HandleRightForearmClicked() { HandlePartClickedImpl( uc_EBodyPartType_RightForearm ); }

private function HandlePartClickedImpl( uc_EBodyPartType _partType ) {
	CurrentlyModifiedPartType = _partType;

	BodyPartListMenu = class'uc_ui_screens_BodyPartList'.static.CreateBodyPartList(CurrentlyModifiedPartType);
	BodyPartListMenu.OnSelectionChangedSignal.AddHandler(HandlePartSelected);

	switch( _partType ) {
		case uc_EBodyPartType_Legs:
		case uc_EBodyPartType_Shins:
		case uc_EBodyPartType_Thighs:
			BodyPartListMenu.CustomizeManager.UpdateCamera(eUICustomizeCat_Legs);
			BodyPartListMenu.CameraTag = "UIBlueprint_CustomizeLegs";
			BodyPartListMenu.DisplayTag = 'UIBlueprint_CustomizeLegs';
			break;
		default:
			BodyPartListMenu.CustomizeManager.UpdateCamera();
	}
}


private function HandlePartSelected( Object _source ) {
	BodyPartListMenu.ClearTimer( nameof(HandlePartSelected_Delayed), self );
	BodyPartListMenu.SetTimer( 0.1f, false, nameof(HandlePartSelected_Delayed), self );
}
private function HandlePartSelected_Delayed() {
	/*
	AppearanceModifier.SetBodyPart( 
		CurrentlyModifiedPartType, 
		BodyPartListMenu.GetSelection().VanillaTemplate
	);
	*/
	class'uc_Customizer'.static.SetBodyPart(
		CurrentlyModifiedPartType,
		BodyPartListMenu.GetSelection().VanillaTemplate
	);
}

//======================================================================================================================
defaultProperties // '{' in separate line or defaultProperties will be ignored !
{
	BaseScreenClass=class'UICustomize_Body';
}


