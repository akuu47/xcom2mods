///
/// Class used to query body part templates.
/// (Use this instead of X2BodyPartTemplateManager)
///
/// - Allows to Assign values to properties you want to filter.
/// - Results are duplicate-free.
///
class uc_BodyPartFilter extends Object dependson(uc_BodyPartUtil);

`define ClassName uc_BodyPartFilter
`include( UnrestrictedCustomization\Src\UnrestrictedCustomization\macros.uci )

//======================================================================================================================
// FIELDS

/// Archetypes to filter, leave it empty to use all archetypes.
var public array<uc_BodyPartArchetype> UnfilteredArchetypes;

/// Achetype names to include (empty = include all).
var public array<string> ArchetypeNames;
/// DLCs to include (empty = include all).
var public array<string> DlcNames;
/// PartTypes to include (empty = include all).
var public array<uc_EBodyPartType> PartTypes;
/// Genders to include (empty = include all).
var public array<EGender> Genders;
/// ArmorTypes to include (empty = include all).
var public array<uc_EArmorType> ArmorTypes;
/// TechLevels to include (empty = include all).
var public array<uc_ETechLevel> TechLevels;
/// Styles to include (empty = include all).
var public array<uc_EStyle> Styles;

var public float ArmorTypeTolerance;
var public float TechLevelTolerance;

var public float ArmorTypeDeltaMax;
var public float TechLevelDeltaMax;

var private array<string> TruncatedArms;

var private bool BlacklistedOnly;

var public bool ExcludeTruncatedArms;
var public bool ExcludeSparkLegs;
var public bool ExcludeSparkTorsos;

//======================================================================================================================
// PROPERTIES

public function bool GetBlacklistedOnly() {
	return BlacklistedOnly;
}
public function uc_BodyPartFilter SetBlacklistedOnly( bool _value ) {
	BlacklistedOnly = _value;
	return self;
}

//======================================================================================================================
// CTOR

///
/// Instantiates this class.
///
public static function uc_BodyPartFilter CreateBodyPartFilter() {
	return BodyPartFilter( class'uc_BodyPartFilter' );
}

protected static function uc_BodyPartFilter BodyPartFilter(
	class<uc_BodyPartFilter> _class
) {
	local uc_BodyPartFilter this;
	this = new _class;
	this.InitBodyPartFilter();
	return this;
}

private function InitBodyPartFilter() {
	
}

//======================================================================================================================
// Filter

private function bool IsArchetypeNameIncluded( string _name ) {
	return ArchetypeNames.Length==0 || ArchetypeNames.Find(_name) != INDEX_NONE;
}
private function bool IsDlcNameIncluded( string _name ) {
	return DlcNames.Length==0 || DlcNames.Find(_name) != INDEX_NONE;
}
private function bool IsAnyPartTypeIncluded( array<uc_EBodyPartType> _partTypes ) {
	return PartTypes.Length==0 || class'uc_ArrayUtil'.static.ContainsAny_uc_EBodyPartType(PartTypes, _partTypes);
}
private function bool IsAnyGenderIncluded( array<EGender> _genders ) {
	return Genders.Length==0 || class'uc_ArrayUtil'.static.ContainsAny_EGender(Genders, _genders);
}
private function bool IsAnyStyleIncluded( array<uc_EStyle> _styles ) {
	return Styles.Length==0 || class'uc_ArrayUtil'.static.ContainsAny_uc_EStyle(Styles, _styles);
}
private function bool IsArchetypeIncluded( uc_BodyPartArchetype _archetype ) {
	local uc_BodyPartTemplate _template;
	local float _rnd;

	_template = _archetype.Template;

	if(	BlacklistedOnly && _archetype.GetBlacklist() != uc_EBlacklist_User 
	 || ! BlacklistedOnly && _archetype.IsBlacklisted()
	 ||	! IsArchetypeNameIncluded(_template.ArchetypeName)
	 || ! IsDlcNameIncluded(_template.DLCName)
	 || ! IsAnyPartTypeIncluded(_template.PartTypes)
	 || ! IsAnyGenderIncluded(_template.Genders)
	 || ! IsAnyStyleIncluded(_template.Styles)
	 || _template.ArchetypeName == class'uc_BodyPartUtil'.const.InvisibleArchetype
	 || ExcludeSparkLegs && _archetype.VanillaTemplate.CharacterTemplate=='SparkSoldier' && _archetype.HasPartType(uc_EBodyPartType_Legs)
	 || ExcludeSparkTorsos && _archetype.VanillaTemplate.CharacterTemplate=='SparkSoldier' && _archetype.HasPartType(uc_EBodyPartType_Torso)
	 || ExcludeTruncatedArms && TruncatedArms.Find(_template.ArchetypeName) != INDEX_NONE
	){
		return false;
	}

	//HACK for parts that may not have proper armor type / tech level
	switch( _template.PartTypes[0] ) {
		case uc_EBodyPartType_Pawn:
		case uc_EBodyPartType_Head:
		case uc_EBodyPartType_Haircut:
		case uc_EBodyPartType_Helmet:
		case uc_EBodyPartType_ArmorPattern:
		case uc_EBodyPartType_Voice:
		case uc_EBodyPartType_Eyes:
		case uc_EBodyPartType_Teeth:
		case uc_EBodyPartType_Beard:
		case uc_EBodyPartType_FacePropUpper:
		case uc_EBodyPartType_FacePropLower:
		case uc_EBodyPartType_Tattoo_LeftArm:
		case uc_EBodyPartType_Tattoo_RightArm:
		case uc_EBodyPartType_Scars:
		case uc_EBodyPartType_Facepaint:
			return true;
	}

	_rnd = FRand();

	if( ArmorTypes.Length > 0 && ! class'uc_ArrayUtil'.static.ContainsAny_uc_EArmorType(ArmorTypes, _template.ArmorTypes) ) {
		if( _rnd >= ArmorTypeTolerance ) return false;
		if( GetDelta_EArmorType(ArmorTypes, _template.ArmorTypes) > ArmorTypeDeltaMax ) return false;
	}

	if( TechLevels.Length > 0 && ! class'uc_ArrayUtil'.static.ContainsAny_uc_ETechLevel(TechLevels, _template.TechLevels) ) {
		if( _rnd >= TechLevelTolerance ) return false;
		if( GetDelta_ETechLevel(TechLevels, _template.TechLevels) > TechLevelDeltaMax ) return false;
	}

	return true;
}

