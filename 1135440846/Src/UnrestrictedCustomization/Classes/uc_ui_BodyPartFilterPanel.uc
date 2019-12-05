///
/// 
///
class uc_ui_BodyPartFilterPanel extends UiPanel;

`define ClassName uc_ui_BodyPartFilterPanel
`include( UnrestrictedCustomization\Src\UnrestrictedCustomization\macros.uci )

//======================================================================================================================
// Signal

var privatewrite xmf_Signal OnChanged;

//======================================================================================================================
// FIELDS

var privatewrite xmf_ui_NavigationNode NavigationNode;

var UiCheckbox GenderMaleCb;
var UiCheckbox GenderFemaleCb;

var UiCheckbox ArmorLightCb;
var UiCheckbox ArmorMediumCb;
var UiCheckbox ArmorHeavyCb;
var UiCheckbox ArmorSparkCb;

var UiCheckbox TechPaddedCb;
var UiCheckbox TechPlatedCb;
var UiCheckbox TechPoweredCb;
var UiCheckbox TechAlienCb;

var UiCheckbox StyleCivilianCb;
var UiCheckbox StyleXComCb;
var UiCheckbox StyleAdventCb;
var UiCheckbox StyleOtherCb;

//======================================================================================================================
// CTOR

///
/// Instantiates this class.
///
public static function uc_ui_BodyPartFilterPanel CreateBodyPartFilterPanel( UiPanel _parent ) {
	return BodyPartFilterPanel(class'uc_ui_BodyPartFilterPanel', _parent);
}

protected static function uc_ui_BodyPartFilterPanel BodyPartFilterPanel(
	class<uc_ui_BodyPartFilterPanel> _class,
	UiPanel _parent
) {
	local uc_ui_BodyPartFilterPanel this;
	this = _parent.Spawn(_class, _parent);
	this.InitBodyPartFilterPanel();
	return this;
}


private function InitBodyPartFilterPanel() {
	super.InitPanel();
	
	OnChanged = class'xmf_Signal'.static.CreateSignal();
	NavigationNode = class'xmf_ui_NavigationNode'.static.CreateNavigationNode(self);

	CreatePanels();
}

//======================================================================================================================
// METHODS

private function CreatePanels() {
	local uc_ui_FilterPanel _genderPanel, _armorPanel, _techPanel, _stylePanel;
	local float _x, _y, _w, _h, _scale, _padding;
	_padding = 5;
	_x = 0;
	_y = 0;
	_w = 203;
	_h = 230;
	_scale = 0.7;

	_genderPanel = CreateGenderPanel( _x, _y, _w, _h, _scale );
	_x += _w*_scale + _padding;

	_armorPanel = CreateArmorTypePanel( _x, _y, _w, _h, _scale );
	_x += _w*_scale + _padding;
	
	_techPanel = CreateTechLevelPanel( _x, _y, _w, _h, _scale );
	_x += _w*_scale + _padding;

	_stylePanel = CreateStylePanel( _x, _y, _w, _h, _scale );

	// build navigation tree

	_genderPanel.NavigationNode.Parent = NavigationNode;
	_genderPanel.NavigationNode.LeftNode = _stylePanel.NavigationNode;
	_genderPanel.NavigationNode.RightNode = _armorPanel.NavigationNode;

	_armorPanel.NavigationNode.Parent = NavigationNode;
	_armorPanel.NavigationNode.LeftNode = _genderPanel.NavigationNode;
	_armorPanel.NavigationNode.RightNode = _techPanel.NavigationNode;

	_techPanel.NavigationNode.Parent = NavigationNode;
	_techPanel.NavigationNode.LeftNode = _armorPanel.NavigationNode;
	_techPanel.NavigationNode.RightNode = _stylePanel.NavigationNode;

	_stylePanel.NavigationNode.Parent = NavigationNode;
	_stylePanel.NavigationNode.LeftNode = _techPanel.NavigationNode;
	_stylePanel.NavigationNode.RightNode = _genderPanel.NavigationNode;

	NavigationNode.LastFocusedChild = _armorPanel.NavigationNode;
}


private function uc_ui_FilterPanel CreateFilterMiniPanel(
	string _title, float _x, float _y, float _w, float _h, float _scale
) {
	local uc_ui_FilterPanel _panel;

	_panel = class'uc_ui_FilterPanel'.static.CreateFilterPanel( self, _title, false );
	_panel.SetPosition( _x, _y );
	_panel.OnChanged.AddHandler(HandleFilterChanged);
	_panel.SetSize(_w, _h);
	_panel.SetPanelScale(_scale);
	
	class'xmf_ui_Util'.static.SetTooltip( _panel.Background, `Localize("FilterPanelTooltip") );

	return _panel;
}


private function uc_ui_FilterPanel CreateGenderPanel(
	float _x, float _y, float _w, float _h, float _scale
) {
	local uc_ui_FilterPanel _panel;
	local eGender _gender;

	_gender = class'uc_Customizer'.static.GetGender();

	_panel = CreateFilterMiniPanel( `Localize("Gender"), _x, _y, _w, _h, _scale );
	GenderMaleCb = _panel.AddFilter( `Localize("Male"), _gender==eGender_Male  );
	GenderFemaleCb = _panel.AddFilter( `Localize("Female"), _gender==eGender_Female);

	return _panel;
}


