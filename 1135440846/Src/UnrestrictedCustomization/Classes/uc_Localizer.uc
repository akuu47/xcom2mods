///
/// All-static class for localization.
///
class uc_Localizer extends Object;

`define ClassName uc_Localizer
`include( UnrestrictedCustomization\Src\UnrestrictedCustomization\macros.uci )

//======================================================================================================================
// METHODS

///
/// _text is case insensitive
///
public static function string GetLocalizedText( coerce string _text ) {
	local string _retval;

	/*
	switch( Locs(_text) ) {
		case "none": _retval = Localize("Helmet_0_NoHelmet_M X2BodyPartTemplate", "DisplayName", "XComGame"); break;
		case "gender": _retval = Localize("UICustomize_Info", "m_strGender", "XComGame"); break;
		case "rename": _retval = Localize("UIMPShell_SquadLoadoutList", "m_strRenameButtonText", "XComGame"); break;
		case "male": _retval = Localize("XComCharacterCustomization", "Gender_Male", "XComGame"); break;
		case "female": _retval = Localize("XComCharacterCustomization", "Gender_Female", "XComGame"); break;
		case "hidden": _retval = Localize("XGMission", "m_aFirstOpName[44]", "XComGame"); break;
		case "heavy": _retval = Localize("XGMission", "m_aFirstOpName[100]", "XComGame"); break;
		case "randomize": _retval = Localize("UIPhotoboothBase", "Randomize", "XComGame"); break;
		case "confirm": _retval = Localize("UIUtilities_Text", "m_strGenericConfirm", "XComGame"); break;
		case "cancel": _retval = Localize("UIUtilities_Text", "m_strGenericCancel", "XComGame"); break;
		case "options": _retval = Localize("UIShell", "m_sOptions", "XComGame"); break;
		case "edit": _retval = Localize("UISquadSelect_ListItem", "m_strEdit", "XComGame"); break;
		case "reaper": _retval = Localize("Reaper X2SoldierClassTemplate", "DisplayName", "XComGame"); break;
		case "skirmisher": _retval = Localize("Skirmisher X2SoldierClassTemplate", "DisplayName", "XComGame"); break;
		case "templar": _retval = Localize("Templar X2SoldierClassTemplate", "DisplayName", "XComGame"); break;
		case "spark": _retval = Localize("Spark X2SoldierClassTemplate", "DisplayName", "XComGame"); break;
		case "techlevel": _retval = Localize("XLocalizedData", "TechStat", "XComGame"); break;
	}
	_retval = CapitalizeFirstLetter(_retval);
	*/
	_retval = "";

	// fallback to mod's localization database
	if( _retval == "" || IsFailedLocalization(_retval) ) {
		_retval = Localize( `ModPackage, _text, `ModPackage );
	}

	// fallback to non-localized...
	if( IsFailedLocalization(_retval) ) {
		`LogWarning("Localization failed");
		`LogVar(_retval);
		`LogVar(_text);
		_retval = _text;
	}

	return _retval;
}


public static function string LocalizeSafely( coerce string _section, coerce string _text, coerce string _package ) {
	local string _retval;
	_retval = Localize( _section, _text, _package );
	if( IsFailedLocalization(_retval) ) _retval = _text;
	return _retval;
}


///
/// Sets localized template's name in out var.
/// returns true if localization succeeded, false otherwise.
///
public static function bool LocalizeX2BodyPartTemplate( X2BodyPartTemplate _template, out string _localizedName ) {
	_localizedName = Localize( _template.DataName$" X2BodyPartTemplate", "DisplayName", "XComGame" );
	return ! IsFailedLocalization(_localizedName);
}


public static function bool IsFailedLocalization( string _str ) {
	return _str == "" || Left(_str,1) == "?";
}


private static function string CapitalizeFirstLetter( string _str ) {
	return Caps( Left(_str, 1) ) $ Locs( Mid(_str, 1) );
}