private function int GetDelta_EArmorType( array<uc_EArmorType> _typesA, array<uc_EArmorType> _typesB ) {
	return GetDelta( EArmorTypes_to_Ints(_typesA), EArmorTypes_to_Ints(_typesB) );
}
private function int GetDelta_ETechLevel( array<uc_ETechLevel> _typesA, array<uc_ETechLevel> _typesB ) {
	return GetDelta( ETechLevels_to_Ints(_typesA), ETechLevels_to_Ints(_typesB) );
}
private function array<int> EArmorTypes_to_Ints( array<uc_EArmorType> _arr ) {
	local int i;
	local array<int> _arr2;
	for( i=0; i<_arr.Length; i++ ) {
		_arr2.AddItem( int( _arr[i] ));
	}
	return _arr2;
}
private function array<int> ETechLevels_to_Ints( array<uc_ETechLevel> _arr ) {
	local int i;
	local array<int> _arr2;
	for( i=0; i<_arr.Length; i++ ) {
		_arr2.AddItem( int( _arr[i] ));
	}
	return _arr2;
}
private function int GetDelta( array<int> _typesA, array<int> _typesB ) {
	local int _minA, _maxA;
	local int _minB, _maxB;
	local int _deltaMin, _deltaMax;

	GetMinMax(_typesA, _minA, _maxA);
	GetMinMax(_typesB, _minB, _maxB);
	
	_deltaMin = Abs( _minA - _minB );
	_deltaMax = Abs( _maxA - _maxB );

	return Max( _deltaMin, _deltaMax );
}
private function GetMinMax( array<int> _arr, out int _min, out int _max ) {
	local int _val;

	`assert(_arr.Length > 0);

	_min = 999;
	_max = 0;

	foreach _arr(_val) {
		if( _val < _min ) _min = _val;
		if( _val > _max ) _max = _val;
	}
}

//======================================================================================================================
// QUERY

///
///
///
public static function X2BodyPartTemplate GetTemplate( uc_EBodyPartType _partType, name _templateName ) {
	return class'X2BodyPartTemplateManager'.static.GetBodyPartTemplateManager().FindUberTemplate(
		class'uc_BodyPartUtil'.static.BodyPartTypeToString(_partType),
		_templateName
	);
}

///
///
///
public function X2BodyPartTemplate GetRandomTemplate() {
	local array<uc_BodyPartArchetype> _archetypes;
	local X2BodyPartTemplate _template;
	_archetypes = GetAchetypes();
	_template = _archetypes[ Rand(_archetypes.Length) ].VanillaTemplate;
	return _template;
}

///
///
///
public function array<uc_BodyPartArchetype> GetAchetypes() {
	local array<uc_BodyPartArchetype> _retVal;
	local array<Object> _uncastedArchetypes;
	local Object _uncastedArchetype;
	local uc_BodyPartArchetype _archetype;
	local uc_Global _global;
	_global = class'uc_Global'.static.GetInstance();
	_retVal.Length = 0;
	
	_uncastedArchetypes = UnfilteredArchetypes.Length == 0 ? _global.BodyPartArchetypesByName.GetValues() : UnfilteredArchetypes;
	foreach _uncastedArchetypes( _uncastedArchetype) {
		_archetype = uc_BodyPartArchetype(_uncastedArchetype);
		if( IsArchetypeIncluded(_archetype) ) {
			_retVal.AddItem(_archetype);
		}
	}

	return _retVal;
}

//======================================================================================================================
defaultProperties // '{' in separate line or defaultProperties will be ignored !
{
	TruncatedArms={(
		"GameUnit_Skirmisher.ARC_Skirmisher_Arm_Left_A_T1_M",
		"GameUnit_Skirmisher.ARC_Skirmisher_Arm_Right_A_T1_M",
		"GameUnit_Skirmisher.ARC_Skirmisher_Arm_Left_A_T1_F",
		"GameUnit_Skirmisher.ARC_Skirmisher_Arm_Right_A_T1_F",
		"GameUnit_Templar.ARC_Templar_Arm_Left_A_T1_M",
		"GameUnit_Templar.ARC_Templar_Arm_Left_A_T1_F",
		"GameUnit_Templar.ARC_Templar_Arm_Right_A_T1_M",
		"GameUnit_Templar.ARC_Templar_Arm_Right_A_T1_F",
		"GameUnit_Templar.ARC_Templar_Arm_Left_B_T1_M",
		"GameUnit_Templar.ARC_Templar_Arm_Left_B_T1_F",
		"GameUnit_Templar.ARC_Templar_Arm_Right_B_T1_M",
		"GameUnit_Templar.ARC_Templar_Arm_Right_B_T1_F"
	)}
}