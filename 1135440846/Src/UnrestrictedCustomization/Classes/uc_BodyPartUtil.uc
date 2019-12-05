///
/// X2BodyPartTemplateManager wrapper that 
///
///
class uc_BodyPartUtil extends UiDataStore;

`define ClassName uc_BodyPartUtil
`include( UnrestrictedCustomization\Src\UnrestrictedCustomization\macros.uci )

//======================================================================================================================
// ENUMS

enum uc_EBodyPartType {
	uc_EBodyPartType_None,
	uc_EBodyPartType_Pawn,
	uc_EBodyPartType_Torso,
	uc_EBodyPartType_Arms,
	uc_EBodyPartType_Legs,
	uc_EBodyPartType_Head,
	uc_EBodyPartType_Haircut,
	uc_EBodyPartType_Helmet,
	uc_EBodyPartType_ArmorPattern,
	uc_EBodyPartType_Voice,
	uc_EBodyPartType_Eyes,
	uc_EBodyPartType_Teeth,
	uc_EBodyPartType_Beard,
	uc_EBodyPartType_FacePropUpper,
	uc_EBodyPartType_FacePropLower,
	uc_EBodyPartType_Tattoo_LeftArm,
	uc_EBodyPartType_Tattoo_RightArm,
	uc_EBodyPartType_Scars,
	uc_EBodyPartType_Facepaint,
	uc_EBodyPartType_LeftArm,
	uc_EBodyPartType_RightArm,
	uc_EBodyPartType_LeftArmDeco,
	uc_EBodyPartType_RightArmDeco,
	uc_EBodyPartType_LeftForearm,
	uc_EBodyPartType_RightForearm,
	uc_EBodyPartType_Thighs,
	uc_EBodyPartType_Shins,
	uc_EBodyPartType_TorsoDeco
};

enum uc_EArmorType {
	uc_EArmorType_None,
	uc_EArmorType_Light,
	uc_EArmorType_Medium,
	uc_EArmorType_Heavy,
	uc_EArmorType_Spark
};

enum uc_ETechLevel {
	uc_ETechLevel_None,
	uc_ETechLevel_Padded,
	uc_ETechLevel_Plated,
	uc_ETechLevel_Powered,
	uc_ETechLevel_Alien
};

enum uc_EStyle {
	uc_EStyle_None,
	uc_EStyle_Civilian,
	uc_EStyle_XCom,
	uc_EStyle_Advent,
	uc_EStyle_Other
};


//======================================================================================================================
// CONSTS

const InvisibleArchetype = "Helmet_0_NoHelmet.ARC_Helmet_0_NoHelmet";

//======================================================================================================================
// FIELDS

var private const array<string> Tier1ArmorTemplates;
var private const array<string> Tier2ArmorTemplates;
var private const array<string> Tier3ArmorTemplates;
var private const array<string> Tier4ArmorTemplates;

var private const array<string> LightArmorTemplates;
var private const array<string> HeavyArmorTemplates;
var private const array<string> SparkArmorTemplates;
var private const array<string> ReaperArmorTemplates;
var private const array<string> SkirmisherArmorTemplates;
var private const array<string> TemplarArmorTemplates;

//======================================================================================================================
// uc_EBodyPartType UTILS

