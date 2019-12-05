class UIShowEnemies_MCMScreen extends Object config(WOTC_UIShowEnemies);

`include(WOTC_ShowEnemiesonMissionPlanning\Src\ModConfigMenuAPI\MCM_API_Includes.uci)
`include(WOTC_ShowEnemiesonMissionPlanning\Src\ModConfigMenuAPI\MCM_API_CfgHelpers.uci)

var config int CONFIG_VERSION;

// Localization Strings for Mod Config Menu Items
var public localized string	sSettingsPage_MCMText;
var public localized string	sPageTitle_MCMText;
var public localized string	sGroupGeneralSettings_MCMText;
var public localized string	sShowBackground_MCMText;
var public localized string	sPanelSettings_MCMText;
var public localized string	sBackgroundType_MCMText;
var public localized string	sEnemiesCountPanelSizeX_MCMText;
var public localized string	sEnemiesCountPanelSizeY_MCMText;
var public localized string	sEnemiesListPanelSizeX_MCMText;
var public localized string	sEnemiesListPanelSizeY_MCMText;
var public localized string	sPanelTerrainSizeX_MCMText;
var public localized string	sPanelTerrainSizeY_MCMText;
var public localized string	sAlphaBackground_MCMText;
var public localized string	sGroupEnemiesListSettings_MCMText;
var public localized string	sShowWithoutShadowChamber_MCMText;
var public localized string	sEnemiesListPositionX_MCMText;
var public localized string	sEnemiesListPositionY_MCMText;
var public localized string	sEnemiesListSitrepOffset_MCMText;
var public localized string	sGroupTerrainSettings_MCMText;
var public localized string	sShowTerrain_MCMText;
var public localized string	sShowPlotText_MCMText;
var public localized string	sShowBiomeText_MCMText;
var public localized string	sShowIcons_MCMText;
var public localized string	sShowEnemyIcons_MCMText;
var public localized string	sTerrainTitleColor_MCMText;
var public localized string	sTerrainColor_MCMText;
var public localized string sTimeColor_MCMText;
var public localized string	sTerrainPosX_MCMText;
var public localized string	sTerrainPosY_MCMText;
var public localized string	sIconSize_MCMText;
var public localized string	sEnemyIconSize_MCMText;
var public localized string	sIconVSpace_MCMText;
var public localized string	sEnemyIconVSpace_MCMText;
var public localized string	sShowTime_MCMText;
var public localized string	sShowEnemiesList_MCMText;
var public localized string	sShowChosen_MCMText;
var public localized string sEnemiesListAnchor_MCMText;
var public localized string sTerrainAnchor_MCMText;
//var public localized string sShadowChamberStyle_MCMText;

// Configuration Variables
// Booleans
var config bool				bSHOW_WITHOUT_SHADOWCHAMBER;
var config bool				bBackground;
var config bool				bShowTerrain;
var config bool				bShowIcons;
var config bool				bShowEnemyIcons;
var config bool				bShowBiomeText;
var config bool				bShowPlotText;
var config bool				bShowTime;
var config bool				bShowEnemiesList;
var config bool				bShowChosen;
var config bool				DEBUG;
//var config bool				bShadowChamberStyle;
// Integers
var config int				iEnemiesListPosX;
var config int				iEnemiesListPosY;
var config int				iSitrepDisplayOffset;
var config int				iTerrainPosX;
var config int				iTerrainPosY;
var config int				iIconSize;
var config int				iEnemyIconSize;
var config int				iIconVSpace;
var config int				iEnemyIconVSpace;
var config int				iPanelTerrainSizeX;
var config int				iPanelTerrainSizeY;
var config int				iPanelEnemiesCountSizeX;
var config int				iPanelEnemiesCountSizeY;
var config int				iPanelEnemiesListSizeX;
var config int				iPanelEnemiesListSizeY;
// Floats
var config float				fAlphaBackground;
// Strings
var config string			sTerrainTitleColor;
var config string			sTerrainColor;
var config string			sTimeColor;
var config string			sBackground;
var config string			sEnemiesListAnchor;
var config string			sTerrainAnchor;

