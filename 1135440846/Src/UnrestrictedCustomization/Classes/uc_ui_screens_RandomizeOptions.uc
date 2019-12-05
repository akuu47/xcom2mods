///
/// 
///
class uc_ui_screens_RandomizeOptions extends uc_ui_screens_Customize;

`define ClassName uc_ui_screens_RandomizeOptions
`include( UnrestrictedCustomization\Src\UnrestrictedCustomization\macros.uci )

//======================================================================================================================
// CTOR

public static function uc_ui_screens_RandomizeOptions CreateRandomizeOptions() {
	return RandomizeOptions( class'uc_ui_screens_RandomizeOptions' );
}

protected static function uc_ui_screens_RandomizeOptions RandomizeOptions(
	class<uc_ui_screens_RandomizeOptions> _class
) {
	local uc_ui_screens_RandomizeOptions this;
	this = uc_ui_screens_RandomizeOptions( Customize(_class) );
	this.InitRandomizeOptions();
	return this;
}

private function InitRandomizeOptions() {

}

/*override*/ simulated function InitScreen( XComPlayerController _controller, UIMovie _movie, name _name='') {
	super.InitScreen(_controller, _movie, _name);

	UpdateData();
}

//======================================================================================================================
// METHODS

/*override*/ protected function AddListItems() {
	local uc_Config _config;
	local xmf_ui_ListWrapper _list;

	_config = class'uc_Config'.static.GetInstance();
	_list = class'xmf_ui_ListWrapper'.static.CreateListWrapper(List);

	_list.CreateSpinner(
		`Localize("ArmorTypeDeltaMax"), `Localize("ArmorTypeDeltaMaxDescr"),
		HandleArmorTypeDeltaMaxChanged, _config.ArmorTypeDeltaMax
	);
	_list.CreateSpinner(
		`Localize("TechLevelDeltaMax"), `Localize("TechLevelDeltaMaxDescr"),
		HandleTechLevelDeltaMaxChanged, _config.TechLevelDeltaMax
	);

	_list.CreateSlider(
		`Localize("ArmorTypeTolerance"), `Localize("ArmorTypeToleranceDescr"),
		HandleArmorTypeToleranceChanged, _config.ArmorTypeTolerance
	);
	_list.CreateSlider(
		`Localize("TechLevelTolerance"), `Localize("TechLevelToleranceDescr"),
		HandleTechLevelToleranceChanged, _config.TechLevelTolerance
	);

	_list.CreateSlider(
		`Localize("HelmetDrawChance"), `Localize("HelmetDrawChanceDescr"),
		HandleHelmetDrawChanceChanged, _config.HelmetDrawChance
	);
	_list.CreateSlider(
		`Localize("FacePropUpperDrawChance"), `Localize("FacePropUpperDrawChanceDescr"),
		HandleFacePropUpperDrawChanceChanged, _config.FacePropUpperDrawChance
	);
	_list.CreateSlider(
		`Localize("FacePropLowerDrawChance"), `Localize("FacePropLowerDrawChanceDescr"),
		HandleFacePropLowerDrawChanceChanged, _config.FacePropLowerDrawChance
	);
	_list.CreateSlider(
		`Localize("ShoulderDrawChance"), `Localize("ShoulderDrawChanceDescr"),
		HandleShoulderDrawChanceChanged, _config.ShoulderDrawChance
	);
	_list.CreateSlider(
		`Localize("ForearmDrawChance"), `Localize("ForearmDrawChanceDescr"),
		HandleForearmDrawChanceChanged, _config.ForearmDrawChance
	);
	_list.CreateSlider(
		`Localize("TorsoDecoDrawChance"), `Localize("TorsoDecoDrawChanceDescr"),
		HandleTorsoDecoDrawChanceChanged, _config.TorsoDecoDrawChance
	);
	_list.CreateSlider(
		`Localize("ThighsDrawChance"), `Localize("ThighsDrawChanceDescr"),
		HandleThighsDrawChanceChanged, _config.ThighsDrawChance
	);
	_list.CreateSlider(
		`Localize("ShinsDrawChance"), `Localize("ShinsDrawChanceDescr"),
		HandleShinsDrawChanceChanged, _config.ShinsDrawChance
	);

	_list.CreateCheckbox(
		`Localize("LimitRandomizationToOneDlc"), `Localize("LimitRandomizationToOneDlcDescr"),
		HandleLimitRandomizationToOneDlcChanged, _config.LimitRandomizationToOneDlc
	);
	_list.CreateCheckbox(
		`Localize("UseCustomColorPalette"), `Localize("UseCustomColorPaletteDescr"),
		HandleUseCustomColorPaletteChanged, _config.UseCustomColorPalette
	);
}

