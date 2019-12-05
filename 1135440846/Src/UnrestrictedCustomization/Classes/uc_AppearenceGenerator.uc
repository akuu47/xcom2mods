///
/// Generates soldier appearance using uc_BodyPartFilter
///
class uc_AppearenceGenerator extends Object dependson(uc_BodyPartUtil);

`define ClassName uc_AppearenceGenerator
`include( UnrestrictedCustomization\Src\UnrestrictedCustomization\macros.uci )

//======================================================================================================================
// FIELDS

var public uc_BodyPartFilter Filter;
var public array<int> ColorPalette;

var private uc_Config Cfg;
//var private array<float> DlcWeights;

var public bool LimitRandomizationToOneDlc;

//======================================================================================================================
// CTOR

///
/// Instantiates this class.
///
public static function uc_AppearenceGenerator CreateAppearenceGenerator() {
	return AppearenceGenerator( class'uc_AppearenceGenerator' );
}

protected static function uc_AppearenceGenerator AppearenceGenerator(
	class<uc_AppearenceGenerator> _class
) {
	local uc_AppearenceGenerator this;
	this = new _class;
	this.InitAppearenceGenerator();
	return this;
}

private function InitAppearenceGenerator() {
	Filter = class'uc_BodyPartFilter'.static.CreateBodyPartFilter();
	//Filter.SetSparkTorsosAndLegsExcluded( true );
	Cfg = class'uc_Config'.static.GetInstance();
}

//======================================================================================================================
// METHODS

///
/// 
///
public function RandomizeOutfit( out TAppearance _apr ) {
	if( LimitRandomizationToOneDlc ) {
		Filter.DlcNames.AddItem( GetRandomDlcName() );
	}
	RandomizeHeadProps(_apr);
	RandomizeBodyPart(uc_EBodyPartType_Torso, 1.0 , _apr);
	RandomizeBodyPart(uc_EBodyPartType_Legs, 1.0 , _apr);
	RandomizeBodyPart(uc_EBodyPartType_Arms, 1.0 , _apr);
	RandomizeBodyPart(uc_EBodyPartType_LeftArmDeco, Cfg.ShoulderDrawChance, _apr);
	RandomizeBodyPart(uc_EBodyPartType_RightArmDeco, Cfg.ShoulderDrawChance, _apr);
`if( `Wotc )
	RandomizeBodyPart(uc_EBodyPartType_LeftForearm, Cfg.ForearmDrawChance, _apr);
	RandomizeBodyPart(uc_EBodyPartType_RightForearm, Cfg.ForearmDrawChance, _apr);
	RandomizeBodyPart(uc_EBodyPartType_Thighs, Cfg.ThighsDrawChance, _apr);
	RandomizeBodyPart(uc_EBodyPartType_Shins, Cfg.ShinsDrawChance, _apr);
	RandomizeBodyPart(uc_EBodyPartType_TorsoDeco, Cfg.TorsoDecoDrawChance , _apr);