// MCM UI Elements
var MCM_API_Checkbox			DEBUG_MCMUI;
var MCM_API_Checkbox			ShowBackground_MCMUI;
var MCM_API_Checkbox			ShowTerrain_MCMUI;
//var MCM_API_Checkbox			ShadowChamberStyle_MCMUI;
var MCM_API_Checkbox			ShowEnemyIcons_MCMUI;
var MCM_API_Dropdown			BackgroundType_MCMUI;
var MCM_API_Slider			EnemiesCountPanelSizeX_MCMUI;
var MCM_API_Slider			EnemiesCountPanelSizeY_MCMUI;
var MCM_API_Slider			EnemiesListPanelSizeX_MCMUI;
var MCM_API_Slider			EnemiesListPanelSizeY_MCMUI;
var MCM_API_Slider			PanelTerrainSizeX_MCMUI;
var MCM_API_Slider			PanelTerrainSizeY_MCMUI;
var MCM_API_Slider			AlphaBackground_MCMUI;
var MCM_API_Checkbox			ShowWithoutShadowChamber_MCMUI;
var MCM_API_Slider			EnemiesListPositionX_MCMUI;
var MCM_API_Slider			EnemiesListPositionY_MCMUI;
var MCM_API_Slider			EnemiesListSitrepOffset_MCMUI;
var MCM_API_Checkbox			ShowPlotText_MCMUI;
var MCM_API_Checkbox			ShowBiomeText_MCMUI;
var MCM_API_Checkbox			ShowIcons_MCMUI;
var MCM_API_Dropdown			TerrainTitleColor_MCMUI;
var MCM_API_Dropdown			TerrainColor_MCMUI;
var MCM_API_Dropdown			TimeColor_MCMUI;
var MCM_API_Slider			TerrainPosX_MCMUI;
var MCM_API_Slider			TerrainPosY_MCMUI;
var MCM_API_Slider			IconSize_MCMUI;
var MCM_API_Slider			EnemyIconSize_MCMUI;
var MCM_API_Slider			IconVSpace_MCMUI;
var MCM_API_Slider			EnemyIconVSpace_MCMUI;
var MCM_API_Checkbox			ShowTime_MCMUI;
var MCM_API_Checkbox			ShowEnemiesList_MCMUI;
var MCM_API_Checkbox			ShowChosen_MCMUI;
var MCM_API_Dropdown			EnemiesListAnchor_MCMUI;
var MCM_API_Dropdown			TerrainAnchor_MCMUI;

