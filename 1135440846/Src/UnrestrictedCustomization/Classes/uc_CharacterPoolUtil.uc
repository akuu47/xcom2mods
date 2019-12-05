

class uc_CharacterPoolUtil extends Object;

`define ClassName uc_CharacterPoolUtil
`include( UnrestrictedCustomization\Src\UnrestrictedCustomization\macros.uci )

//======================================================================================================================
// METHODS

///
/// Returns true if character pool is currently opened, false otherwise.
///
public static function bool IsOpen() {
	return `PresBase.ScreenStack.GetLastInstanceOf(class'UICharacterPool') != none;
}

///
/// Returns the the lost of character in the pool (weither males, females, or both).
///
public static function array<XComGameState_Unit> GetCharacters( EGender _gender = EGender_None ) {
	local array<XComGameState_Unit> _retVal;
	local XComGameState_Unit _unit;
	local int i;
	_retVal = CharacterPoolManager(`XENGINE.GetCharacterPoolManager()).CharacterPool;
	if( _gender != EGender_None ) {
		for(i=_retVal.Length-1; i>=0; i-- ) {
			_unit = _retVal[i];
			if( class'uc_Customizer'.static.GetGender(_unit) != _gender ) {
				_retVal.RemoveItem(_unit);
			}
		}
	}
	return _retVal;
}