///
///
///
public static function string BodyPartTypeToString( uc_EBodyPartType _partType ) {
	switch( _partType ) {
		case uc_EBodyPartType_Pawn: return "Pawn";
		case uc_EBodyPartType_Torso: return "Torso";
		case uc_EBodyPartType_Arms: return "Arms";
		case uc_EBodyPartType_Legs: return "Legs";
		case uc_EBodyPartType_Head: return "Head";
		case uc_EBodyPartType_Haircut: return "Hair";
		case uc_EBodyPartType_Helmet: return "Helmets";
		case uc_EBodyPartType_ArmorPattern: return "Patterns";
		case uc_EBodyPartType_Voice: return "Voice";
		case uc_EBodyPartType_Eyes: return "Eyes";
		case uc_EBodyPartType_Teeth: return "Teeth";
		case uc_EBodyPartType_Beard: return "Beards";
		case uc_EBodyPartType_FacePropUpper: return "FacePropsUpper";
		case uc_EBodyPartType_FacePropLower: return "FacePropsLower";
		case uc_EBodyPartType_Tattoo_LeftArm: return "Tattoos";
		case uc_EBodyPartType_Tattoo_RightArm: return "Tattoos";
		case uc_EBodyPartType_Scars: return "Scars";
		case uc_EBodyPartType_Facepaint: return "Facepaint";
		case uc_EBodyPartType_LeftArm: return "LeftArm";
		case uc_EBodyPartType_RightArm: return "RightArm";
		case uc_EBodyPartType_LeftArmDeco: return "LeftArmDeco";
		case uc_EBodyPartType_RightArmDeco: return "RightArmDeco";
		case uc_EBodyPartType_LeftForearm: return "LeftForearm";
		case uc_EBodyPartType_RightForearm: return "RightForearm";
		case uc_EBodyPartType_Thighs: return "Thighs";
		case uc_EBodyPartType_Shins: return "Shins";
		case uc_EBodyPartType_TorsoDeco: return "TorsoDeco";
	}
}