event OnInit(UIScreen Screen)
{
	// Everything in here runs only when you need to touch MCM.
	`MCM_API_Register(Screen, ClientModCallback);
}

`MCM_API_BasicCheckboxSaveHandler(ShadowHandler, bSHOW_WITHOUT_SHADOWCHAMBER)
`MCM_API_BasicCheckboxSaveHandler(ShowBiomeTextHandler, bShowBiomeText)
`MCM_API_BasicCheckboxSaveHandler(ShowPlotTextHandler, bShowPlotText)
`MCM_API_BasicCheckboxSaveHandler(ShowIconsHandler, bShowIcons)
`MCM_API_BasicCheckboxSaveHandler(ShowEnemiesListHandler,bShowEnemiesList)
`MCM_API_BasicCheckboxSaveHandler(ShowChosenHandler, bShowChosen)
`MCM_API_BasicCheckboxSaveHandler(ShowTimeHandler, bShowTime)
//`MCM_API_BasicCheckboxSaveHandler(ShadowChamberStyleHandler, bShadowChamberStyle)
`MCM_API_BasicSliderSaveHandler(EnemiesListPosXHandler,iEnemiesListPosX)
`MCM_API_BasicSliderSaveHandler(EnemiesListPosYHandler,iEnemiesListPosY)
`MCM_API_BasicSliderSaveHandler(SitrepDisplayOffsetHandler,iSitrepDisplayOffset)
`MCM_API_BasicSliderSaveHandler(TerrainPosXHandler,iTerrainPosX)
`MCM_API_BasicSliderSaveHandler(TerrainPosYHandler,iTerrainPosY)
`MCM_API_BasicSliderSaveHandler(AlphaBackgroundHandler,fAlphaBackground)
`MCM_API_BasicDropdownSaveHandler(TerrainTitleColorHandler,sTerrainTitleColor)
`MCM_API_BasicDropdownSaveHandler(TerrainColorHandler,sTerrainColor)
`MCM_API_BasicDropdownSaveHandler(BackgroundTypeHandler,sBackground)
`MCM_API_BasicDropdownSaveHandler(TimeColorHandler,sTimeColor)
`MCM_API_BasicSliderSaveHandler(PanelTerrainSizeXHandler,iPanelTerrainSizeX)
`MCM_API_BasicSliderSaveHandler(PanelEnemiesCountSizeXHandler,iPanelEnemiesCountSizeX)
`MCM_API_BasicSliderSaveHandler(PanelEnemiesCountSizeYHandler,iPanelEnemiesCountSizeY)
`MCM_API_BasicSliderSaveHandler(PanelEnemiesListSizeXHandler,iPanelEnemiesListSizeX)
`MCM_API_BasicSliderSaveHandler(PanelEnemiesListSizeYHandler,iPanelEnemiesListSizeY)
`MCM_API_BasicSliderSaveHandler(IconVSpaceHandler,iIconVSpace)
`MCM_API_BasicSliderSaveHandler(EnemyIconVSpaceHandler,iEnemyIconVSpace)
`MCM_API_BasicSliderSaveHandler(EnemyIconSizeHandler,iEnemyIconSize)

simulated function ClientModCallback(MCM_API_Instance ConfigAPI, int GameMode)
{
	// Code goes here.
	local MCM_API_SettingsPage Page;
	local MCM_API_SettingsGroup Group1;
	local MCM_API_SettingsGroup Group2;
	local MCM_API_SettingsGroup Group3;
	local MCM_API_SettingsGroup Group4;
	local MCM_API_SettingsGroup Group5;

	local array<string> ColorsArray;
	local array<string> BackgroundsArray;
	local array<string> AnchorTextArray;
	ColorsArray.AddItem("Cyan");
	ColorsArray.AddItem("Red");
	ColorsArray.AddItem("Yellow");
	ColorsArray.AddItem("Orange");
	ColorsArray.AddItem("Green");
	ColorsArray.AddItem("Gray");
	ColorsArray.AddItem("Faded");
	ColorsArray.AddItem("Psyonic");
	ColorsArray.AddItem("Header");
	ColorsArray.AddItem("Cash");
	ColorsArray.AddItem("Thelost");
	BackgroundsArray.AddItem("Panel");
	BackgroundsArray.AddItem("Simple");
	BackgroundsArray.AddItem("Shading");
	AnchorTextArray.AddItem("TopLeft");
	AnchorTextArray.AddItem("TopRight");

	LoadSavedSettings();

	Page = ConfigAPI.NewSettingsPage(sSettingsPage_MCMText);
	Page.SetPageTitle(sPageTitle_MCMText);
	Page.SetSaveHandler(SaveButtonClicked);
	Page.EnableResetButton(ResetButtonClicked);

	Group1 = Page.AddGroup('Group1', sGroupGeneralSettings_MCMText);
	ShowBackground_MCMUI				= Group1.AddCheckbox('ShowBackground', sShowBackground_MCMText, sShowBackground_MCMText, bBackground, , CheckBoxChangeHandler);
	ShowTerrain_MCMUI				= Group1.AddCheckbox('ShowTerrain', sShowTerrain_MCMText, sShowTerrain_MCMText, bShowTerrain, , CheckBoxChangeHandler);
	//Group1.AddLabel('empty_line',"!!!EXPERIMENTAL!!!","!!!EXPERIMENTAL!!! You've been Warned :-)");
	//ShadowChamberStyle_MCMUI			= Group1.AddCheckbox('ShadowChamberStyle', sShadowChamberStyle_MCMText, sShadowChamberStyle_MCMText, bShadowChamberStyle, ShadowChamberStyleHandler, CheckBoxChangeHandler);
	//Group1.AddLabel('empty_line',"!!!EXPERIMENTAL!!!","!!!EXPERIMENTAL!!! You've been Warned :-)");
	Group1.AddLabel('empty_line',"","");

	Group2 = Page.AddGroup('Group2', sPanelSettings_MCMText);
	BackgroundType_MCMUI				= Group2.AddDropdown('BackgroundType', sBackgroundType_MCMText, sBackgroundType_MCMText, BackgroundsArray, sBackground, BackgroundTypeHandler, );
	AlphaBackground_MCMUI			= Group2.AddSlider('AlphaBackground', sAlphaBackground_MCMText, sAlphaBackground_MCMText, 0, 1, 0.1, fAlphaBackground, AlphaBackgroundHandler, );
	BackgroundType_MCMUI.SetEditable(bBackground);
	AlphaBackground_MCMUI.SetEditable(bBackground);
	Group2.AddLabel('empty_line',"","");
	
	Group3 = Page.AddGroup('Group3', sGroupEnemiesListSettings_MCMText);
	ShowWithoutShadowChamber_MCMUI	= Group3.AddCheckbox('ShowWithoutShadowChamber', sShowWithoutShadowChamber_MCMText, sShowWithoutShadowChamber_MCMText, bSHOW_WITHOUT_SHADOWCHAMBER, ShadowHandler, );
	ShowEnemiesList_MCMUI			= Group3.AddCheckbox('ShowEnemiesList', sShowEnemiesList_MCMText, sShowEnemiesList_MCMText, bShowEnemiesList, ShowEnemiesListHandler, );
	ShowChosen_MCMUI					= Group3.AddCheckbox('ShowChosen', sShowChosen_MCMText, sShowChosen_MCMText, bShowChosen, ShowChosenHandler, );
	ShowEnemyIcons_MCMUI				= Group3.AddCheckbox('ShowEnemyIcons', sShowEnemyIcons_MCMText, sShowEnemyIcons_MCMText, bShowEnemyIcons, , CheckBoxChangeHandler);
	EnemiesListAnchor_MCMUI			= Group3.AddDropdown('EnemiesListAnchor', sEnemiesListAnchor_MCMText, sEnemiesListAnchor_MCMText, AnchorTextArray, sEnemiesListAnchor, , DropdownChangeHandler);
	EnemiesListSitrepOffset_MCMUI	= Group3.AddSlider('EnemiesListSitrepOffset', sEnemiesListSitrepOffset_MCMText, sEnemiesListSitrepOffset_MCMText, 0, 300, 5, iSitrepDisplayOffset, SitrepDisplayOffsetHandler, );
	EnemyIconSize_MCMUI				= Group3.AddSlider('EnemyIconSize', sEnemyIconSize_MCMText, sEnemyIconSize_MCMText, 1, 64, 1, iEnemyIconSize, EnemyIconSizeHandler, );
	EnemyIconSize_MCMUI.SetEditable(bShowEnemyIcons);
	Group3.AddLabel('empty_line',"","");

	Group4 = Page.AddGroup('Group4', sGroupTerrainSettings_MCMText);
	ShowPlotText_MCMUI				= Group4.AddCheckbox('ShowPlot', sShowPlotText_MCMText, sShowPlotText_MCMText, bShowPlotText, ShowPlotTextHandler, );
	ShowBiomeText_MCMUI				= Group4.AddCheckbox('ShowBiome', sShowBiomeText_MCMText, sShowBiomeText_MCMText, bShowBiomeText, ShowBiomeTextHandler, );
	ShowTime_MCMUI					= Group4.AddCheckbox('ShowTime', sShowTime_MCMText, sShowTime_MCMText, bShowTime, ShowTimeHandler, );
	ShowIcons_MCMUI					= Group4.AddCheckbox('ShowIcons', sShowIcons_MCMText, sShowIcons_MCMText, bShowIcons, , CheckBoxChangeHandler);
	TerrainTitleColor_MCMUI			= Group4.AddDropdown('TerrainTitleColor', sTerrainTitleColor_MCMText, sTerrainTitleColor_MCMText, ColorsArray, sTerrainTitleColor, TerrainTitleColorHandler, );
	TerrainColor_MCMUI				= Group4.AddDropdown('TerrainColor', sTerrainColor_MCMText, sTerrainColor_MCMText, ColorsArray, sTerrainColor, TerrainColorHandler, );
	TimeColor_MCMUI					= Group4.AddDropdown('TimeColor', sTimeColor_MCMText, sTimeColor_MCMText, ColorsArray, sTimeColor, TimeColorHandler, );
	IconSize_MCMUI					= Group4.AddSlider('IconSize', sIconSize_MCMText, sIconSize_MCMText, 1, 64, 1, iIconSize, , SliderChangeHandler);
	ShowPlotText_MCMUI.SetEditable(bShowTerrain);
	ShowBiomeText_MCMUI.SetEditable(bShowTerrain);
	ShowTime_MCMUI.SetEditable(bShowTerrain);
	ShowIcons_MCMUI.SetEditable(bShowTerrain);
	TerrainTitleColor_MCMUI.SetEditable(bShowTerrain);
	TerrainColor_MCMUI.SetEditable(bShowTerrain);
	TimeColor_MCMUI.SetEditable(bShowTerrain);
	TerrainAnchor_MCMUI.SetEditable(bShowTerrain);
	IconSize_MCMUI.SetEditable(bShowTerrain&&bShowIcons);
	Group4.AddLabel('empty_line',"","");

	Group5 = Page.AddGroup('Group5', "DEBUG");
	DEBUG_MCMUI						= Group5.AddCheckbox('DEBUG', "DEBUG", "DEBUG", DEBUG, , CheckBoxChangeHandler);
	Group5.AddLabel('empty_line',"","");
	EnemiesCountPanelSizeX_MCMUI		= Group5.AddSlider('CountPanelSizeX', sEnemiesCountPanelSizeX_MCMText, sEnemiesCountPanelSizeX_MCMText, 35, 1000, 5, iPanelEnemiesCountSizeX, PanelEnemiesCountSizeXHandler, );
	EnemiesCountPanelSizeY_MCMUI		= Group5.AddSlider('CountPanelSizeY', sEnemiesCountPanelSizeY_MCMText, sEnemiesCountPanelSizeY_MCMText, 35, 1000, 5, iPanelEnemiesCountSizeY, PanelEnemiesCountSizeYHandler, );
	EnemiesListPanelSizeX_MCMUI		= Group5.AddSlider('ListPanelSizeX', sEnemiesListPanelSizeX_MCMText, sEnemiesListPanelSizeX_MCMText, 35, 1000, 5, iPanelEnemiesListSizeX, PanelEnemiesListSizeXHandler, );
	EnemiesListPanelSizeY_MCMUI		= Group5.AddSlider('ListPanelSizeY', sEnemiesListPanelSizeY_MCMText, sEnemiesListPanelSizeY_MCMText, 100, 1000, 5, iPanelEnemiesListSizeY, PanelEnemiesListSizeYHandler, );
	PanelTerrainSizeX_MCMUI			= Group5.AddSlider('TerrainPanelSizeX', sPanelTerrainSizeX_MCMText, sPanelTerrainSizeX_MCMText, 35, 1000, 5, iPanelTerrainSizeX, PanelTerrainSizeXHandler, );
	PanelTerrainSizeY_MCMUI			= Group5.AddSlider('TerrainPanelSizeY', sPanelTerrainSizeY_MCMText, sPanelTerrainSizeY_MCMText, 35, 1000, 5, iPanelTerrainSizeY, , SliderChangehandler);
	EnemiesListPositionX_MCMUI		= Group5.AddSlider('EnemiesListPositionX', sEnemiesListPositionX_MCMText, sEnemiesListPositionX_MCMText, -1920, 1920, 5, iEnemiesListPosX, EnemiesListPosXHandler, );
	EnemiesListPositionY_MCMUI		= Group5.AddSlider('EnemiesListPositionY', sEnemiesListPositionY_MCMText, sEnemiesListPositionY_MCMText, 0, 1080, 5, iEnemiesListPosY, EnemiesListPosYHandler, );
	TerrainAnchor_MCMUI				= Group5.AddDropdown('TerrainAnchor', sTerrainAnchor_MCMText, sTerrainAnchor_MCMText, AnchorTextArray, sTerrainAnchor, , DropdownChangeHandler);
	TerrainPosX_MCMUI				= Group5.AddSlider('TerrainPosX', sTerrainPosX_MCMText, sTerrainPosX_MCMText, -1920, 1920, 5, iTerrainPosX, TerrainPosXHandler, );
	TerrainPosY_MCMUI				= Group5.AddSlider('TerrainPosY', sTerrainPosY_MCMText, sTerrainPosY_MCMText, 0, 1080, 5, iTerrainPosY, TerrainPosYHandler, );
	EnemyIconVSpace_MCMUI			= Group5.AddSlider('EnemyIconVSpace', sEnemyIconVSpace_MCMText, sEnemyIconVSpace_MCMText, -32, 32, 1, iEnemyIconVSpace, EnemyIconVSpaceHandler, );
	IconVSpace_MCMUI				= Group5.AddSlider('IconVSpace', sIconVSpace_MCMText, sIconVSpace_MCMText, -32, 32, 1, iIconVSpace, IconVSpaceHandler, );
	IconVSpace_MCMUI.SetEditable(bShowTerrain&&bShowIcons&&DEBUG);
	EnemyIconVSpace_MCMUI.SetEditable(bShowEnemyIcons&&DEBUG);
	TerrainPosX_MCMUI.SetEditable(bShowTerrain&&DEBUG);
	TerrainPosY_MCMUI.SetEditable(bShowTerrain&&DEBUG);
	EnemiesCountPanelSizeX_MCMUI.SetEditable(bBackground&&DEBUG);
	EnemiesCountPanelSizeY_MCMUI.SetEditable(bBackground&&DEBUG);
	EnemiesListPanelSizeX_MCMUI.SetEditable(bBackground&&DEBUG);
	EnemiesListPanelSizeY_MCMUI.SetEditable(bBackground&&DEBUG);
	PanelTerrainSizeX_MCMUI.SetEditable(bBackground&&DEBUG);
	PanelTerrainSizeY_MCMUI.SetEditable(bBackground&&DEBUG);
	EnemiesListPositionX_MCMUI.SetEditable(DEBUG);
	EnemiesListPositionY_MCMUI.SetEditable(DEBUG);
	TerrainAnchor_MCMUI.SetEditable(DEBUG);
	Group5.AddLabel('empty_line',"","");


	Page.ShowSettings();
}

`MCM_CH_VersionChecker(class'MCM_Defaults'.default.VERSION,CONFIG_VERSION)

simulated function LoadSavedSettings()
{
    bSHOW_WITHOUT_SHADOWCHAMBER =	`MCM_CH_GetValue(class'MCM_Defaults'.default.bSHOW_WITHOUT_SHADOWCHAMBER,bSHOW_WITHOUT_SHADOWCHAMBER);
	bBackground =					`MCM_CH_GetValue(class'MCM_Defaults'.default.bBackground,bBackground);
	bShowTerrain =					`MCM_CH_GetValue(class'MCM_Defaults'.default.bShowTerrain,bShowTerrain);
	bShowBiomeText =					`MCM_CH_GetValue(class'MCM_Defaults'.default.bShowBiomeText,bShowBiomeText);
	bShowPlotText =					`MCM_CH_GetValue(class'MCM_Defaults'.default.bShowPlotText,bShowPlotText);
	bShowIcons =						`MCM_CH_GetValue(class'MCM_Defaults'.default.bShowIcons,bShowIcons);
	bShowEnemyIcons =				`MCM_CH_GetValue(class'MCM_Defaults'.default.bShowEnemyIcons,bShowEnemyIcons);
	bShowEnemiesList =				`MCM_CH_GetValue(class'MCM_Defaults'.default.bShowEnemiesList,bShowEnemiesList);
	bShowChosen =					`MCM_CH_GetValue(class'MCM_Defaults'.default.bShowChosen,bShowChosen);
	//bShadowChamberStyle =			`MCM_CH_GetValue(class'MCM_Defaults'.default.bShadowChamberStyle, bShadowChamberStyle);
	iSitrepDisplayOffset =			`MCM_CH_GetValue(class'MCM_Defaults'.default.iSitrepDisplayOffset,iSitrepDisplayOffset);
	iIconSize =						`MCM_CH_GetValue(class'MCM_Defaults'.default.iIconSize,iIconSize);
	iEnemyIconSize =					`MCM_CH_GetValue(class'MCM_Defaults'.default.iEnemyIconSize,iEnemyIconSize);
	fAlphaBackground =				`MCM_CH_GetValue(class'MCM_Defaults'.default.fAlphaBackground,fAlphaBackground);
	sTerrainTitleColor =				`MCM_CH_GetValue(class'MCM_Defaults'.default.sTerrainTitleColor,sTerrainTitleColor);
	sTerrainColor =					`MCM_CH_GetValue(class'MCM_Defaults'.default.sTerrainColor,sTerrainColor);
	sTimeColor =						`MCM_CH_GetValue(class'MCM_Defaults'.default.sTimeColor,sTimeColor);
	sBackground =					`MCM_CH_GetValue(class'MCM_Defaults'.default.sBackground,sBackground);
	sEnemiesListAnchor =				`MCM_CH_GetValue(class'MCM_Defaults'.default.sEnemiesListAnchor,sEnemiesListAnchor);
	DEBUG =							`MCM_CH_GetValue(class'MCM_Defaults'.default.DEBUG,DEBUG);
	if(DEBUG)
	{
		sTerrainAnchor =					`MCM_CH_GetValue(class'MCM_Defaults'.default.sTerrainAnchor,sTerrainAnchor);
		iEnemiesListPosX =				`MCM_CH_GetValue(class'MCM_Defaults'.default.iEnemiesListPosX,iEnemiesListPosX);
		iEnemiesListPosY =				`MCM_CH_GetValue(class'MCM_Defaults'.default.iEnemiesListPosY,iEnemiesListPosY);
		iTerrainPosX =					`MCM_CH_GetValue(class'MCM_Defaults'.default.iTerrainPosX,iTerrainPosX);
		iTerrainPosY =					`MCM_CH_GetValue(class'MCM_Defaults'.default.iTerrainPosY,iTerrainPosY);
		iPanelTerrainSizeX =				`MCM_CH_GetValue(class'MCM_Defaults'.default.iPanelTerrainSizeX,iPanelTerrainSizeX);
		iPanelTerrainSizeY =				`MCM_CH_GetValue(class'MCM_Defaults'.default.iPanelTerrainSizeY,iPanelTerrainSizeY);
		iPanelEnemiesCountSizeX =		`MCM_CH_GetValue(class'MCM_Defaults'.default.iPanelEnemiesCountSizeX,iPanelEnemiesCountSizeX);
		iPanelEnemiesCountSizeY =		`MCM_CH_GetValue(class'MCM_Defaults'.default.iPanelEnemiesCountSizeY,iPanelEnemiesCountSizeY);
		iPanelEnemiesListSizeX =			`MCM_CH_GetValue(class'MCM_Defaults'.default.iPanelEnemiesListSizeX,iPanelEnemiesListSizeX);
		iPanelEnemiesListSizeY =			`MCM_CH_GetValue(class'MCM_Defaults'.default.iPanelEnemiesListSizeY,iPanelEnemiesListSizeY);
		iEnemyIconVSpace =				`MCM_CH_GetValue(class'MCM_Defaults'.default.iEnemyIconVSpace,iEnemyIconVSpace);
		iIconVSpace =					`MCM_CH_GetValue(class'MCM_Defaults'.default.iIconVSpace,iIconVSpace);
	}
}

simulated function CheckBoxChangeHandler(MCM_API_Setting _Setting, bool _SettingValue)
{
	local name	SettingName;
	SettingName = _Setting.GetName();
	switch (SettingName)
	{
		case 'ShowBackground'	:
			BackgroundType_MCMUI.SetEditable(_SettingValue);
			AlphaBackground_MCMUI.SetEditable(_SettingValue);
			if(DEBUG)
			{
				EnemiesCountPanelSizeX_MCMUI.SetEditable(_SettingValue);
				EnemiesCountPanelSizeY_MCMUI.SetEditable(_SettingValue);
				EnemiesListPanelSizeX_MCMUI.SetEditable(_SettingValue);
				EnemiesListPanelSizeY_MCMUI.SetEditable(_SettingValue);
				PanelTerrainSizeX_MCMUI.SetEditable(_SettingValue);
				PanelTerrainSizeY_MCMUI.SetEditable(_SettingValue);
			}
			bBackground = _SettingValue;
			break;
		case 'ShowTerrain'		: 
			ShowPlotText_MCMUI.SetEditable(_SettingValue);
			ShowBiomeText_MCMUI.SetEditable(_SettingValue);
			ShowIcons_MCMUI.SetEditable(_SettingValue);
			TerrainTitleColor_MCMUI.SetEditable(_SettingValue);
			TerrainColor_MCMUI.SetEditable(_SettingValue);
			TimeColor_MCMUI.SetEditable(_SettingValue);
			IconSize_MCMUI.SetEditable(_SettingValue&&bShowIcons);
			IconVSpace_MCMUI.SetEditable(_SettingValue&&bShowIcons);
			ShowTime_MCMUI.SetEditable(_SettingValue);
			if(DEBUG)
			{
				TerrainPosX_MCMUI.SetEditable(_SettingValue);
				TerrainPosY_MCMUI.SetEditable(_SettingValue);
			}
			bShowTerrain = _SettingValue;
			break;
		case 'ShowIcons'			:
			IconSize_MCMUI.SetEditable(_SettingValue);
			IconVSpace_MCMUI.SetEditable(DEBUG&&_SettingValue);
			bShowIcons = _SettingValue;
			break;
		case 'ShowEnemyIcons'	:
			EnemyIconSize_MCMUI.SetEditable(_SettingValue);
			EnemyIconVSpace_MCMUI.SetEditable(DEBUG&&_SettingValue);
			bShowEnemyIcons = _SettingValue;
			break;
		case 'DEBUG'				:
			TerrainPosX_MCMUI.SetEditable(bShowTerrain&&_SettingValue);
			TerrainPosY_MCMUI.SetEditable(bShowTerrain&&_SettingValue);
			EnemiesCountPanelSizeX_MCMUI.SetEditable(bBackground&&_SettingValue);
			EnemiesCountPanelSizeY_MCMUI.SetEditable(bBackground&&_SettingValue);
			EnemiesListPanelSizeX_MCMUI.SetEditable(bBackground&&_SettingValue);
			EnemiesListPanelSizeY_MCMUI.SetEditable(bBackground&&_SettingValue);
			PanelTerrainSizeX_MCMUI.SetEditable(bBackground&&_SettingValue);
			PanelTerrainSizeY_MCMUI.SetEditable(bBackground&&_SettingValue);
			EnemiesListPositionX_MCMUI.SetEditable(_SettingValue);
			EnemiesListPositionY_MCMUI.SetEditable(_SettingValue);
			TerrainAnchor_MCMUI.SetEditable(_SettingValue);
			EnemyIconVSpace_MCMUI.SetEditable(bShowIcons&&_SettingValue);
			IconVSpace_MCMUI.SetEditable(bShowTerrain&&bShowIcons&&_SettingValue);
			DEBUG = _SettingValue;
			break;
		default					: assert(false);
	}
}

simulated function SliderChangeHandler(MCM_API_Setting _Setting, float _SettingValue)
{
	local name SettingName;
	SettingName = _Setting.GetName();
	switch (SettingName)
	{
		case 'IconSize':
			if(DEBUG)
			{
				if (_SettingValue+10>iPanelTerrainSizeY)
				{
					iPanelTerrainSizeY += 10;
					PanelTerrainSizeY_MCMUI.SetValue(iPanelTerrainSizeY, true);
				}
			}
			iIconSize = _SettingValue;
			break;
		case 'TerrainPanelSizeY':
			if (_SettingValue-10<iIconSize)
			{
				iIconSize -= 10;
				IconSize_MCMUI.SetValue(iIconSize, true);
			}
			iPanelTerrainSizeY = _SettingValue;
			break;
		default: assert(false);
	}
}

simulated function DropdownChangeHandler(MCM_API_Setting _Setting, string _SettingValue)
{
	local name SettingName;
	SettingName = _Setting.GetName();
	switch (SettingName)
	{
		case 'EnemiesListAnchor':
			if(DEBUG)
			{
				if (_SettingValue=="TopLeft")
				{
					EnemiesListPositionX_MCMUI.SetValue(0, false);
				}
				else
				{
					EnemiesListPositionX_MCMUI.SetValue(-400, false);				
				}
			}
			sEnemiesListAnchor = _SettingValue;
			break;
		case 'TerrainAnchor':
			if (_SettingValue=="TopLeft")
			{
				TerrainPosX_MCMUI.SetValue(0, false);
			}
			else
			{
				TerrainPosX_MCMUI.SetValue(-400, false);				
			}
			sTerrainAnchor = _SettingValue;
			break;
		default: assert(false);
	}
}

simulated function SaveButtonClicked(MCM_API_SettingsPage Page)
{
    self.CONFIG_VERSION = `MCM_CH_GetCompositeVersion();
    self.SaveConfig();
}

simulated function ResetButtonClicked(MCM_API_SettingsPage Page)
{
	ShowBackground_MCMUI.SetValue(			class'MCM_Defaults'.default.bBackground,					false);
	ShowTerrain_MCMUI.SetValue(				class'MCM_Defaults'.default.bShowTerrain,				false);
	//ShadowChamberStyle_MCMUI.SetValue(		class'MCM_Defaults'.default.bShadowChamberStyle,			false);
	BackgroundType_MCMUI.SetValue(			class'MCM_Defaults'.default.sBackground,					false);
	AlphaBackground_MCMUI.SetValue(			class'MCM_Defaults'.default.fAlphaBackground,			false);
	ShowWithoutShadowChamber_MCMUI.SetValue(class'MCM_Defaults'.default.bSHOW_WITHOUT_SHADOWCHAMBER,false);
	EnemiesListSitrepOffset_MCMUI.SetValue(	class'MCM_Defaults'.default.iSitrepDisplayOffset,		false);
	ShowPlotText_MCMUI.SetValue(				class'MCM_Defaults'.default.bShowPlotText,				false);
	ShowBiomeText_MCMUI.SetValue(			class'MCM_Defaults'.default.bShowBiomeText,				false);
	ShowIcons_MCMUI.SetValue(				class'MCM_Defaults'.default.bShowIcons,					false);
	ShowEnemyIcons_MCMUI.SetValue(			class'MCM_Defaults'.default.bShowEnemyIcons,				false);
	TerrainTitleColor_MCMUI.SetValue(		class'MCM_Defaults'.default.sTerrainTitleColor,			false);
	TerrainColor_MCMUI.SetValue(				class'MCM_Defaults'.default.sTerrainColor,				false);
	IconSize_MCMUI.SetValue(					class'MCM_Defaults'.default.iIconSize,					false);
	EnemyIconSize_MCMUI.SetValue(			class'MCM_Defaults'.default.iEnemyIconSize,				false);
	ShowTime_MCMUI.SetValue(					class'MCM_Defaults'.default.bShowTime,					false);
	ShowEnemiesList_MCMUI.SetValue(			class'MCM_Defaults'.default.bShowEnemiesList,			false);
	ShowChosen_MCMUI.SetValue(				class'MCM_Defaults'.default.bShowChosen,					false);
	EnemiesListAnchor_MCMUI.SetValue(		class'MCM_Defaults'.default.sEnemiesListAnchor,			false);
	TimeColor_MCMUI.SetValue(				class'MCM_Defaults'.default.sTimeColor,					false);
	DEBUG_MCMUI.SetValue(					class'MCM_Defaults'.default.DEBUG,						false);
	if(DEBUG)
	{
		TerrainAnchor_MCMUI.SetValue(			class'MCM_Defaults'.default.sTerrainAnchor,				false);
		EnemiesCountPanelSizeX_MCMUI.SetValue(	class'MCM_Defaults'.default.iPanelEnemiesCountSizeX,		false);
		EnemiesCountPanelSizeY_MCMUI.SetValue(	class'MCM_Defaults'.default.iPanelEnemiesCountSizeY,		false);
		EnemiesListPanelSizeX_MCMUI.SetValue(	class'MCM_Defaults'.default.iPanelEnemiesListSizeX,		false);
		EnemiesListPanelSizeY_MCMUI.SetValue(	class'MCM_Defaults'.default.iPanelEnemiesListSizeY,		false);
		PanelTerrainSizeX_MCMUI.SetValue(		class'MCM_Defaults'.default.iPanelTerrainSizeX,			false);
		PanelTerrainSizeY_MCMUI.SetValue(		class'MCM_Defaults'.default.iPanelTerrainSizeY,			false);
		EnemiesListPositionX_MCMUI.SetValue(		class'MCM_Defaults'.default.iEnemiesListPosX,			false);
		EnemiesListPositionY_MCMUI.SetValue(		class'MCM_Defaults'.default.iEnemiesListPosY,			false);
		TerrainPosX_MCMUI.SetValue(				class'MCM_Defaults'.default.iTerrainPosX,				false);
		TerrainPosY_MCMUI.SetValue(				class'MCM_Defaults'.default.iTerrainPosY,				false);
		EnemyIconVSpace_MCMUI.SetValue(			class'MCM_Defaults'.default.iEnemyIconVSpace,			false);
		IconVSpace_MCMUI.SetValue(				class'MCM_Defaults'.default.iIconVSpace,					false);
	}
}