private function uc_ui_FilterPanel CreateArmorTypePanel( 
	float _x, float _y, float _w, float _h, float _scale
) {
	local uc_ui_FilterPanel _panel;
	local bool _inCharPool;
	local uc_EArmorType _armorType;

	_inCharPool = class'uc_CharacterPoolUtil'.static.IsOpen();
	_armorType = class'uc_Customizer'.static.GetArmorType();

	_panel = CreateFilterMiniPanel( `Localize("Armor"), _x, _y, _w, _h, _scale );
	ArmorLightCb = _panel.AddFilter( `Localize("Light"), !_inCharPool && _armorType==uc_EArmorType_Light );
	ArmorMediumCb = _panel.AddFilter( `Localize("Medium"), !_inCharPool && _armorType==uc_EArmorType_Medium );
	ArmorHeavyCb = _panel.AddFilter( `Localize("Heavy"), !_inCharPool && _armorType==uc_EArmorType_Heavy );
	ArmorSparkCb = _panel.AddFilter( `Localize("Spark"), !_inCharPool && _armorType==uc_EArmorType_Spark );
	
	return _panel;
}


private function uc_ui_FilterPanel CreateTechLevelPanel( 
	float _x, float _y, float _w, float _h, float _scale
) {
	local uc_ui_FilterPanel _panel;
	local bool _inCharPool;
	local uc_ETechLevel _techLevel;

	_inCharPool = class'uc_CharacterPoolUtil'.static.IsOpen();
	_techLevel = class'uc_Customizer'.static.GetArmorTechLevel();

	_panel = CreateFilterMiniPanel( `Localize("Tech"), _x, _y, _w, _h, _scale );
	TechPaddedCb = _panel.AddFilter( `Localize("Padded"), !_inCharPool && _techLevel==uc_ETechLevel_Padded );
	TechPlatedCb = _panel.AddFilter( `Localize("Plated"), !_inCharPool && _techLevel==uc_ETechLevel_Plated );
	TechPoweredCb = _panel.AddFilter( `Localize("Powered"), !_inCharPool && _techLevel==uc_ETechLevel_Powered );
	TechAlienCb = _panel.AddFilter( `Localize("Alien"), !_inCharPool && _techLevel==uc_ETechLevel_Alien );
	
	return _panel;
}


private function uc_ui_FilterPanel CreateStylePanel( 
	float _x, float _y, float _w, float _h, float _scale
) {
	local uc_ui_FilterPanel _panel;

	_panel = CreateFilterMiniPanel( `Localize("Style"), _x, _y, _w, _h, _scale );
	StyleCivilianCb = _panel.AddFilter( `Localize("Civilian"), false );
	StyleXComCb = _panel.AddFilter( `Localize("XCom"), false );
	StyleAdventCb = _panel.AddFilter( `Localize("Advent"), false );
	StyleOtherCb = _panel.AddFilter( `Localize("Other"), false );
	
	return _panel;
}

	
///
/// Creates a uc_BodyPartFilter reflecting this filterpanel's state.
///
public function uc_BodyPartFilter CreateFilter() {
	local uc_BodyPartFilter _filter;

	_filter = class'uc_BodyPartFilter'.static.CreateBodyPartFilter();
	// genders
	if( GenderMaleCb.bChecked ) _filter.Genders.AddItem( eGender_Male );
	if( GenderFemaleCb.bChecked ) _filter.Genders.AddItem( eGender_Female );
	// armor types
	if( ArmorLightCb.bChecked ) _filter.ArmorTypes.AddItem( uc_EArmorType_Light );
	if( ArmorMediumCb.bChecked ) _filter.ArmorTypes.AddItem( uc_EArmorType_Medium );
	if( ArmorHeavyCb.bChecked ) _filter.ArmorTypes.AddItem( uc_EArmorType_Heavy );
	if( ArmorSparkCb.bChecked ) _filter.ArmorTypes.AddItem( uc_EArmorType_Spark );
	// tech levels
	if( TechPaddedCb.bChecked ) _filter.TechLevels.AddItem( uc_ETechLevel_Padded );
	if( TechPlatedCb.bChecked ) _filter.TechLevels.AddItem( uc_ETechLevel_Plated );
	if( TechPoweredCb.bChecked ) _filter.TechLevels.AddItem( uc_ETechLevel_Powered );
	if( TechAlienCb.bChecked ) _filter.TechLevels.AddItem( uc_ETechLevel_Alien );
	// character type
	if( StyleCivilianCb.bChecked ) _filter.Styles.AddItem( uc_EStyle_Civilian );
	if( StyleXComCb.bChecked ) _filter.Styles.AddItem( uc_EStyle_XCom );
	if( StyleAdventCb.bChecked ) _filter.Styles.AddItem( uc_EStyle_Advent );
	if( StyleOtherCb.bChecked ) _filter.Styles.AddItem( uc_EStyle_Other );

	return _filter;
}

private function HandleFilterChanged( Object _source ) {
	OnChanged.Dispatch(self);
}

//======================================================================================================================
defaultProperties // '{' in separate line or defaultProperties will be ignored !
{
	bAnimateOnInit = false;
	bCascadeFocus = false;
}