//======================================================================================================================
// HANDLERS

private function  HandleArmorTypeDeltaMaxChanged( UIListItemSpinner _source, int _direction ) {
	local uc_Config _config;
	_config = class'uc_Config'.static.GetInstance();

	_config.SetArmorTypeDeltaMax(
		Clamp( _config.ArmorTypeDeltaMax+_direction, 0, 3 )
	);
	_source.SetValue( string(_config.ArmorTypeDeltaMax) );
}

private function  HandleTechLevelDeltaMaxChanged( UIListItemSpinner _source, int _direction ) {
	local uc_Config _config;
	_config = class'uc_Config'.static.GetInstance();

	_config.SetTechLevelDeltaMax(
		Clamp( _config.TechLevelDeltaMax+_direction, 0, 3 )
	);
	_source.SetValue( string(_config.TechLevelDeltaMax) );
}

private function HandleArmorTypeToleranceChanged( UISlider _source ) {
	class'uc_Config'.static.GetInstance().SetArmorTypeTolerance( _source.percent/100.0 );
}

private function HandleTechLevelToleranceChanged( UISlider _source ) {
	class'uc_Config'.static.GetInstance().SetTechLevelTolerance( _source.percent/100.0 );
}

private function HandleHelmetDrawChanceChanged( UISlider _source ) {
	class'uc_Config'.static.GetInstance().SetHelmetDrawChance( _source.percent/100.0 );
}

private function HandleFacePropUpperDrawChanceChanged( UISlider _source ) {
	class'uc_Config'.static.GetInstance().SetFacePropUpperDrawChance( _source.percent/100.0 );
}

private function HandleFacePropLowerDrawChanceChanged( UISlider _source ) {
	class'uc_Config'.static.GetInstance().SetFacePropLowerDrawChance( _source.percent/100.0 );
}

private function HandleShoulderDrawChanceChanged( UISlider _source ) {
	class'uc_Config'.static.GetInstance().SetShoulderDrawChance( _source.percent/100.0 );
}

private function HandleThighsDrawChanceChanged( UISlider _source ) {
	class'uc_Config'.static.GetInstance().SetThighsDrawChance( _source.percent/100.0 );
}

private function HandleShinsDrawChanceChanged( UISlider _source ) {
	class'uc_Config'.static.GetInstance().SetShinsDrawChance( _source.percent/100.0 );
}

private function HandleForearmDrawChanceChanged( UISlider _source ) {
	class'uc_Config'.static.GetInstance().SetForearmDrawChance( _source.percent/100.0 );
}

private function HandleTorsoDecoDrawChanceChanged( UISlider _source ) {
	class'uc_Config'.static.GetInstance().SetTorsoDecoDrawChance( _source.percent/100.0 );
}

private function HandleLimitRandomizationToOneDlcChanged( UICheckbox _source ) {
	class'uc_Config'.static.GetInstance().SetLimitRandomizationToOneDlc(_source.bChecked);
}

private function HandleUseCustomColorPaletteChanged( UICheckbox _source ) {
	class'uc_Config'.static.GetInstance().SetUseCustomColorPalette(_source.bChecked);
}
