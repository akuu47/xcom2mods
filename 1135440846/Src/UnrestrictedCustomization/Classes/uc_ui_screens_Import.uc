///
/// Creates a list from character pool to let player import/copy their appearance.
///
class uc_ui_screens_Import extends uc_ui_screens_AppearanceList;

`define ClassName uc_ui_screens_Import
`include( UnrestrictedCustomization\Src\UnrestrictedCustomization\macros.uci )

//======================================================================================================================
// FIELDS

var private array<XComGameState_Unit> Characters;

//======================================================================================================================
// CTOR

///
/// Instantiates this class.
///
public static function uc_ui_screens_Import CreateImport() {
	return Import( class'uc_ui_screens_Import' );
}

///
/// Protected ctor used from chained construction.
///
protected static function uc_ui_screens_Import Import(
	class<uc_ui_screens_Import> _class
) {
	local uc_ui_screens_Import this;
	this = uc_ui_screens_Import( AppearanceList(_class) );
	this.InitImport();
	return this;
}

///
/// Ctor's impl.
///
private function InitImport() {
	Characters = class'uc_CharacterPoolUtil'.static.GetCharacters( class'uc_Customizer'.static.GetGender() );
}

//======================================================================================================================
// METHODS

/*override*/ protected function bool GetAppearance( int _index, out TAppearance _appearance, out string _label ) {
	if( _index > Characters.Length-1 ) return false;
	_appearance = Characters[_index].kAppearance;
	_label = Characters[_index].GetName(eNameType_FullNick);
	return true;
}
