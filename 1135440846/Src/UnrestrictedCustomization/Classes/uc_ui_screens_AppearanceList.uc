///
/// Creates a list from character pool to let player import/copy their appearance.
///
class uc_ui_screens_AppearanceList extends uc_ui_screens_Customize;

`define ClassName uc_ui_screens_AppearanceList
`include( UnrestrictedCustomization\Src\UnrestrictedCustomization\macros.uci )

//======================================================================================================================
// FIELDS

var private array<TAppearance> Appearances;
var protected int FirstAppearanceIndex;

//======================================================================================================================
// CTOR

public static function uc_ui_screens_AppearanceList CreateAppearanceList() {
	return AppearanceList( class'uc_ui_screens_AppearanceList' );
}

protected static function uc_ui_screens_AppearanceList AppearanceList(
	class<uc_ui_screens_AppearanceList> _class
) {
	local uc_ui_screens_AppearanceList this;
	this = uc_ui_screens_AppearanceList( Customize(_class) );
	this.InitAppearanceList();
	return this;
}

private function InitAppearanceList() {
	
}

//======================================================================================================================
// METHODS

/*override*/ protected function AddListItems() {
	local int _i;
	local string _label;
	local TAppearance _appearance;

	Appearances.Length = 0;
	_i = 0;
	FirstAppearanceIndex = List.GetItemCount();
	while( GetAppearance(_i, _appearance, _label) ) {
		Appearances.AddItem(_appearance);
		ListWrapper.CreateSimpleButton( _label, "", "", HandleAppearanceClicked );
		_i++;
	}
}

///
/// returns true if an appearance is created, false otherwise.
///
/*abstract*/ protected function bool GetAppearance( int _index, out TAppearance _appearance, out string _label ) {}

//======================================================================================================================
// HANDLERS

private function HandleAppearanceClicked() {
	CloseScreen();
}

/*override*/ protected function HandleSelectionChanged( UIList _list, int _itemIndex ) {
	_itemIndex -= FirstAppearanceIndex;
	if( _itemIndex < 0 || _itemIndex >= Appearances.Length ) return;
	class'uc_Customizer'.static.SetBodyAppearance( Appearances[_itemIndex] );
}
