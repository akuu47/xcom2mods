//TDOO refactor

///
/// class to store body part templates in a way that allows to exclude duplicate easily.
///
class uc_BodyPartArchetype extends JsonObject dependson(uc_BodyPartUtil);

`define ClassName uc_BodyPartArchetype
`include( UnrestrictedCustomization\Src\UnrestrictedCustomization\macros.uci )

//======================================================================================================================
// ENUM

enum uc_EBlacklist {
	uc_EBlacklist_None, // not blacklisted
	uc_EBlacklist_Uc, // blacklisted by this mod
	uc_EBlacklist_Mod, // blacklisted by another mod
	uc_EBlacklist_User // blacklisted by user
};

//======================================================================================================================
// STRUCTS

///
/// Struct used to (un)serialize from/to ini file.
///
struct uc_BodyPartTemplate {
	var string ArchetypeName;
	var string DlcName;
	var string DisplayName;
	var string Icon;
	var array<uc_EBodyPartType> PartTypes;
	var array<EGender> Genders;
	var array<uc_EArmorType> ArmorTypes;
	var array<uc_ETechLevel> TechLevels;
	var array<uc_EStyle> Styles;
};

//======================================================================================================================
// FIELDS

var private uc_Config ConfigMgr;

var private bool Bogus;
var private uc_EBlacklist Blacklist;

var privatewrite uc_BodyPartTemplate Template;
var privatewrite X2BodyPartTemplate VanillaTemplate;

//======================================================================================================================
// PROPERTIES

///
/// Returns true if multiple vanilla templates reference that archetype.
///
public function bool IsBogus() {
	return Bogus;
}

public function string GetArchetypeName() {
	return Template.ArchetypeName;
}

///
///
///
public function bool IsBlacklisted() {
	return Blacklist != uc_EBlacklist_None;
}

///
///
///
public function uc_EBlacklist GetBlacklist() {
	return Blacklist;
}
public function SetBlacklist( uc_EBlacklist _blacklist ) {
	Blacklist = _blacklist;
}

///
/// The html-formatted label, with icon (if any).
///
public function string GetLabel( bool _genderSuffix ) {
	local string _s;

	_s = GetBodyPartIcon() $ Template.DisplayName;

	if( _genderSuffix 
		&& Template.DlcName != `ModPackage // do not add prefix for "none"
	) {
		if( Template.Genders.Find(eGender_Male) >= 0 ) _s @= `Localize("MaleSuffix");
		else if( Template.Genders.Find(eGender_Female) >= 0 ) _s @= `Localize("FemaleSuffix");
	}

	return _s;
}

///
///
///
public function string GetDlcName() {
	return Template.DlcName;
}
public function SetDlcName( string _value, bool _writeChange ) {
	if( _value == Template.DlcName ) return;
	Template.DlcName = _value;
	if(_writeChange) Save();
}

///
///
///
public function bool HasPartType( uc_EBodyPartType _value ) {
	return Template.PartTypes.Find(_value) >= 0;
}

///
///
///
public function bool HasGender( EGender _value ) {
	return Template.Genders.Find(_value) >= 0;
}

///
///
///
public function bool HasArmorType( uc_EArmorType _value ) {
	return Template.ArmorTypes.Find(_value) >= 0;
}

///
///
///
public function bool HasTechLevel( uc_ETechLevel _value ) {
	return Template.TechLevels.Find(_value) >= 0;
}

///
///
///
public function bool HasStyle( uc_EStyle _value ) {
	return Template.Styles.Find(_value) >= 0;
}

//======================================================================================================================
// CTOR

///
/// Instantiates this class.
///
public static function uc_BodyPartArchetype CreateBodyPartArchetype( string _id ) {
	return BodyPartArchetype( class'uc_BodyPartArchetype', _id );
}

protected static function uc_BodyPartArchetype BodyPartArchetype(
	class<uc_BodyPartArchetype> _class, string _id
) {
	local uc_BodyPartArchetype this;
	this = new _class;
	this.InitBodyPartArchetype(_id);
	return this;
}

private function InitBodyPartArchetype( string _archetypeName ) {
	Template.ArchetypeName = _archetypeName;
}

//======================================================================================================================
// METHODS

private function AddPartType( uc_EBodyPartType _value ) {
	if(_value == uc_EBodyPartType_None) return;
	if( HasPartType(_value) ) return;
	Template.PartTypes.AddItem(_value);
	//Save();
}

private function AddGender( EGender _value ) {
	if(_value == eGender_None) return;
	if( HasGender(_value) ) return;
	Template.Genders.AddItem(_value);
	//Save();
}

private function AddArmorType( uc_EArmorType _value ) {
	if(_value == uc_EArmorType_None) return;
	if( HasArmorType(_value) ) return;
	Template.ArmorTypes.AddItem(_value);
	//Save();
}

private function AddTechLevel( uc_ETechLevel _value ) {
	if(_value == uc_ETechLevel_None) return;
	if( HasTechLevel(_value) ) return;
	Template.TechLevels.AddItem(_value);
	//Save();
}

private function AddStyle( uc_EStyle _value ) {
	if(_value == uc_EStyle_None) return;
	if( HasStyle(_value) ) return;
	Template.Styles.AddItem(_value);
	//Save();
}


public function SetTemplate( X2BodyPartTemplate _vanillaTemplate ) {
	//local uc_EBodyPartType _vanillaTemplatePartType;
	//_vanillaTemplatePartType = class'uc_BodyPartUtil'.static.StringToBodyPartType(_vanillaTemplate.PartType);

	if( VanillaTemplate == none ) {
		// first time
		//Template.PartType = _vanillaTemplatePartType;
		//Template.DlcName = string(_vanillaTemplate.DLCName);
	}
	else {
		Bogus = true;
	}
	
	if( _vanillaTemplate.ArchetypeName == Template.ArchetypeName
	//&& string(_vanillaTemplate.DLCName) == Template.DlcName
	//&& _vanillaTemplatePartType == Template.PartType
	) {
		VanillaTemplate = _vanillaTemplate;
		Template.DisplayName = GetVanillaTemplateDisplayName(_vanillaTemplate);
		if( _vanillaTemplate.Gender != eGender_None ) {
			AddGender(_vanillaTemplate.Gender);
		}else{
			AddGender(eGender_Male);
			AddGender(eGender_Female);
		}
		AddPartType( class'uc_BodyPartUtil'.static.StringToBodyPartType(_vanillaTemplate.PartType) );
		AddArmorType( class'uc_BodyPartUtil'.static.GetArmorType(_vanillaTemplate.ArmorTemplate) );
		AddTechLevel( class'uc_BodyPartUtil'.static.GetArmorTechLevel(_vanillaTemplate.ArmorTemplate) );
		AddStyle( GetVanillaTemplateStyle(_vanillaTemplate) );
	}
	else {
		`LogError("incompatible template");
		`LogVar(_vanillaTemplate.ArchetypeName);
		//`LogVar(Template.DlcName);
		//`LogVar(Template.PartType);
		//`LogVar(_vanillaTemplate.DLCName);
		//`LogVar(_vanillaTemplatePartType);
	}
}


