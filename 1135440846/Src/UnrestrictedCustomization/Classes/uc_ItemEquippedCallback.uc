///
/// Stores a X2ItemTemplate.OnEquippedDelegate, so it can be stored within xmf_HashMap
///
class uc_ItemEquippedCallback extends JsonObject;

`define ClassName uc_ItemEquippedCallback
`include( UnrestrictedCustomization\Src\UnrestrictedCustomization\macros.uci )

//======================================================================================================================
// FIELDS

var privatewrite delegate<X2ItemTemplate.OnEquippedDelegate> OnEquippedFn;

//======================================================================================================================
// CTOR

///
/// Instantiates this class.
///
public static function uc_ItemEquippedCallback CreateItemEquippedCallback(
	delegate<X2ItemTemplate.OnEquippedDelegate> _onEquippedFn
) {
	return ItemEquippedCallback(class'uc_ItemEquippedCallback', _onEquippedFn);
}

protected static function uc_ItemEquippedCallback ItemEquippedCallback(
	class<uc_ItemEquippedCallback> _class,
	delegate<X2ItemTemplate.OnEquippedDelegate> _onEquippedFn
) {
	local uc_ItemEquippedCallback this;
	this = new _class;
	this.InitItemEquippedCallback(_onEquippedFn);
	return this;
}

private function InitItemEquippedCallback(
 delegate<X2ItemTemplate.OnEquippedDelegate> _onEquippedFn
) {
	OnEquippedFn = _onEquippedFn;
}

//======================================================================================================================
// METHODS


