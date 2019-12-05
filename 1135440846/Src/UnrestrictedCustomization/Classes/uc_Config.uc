
class uc_Config extends UiDataStore implements(xmf_ini_Configurable) config(_UnrestrictedCustomization);

`define ClassName uc_Config
`include( UnrestrictedCustomization\Src\UnrestrictedCustomization\macros.uci )

//======================================================================================================================
// ENUMS

// behavior modes for appearance generation when equipping a new armor
enum uc_EArmorEquippedBehavior {
	uc_EArmorEquippedBehavior_Vanilla, // use vanilla 
	uc_EArmorEquippedBehavior_Randomize, // use UC randomization
	uc_EArmorEquippedBehavior_Transfer, // transert current appearance to new armor
	uc_EArmorEquippedBehavior_Lock // always lock appearance
};

//======================================================================================================================
// FIELDS

var private bool Inited;
var private xmf_ini_ConfigPatcher Patcher;
var private config string _ConfigRevision_DoNotModify;


// randomization/uniformization
var privateWrite config float ArmorTypeTolerance;
var privateWrite config float TechLevelTolerance;
var privateWrite config float HelmetDrawChance;
var privateWrite config float ShoulderDrawChance;
var privateWrite config float FacePropLowerDrawChance;
var privateWrite config float FacePropUpperDrawChance;
var privateWrite config float ThighsDrawChance;
var privateWrite config float ShinsDrawChance;
var privateWrite config float TorsoDecoDrawChance;
var privateWrite config float ForearmDrawChance;
var privateWrite config bool LimitRandomizationToOneDlc;
var privateWrite config bool UseCustomColorPalette;
var privateWrite config int ArmorTypeDeltaMax;
var privateWrite config int TechLevelDeltaMax;
var privateWrite config string LastLaunchVersion;

// uc_BodyPartFilter
var public config array<string> BlackListedArchetypeNames;

//
var public config array<uc_BodyPartTemplate> BodyPartTemplates;

// uc_ui_FilterPanel
var privateWrite config bool ShowBlacklistedOnly;

// 
var privateWrite config bool ConfirmWholeAppearanceModification;

var privateWrite config array<int> CustomColorPalette;

var privateWrite config bool GlobalAppearance;

var privateWrite config bool ShowToolPanel;

//======================================================================================================================
// PROPERTIES

public function SetArmorTypeDeltaMax( int _value ) {
	ArmorTypeDeltaMax = _value;
	ScheduleSaveConfig();
}
public function SetTechLevelDeltaMax( int _value ) {
	TechLevelDeltaMax = _value;
	Patcher.ScheduleSaveConfig();
}
public function SetArmorTypeTolerance( float _value ) {
	ArmorTypeTolerance = _value;
	ScheduleSaveConfig();
}
public function SetTechLevelTolerance( float _value ) {
	TechLevelTolerance = _value;
	ScheduleSaveConfig();
}
public function SetHelmetDrawChance( float _value ) {
	HelmetDrawChance = _value;
	ScheduleSaveConfig();
}
public function SetShoulderDrawChance( float _value ) {
	ShoulderDrawChance = _value;
	ScheduleSaveConfig();
}
public function SetFacePropLowerDrawChance( float _value ) {
	FacePropLowerDrawChance = _value;
	ScheduleSaveConfig();
}
public function SetFacePropUpperDrawChance( float _value ) {
	FacePropUpperDrawChance = _value;
	ScheduleSaveConfig();
}
public function SetThighsDrawChance( float _value ) {
	ThighsDrawChance = _value;
	ScheduleSaveConfig();
}
public function SetShinsDrawChance( float _value ) {
	ShinsDrawChance = _value;
	ScheduleSaveConfig();
}
public function SetTorsoDecoDrawChance( float _value ) {
	TorsoDecoDrawChance = _value;
	ScheduleSaveConfig();
}
public function SetForearmDrawChance( float _value ) {
	ForearmDrawChance = _value;
	ScheduleSaveConfig();
}

public function SetLimitRandomizationToOneDlc( bool _value ) {
	LimitRandomizationToOneDlc = _value;
	ScheduleSaveConfig();
}
public function SetUseCustomColorPalette( bool _value ) {
	UseCustomColorPalette = _value;
	ScheduleSaveConfig();
}