`endif
	RandomizeBodyPart(uc_EBodyPartType_ArmorPattern, 1.0, _apr);
	RandomizeArmorColors(_apr);
}

///
/// 
///
private function RandomizeHeadProps( out TAppearance _apr ) {
	if( ! RandomizeBodyPart(uc_EBodyPartType_Helmet, Cfg.HelmetDrawChance, _apr) ) {
		RandomizeBodyPart(uc_EBodyPartType_FacePropUpper, Cfg.FacePropUpperDrawChance, _apr);
		RandomizeBodyPart(uc_EBodyPartType_FacePropLower, Cfg.FacePropLowerDrawChance, _apr);
	}
}

///
/// note that randomizing uc_EBodyPartType_Arms will either randomize "both arms" body part or "left arm" + "right arm"
///
/// Returns true if the draw succeeded ( FRand() <= _drawChance )
///
private function bool RandomizeBodyPart( uc_EBodyPartType _partType, float _drawChance, out TAppearance _apr ) {
	local name _templateName;

	Filter.PartTypes.Length = 0;
	Filter.PartTypes.AddItem(_partType);
	_templateName = FRand() < _drawChance ? Filter.GetRandomTemplate().DataName : '';

	switch(_partType) {
		case uc_EBodyPartType_Torso: _apr.nmTorso = _templateName; break;
		case uc_EBodyPartType_Legs: _apr.nmLegs = _templateName; break;
		case uc_EBodyPartType_Head: _apr.nmHead = _templateName; break;
		case uc_EBodyPartType_Haircut: _apr.nmHaircut = _templateName; break;
		case uc_EBodyPartType_Helmet:
			_apr.nmHelmet = _templateName;
			if( _templateName != '' ) {
				_apr.nmFacePropLower = '';
				_apr.nmFacePropUpper = '';
			}
			break;
		case uc_EBodyPartType_ArmorPattern: _apr.nmPatterns = _templateName; break;
		case uc_EBodyPartType_Voice: _apr.nmVoice = _templateName; break;
		case uc_EBodyPartType_Eyes: _apr.nmEye = _templateName; break;
		case uc_EBodyPartType_Teeth: _apr.nmTeeth = _templateName; break;
		case uc_EBodyPartType_Beard: _apr.nmBeard = _templateName; break;
		case uc_EBodyPartType_FacePropUpper:
			_apr.nmFacePropLower = _templateName;
			if( _templateName != '' ) _apr.nmHelmet = '';
			break;
		case uc_EBodyPartType_FacePropLower:
			_apr.nmFacePropLower = _templateName;
			if( _templateName != '' ) _apr.nmHelmet = '';
			break;
		case uc_EBodyPartType_Tattoo_LeftArm: _apr.nmTattoo_LeftArm = _templateName; break;
		case uc_EBodyPartType_Tattoo_RightArm: _apr.nmTattoo_RightArm = _templateName; break;
		case uc_EBodyPartType_Scars: _apr.nmScars = _templateName; break;
		case uc_EBodyPartType_Facepaint: _apr.nmFacePaint = _templateName; break;
		case uc_EBodyPartType_LeftArmDeco: _apr.nmLeftArmDeco = _templateName; break;
		case uc_EBodyPartType_RightArmDeco: _apr.nmRightArmDeco = _templateName; break;
`if( `Wotc )
		case uc_EBodyPartType_LeftForearm: _apr.nmLeftForearm = _templateName; break;
		case uc_EBodyPartType_RightForearm: _apr.nmRightForearm = _templateName; break;
		case uc_EBodyPartType_Thighs: _apr.nmThighs = _templateName; break;
		case uc_EBodyPartType_Shins: _apr.nmShins = _templateName; break;
		case uc_EBodyPartType_TorsoDeco: _apr.nmTorsoDeco = _templateName; break;
`endif
		case uc_EBodyPartType_LeftArm: _apr.nmLeftArm = _templateName; break;
		case uc_EBodyPartType_RightArm: _apr.nmRightArm = _templateName; break;
		case uc_EBodyPartType_Arms:
			_apr.nmArms = Filter.GetRandomTemplate().DataName;
			RandomizeBodyPart(uc_EBodyPartType_LeftArm, 1.0, _apr);
			RandomizeBodyPart(uc_EBodyPartType_RightArm, 1.0, _apr);
			if( _apr.nmArms!='' && _apr.nmLeftArm!='' && _apr.nmRightArm!='' ) { // has 4 arms ?
				if( Rand(2) == 0 ) {
					_apr.nmLeftArm = '';
					_apr.nmRightArm = '';
				}else {
					_apr.nmArms = '';
				}
			}
			else if( _apr.nmArms!='' && (_apr.nmLeftArm!='' || _apr.nmRightArm!='') ) { // has 3 arms ?
				_apr.nmLeftArm = '';
				_apr.nmRightArm = '';
			}
			else if( _apr.nmArms=='' && (_apr.nmLeftArm == '' || _apr.nmRightArm == '') ) { // has less than 2 arms
				`LogWarning("Body part filter could not find 2 arms for that character :(");	
			}
			break;
		default:
			`LogError("Cannot randomize part type : " $ _partType );
	}
	return _templateName != '';
}

