///
/// Ensures than spark customization filter is valid.
/// _filter.ArmorName is set to '' if player remove the body part template (ie: by disabling the mod that added it)
/// which causes total chaos within UICustomize_SparkBody.UpdateData
///
class uc_ui_modifiers_CustomizeSparkBody extends uc_ui_modifiers_ScreenModifier;

`define ClassName uc_ui_modifiers_CustomizeSparkBody
`include( UnrestrictedCustomization\Src\UnrestrictedCustomization\macros.uci )

//======================================================================================================================
// FIELDS

const DefaultTorso = 'Spark_A';

//======================================================================================================================
// METHODS

/*override*/ protected function Modify() {
	local X2SimpleBodyPartFilter _filter;
	
	class'uc_Customizer'.static.SetBodyPart(
		uc_EBodyPartType_Torso,
		class'X2BodyPartTemplateManager'.static.GetBodyPartTemplateManager().FindUberTemplate("Torso", DefaultTorso)
	);

	_filter = `XCOMGAME.SharedBodyPartFilter;
	_filter.Set(
		_filter.Gender,
		_filter.Race,
		DefaultTorso,
		_filter.bCivilian,
		_filter.bVeteran,
		_filter.DLCNames
	);

	UICustomize_SparkBody(Screen).UpdateData();
}


/*override*/ protected function bool RequiresModification() {
	local UIMechaListItem _item;
	
	_item = class'xmf_ui_ListWrapper'.static
		.CreateListWrapper( UICustomize_SparkBody(Screen).List )
		.GetItemByLabel( class'UICustomize_SparkProps'.default.m_strTorso );

	return _item != none && _item.bDisabled;
}



//======================================================================================================================
defaultProperties // '{' in separate line or defaultProperties will be ignored !
{
	BaseScreenClass=class'UICustomize_SparkBody';
}