public function SetShowBlacklistedOnly( bool _value ) {
	ShowBlacklistedOnly = _value;
	ScheduleSaveConfig();
}

public function SetConfirmWholeAppearanceModification( bool _value ) {
	ConfirmWholeAppearanceModification = _value;
	ScheduleSaveConfig();
}

public function SetLastLaunchVersion( string _value ) {
	LastLaunchVersion = _value;
	ScheduleSaveConfig();
}

public function SetGlobalAppearance( bool _value ) {
	GlobalAppearance = _value;
	ScheduleSaveConfig();
}

public function SetShowToolPanel( bool _value ) {
	ShowToolPanel = _value;
	ScheduleSaveConfig();
}


//======================================================================================================================
// CTOR

public static function uc_Config GetInstance() {
	return uc_Config( class'xmf_SingletonStore'.static.GetInstance(class'uc_Config') ).Init();
}

private function uc_Config Init() {
	if( ! Inited ) {
		`LogInfo("Reloading config file...");
		Patcher = class'xmf_ini_ConfigPatcher'.static.CreateConfigPatcher(self);
		Patcher.AppendPatch( PatchRev0ToRev1 );
		Patcher.AppendPatch( PatchRev1ToRev2 );
		Patcher.AppendPatch( PatchRev2ToRev3 );
		Patcher.AppendPatch( PatchRev3ToRev4 );
		Patcher.AppendPatch( PatchRev4ToRev5 );
		Patcher.AppendPatch( PatchRev5ToRev6 );
		Patcher.AppendPatch( PatchRev6ToRev7 );
		Patcher.AppendPatch( PatchRev7ToRev8 );
		Patcher.UpdateConfig();
		Inited = true;
	}
	return self;
}

//======================================================================================================================
// IMPL xmf_ini_Configurable


function ScheduleSaveConfig() {
	Patcher.ScheduleSaveConfig();
}


function string GetUserConfigRevision() { return _ConfigRevision_DoNotModify; }


function SetUserConfigRevision( string _value ) { _ConfigRevision_DoNotModify = _value; }


function string GetHeader() {
	return "Please edit this file with a text editor supporting unix-style line breaks (eg: notepad++)"
	$ "\n"
	$ "\nDeprecated: UniformizeVanillaChances, DefaultShowAllTechLevels, DefaultShowAllGenders, "
	$ "\n ShowAllTechLevels ShowAllArmorTypes ShowAllGenders"
	$ "\n TierXArmorTemplates, LightArmorTemplates, HeavyArmorTemplates, SparkArmorTemplates"
	;
}

private function PatchRev0ToRev1() {
	
}

private function PatchRev1ToRev2() {
	
}

private function PatchRev2ToRev3() {
	local int i;

	ShoulderDrawChance = 0.33;
	HelmetDrawChance = 0.33;
	FacePropUpperDrawChance = 0.33;
	FacePropLowerDrawChance = 0.33;
	ThighsDrawChance = 0.33;
	ShinsDrawChance = 0.33;
	TorsoDecoDrawChance = 0.33;
	ArmorTypeTolerance = 0.10;
	TechLevelTolerance = 0.10;
	ArmorTypeDeltaMax = 1;
	TechLevelDeltaMax = 1;
	UseCustomColorPalette = true;

	CustomColorPalette.Length = 0;
	for( i= 0; i<6; i++) CustomColorPalette.AddItem(i);
	for( i=28; i<42; i++) CustomColorPalette.AddItem(i);
	for( i=49; i<63; i++) CustomColorPalette.AddItem(i);
	for( i=93; i<98; i++) CustomColorPalette.AddItem(i);

	BlackListedArchetypeNames.Length = 0; // reset
}


private function PatchRev3ToRev4() {
	ForearmDrawChance = 0.33;
}


private function PatchRev4ToRev5() {
	//ArmorEquippedBehavior = uc_EArmorEquippedBehavior_Randomize;
}

private function PatchRev5ToRev6() {
	ConfirmWholeAppearanceModification = true;
}

private function PatchRev6ToRev7() {
	//ArmorEquippedBehavior = uc_EArmorEquippedBehavior_Transfer;
}

private function PatchRev7ToRev8() {
	ShowToolPanel = true;
	GlobalAppearance = false;
}

//======================================================================================================================
defaultProperties // '{' in separate line or defaultProperties will be ignored !
{
	Tag=UnrestrictedCustomization_uc_Config;
}