///
/// _colorPalette's default = all available colors
///
private function RandomizeArmorColors( out TAppearance _apr ) {
	if( ColorPalette.Length == 0 ) {
		_apr.iArmorTint = GetRandomArmorColorIndex();
		_apr.iArmorTintSecondary = GetRandomArmorColorIndex();
	}
	else {
		_apr.iArmorTint = ColorPalette[ Rand(ColorPalette.Length) ];
		_apr.iArmorTintSecondary = ColorPalette[ Rand(ColorPalette.Length) ];
	}
}
private static function int GetRandomArmorColorIndex() {
	local XComLinearColorPalette _palette;
	_palette = GetArmorPalette();
	return Rand(_palette.Entries.Length);
}
private static function XComLinearColorPalette GetArmorPalette() {
	return `CONTENT.GetColorPalette(ePalette_ArmorTint);
}




///
/// 
///
private function string GetRandomDlcName() {
	local array<string> _dlcs;
	local string _selected;
	local string _current;
	local int _i;
	local float _totalWeight;
	local int _weight;
	_totalWeight = 0;

	_dlcs = class'xmf_DlcUtil'.static.GetDlcNames();
	_dlcs.RemoveItem( `ModPackage ); // we don't want to generate all invisible character


	// adapted from https://softwareengineering.stackexchange.com/a/150642
	_i = 0;
	_selected = "Vanilla";
	foreach _dlcs(_current) {
		if( _current == "" ) `Assert(false);
		_weight = GetDlcWeight(_i, _current);
		if( FRand()*(_totalWeight+_weight) > _totalWeight ) {
			_selected = _current;
		}
		_totalWeight += _weight;
		_i++;
	}

	if( _selected == "" ) `Assert(false);

	return _selected;
}


private function float GetDlcWeight( int _i, string _dlc ) {
	local uc_Global _global;
	_global = class'uc_Global'.static.GetInstance();

	if( _global.uc_AppearenceGenerator_DlcWeights.Length <= _i ) {
		_global.uc_AppearenceGenerator_DlcWeights.AddItem( CalcDlcWeight(_dlc) );
	}
	return _global.uc_AppearenceGenerator_DlcWeights[_i];
}

///
/// Returns the number of body part of given type,
/// using this generator's body part filter for others properties.
///
private function int GetBodyPartCount( uc_EBodyPartType _type ) {
	local array<uc_BodyPartArchetype> _archetypes;

	Filter.PartTypes.Length = 0;
	Filter.PartTypes.AddItem( _type );
	// Note : cannot access Length on return value, have to store it in a named var...
	Filter.ArmorTypeDeltaMax = 0;
	Filter.TechLevelDeltaMax = 0;
	_archetypes = Filter.GetAchetypes();
	Filter.ArmorTypeTolerance = Cfg.ArmorTypeDeltaMax;
	Filter.TechLevelTolerance = Cfg.TechLevelDeltaMax;

	return _archetypes.Length;
}



private function float CalcDlcWeight( string _dlc ) {
	local int _torsosNum, _legsNum, _armsNum, _leftArmsNum, _rightArmsNum;
	local float _weigth;
	local array<string> _oldDlcs;
	local string _msg;

	_oldDlcs = class'uc_ArrayUtil'.static.Clone_String(Filter.DlcNames);

	Filter.DlcNames.Length = 0;
	Filter.DlcNames.AddItem(_dlc);

	// Note : remove 1 to each part because of added invisible part
	_torsosNum = GetBodyPartCount(uc_EBodyPartType_Torso) - 1;
	_legsNum = GetBodyPartCount(uc_EBodyPartType_Legs) - 1;
	_armsNum = GetBodyPartCount(uc_EBodyPartType_Arms) - 1;
	_leftArmsNum = GetBodyPartCount(uc_EBodyPartType_LeftArm) - 1;
	_rightArmsNum = GetBodyPartCount(uc_EBodyPartType_RightArm) - 1;

	Filter.DlcNames = _oldDlcs;

	if( _torsosNum<=0 ) {
		_weigth = 0;
	}
	else if( _legsNum<=0 ) {
		_weigth = 0;
	}
	else if( _armsNum<=0 && (_leftArmsNum<=0 || _rightArmsNum<=0) ) {
		_weigth = 0;
	}
	else {
		_weigth = _torsosNum * 2;
		_weigth += _legsNum * 1.25;
		_weigth += _armsNum * 1;
		_weigth += _leftArmsNum * 0.75;
		_weigth += _rightArmsNum * 0.75;
		if( _weigth<0 ) _weigth=0;
	}

	_msg = _dlc;
	_msg @= `ToString(_torsosNum);
	_msg @= `ToString(_legsNum);
	_msg @= `ToString(_armsNum);
	_msg @= `ToString(_leftArmsNum);
	_msg @= `ToString(_rightArmsNum);
	_msg @= `ToString(_weigth);
	
	`VlogInfo( _msg );

	return _weigth;
}