private static function uc_EStyle GetVanillaTemplateStyle( X2BodyPartTemplate _template ) {
	switch( _template.CharacterTemplate ) {
		case 'Civilian':
		case 'Engineer':
		case 'Scientist':
		case 'Clerk':
		case 'FacelessCivilian':
		case 'HostileCivilian':
		case 'FriendlyVIPCivilian':
		case 'HostileVIPCivilian':
			return uc_EStyle_Civilian;
		
		case 'VolunteerArmyMilitia':
		case 'VolunteerArmyMilitiaM2':
		case 'VolunteerArmyMilitiaM3':
		case 'Soldier_VIP':
		case 'Scientist_VIP':
		case 'Engineer_VIP':
		case 'TutorialCentral':
		case 'StrategyCentral':
		case 'HeadEngineer':
		case 'HeadScientist':
			return uc_EStyle_XCom;

		default:
		//case 'CivilianMilitia':
		//case 'CivilianMilitiaM2':
		//case 'CivilianMilitiaM3':
			//Soldier
			//ReaperSoldier
			//SkirmisherSoldier
			//TemplarSoldier
			//SparkSoldier
			return uc_EStyle_XCom;
	}
}

///
/// arrays must not contain duplicates nor null values.
/// returns true if the archetype was modified as a result (and thus should probably be saved)
///
public function bool Update(
	string _displayName,
	array<EGender> _genders,
	array<uc_EArmorType> _armorTypes,
	array<uc_ETechLevel> _techLevels,
	array<uc_EStyle> _styles,
	string _dlcName = "",
	string _icon = ""
) {
	local bool _modified;
	local string _vanillaDisplayName;

	_vanillaDisplayName = GetVanillaTemplateDisplayName(VanillaTemplate);
	if( _displayName == "" ) _displayName = _vanillaDisplayName;
	_modified = _displayName != _vanillaDisplayName;

	if( _dlcName != "" && _dlcName != Template.DlcName ) {
		Template.DlcName = _dlcName;
		_modified = true;
	}

	if( _icon != "" && _icon != Template.Icon ) {
		Template.Icon = _icon;
		_modified = true;
	}

	if( _genders.Length>0 && ! class'uc_ArrayUtil'.static.ContainSameElements_EGender(_genders, Template.Genders) ) {
		Template.Genders = _genders;
		_modified = true;
	}

	if( _armorTypes.Length>0 && ! class'uc_ArrayUtil'.static.ContainSameElements_uc_EArmorType(_armorTypes, Template.ArmorTypes) ) {
		Template.ArmorTypes = _armorTypes;
		_modified = true;
	}

	if( _techLevels.Length>0 && ! class'uc_ArrayUtil'.static.ContainSameElements_uc_ETechLevel(_techLevels, Template.TechLevels) ) {
		Template.TechLevels = _techLevels;
		_modified = true;
	}

	if( _styles.Length>0 && ! class'uc_ArrayUtil'.static.ContainSameElements_uc_EStyle(_styles, Template.Styles) ) {
		Template.Styles = _styles;
		_modified = true;
	}

	if( Bogus || _modified ) {
		Bogus = false;
		return true;
	}

	return false;
}