///
///
///
public static function uc_EBodyPartType StringToBodyPartType( string _internalPartType ) {
	switch( _internalPartType ) {
		case "Pawn": return uc_EBodyPartType_Pawn;
		case "Torso": return uc_EBodyPartType_Torso;
		case "Arms": return uc_EBodyPartType_Arms;
		case "Legs": return uc_EBodyPartType_Legs;
		case "Head": return uc_EBodyPartType_Head;
		case "Hair": return uc_EBodyPartType_Haircut;
		case "Helmets": return uc_EBodyPartType_Helmet;
		case "Patterns": return uc_EBodyPartType_ArmorPattern;
		case "Voice": return uc_EBodyPartType_Voice;
		case "Eyes": return uc_EBodyPartType_Eyes;
		case "Teeth": return uc_EBodyPartType_Teeth;
		case "Beards": return uc_EBodyPartType_Beard;
		case "FacePropsUpper": return uc_EBodyPartType_FacePropUpper;
		case "FacePropsLower": return uc_EBodyPartType_FacePropLower;
		case "Tattoos": return uc_EBodyPartType_Tattoo_LeftArm;
		case "Tattoos": return uc_EBodyPartType_Tattoo_RightArm;
		case "Scars": return uc_EBodyPartType_Scars;
		case "Facepaint": return uc_EBodyPartType_Facepaint;
		case "LeftArm": return uc_EBodyPartType_LeftArm;
		case "RightArm": return uc_EBodyPartType_RightArm;
		case "LeftArmDeco": return uc_EBodyPartType_LeftArmDeco;
		case "RightArmDeco": return uc_EBodyPartType_RightArmDeco;
		case "LeftForearm": return uc_EBodyPartType_LeftForearm;
		case "RightForearm": return uc_EBodyPartType_RightForearm;
		case "Thighs": return uc_EBodyPartType_Thighs;
		case "Shins": return uc_EBodyPartType_Shins;
		case "TorsoDeco": return uc_EBodyPartType_TorsoDeco;
		default:
			`LogWarning( "Unknown body part type " $ _internalPartType );
			return uc_EBodyPartType_None;
	}
}

//======================================================================================================================
// FIXES

///
/// Fix soldier pawn so it work with thighs.
///
public static function FixSoldierPawnTemplates() {
	if( ! class'xmf_DlcUtil'.static.IsWarOfTheChosenActive() ) {
		`LogWarning("Cannot use Wotc's pawns since Wotc is not active.");
		return;
	}
	`LogInfo("Fixing soldiers pawn template, so it's compatible with thighs...");
	class'uc_BodyPartFilter'.static.GetTemplate(uc_EBodyPartType_Pawn, 'XCom_Soldier_M').ArchetypeName = "GameUnit_Reaper.ARC_Reaper_M";
	class'uc_BodyPartFilter'.static.GetTemplate(uc_EBodyPartType_Pawn, 'XCom_Soldier_F').ArchetypeName = "GameUnit_Reaper.ARC_Reaper_F";
}

///
///
///
public static function FixHeroBodyPartsArmorTemplates() {
	local array<uc_BodyPartArchetype> _archetypes;
	local uc_BodyPartArchetype _archetype;
	local uc_BodyPartFilter _filter;
	local int _i;

	_filter = class'uc_BodyPartFilter'.static.CreateBodyPartFilter();
	for( _i=0; _i<=uc_EBodyPartType_TorsoDeco; _i++ ) {
		switch( uc_EBodyPartType(_i) ) {
			case uc_EBodyPartType_Torso:
			case uc_EBodyPartType_Arms:
			case uc_EBodyPartType_Legs:
			case uc_EBodyPartType_LeftArm:
			case uc_EBodyPartType_RightArm:
			case uc_EBodyPartType_LeftArmDeco:
			case uc_EBodyPartType_RightArmDeco:
			case uc_EBodyPartType_LeftForearm:
			case uc_EBodyPartType_RightForearm:
			case uc_EBodyPartType_Thighs:
			case uc_EBodyPartType_Shins:
			case uc_EBodyPartType_TorsoDeco:
				_filter.PartTypes.AddItem( uc_EBodyPartType(_i) );
				break;
		}
	}

	_archetypes = _filter.GetAchetypes();
	foreach _archetypes(_archetype) {
		if( _archetype.VanillaTemplate.ArmorTemplate != '' ) continue;
		switch( _archetype.VanillaTemplate.CharacterTemplate ) {
			case 'ReaperSoldier': _archetype.VanillaTemplate.ArmorTemplate='ReaperArmor'; break;
			case 'SkirmisherSoldier': _archetype.VanillaTemplate.ArmorTemplate='SkirmisherArmor'; break;
			case 'TemplarSoldier': _archetype.VanillaTemplate.ArmorTemplate='TemplarArmor'; break;
		}
	}
}

//======================================================================================================================
// ARMOR UTILS

///
/// Returns the armor type corresponding to given armor template name.
///
public static function uc_EArmorType GetArmorType( coerce string _armorTemplateName ) {
	if( default.LightArmorTemplates.Find(_armorTemplateName) != INDEX_NONE ) return uc_EArmorType_Light;
	if( default.HeavyArmorTemplates.Find(_armorTemplateName) != INDEX_NONE ) return uc_EArmorType_Heavy;
	if( default.SparkArmorTemplates.Find(_armorTemplateName) != INDEX_NONE ) return uc_EArmorType_Spark;
	return uc_EArmorType_Medium;
}

///
/// Returns the tech level corresponding to given armor template name.
///
public static function uc_ETechLevel GetArmorTechLevel( coerce string _armorTemplateName ) {
	if( default.Tier1ArmorTemplates.Find(_armorTemplateName) != INDEX_NONE ) return uc_ETechLevel_Padded;
	if( default.Tier2ArmorTemplates.Find(_armorTemplateName) != INDEX_NONE ) return uc_ETechLevel_Plated;
	if( default.Tier3ArmorTemplates.Find(_armorTemplateName) != INDEX_NONE ) return uc_ETechLevel_Powered;
	if( default.Tier4ArmorTemplates.Find(_armorTemplateName) != INDEX_NONE ) return uc_ETechLevel_Alien;
	return uc_ETechLevel_Padded;
}

//======================================================================================================================
// INVISIBLE PARTS

///
/// 
///
public static function AddInvisiblePartTemplates() {
	local X2BodyPartTemplateManager _mgr;
	local X2BodyPartTemplate _template;
	local int _i;

	_mgr = class'X2BodyPartTemplateManager'.static.GetBodyPartTemplateManager();

	`LogInfo("Adding invisible body part templates...");
	for( _i=0; _i<=uc_EBodyPartType_TorsoDeco; _i++ ) {
		switch( uc_EBodyPartType(_i) ) {
			case uc_EBodyPartType_Torso:
			case uc_EBodyPartType_Arms:
			case uc_EBodyPartType_Legs:
			case uc_EBodyPartType_LeftArm:
			case uc_EBodyPartType_RightArm:
			case uc_EBodyPartType_LeftArmDeco:
			case uc_EBodyPartType_RightArmDeco:
			case uc_EBodyPartType_LeftForearm:
			case uc_EBodyPartType_RightForearm:
			case uc_EBodyPartType_Thighs:
			case uc_EBodyPartType_Shins:
			case uc_EBodyPartType_TorsoDeco:
				_template = new class'X2BodyPartTemplate';
				_template.ArchetypeName = InvisibleArchetype;
				_template.ArmorTemplate = 'DoesNotExist';
				_template.DlcName = name( `ModPackage );
				_template.DisplayName = `Localize("None");
				_template.PartType = class'uc_BodyPartUtil'.static.BodyPartTypeToString( uc_EBodyPartType(_i) );
				_template.SetTemplateName( name(_template.PartType$"_Invisible") );
				_mgr.AddUberTemplate(_template.PartType, _template, true);
				break;
		}
	}
}

///
/// 
///
public static function X2BodyPartTemplate GetInvisibleTemplate(uc_EBodyPartType _partType) {
	switch( _partType ) {
		case uc_EBodyPartType_FacePropLower: return class'uc_BodyPartFilter'.static.GetTemplate(_partType, 'Prop_FaceLower_Blank');
		case uc_EBodyPartType_FacePropUpper: return class'uc_BodyPartFilter'.static.GetTemplate(_partType, 'Prop_FaceUpper_Blank');
		case uc_EBodyPartType_Helmet: return class'uc_BodyPartFilter'.static.GetTemplate(_partType, 'Helmet_0_NoHelmet_M');
	}
	return class'uc_BodyPartFilter'.static.GetTemplate(
		_partType,
		name(class'uc_BodyPartUtil'.static.BodyPartTypeToString(_partType)$"_Invisible")
	);
}

///
/// 
///
public static function bool IsInvisibleTemplate(X2BodyPartTemplate _template) {
	switch( _template.DataName ) {
		case 'Prop_FaceLower_Blank':
		case 'Prop_FaceUpper_Blank':
		case 'Helmet_0_NoHelmet_M':
			return true;
	}
	return _template.DataName == name(_template.PartType$"_Invisible");
}

//======================================================================================================================
defaultProperties // '{' in separate line or defaultProperties will be ignored !
{
	LightArmorTemplates={(
		"LightPlatedArmor", 
		"LightPoweredArmor",
		"LightAlienArmor",
		"LightAlienArmorMk2"
	)}
	HeavyArmorTemplates={(
		"HeavyPlatedArmor",
		"HeavyPoweredArmor",
		"HeavyAlienArmor",
		"HeavyAlienArmorMk2"
	)}
	SparkArmorTemplates={(
		"SparkArmor",
		"PlatedSparkArmor",
		"PoweredSparkArmor"
	)}
	ReaperArmorTemplates={(
		"ReaperArmor",
		"PlatedReaperArmor",
		"PoweredReaperArmor",
	)}
	SkirmisherArmorTemplates={(
		"SkirmisherArmor",
		"PlatedSkirmisherArmor",
		"PoweredSkirmisherArmor"
	)}
	TemplarArmorTemplates={(
		"TemplarArmor",
		"PlatedTemplarArmor",
		"PoweredTemplarArmor"
	)}

	Tier1ArmorTemplates={(
		"Underlay",
		"KevlarArmor",
		"ReaperArmor",
		"SkirmisherArmor",
		"TemplarArmor",
		"SparkArmor"
	)}
	Tier2ArmorTemplates={(
		"LightPlatedArmor",
		"MediumPlatedArmor",
		"HeavyPlatedArmor",
		"PlatedReaperArmor",
		"PlatedSkirmisherArmor",
		"PlatedTemplarArmor",
		"PlatedSparkArmor"
	)}
	Tier3ArmorTemplates={(
		"LightPoweredArmor",
		"MediumPoweredArmor",
		"HeavyPoweredArmor",
		"PoweredReaperArmor",
		"PoweredSkirmisherArmor",
		"PoweredTemplarArmor",
		"PoweredSparkArmor"
	)}
	Tier4ArmorTemplates={(
		"MediumAlienArmor",
		"LightAlienArmor",
		"LightAlienArmorMk2",
		"HeavyAlienArmor",
		"HeavyAlienArmorMk2"
	)}
}