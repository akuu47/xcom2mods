
class uc_Global extends UiDataStore;

`define ClassName uc_Global
`include( UnrestrictedCustomization\Src\UnrestrictedCustomization\macros.uci )

//======================================================================================================================
// FIELDS

var private bool Inited;

/// since struct has no null value, use a bool to know if an appearance is stored in the clipboard
var bool AppearanceClipboardNotNull;
var TAppearance AppearanceClipboard;

var xmf_HashMap BodyPartArchetypesByName;


var array<float> uc_AppearenceGenerator_DlcWeights;
 
//TODO `define GetStatic(varName) class'uc_Global'.static.GetInstance().GetStaticVar( `ClassName, `varName )
//TODO `define SetStatic(varName, value) class'uc_Global'.static.GetInstance().SetStaticVar( `ClassName, `varName, `value )

//======================================================================================================================
// CTOR

public static function uc_Global GetInstance() {
	return uc_Global( class'xmf_SingletonStore'.static.GetInstance(class'uc_Global') ).Init();
}

private function uc_Global Init() {
	if( ! Inited ) {
		BodyPartArchetypesByName = class'xmf_HashMap'.static.CreateHashMap();
	}
	Inited = true;
	return self;
}

//======================================================================================================================
defaultProperties // '{' in separate line or defaultProperties will be ignored !
{
	Tag=UnrestrictedCustomization_uc_Global
}