///
/// 
///
class xmf_BoxedBool extends JsonObject;

`define ClassName xmf_BoxedBool
`include( UnrestrictedCustomization\Src\UnrestrictedCustomization\macros.uci )

//======================================================================================================================
// FIELDS

var bool Value;

//======================================================================================================================
// CTOR

///
/// Instantiates this class.
///
public static function xmf_BoxedBool CreateBoxedBool( bool _value=false ) {
	return BoxedBool(class'xmf_BoxedBool', _value);
}

protected static function xmf_BoxedBool BoxedBool( class<xmf_BoxedBool> _class, bool _value ) {
	local xmf_BoxedBool this;
	this = new _class;
	this.InitBoxedBool(_value);
	return this;
}

private function InitBoxedBool( bool _value ) {
	Value = _value;
}

//======================================================================================================================
// METHODS


