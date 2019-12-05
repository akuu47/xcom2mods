
class uc_Main extends UIScreenListener;

`define ClassName uc_Main
`include( UnrestrictedCustomization\Src\UnrestrictedCustomization\macros.uci )

`include( UnrestrictedCustomization\Src\ModConfigMenuAPI\MCM_API_Includes.uci )
`include( UnrestrictedCustomization\Src\ModConfigMenuAPI\MCM_API_CfgHelpers.uci )

//======================================================================================================================
// FIELDS

var private bool Inited;

//======================================================================================================================
// HANDLERS

event OnInit(UIScreen _screen) {
	local uc_Config _config;

	_config = class'uc_Config'.static.GetInstance();

	RunOnce(_screen);

	if( UiCustomize(_screen) != none ) {
		_screen.SetPosition(0,-100);
		if( _config.ShowToolPanel && ! class'uc_Customizer'.static.IsSpark() ) {
			ShowToolPanel(_screen);
		}
	}
	else if( MCM_API(_screen) != none ) {
		ShowOptionMenu( MCM_API(_screen) );
	}
}

//======================================================================================================================
// METHODS


private function ShowToolPanel( UiPanel _parent ) {
	local uc_ui_ToolPanel _appearancePanel;
	_appearancePanel = class'uc_ui_ToolPanel'.static.CreateToolPanel(_parent);
	_appearancePanel.SetPosition( 1750, 100 );
}


private function ShowOptionMenu( MCM_API _screen ) {
	local uc_ui_McmConfig _mcmConfig;
	`assert( _screen != none );
	_mcmConfig = class'uc_ui_McmConfig'.static.CreateMcmConfig();
	_screen.RegisterClientMod( `MCM_MAJOR_VERSION, `MCM_MINOR_VERSION, _mcmConfig.ClientModCallback );
}


private function RunOnce(UIScreen _screen) {
	if( Inited ) return;
	`LogInfo( `ModPackage @ `ModVersion );

	class'uc_BodyPartLoader'.static.LoadBodyParts();
	`if( `VerboseLog )
		class'xmf_DlcUtil'.static.LogDlcNames();
	`endif

`if( `Wotc )
	class'uc_BodyPartUtil'.static.FixSoldierPawnTemplates();
	class'uc_BodyPartUtil'.static.FixHeroBodyPartsArmorTemplates();
`endif
	class'uc_RestrictionDisabler'.static.GetInstance().UnrestrictBodyParts();

	`if( `Test )
		RunTests();
	`endif

	Inited = true;
}


private static function RunTests() {
	`LogInfo("Running tests...");
	class'xmf_HashMap'.static.TEST();
//	class'uc_BodyPartFilter'.static.TEST();
}

//======================================================================================================================
defaultProperties // '{' in separate line or defaultProperties will be ignored !
{
	ScreenClass=none
}
