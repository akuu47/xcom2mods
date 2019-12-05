
class xmf_Global extends UiDataStore;

`define ClassName xmf_Global
`include( UnrestrictedCustomization\Src\UnrestrictedCustomization\macros.uci )

//======================================================================================================================
// FIELDS

///
/// Do not used outside xmf_DlcUtil
///
var array<string> BodyPartUtil_DlcNames;

//======================================================================================================================
// CTOR

public static function xmf_Global GetInstance() {
	return xmf_Global( class'xmf_SingletonStore'.static.GetInstance(class'xmf_Global') ).Init();
}

private function xmf_Global Init() {
	return self;
}

//======================================================================================================================
defaultProperties // '{' in separate line or defaultProperties will be ignored !
{
	Tag=UnrestrictedCustomization_xmf_Global
}