///
/// Save archetype infos to ini config
///
public function Save() {
	local int _structIndex;
	local uc_Config _config;
	_config = class'uc_Config'.static.GetInstance();

	// copy Template to _config
	_structIndex = _config.BodyPartTemplates.Find( 'ArchetypeName', Template.ArchetypeName );
	if( _structIndex != INDEX_NONE ) {
		_config.BodyPartTemplates[_structIndex] = Template;
	}else {
		_config.BodyPartTemplates.AddItem(Template);
	}

	_config.ScheduleSaveConfig();
}






///
///
///
public static function uc_BodyPartArchetype GetArchetypeFromVanillaTemplate( X2BodyPartTemplate _vanillaTemplate ) {
	local uc_Global _global;
	_global = class'uc_Global'.static.GetInstance();
	return uc_BodyPartArchetype( _global.BodyPartArchetypesByName.Get(_vanillaTemplate.ArchetypeName) );
}



///
///
///
private static function string GetVanillaTemplateDisplayName( X2BodyPartTemplate _template ) {
	local string _s;

	if( _template.DisplayName != "" ) {
		return _template.DisplayName;
	}

	if( class'uc_Localizer'.static.LocalizeX2BodyPartTemplate(_template, _s) ) {
		return _s;
	}

	_s = string(_template.DataName);

	// remove dlc prefixes
	_s = Repl(_s, "DLC_0_", "");
	_s = Repl(_s, "DLC_30_", "");

	_s = Repl(_s, "Cnv", `Localize("Padded")$" ");
	_s = Repl(_s, "Plt", `Localize("Plated")$" ");
	_s = Repl(_s, "Pwr", `Localize("Powered")$" ");
	_s = Repl(_s, "Alien", `Localize("Alien")$" ");

	_s = Repl(_s, "Lgt_", `Localize("Light")$" ");
	_s = Repl(_s, "Med_", `Localize("Medium")$" ");
	_s = Repl(_s, "Hvy_", `Localize("Heavy")$" ");

	// remove redondant stuff
	_s = Repl(_s, "Std_", "");
	_s = Repl(_s, "Arms_", "");
	_s = Repl(_s, "Forearm_", "");
	_s = Repl(_s, "Thighs_", "");
	_s = Repl(_s, "TorsoDeco_", "");
	_s = Repl(_s, "Shins_", "");
	_s = Repl(_s, "Legs_", "");
	_s = Repl(_s, "Shoulder_", "");
	
	_s = Repl(_s, "Left_", "");
	_s = Repl(_s, "Right_", "");

	// remove gender
	_s = Repl(_s, "_M", "");
	_s = Repl(_s, "_F", "");

	_s = Repl(_s, "_", " ");

	return _s;
}

///
/// Returns DLC-icon (in html iirc) for given template if any, empty string otherwise.
///
private function string GetBodyPartIcon() {
	local array< delegate<XComCharacterCustomization.GetIconsForBodyPartCallback> > dlgts;
	local delegate<XComCharacterCustomization.GetIconsForBodyPartCallback> dlgt;
	local string icon;

	if( Template.Icon != "" ) {
		return class'UIUtilities_Text'.static.InjectImage( "img:///" $ Template.Icon, 26, 26, -4) $ " ";
	}
	
	dlgts = `PresBase.m_kCustomizeManager.arrGetIconsForBodyPartDelegates;
	foreach dlgts(dlgt) {
		icon = dlgt(VanillaTemplate);
		if( icon != "" ) break;
	}
	return icon;
}
