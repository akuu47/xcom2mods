///
/// Class to test if dlc are active and other dlc related operation.
///
class xmf_DlcUtil extends Object;

`define ClassName xmf_DlcUtil
`include( UnrestrictedCustomization\Src\UnrestrictedCustomization\macros.uci )

//======================================================================================================================
// ENUMS

/*
enum EDlc {
	EDlc_ResistanceWarriorPack,
	EDlc_AnarchysChildren,
	EDlc_AlienHunters,
	EDlc_ShensLastGift,
	EDlc_WarOfTheChosen
};
*/

//======================================================================================================================
// METHODS

private static function bool IsTorsoTemplateDefined( name _templateName ) {
	return class'X2BodyPartTemplateManager'.static.GetBodyPartTemplateManager().FindUberTemplate(
		"Torso",
		_templateName
	) != none;
}


public static function bool IsResistanceWarriorActive() {
	return IsTorsoTemplateDefined('DLC_0_ResistanceWarrior_A_M');
}


public static function bool IsAnarchysChildrenActive() {
	return IsTorsoTemplateDefined('DLC_30_Torso_M');
}


public static function bool IsAlienHuntersActive() {
	return IsTorsoTemplateDefined('AlienMed_Std_A_M');
}


public static function bool IsShensLastGiftActive() {
	return IsTorsoTemplateDefined('Spark_A');
}


public static function bool IsWarOfTheChosenActive() {
	return IsTorsoTemplateDefined('CnvReaper_Std_A_M');
}

//======================================================================================================================


//TODO FixBodyPartDlcNames should probably be in uc_BodyPartArchetype

