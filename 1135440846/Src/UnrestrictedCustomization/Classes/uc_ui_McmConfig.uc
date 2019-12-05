///
/// 
///
class uc_ui_McmConfig extends Object;

`define ClassName uc_ui_McmConfig
`include( UnrestrictedCustomization\Src\UnrestrictedCustomization\macros.uci )

`include( UnrestrictedCustomization\Src\ModConfigMenuAPI\MCM_API_Includes.uci )
`include( UnrestrictedCustomization\Src\ModConfigMenuAPI\MCM_API_CfgHelpers.uci )

//======================================================================================================================
// FIELDS

// uc_ui_FilterPanel
var private bool ShowBlacklistedOnly;

var private bool ShowToolPanel;

var private bool ConfirmWholeAppearanceModification;

var private bool GlobalAppearance;

//======================================================================================================================
// CTOR

///
/// Instantiates this class.
///
public static function uc_ui_McmConfig CreateMcmConfig() {
	return McmConfig(class'uc_ui_McmConfig');
}

protected static function uc_ui_McmConfig McmConfig( class<uc_ui_McmConfig> _class ) {
	local uc_ui_McmConfig this;
	this = new _class;
	this.InitMcmConfig();
	return this;
}

private function InitMcmConfig() {
	
}

//======================================================================================================================
// METHODS

public function ClientModCallback( MCM_API_Instance _configAPI, int _gameMode ) {
	local MCM_API_SettingsPage _page;
	local MCM_API_SettingsGroup _group;

	LoadSavedSettings();
    
	_page = _configAPI.NewSettingsPage(`ModPackage);
	_page.SetPageTitle(`ModPackage);
	_page.SetSaveHandler(HandleSaveButtonClicked);

	_group = _page.AddGroup('Group1', "");
    
	_group.AddCheckbox(
		'ShowBlacklistedOnly', `Localize("ShowBlacklistedOnly"), `Localize("ShowBlacklistedOnlyDescr"),
		ShowBlacklistedOnly, HandleSaveShowBlacklistedOnly
	);

	_group.AddCheckbox(
		'ShowToolPanel', `Localize("ShowToolPanel"), `Localize("ShowToolPanelDescr"),
		ShowToolPanel, HandleShowToolPanel
	);

	_group.AddCheckbox(
		'ShowToolPanel', `Localize("ConfirmWholeAppearanceModification"), `Localize("ConfirmWholeAppearanceModificationDescr"),
		ConfirmWholeAppearanceModification, HandleConfirmWholeAppearanceModification
	);

	_group.AddCheckbox(
		'ShowToolPanel', `Localize("GlobalAppearance"), `Localize("GlobalAppearanceDescr"),
		GlobalAppearance, HandleGlobalAppearance
	);

	_page.ShowSettings();
}

`MCM_API_BasicCheckboxSaveHandler(HandleSaveShowBlacklistedOnly, ShowBlacklistedOnly)
`MCM_API_BasicCheckboxSaveHandler(HandleShowToolPanel, ShowToolPanel)
`MCM_API_BasicCheckboxSaveHandler(HandleConfirmWholeAppearanceModification, ConfirmWholeAppearanceModification)
`MCM_API_BasicCheckboxSaveHandler(HandleGlobalAppearance, GlobalAppearance)


private function LoadSavedSettings() {
	local uc_Config _config;
	_config = class'uc_Config'.static.GetInstance();

	ShowBlacklistedOnly = _config.ShowBlacklistedOnly;
	ConfirmWholeAppearanceModification = _config.ConfirmWholeAppearanceModification;
	ShowToolPanel = _config.ShowToolPanel;
	GlobalAppearance = _config.GlobalAppearance;
}


private function HandleSaveButtonClicked( MCM_API_SettingsPage _page ) {
	local uc_Config _config;
	_config = class'uc_Config'.static.GetInstance();
	_config.SetShowBlacklistedOnly(ShowBlacklistedOnly);
	_config.SetShowToolPanel(ShowToolPanel);
	_config.SetConfirmWholeAppearanceModification(ConfirmWholeAppearanceModification);
	_config.SetGlobalAppearance( GlobalAppearance );
}