///
/// Ensures body parts has DLCName.
/// If not, it will be filled by archetype prefix
/// or for Firaxis' assets : 'Vanilla', 'DLC_0', 'DLC_1', 'DLC_2', or 'DLC_3'
///
public static function FixBodyPartDlcNames( array<Object> _uncastedArchetypes ) {
	local string _msg;
	local Object _uncastedArchetype;
	local uc_BodyPartArchetype _archetype;
	local xmf_Global _global;
	local bool _assertionPassed;

	_msg = "";
	_global = class'xmf_Global'.static.GetInstance();

	`vlogvar(_uncastedArchetypes.Length);
	
	foreach _uncastedArchetypes(_uncastedArchetype) {
		_archetype = uc_BodyPartArchetype(_uncastedArchetype);
		if( _archetype.GetDLCName() == "" || _archetype.GetDLCName() == "None" ) {
			_archetype.SetDLCName( InferDlcName(_archetype.VanillaTemplate), false );
			_assertionPassed = _archetype.GetDLCName() != ""; // assert macro cannot contain double quotes
			`Assert( _assertionPassed );
			_msg @= _archetype.Template.DLCName;
		}
		if( _global.BodyPartUtil_DlcNames.Find(_archetype.Template.DLCName) < 0 ) {
			_global.BodyPartUtil_DlcNames.AddItem(_archetype.Template.DLCName);
		}
	}
	`LogInfo( "Fixed Dlc Names for" @ _msg );
}

private static function string InferDlcName( X2BodyPartTemplate _template ) {
	if( _template.DLCName != '' ) return string(_template.DLCName);
	if( IsBodyPartFromVanilla(_template) ) return "Vanilla";
	if( IsBodyPartFromDlc0(_template) ) return "Vanilla"; // DLC_0 is considered vanilla
	if( IsBodyPartFromDlc1(_template) ) return "DLC_1";
	if( IsBodyPartFromDlc2(_template) ) return "DLC_2";
	if( IsBodyPartFromDlc3(_template) ) return "DLC_3";
	return GetArchetypePrefix(_template);
}

private static function bool IsBodyPartFromVanilla( X2BodyPartTemplate _template ) {
	local string _archetypePerfix;
	_archetypePerfix = GetArchetypePrefix(_template);
	switch( _archetypePerfix ) {
		case "GameUnit_XComSoldier":
		case "GameUnit_Civilian":
		case "GameUnit_Reaper":
		case "GameUnit_Skirmisher":
		case "GameUnit_Templar":
		case "GameUnit_HOR":
		case "GameUnit_Spark":
		case "GameUnit_CivilianMilitia":
		case "Central_GD":
		case "Shen_GD":
		case "Tygan_GD":
		case "Jane_GD":
		case "SldCnvUnderlay_Std_GD":
		case "SldCnvMed_Std_GD":
		case "SldPltLgt_Std_GD":
		case "SldPltMed_Std_GD":
		case "SldPltHvy_Std_GD":
		case "SldPwrLgt_Std_GD":
		case "SldPwrMed_Std_GD":
		case "SldPwrHvy_Std_GD":
		case "AvengerEngineers_GD":
		case "AvengerScientists_GD":
		case "Eyes_Default":
		case "Teeth_Default":
		case "X2_UnitPatterns":
		case "X2_UnitTattoos":
		case "X2_UnitScars":
		case "X2_UnitFacePaint":
		case "PreviewVoices":
			return true;
	}
	if( 0 == InStr(_archetypePerfix, "Voice_")
	||  0 == InStr(_archetypePerfix, "MaleVoice")
	||  0 == InStr(_archetypePerfix, "FemaleVoice")
	||  0 == InStr(_archetypePerfix, "Head_")
	||  0 == InStr(_archetypePerfix, "Hair_")
	||  0 == InStr(_archetypePerfix, "FacialHair_")
	||  0 == InStr(_archetypePerfix, "Prop_FaceLower")
	||  0 == InStr(_archetypePerfix, "Prop_FaceUpper")
	||  0 == InStr(_archetypePerfix, "Prop_Sunglasses")
	||  0 == InStr(_archetypePerfix, "Prop_Glasses")
	||  0 == InStr(_archetypePerfix, "Helmet_")
	||  0 == InStr(_archetypePerfix, "Hat_")
	||  0 == InStr(_archetypePerfix, "ReaperMaleVoice")
	||  0 == InStr(_archetypePerfix, "ReaperFemaleVoice")
	||  0 == InStr(_archetypePerfix, "SkirmisherMaleVoice")
	||  0 == InStr(_archetypePerfix, "SkirmisherFemaleVoice")
	||  0 == InStr(_archetypePerfix, "TemplarMaleVoice")
	||  0 == InStr(_archetypePerfix, "TemplarFemaleVoice")
	) {
		return true;
	}
	return false;
}

private static function bool IsBodyPartFromDlc0( X2BodyPartTemplate _template ) {
	return InStr(_template.ArchetypeName, "DLC_0") == 0;
}

private static function bool IsBodyPartFromDlc1( X2BodyPartTemplate _template ) {
	return InStr(_template.ArchetypeName, "DLC_1") == 0 || InStr(_template.ArchetypeName, "DLC_30") == 0;
}

private static function bool IsBodyPartFromDlc2( X2BodyPartTemplate _template ) {
	return InStr(_template.ArchetypeName, "DLC_2") == 0 || InStr(_template.ArchetypeName, "DLC_60") == 0
		||   InStr(_template.ArchetypeName, "CentralVoice1_Localized.") == 0;
}

private static function bool IsBodyPartFromDlc3( X2BodyPartTemplate _template ) {
	if( InStr(_template.ArchetypeName, "DLC_2") == 0 || InStr(_template.ArchetypeName, "DLC_60") == 0 ) return true;
	switch( GetArchetypePrefix(_template) ) {
		case "GameUnit_Spark":
		case "ShenVoice1_Localized":
		case "SparkCVoice1_English":
		case "SparkSVoice1_English":
		case "SparkJVoice1_English":
		case "SparkCVoice1_French":
		case "SparkSVoice1_French":
		case "SparkJVoice1_French":
		case "SparkCVoice1_German":
		case "SparkSVoice1_German":
		case "SparkJVoice1_German":
		case "SparkCVoice1_Italian":
		case "SparkSVoice1_Italian":
		case "SparkJVoice1_Italian":
		case "SparkCVoice1_Spanish":
		case "SparkSVoice1_Spanish":
		case "SparkJVoice1_Spanish":
			return true;
	}
	return false;
}


private static function string GetArchetypePrefix( X2BodyPartTemplate _template ) {
	local int _dotIndex;
	_dotIndex = InStr(_template.ArchetypeName, ".");
	if( _dotIndex < 0 ) {
		`LogWarning( "Invalid Archetype name : " $ _template.ArchetypeName );
		return _template.ArchetypeName;
	}
	return Left(_template.ArchetypeName, _dotIndex);
}

///
/// Use this instead of class'X2BodyPartTemplateManager'.static.GetBodyPartTemplateManager().GetPartPackNames();
/// Because this one gets updated after #FixDlcNames was called.
///
public static function array<string> GetDlcNames() {
	local xmf_Global _global;
	_global = class'xmf_Global'.static.GetInstance();

	return _global.BodyPartUtil_DlcNames;
} 

///
///
///
public static function LogDlcNames() {
	local string _dlcName;
	local string _msg;
	local xmf_Global _global;
	_global = class'xmf_Global'.static.GetInstance();

	_msg = "BodyPart DLCs :";
	foreach _global.BodyPartUtil_DlcNames(_dlcName) {
		_msg @= _dlcName;
	}
	`LogInfo( _msg );
}